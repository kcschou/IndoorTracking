public class PoseCorner extends Pose {

  PoseCorner(Location givenModelSet, Location givenDataSet) {
    super(givenModelSet, givenDataSet);
  }
  
  //Vi bliver nødt til at have disse to funktioner herinde, da der er en forskel på om vi skal kigge på hjørner eller linjer - Essentielt så er PoseCorner og PoseLine ens
  
  //Vi skal beregne ModelMatrix og DataMatrix, det vil essentielt sige, at vi skal gemme enten alle hjørnerne eller alle linjer i en matrice og en liste (jeg tror vi kan undgå matricen, skal lige tænke mig om)
  
  public void calculateModelMatrix() {

    double[][] calculationMatrixCorners = 
      new double[2][modelSet.Corners.size()];
    for (int i = 0; i < modelSet.Corners.size(); i++) {
      calculationMatrixCorners[0][i] = modelSet.Corners.get(i).x;
      calculationMatrixCorners[1][i] = modelSet.Corners.get(i).y;
      super.modelPoints.add(modelSet.Corners.get(i));
    }
    super.modelMatrix = new Matrix(calculationMatrixCorners);
  }

  public void calculateDataMatrix() {
    double[][] calculationMatrixCorners = 
      new double[2][dataSet.Corners.size()];

    for (int i = 0; i < dataSet.Corners.size(); i++) {
      calculationMatrixCorners[0][i] = dataSet.Corners.get(i).x;
      calculationMatrixCorners[1][i] = dataSet.Corners.get(i).y;
      super.dataPoints.add(dataSet.Corners.get(i));
    }
    super.dataMatrix = new Matrix(calculationMatrixCorners);
  }
}
