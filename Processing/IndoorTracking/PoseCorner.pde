public class PoseCorner extends Pose {

  PoseCorner(Location givenModelSet, Location givenDataSet) {
    super(givenModelSet, givenDataSet);
  }

  public void calculateModelMatrix() {

    double[][] calculationMatrixCorners = 
      new double[2][modelSet.Corners.size()-1];
    for (int i = 0; i < modelSet.Corners.size()-1; i++) {
      calculationMatrixCorners[0][i] = modelSet.Corners.get(i).x;
      calculationMatrixCorners[1][i] = modelSet.Corners.get(i).y;
    }
    super.modelMatrix = new Matrix(calculationMatrixCorners);
  }

  public void calculateDataMatrix() {
    double[][] calculationMatrixCorners = 
      new double[2][dataSet.Corners.size()-1];

    for (int i = 0; i < dataSet.Corners.size()-1; i++) {
      calculationMatrixCorners[0][i] = dataSet.Corners.get(i).x;
      calculationMatrixCorners[1][i] = dataSet.Corners.get(i).y;
    }
    super.dataMatrix = new Matrix(calculationMatrixCorners);
  }
}
