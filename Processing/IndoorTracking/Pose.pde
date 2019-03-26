public class Pose {


  //De sætter den til 50 cm i artiklen (40000 er bare for at kunne arbejde med min dumme fiktive værdier)
  float minDistanceForCorrespondence = 40000;

  //Ved ikke om de bliver nødvendige, men tænker at den helst skal vide hvor den sidste har været
  float previousX;
  float previousY;

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
  public void calculateT() {

    double[][] dataV = new double[2][1];
    dataV[0][0] = dataVector.get(0).x;
    dataV[1][0] = dataVector.get(0).y;

    double[][] modelV = new double[2][1];
    modelV[0][0] = modelVector.get(0).x;
    modelV[1][0] = modelVector.get(0).y;

    Matrix dv = new Matrix(dataV);
    Matrix mv = new Matrix(modelV);
    t = mv.minus(R.times(dv));
  }

  //Formel 9
  public void calculateR() {

    //Vi skal først beregne U og V ud fra S
    Matrix U;
    Matrix V;

    U = S.svd().getU();
    V = S.svd().getV();


    //Derefter har vi alle værdier som skal bruges for at beregne R
    R = U.transpose().times(V);

    calculateT();
  }

  //Formel 8
  public void calculateS() {

    //Vi laver et dobbelt array til både X, Y og W, fra formel 8, som senere bliver lavet om til Matricer. Grunden til at jeg gør det på den måde er, at det er nemmere at fylde ting i et
    //dobbelt array og senere lave det om til en matrice end direkte lave det til en matrice med det samme.
    //Hvis alt er gjort ordentligt så burde dataPoint.size() = weight.size() og teknisk set også = relevantModelPoints[1].length (jeg hader bare at bruge den)
    double[][] XArray = new double[dataPoints.size()][2];
    double[][] YArray = new double[dataPoints.size()][2];
    double[][] WArray = new double[weights.size()][weights.size()];

    //Vi skal beregner både X, Y og W, som de gør mellem formel 7 og 8
    for (int i = 0; i < dataPoints.size(); i++) {

      XArray[i][0] = dataPoints.get(i).x - dataVector.get(0).x;
      XArray[i][1] = dataPoints.get(i).y - dataVector.get(0).y;

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

    //for (int i = 0; i < W.getArray().length; i++) {
    //  for (int j = 0; j < W.getArray()[i].length; j++) {
    //    println("DM " + i + " " + j+ " : " +W.get(i, j));
    //  }
    //  println();
    //}



    //W = W.svd().getS();

    //Nu når vi har alle værdier kan vi beregne S som de gør mellem formel 7 og 8
    S = Y.transpose().times(W.times(X));

    //Hvorfor ikke beregne R med det samme efter
    calculateR();
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

      //Inkrementere den totale vægt med den næste vægt i rækken
      totalWeight+= weights.get(i);
      //Inkrementere dataVector X og Y (det svare til det de gør i numeratoren i formel 7)
      dataVectorX += (dataMatrixArray[i][0] * weights.get(i));
      dataVectorY += (dataMatrixArray[i][1] * weights.get(i));
    }

    //for (int i = 0; i < dataMatrixArray[0].length; i++) {
    //  weight = calculateWeight(width/2, height/2, 
    //    (float)dataMatrixArray[0][i], (float)dataMatrixArray[1][i]);
    //  totalWeight += weight;
    //  dataVectorX += (dataMatrixArray[0][i] * weight);
    //  dataVectorY += (dataMatrixArray[1][i] * weight);
    //}

    //Får lige demoninatoren med i formlen, det er dette vi bruger den totale vægt til
    dataVectorX = dataVectorX/totalWeight;
    dataVectorY = dataVectorY/totalWeight;

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

      totalWeight+= weights.get(i);
      modelVectorX += (modelMatrixArray[i][0] * weights.get(i));
      modelVectorY += (modelMatrixArray[i][1] * weights.get(i));
    }

    //for (int i = 0; i < modelMatrixArray[0].length; i++) {
    //  weight = calculateWeight(width/2, height/2, 
    //    (float)modelMatrixArray[0][i], (float)modelMatrixArray[1][i]);
    //  totalWeight += weight;
    //  modelVectorX += (modelMatrixArray[0][i] * weight);
    //  modelVectorY += (modelMatrixArray[1][i] * weight);
    //}

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

  //Uha, så kommer den famøse ICP (Iterative Closest Point) algoritme som de går gennem i section 3.2, den skal gennemgåes før Pose beregningen (måske den skal i en anden klasse, det kan vi snakke om)
  public void ICP() {

    //Vi skal have ligeså mange relevante model points som datapoints (alle data points skal mappes til ét model point kun)
    relevantModelPoints = new double[dataPoints.size()][2];
    //Derfor er maks antal feature point lig antallet af datapoint
    totalFeaturePoints = dataPoints.size();
    //Vi går i gennem alle datapoints, da alle som sagt skal mappes
    for (int i = 0; i < dataPoints.size(); i++) {
      //Vi vil gerne finde det punkt par med den korteste distance, så vi starter med at sige at den korteste distance er uendeligt stort.
      float minDistance = (float) Double.POSITIVE_INFINITY;
      //Vi skal initiere variablen (dammit), så siger bare at den er -1, den burde altid ændre sig, da der bliver nødt til at være et punkt med lavere distance end uendeligt
      int minDistanceIndex = -1;
      //Så går vi gennem alle punkter i vores model (husk på at det er opdelt efter hjørner og linjer og derfor ikke er uendeligt højt, cirka 2000 i artiklen)
      for (int j = 0; j < modelPoints.size(); j++) {
        //Så beregner vi vægten mellem data punktet og model punktet
        float distance = calculateWeight(dataPoints.get(i).x, dataPoints.get(i).y, modelPoints.get(j).x, modelPoints.get(j).y);
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
      //Og gemmer det punkt som matchede i vores relevantModelPoints array
      relevantModelPoints[i][0] = modelPoints.get(minDistanceIndex).x;
      relevantModelPoints[i][1] = modelPoints.get(minDistanceIndex).y;
    }
    //Efter alle feature points er fundet, så kan jeg beregne confidence som de gør i formel 10
   if(dataPoints.size() != 0){
    confidence = totalFeaturePoints/dataPoints.size();
  } else {
  println("Pose.pde dataPoints.size() == 0");
  }
  }
}
