public class PoseLine extends Pose {

  PoseLine(Location givenModelSet, Location givenDataSet) {
    super(givenModelSet, givenDataSet);
    calculateModelMatrix();
    calculateDataMatrix();
    ICP();
    calculateModelVector();
    calculateDataVector();
    calculateS();
  }


  public void calculateModelMatrix() {

    int totalsize = 0;

    for (int i = 0; i < modelSet.Lines.size(); i++) {
      totalsize=+ modelSet.Lines.get(i).cluster.size();
    }

    double[][] calculationMatrixLines = 
      new double[totalsize][2];
    for (int i = 0; i < modelSet.Lines.size(); i++) {
      for (int j = 0; j < modelSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[j][0] = modelSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[j][1] = modelSet.Lines.get(i).cluster.get(j).y;
      }
    }
    println(totalsize);
    super.modelMatrix = new Matrix(calculationMatrixLines);
  }

  public void calculateDataMatrix() {

    int totalsize = 0;

    for (int i = 0; i < dataSet.Lines.size(); i++) {
      totalsize=+ dataSet.Lines.get(i).cluster.size();
    }

    double[][] calculationMatrixLines = new double[totalsize][2];
    for (int i = 0; i < dataSet.Lines.size(); i++) {
      for (int j = 0; j < dataSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[j][0] = dataSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[j][1] = dataSet.Lines.get(i).cluster.get(j).y;
      }
    }

    super.dataMatrix = new Matrix(calculationMatrixLines);
  }
}
