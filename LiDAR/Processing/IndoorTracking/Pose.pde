public class Pose {


  //De sætter den til 50 cm i artiklen (400000 er bare for at kunne arbejde med min dumme fiktive værdier)
  float minDistanceForCorrespondence = 50;

  //Ved ikke om de bliver nødvendige, men tænker at den helst skal vide hvor den sidste har været
  float previousX;
  float previousY;

  float minR;
  Point minT;


  // for use in the iterative part of ICP
  int iterationsLines = 5; //number of iteration over the lines in the ICP
  ArrayList<Point> ClonedModelPoints = new ArrayList<Point>();  
  ArrayList<Float> currentWeights = new ArrayList<Float>();
  float totalWeight = 0;
  float bestWeight = (float) Double.POSITIVE_INFINITY;


  //Den måde, så vidt jeg har forstået, at algoritmen funker er at den gå i gennem et fuldt model set (alle hjørner eller linjer), finder de punkter herfra som er tættest på data settet og udtrækker disse
  //derfor har jeg både lavet et fullModelSet, modelSet og et dataSet
  Location fullModelSet;
  Location dataSet;
  Location modelSet;

  //I artiklen arbejder de med matricer, jeg skal lige selv have fundet ud af hvad der er smartest, oftest har jeg undgået dem og blot brugt dobbelt array.
  Matrix dataMatrix;
  Matrix modelMatrix;

  Matrix t;

  //Vi har brug for en liste af dataPoints (de kommer fra vores dataSet), en liste af modelPoints (fra vores fulde model set) og så det filtrede modelSet med de relevante point (det er i dobbelt array
  //format da vi blot skal bruge det til at beregne modelVector og senere hen Y
  ArrayList<Point> dataPoints = new ArrayList<Point>();
  ArrayList<Point> modelPoints = new ArrayList<Point>();
  double[][] relevantModelPoints;
  //Vi har en liste med alle vægtningerne mellem punkterne, vi skal gå i gennem dem alle for at beregne W senere, derfor gemmes de i en liste
  ArrayList<Float> weights = new ArrayList<Float>();

  //En af formlerne kræver antal feature points fundet, det bruges denne variable til (Formel 10)
  int totalFeaturePoints = 0;

  //Ud for blandt andet ovenstående variable beregnes en "confidence", det bruges denne variable til
  float confidence = 0;

  //Dette svare til P vector og Q vector fra formel 7
  Vector<Point> dataVector = new Vector();
  Vector<Point> modelVector = new Vector();

  //Disse bruges ikke, jeg skal lige finde ud af hvordan r og t konkret bruges
  //float r;
  //float t;

  //Bruges til at beregne S (mellem formel 7 og 8)
  Matrix X;
  Matrix Y;
  Matrix W;

  //Vores S og R matricer
  Matrix S;
  Matrix R;

  //Vores constructor, tænker at den modtager et fuldt modelSet og et dataSet (det de kalder current scan i artiklen)
  Pose(Location givenFullModelSet, Location givenDataSet) {
    modelSet = givenFullModelSet;
    dataSet = givenDataSet;
  }

  public Matrix poseMatrix(Location givenDataSet) {
    dataSet = givenDataSet;



    return null;
  }

  //Formel 6 - Jeg skal lige have fundet ud af hvordan man rigtigt blander matricer og vektorer i en beregning
  public Matrix calculateT() {

    //println("Calculate T begin");

    double[][] dataV = new double[2][1];
    dataV[0][0] = dataVector.get(0).x;
    dataV[1][0] = dataVector.get(0).y;

    double[][] modelV = new double[2][1];
    modelV[0][0] = modelVector.get(0).x;
    modelV[1][0] = modelVector.get(0).y;

    Matrix dv = new Matrix(dataV);
    Matrix mv = new Matrix(modelV);
    t = mv.minus(R.times(dv));

    return t;

    //for (int i = 0; i < t.getArray().length; i++) {
    //  for (int j = 0; j < t.getArray()[i].length; j++) {
    //    println("transform " + i + " " + j+ " : " +t.get(i, j));
    //  }
    //  println();
    //}
  }

  //Formel 9
  public Matrix calculateR() {
    //println("CalculateR Begin");
    //Vi skal først beregne U og V ud fra S
    Matrix U;
    Matrix V;

    U = S.svd().getU();

    //for (int i = 0; i < U.getArray().length; i++) {
    //  for (int j = 0; j < U.getArray()[i].length; j++) {
    //    println("U " + i + " " + j+ " : " +U.get(i, j));
    //  }
    //  println();
    //}

    V = S.svd().getV();

    //for (int i = 0; i < V.getArray().length; i++) {
    //  for (int j = 0; j < V.getArray()[i].length; j++) {
    //    println("V " + i + " " + j+ " : " +V.get(i, j));
    //  }
    //  println();
    //}


    //Derefter har vi alle værdier som skal bruges for at beregne R
    R = U.transpose().times(V);

    //for (int i = 0; i < R.getArray().length; i++) {
    //  for (int j = 0; j < R.getArray()[i].length; j++) {
    //    println("R " + i + " " + j+ " : " +R.get(i, j));
    //  }
    //  println();
    //}
    //println("Before calculate T");     
    return R;
  }

  //Formel 8
  public void calculateS() {

    //Vi laver et dobbelt array til både X, Y og W, fra formel 8, som senere bliver lavet om til Matricer. Grunden til at jeg gør det på den måde er, at det er nemmere at fylde ting i et
    //dobbelt array og senere lave det om til en matrice end direkte lave det til en matrice med det samme.
    //Hvis alt er gjort ordentligt så burde dataPoint.size() = weight.size() og teknisk set også = mostRelevantModelPoints[1].length (jeg hader bare at bruge den)
    double[][] XArray = new double[dataPoints.size()][2];
    double[][] YArray = new double[dataPoints.size()][2];
    double[][] WArray = new double[weights.size()][weights.size()];

    //Vi skal beregner både X, Y og W, som de gør mellem formel 7 og 8
    for (int i = 0; i < dataPoints.size(); i++) {

      XArray[i][0] = dataPoints.get(i).x - dataVector.get(0).x;
      XArray[i][1] = dataPoints.get(i).y - dataVector.get(0).y;
      //println("X-array : " + dataPoints.get(i).x + " " + dataVector.get(0).x);
      YArray[i][0] = relevantModelPoints[i][0] - modelVector.get(0).x;
      YArray[i][1] = relevantModelPoints[i][1] - modelVector.get(0).y;
    }

    //Laver vores arrays om til matricer
    X = new Matrix(XArray);
    Y = new Matrix(YArray);

    //Vi skal bruge diag(W), jeg aner ikke om den nedenstående beregning funker, da jeg ikke ved om W skal have vægtene som rækker eller columns. 
    //Som rækker virker det ikke, som columns gør det.
    //W = W.svd().getS();

    for (int i = 0; i<weights.size(); i++) {
      for (int j = 0; j < weights.size(); j++) {
        if (i == j) {
          WArray[i][j] = weights.get(i);
        } else {
          WArray[i][j] = 0;
        }
      }
    }

    W = new Matrix(WArray);

    //W = W.svd().getS();

    //Nu når vi har alle værdier kan vi beregne S som de gør mellem formel 7 og 8
    S = Y.transpose().times(W).times(X);


    //for (int i = 0; i < X.getArray().length; i++) {
    //for (int j = 0; j < X.getArray()[i].length; j++) {
    //println("X " + i + " " + j+ " : " +X.get(i, j));
    //}
    //println();
    //}
  }

  //Formel 7 for P

  public void calculateDataVector() {

    //Laver vores data matrice om til et dobbelt array, da jeg syntes det er nemmere at arbejde med (ja... I know... Skal lige forsøge at være konsistent, vi kan lige snakke om hvad vi gør)
    double[][] dataMatrixArray = dataMatrix.getArrayCopy();

    //Vi sætter totalvægten lig 0 fra starten, vi skal bruge totalvægten i formlen
    float totalWeight = 0;

    //Jeg bruger disse to variable til at lave det Point vores data Vector skal indeholde
    float dataVectorX = 0;
    float dataVectorY = 0;

    //Går gennem alle vores points
    for (int i = 0; i < dataPoints.size(); i++) {
      //println("matrixX: "+dataMatrixArray[i][0] + "matrixY: "+dataMatrixArray[i][1]);
      //Inkrementere den totale vægt med den næste vægt i rækken
      float dMAx = (float)dataMatrixArray[i][0];
      float dMAy = (float)dataMatrixArray[i][1];
      totalWeight = totalWeight + weights.get(i);
      //Inkrementere dataVector X og Y (det svare til det de gør i numeratoren i formel 7)
      dataVectorX = dataVectorX + (dMAx * weights.get(i));
      dataVectorY = dataVectorY + (dMAy * weights.get(i));
    }

    //Skal slettes når vi er sikre på at vi har noget rigtigt data (Forhindre NaN fejlen)
    //totalWeight = 1;

    //Får lige demoninatoren med i formlen, det er dette vi bruger den totale vægt til
    dataVectorX = (float)(dataVectorX/totalWeight);
    dataVectorY = (float)(dataVectorY/totalWeight);
    //println("DataV X : " + dataVectorX + " DataV Y : " + dataVectorY); 
    //Gemmer punktet i vores vector
    dataVector.add(new Point(dataVectorX, dataVectorY));
  }

  //Formel 7 for Q
  //Fuldstændigt det samme som ovenstående, bare med model vektoren i stedet for

  public void calculateModelVector() {

    double[][] modelMatrixArray = modelMatrix.getArrayCopy();

    float totalWeight = 0;

    float modelVectorX = 0;
    float modelVectorY = 0;

    for (int i = 0; i < dataPoints.size(); i++) {
      float mMAx = (float)modelMatrixArray[i][0];
      float mMAy = (float)modelMatrixArray[i][1];
      totalWeight = totalWeight + weights.get(i);
      modelVectorX = modelVectorX + (mMAx * weights.get(i));
      modelVectorY = modelVectorY + (mMAy * weights.get(i));
    }

    //Skal slettes når vi er sikre på at vi har noget rigtigt data (Forhindre NaN fejlen)
    //totalWeight = 1;

    modelVectorX = modelVectorX/totalWeight;
    modelVectorY = modelVectorY/totalWeight;

    //Laver også en vektor af det, da det er brugbart til formel 6
    modelVector.add(new Point(modelVectorX, modelVectorY));
  }


  //I artiklen skriver de, at vægten blot kan beregnes ud fra afstanden... Så... Det gjorde jeg da bare (syntes det var mere sexet at isolere det i sin egen funktion)
  public float calculateWeight(float firstX, float firstY, float secondX, float secondY ) {
    return dist(firstX, firstY, secondX, secondY);
  }

  //Logikken er ovre i PoseCorner og PoseLine, da der er forskel på det alt efter om vi skal søge gennem linjer eller hjørner
  public void calculateDataMatrix() {
  }

  public void calculateModelMatrix() {
  }

  public void argmin() {
    int step = 8;
    minR = (float) Double.POSITIVE_INFINITY;

    float epsilon = 2;

    float currentTX = (float) t.get(0, 0);
    float currentTY = (float) t.get(1, 0);

    float currentAngle = degrees(acos((float) R.get(0, 0)));

    ArrayList<Float> translationValue = new ArrayList<Float>();

    float minValue = (float) Double.POSITIVE_INFINITY;
    int numberOfAngles = 20;

    translationValue.add(RBTP(0, currentAngle, currentTX - epsilon, currentTY));
    translationValue.add(RBTP(0, currentAngle, currentTX + epsilon, currentTY));
    translationValue.add(RBTP(0, currentAngle, currentTX, currentTY - epsilon));
    translationValue.add(RBTP(0, currentAngle, currentTX, currentTY + epsilon));
    translationValue.add(RBTP(0, currentAngle, currentTX, currentTY));

    int lowestIndex = 0;
    float lowestValue = (float) Double.POSITIVE_INFINITY;
    for (int h = 0; h < translationValue.size(); h++) {
      if (translationValue.get(h) < lowestValue) {
        lowestIndex = h;
        lowestValue = translationValue.get(h);
      }
    }

    for (int j = 0; j < numberOfAngles; j++) { 
      if (lowestIndex == 0) {
        currentTX = currentTX - epsilon;
      } else if (lowestIndex == 1) {
        currentTX = currentTX + epsilon;
      } else if (lowestIndex == 2) {
        currentTY = currentTY - epsilon;
      } else if (lowestIndex == 3) {
        currentTY = currentTY + epsilon;
      }

      for (int i = 0; i < weights.size(); i += step) {
        float value = RBTP(i, currentAngle, currentTX, currentTY);
        if (i+step < weights.size() && value <  RBTP(i+step, currentAngle, currentTX, currentTY) && step != 1) {
          step = step/2;
        }
        if (minValue > value) {
          //println("minValue > value");
          minR = currentAngle;
          minValue = value;
          minT = new Point(currentTX, currentTY);
        }
      }
      currentAngle+= 360/numberOfAngles;
      if (currentAngle > 360) {
        currentAngle = 0;
      }
    }
  }

  //Rigid body Transformation - Formel 5
  public float RBTP(int index, float givenAngle, float givenTX, float givenTY) {


    Point rotationPoint = new Point(givenAngle*dataPoints.get(index).x, givenAngle*dataPoints.get(index).y);
    //Vector rotationPointT = new Vector<>();
    //rotationPointT.add(givenTX);
    //rotationPointT.add(givenTY);

    rotationPoint.x += (float) givenTX;
    rotationPoint.y += (float) givenTY;

    rotationPoint.x -= (float) relevantModelPoints[index][0];
    rotationPoint.y -= (float) relevantModelPoints[index][1];
    float value = weights.get(index) * pow(mag(rotationPoint.x, rotationPoint.y), 2);
    return value;
  }

  public void WPICP(ArrayList<Point> data, ArrayList<Point> model) {

    float error = (float) Double.POSITIVE_INFINITY;
    int maxIterations = 20;
    float goodEnoughError = 10;

    //println("\n Starting WPICP\n");

    for (int i = 0; i < maxIterations; i++) {
      float currentError = ICP(data, model);
      calculateModelVector();
      calculateDataVector();
      calculateS();
      Matrix currentR = calculateR();
      Matrix currentT = calculateT();
      if (currentError < error) {

        //println("\n WPICP error: " + currentError + ", old error: " + error + "\n");

        error = currentError;
        R = currentR;
        t = currentT;
        if (error < goodEnoughError) {          

          //println("\n Good enough error from WPICP: " + error + ", becaus it's less than: " + goodEnoughError + "\n");

          break;
        }
      }
    }
  }

  //Uha, så kommer den famøse ICP (Iterative Closest Point) algoritme som de går gennem i section 3.2, den skal gennemgåes før Pose beregningen (måske den skal i en anden klasse, det kan vi snakke om)
  public float ICP(ArrayList<Point> data, ArrayList<Point> model) {
    ClonedModelPoints = (ArrayList<Point>) model.clone();
    //ClonedModelPoints = model;
    ArrayList<Point> dataSet = data;
    if (R != null) {
      for (int j = 0; j < data.size(); j++) {
        dataSet.get(j).x += t.get(0, 0);
        dataSet.get(j).x = (dataSet.get(j).x * (float) R.get(0, 0)) + (dataSet.get(j).y * (float) R.get(1, 0));
        dataSet.get(j).y += t.get(1, 0);
        dataSet.get(j).x = (dataSet.get(j).x * (float) R.get(0, 1)) + (dataSet.get(j).y * (float) R.get(1, 1));
      }
    }

    totalWeight = 0;
    weights.clear();

    //Vi skal have ligeså mange relevante model points som datapoints (alle data points skal mappes til ét model point kun)
    relevantModelPoints = new double[dataSet.size()][2];
    //Derfor er maks antal feature point lig antallet af datapoint
    totalFeaturePoints = dataSet.size();
    //Vi går i gennem alle datapoints, da alle som sagt skal mappes
    for (int i = 0; i < dataSet.size(); i++) {
      //Vi vil gerne finde det punkt par med den korteste distance, så vi starter med at sige at den korteste distance er uendeligt stort.
      float minDistance = (float) Double.POSITIVE_INFINITY;
      //Vi skal initiere variablen (dammit), så siger bare at den er -1, den burde altid ændre sig, da der bliver nødt til at være et punkt med lavere distance end uendeligt
      int minDistanceIndex = -1;
      //println("\nClonedModelPoints.size() " + ClonedModelPoints.size() + "\n");
      //Så går vi gennem alle punkter i vores model (husk på at det er opdelt efter hjørner og linjer og derfor ikke er uendeligt højt, cirka 2000 i artiklen)
      for (int j = 0; j < ClonedModelPoints.size(); j++) {
        //Så beregner vi vægten mellem data punktet og model punktet
        float distance = calculateWeight(dataSet.get(i).x, dataSet.get(i).y, ClonedModelPoints.get(j).x, ClonedModelPoints.get(j).y);
        //Hvis de er tættere på hinanden end den nuværende minDistance så gemmes den distance samt hvilket punkt som har den distance

        if (distance < minDistance) {
          minDistance = distance;
          minDistanceIndex = j;
        }
      }
      //I artiklen sætter de vægten lig 0 hvis den mindste distance er større end en fixed distance, så jeg laver et check på dette, og samtidigt trækker jeg 1 fra totalFeaturePoints fra vi så har et ikke
      //sammenhørende punkt par - Jeg er ikke helt sikker på at det er det de gør, men sådan tolker jeg det
      if (minDistance > minDistanceForCorrespondence) {
        minDistance = 0;
        totalFeaturePoints--;
      }
      //Gemmer vægten (skal bruges i formel 7 og til beregning af W)
      weights.add(minDistance);

      totalWeight += minDistance;

      //Og gemmer det punkt som matchede i vores relevantModelPoints array
      relevantModelPoints[i][0] = ClonedModelPoints.get(minDistanceIndex).x;
      relevantModelPoints[i][1] = ClonedModelPoints.get(minDistanceIndex).y;

      // removing the used points from the ClonedModelPoints so only one point can match to each
      ClonedModelPoints.remove(minDistanceIndex);
    }

    //Efter alle feature points er fundet, så kan jeg beregne confidence som de gør i formel 10
    if (dataPoints.size() != 0) {
      confidence = totalFeaturePoints/dataPoints.size();
    } else {
      //println("Pose.pde dataPoints.size() == 0");
    }
    //println("\nTrying to finde Mean Squared Error whit (1.0/(float)" + weights.size() + ") * " + totalWeight + " = " + (1.0/(float)weights.size()) * totalWeight + "\n");
    return (1.0/(float)weights.size()) * totalWeight;
  }
}
