public class PoseCorner extends Pose {

  PoseCorner(Location givenModelSet, Location givenDataSet) {
    super(givenModelSet, givenDataSet);
    calculateModelMatrix();
    calculateDataMatrix();
    WPICP(dataPoints, modelPoints);
    calculateModelVector();
    calculateDataVector();
    calculateS();
  }
  
  //Vi bliver nødt til at have disse to funktioner herinde, da der er en forskel på om vi skal kigge på hjørner eller linjer - Essentielt så er PoseCorner og PoseLine ens
  
  //Vi skal beregne ModelMatrix og DataMatrix, det vil essentielt sige, at vi skal gemme enten alle hjørnerne eller alle linjer i en matrice og en liste (jeg tror vi kan undgå matricen, skal lige tænke mig om)
  
  public void calculateModelMatrix() {

    double[][] calculationMatrixCorners = 
      new double[modelSet.Corners.size()][2];
    for (int i = 0; i < modelSet.Corners.size(); i++) {
      calculationMatrixCorners[i][0] = modelSet.Corners.get(i).x;
      calculationMatrixCorners[i][1] = modelSet.Corners.get(i).y;
      super.modelPoints.add(modelSet.Corners.get(i));
    }
    super.modelMatrix = new Matrix(calculationMatrixCorners);
  }

  public void calculateDataMatrix() {
    double[][] calculationMatrixCorners = 
      new double[dataSet.Corners.size()][2];

    for (int i = 0; i < dataSet.Corners.size(); i++) {
      calculationMatrixCorners[i][0] = dataSet.Corners.get(i).x;
      calculationMatrixCorners[i][1] = dataSet.Corners.get(i).y;
      super.dataPoints.add(dataSet.Corners.get(i));
    }
    super.dataMatrix = new Matrix(calculationMatrixCorners);
  }
}
