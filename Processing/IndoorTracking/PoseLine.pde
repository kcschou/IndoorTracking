public class PoseLine extends Pose {
  
  PoseLine(Location givenModelSet) {
    super(givenModelSet);
  }
  
  
   public void calculateModelMatrix() {
     
     int totalsize = 0;
     
     for(int i = 0; i < modelSet.Lines.size()-1; i++) {
       totalsize=+ modelSet.Lines.get(i).cluster.size();
     }
     
    double[][] calculationMatrixLines = 
      new double[2][totalsize];
    for (int i = 0; i < modelSet.Lines.size()-1; i++) {
      for (int j = 0; j < modelSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[0][j] = modelSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[1][j] = modelSet.Lines.get(i).cluster.get(j).y;
      }
    }
    
    super.modelMatrix = new Matrix(calculationMatrixLines);
    
  }
  
  
  public void calculateDataMatrix() {
    
     double[][] calculationMatrixLines = new double[2][dataSet.Lines.size()-1];
    
    for (int i = 0; i < dataSet.Lines.size()-1; i++) {
      for (int j = 0; j < dataSet.Lines.get(i).cluster.size(); j++) {
        calculationMatrixLines[0][j] = dataSet.Lines.get(i).cluster.get(j).x;
        calculationMatrixLines[1][j] = dataSet.Lines.get(i).cluster.get(j).y;
      }
    }

    super.dataMatrix = new Matrix(calculationMatrixLines);
  } 
}
