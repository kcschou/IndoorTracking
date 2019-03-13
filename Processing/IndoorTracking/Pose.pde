public class Pose {
  Location dataSet;
  Location modelSet;

  Matrix dataMatrixCorner;
  Matrix dataMatrixLines;
  Matrix modelMatrixCorner;
  Matrix modelMatrixLines;
  

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

  public void calculateModleVector() {
  }

  public void calculateDataVector() {
    
      Vector calculationVector;
      double[][] calculationArray = new double[2][dataMatrixLines.getArray().length]
      
      for(int i = 0; i < dataMatrixLines.getArray().length; i++) {
       float weight = calculateWeight
        calculationArray[0][i] = 
        
      }
  }

  public float calculateWeight(Point modelPoint, Point dataPoint) {
  
    return dist(modelPoint.x, modelPoint.y, dataPoint.x, dataPoint.y);
    
    
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
      for(int j = 0; j < dataSet.Lines.get(i).cluster.size();j++){
      calculationMatrixLines[0][j] = dataSet.Lines.get(i).cluster.get(j).x;
      calculationMatrixLines[1][j] = dataSet.Lines.get(i).cluster.get(j).y;
      }
    }
    
    dataMatrixCorner = new Matrix(calculationMatrixCorners);
    dataMatrixLines = new Matrix(calculationMatrixLines);
  }

  public void calculateModelMatrix() {
  }
}
