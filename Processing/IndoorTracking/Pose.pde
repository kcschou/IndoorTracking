public class Pose {
  Location dataSet;
  Location modelSet;

  Matrix dataMatrix;
  Matrix modelMatrix;

  Vector<Point> dataVector = new Vector();
  Vector<Point> modelVector = new Vector();

  float r;
  float t;
  float weight;

  Matrix X;
  Matrix Y;
  Matrix W;

  Matrix S;
  Matrix R;

  Pose(Location givenModelSet, Location givenDataSet) {
    modelSet = givenModelSet;
    dataSet = givenDataSet;
  }

  public Matrix poseMatrix(Location givenDataSet) {
    dataSet = givenDataSet;



    return null;
  }

  public void calculateT() {
  }

  public void calculateR() {
  }

  public void calculateS() {
  }
  
  //Formel 7 for P

  public void calculateDataVector() {

    double[][] dataMatrixArray = dataMatrix.getArrayCopy();

    float totalWeight = 0;

    float dataVectorX = 0;
    float dataVectorY = 0;


    for (int i = 0; i < dataMatrixArray[0].length; i++) {
      weight = calculateWeight(width/2, height/2, 
        (float)dataMatrixArray[0][i], (float)dataMatrixArray[1][i]);
      totalWeight += weight;
      dataVectorX += (dataMatrixArray[0][i] * weight);
      dataVectorY += (dataMatrixArray[1][i] * weight);
    }
    dataVectorX = dataVectorX/totalWeight;
    dataVectorY = dataVectorY/totalWeight;


    dataVector.add(new Point(dataVectorX, dataVectorY));
  }
  
  //Formel 7 for Q

  public void calculateModelVector() {

    double[][] modelMatrixArray = modelMatrix.getArrayCopy();

    float totalWeight = 0;

    float modelVectorX = 0;
    float modelVectorY = 0;
  
    for (int i = 0; i < modelMatrixArray[0].length; i++) {
      weight = calculateWeight(width/2, height/2, 
        (float)modelMatrixArray[0][i], (float)modelMatrixArray[1][i]);
      totalWeight += weight;
      modelVectorX += (modelMatrixArray[0][i] * weight);
      modelVectorY += (modelMatrixArray[1][i] * weight);
    }
    modelVectorX = modelVectorX/totalWeight;
    modelVectorY = modelVectorY/totalWeight;
    
    modelVector.add(new Point(modelVectorX, modelVectorY));
  }
}

public float calculateWeight(float firstX, float firstY, float secondX, float secondY ) {
  return dist(firstX, firstY, secondX, secondY);
}

public void calculateDataMatrix() {
}

public void calculateModelMatrix() {
}
