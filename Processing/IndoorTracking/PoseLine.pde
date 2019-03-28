public class PoseLine extends Pose {

  PoseLine(Location givenModelSet, Location givenDataSet) {
    super(givenModelSet, givenDataSet);
    println("After Constructor");
    calculateModelMatrix();
    println("After Model Matrix");
    calculateDataMatrix();
    println("After Data Matrix");
    ICP();
    println("After ICP");
    calculateModelVector();
    println("After Model Vector");
    calculateDataVector();
    println("After Data Vector");
    calculateS();
    println("After S");
  }


  public void calculateModelMatrix() {

    int totalsize = 0;

    for (int i = 0; i < modelSet.Lines.size(); i++) {
      totalsize = totalsize + modelSet.Lines.get(i).cluster.size();
    }

    double[][] calculationMatrixLines = 
      new double[totalsize][2];
      
      println("Model: Total size: " + totalsize + " Amount of Lines " + modelSet.Lines.size());
    for (int i = 0; i < modelSet.Lines.size(); i++) {
      for (int j = 0; j < modelSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[j][0] = modelSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[j][1] = modelSet.Lines.get(i).cluster.get(j).y;
        super.modelPoints.add(modelSet.Lines.get(i).cluster.get(j));
      }
    }
    super.modelMatrix = new Matrix(calculationMatrixLines);
  }

  public void calculateDataMatrix() {

    int totalsize = 0;

    for (int i = 0; i < dataSet.Lines.size(); i++) {
      totalsize = totalsize + dataSet.Lines.get(i).cluster.size();
    }

    println("Data: Total size: " + totalsize + " Amount of Lines " + modelSet.Lines.size());
    double[][] calculationMatrixLines = new double[totalsize][2];
    for (int i = 0; i < dataSet.Lines.size(); i++) {
      for (int j = 0; j < dataSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[j][0] = dataSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[j][1] = dataSet.Lines.get(i).cluster.get(j).y;
        super.dataPoints.add(dataSet.Lines.get(i).cluster.get(j));
      }
    }

    super.dataMatrix = new Matrix(calculationMatrixLines);
  }
}
