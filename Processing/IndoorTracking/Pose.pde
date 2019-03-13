public class Pose {
  Location dataSet;
  Location modelSet;

  Matrix dataMatrix;
  Matrix modelMatrix;

  Vector dataVector;
  Vector modelVector;

  float r;
  float t;
  float weight;


  Pose(Location givenModelSet) {
    modelSet = givenModelSet;
  }

  public Matrix poseMatrix(Location givenDataSet) {
    dataSet = givenDataSet;



    return null;
  }

  public void calculateT() {
    
    
    
  }

  public void calculateR() {
  }

  public void calculateDataVector() {

    double[][] calculationArray = new double[2][dataMatrix.getArray().length];
    double[][] dataMatrixLinesArray = dataMatrix.getArrayCopy();

    for (int i = 0; i < dataMatrix.getArray().length; i++) {
      weight = calculateWeight(width/2, height/2, 
        (float)dataMatrixLinesArray[0][i], (float)dataMatrixLinesArray[1][i]);
      calculationArray[0][i] = (dataMatrixLinesArray[0][i] * weight)/weight;
      calculationArray[1][i] = (dataMatrixLinesArray[1][i] * weight)/weight;
    }

    dataVector = new Vector(Arrays.asList(calculationArray));
  }

  public void calculateModelVector() {

    double[][] calculationArray = new double[2][modelMatrix.getArray().length];
    double[][] modelMatrixArray = modelMatrix.getArrayCopy();

    for (int i = 0; i < modelMatrix.getArray().length; i++) {
      weight = calculateWeight(width/2, height/2, 
        (float)modelMatrixArray[0][i], (float)modelMatrixArray[1][i]);
      calculationArray[0][i] = (modelMatrixArray[0][i] * weight)/weight;
      calculationArray[1][i] = (modelMatrixArray[1][i] * weight)/weight;
    }
  }

  public float calculateWeight(float firstX, float firstY, float secondX, float secondY ) {
    return dist(firstX, firstY, secondX, secondY);
  }

  public void calculateDataMatrix() {
    
  }

  public void calculateModelMatrix() {

  }
}
