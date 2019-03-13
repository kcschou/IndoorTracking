public class Pose {
  Location dataSet;
  Location modelSet;

  Matrix dataMatrix;
  Matrix modelMatrix;


  Vector dataVector;
  Vector modleVector;

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

    double[][] calculationArray = new double[2][dataMatrix.getArray().length];
    double[][] modelMatrixLinesArray = modelMatrix.getArrayCopy();

    for (int i = 0; i < modelMatrix.getArray().length; i++) {
      weight = calculateWeight(width/2, height/2, 
        (float)modelMatrixLinesArray[0][i], (float)modelMatrixLinesArray[1][i]);
      calculationArray[0][i] = (modelMatrixLinesArray[0][i] * weight)/weight;
      calculationArray[1][i] = (modelMatrixLinesArray[1][i] * weight)/weight;
    }
  }

  public float calculateWeight(float firstX, float firstY, float secondX, float secondY ) {
    return dist(firstX, firstY, secondX, secondY);
  }

  public void calculateDataMatrix() {
    double[][] calculationMatrixCorners = 
      new double[2][dataSet.Corners.size()-1];
    double[][] calculationMatrixLines = 
      new double[2][dataSet.Lines.size()-1];
    for (int i = 0; i < dataSet.Corners.size()-1; i++) {
      calculationMatrixCorners[0][i] = dataSet.Corners.get(i).x;
      calculationMatrixCorners[1][i] = dataSet.Corners.get(i).y;
    }
    for (int i = 0; i < dataSet.Lines.size()-1; i++) {
      for (int j = 0; j < dataSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[0][j] = dataSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[1][j] = dataSet.Lines.get(i).cluster.get(j).y;
      }
    }

    dataMatrix = new Matrix(calculationMatrixLines);
  }

  public void calculateModelMatrix() {

    double[][] calculationMatrixCorners = 
      new double[2][modelSet.Corners.size()-1];
    double[][] calculationMatrixLines = 
      new double[2][modelSet.Lines.size()-1];
    for (int i = 0; i < modelSet.Corners.size()-1; i++) {
      calculationMatrixCorners[0][i] = modelSet.Corners.get(i).x;
      calculationMatrixCorners[1][i] = modelSet.Corners.get(i).y;
    }
    for (int i = 0; i < modelSet.Lines.size()-1; i++) {
      for (int j = 0; j < modelSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[0][j] = modelSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[1][j] = modelSet.Lines.get(i).cluster.get(j).y;
      }
    }

    modelMatrix = new Matrix(calculationMatrixLines);
  }
}
