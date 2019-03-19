public class PoseFused {

  Pose PoseLine;
  Pose PoseCorner;

  Matrix RFused;
  Matrix tFused;
  
  double confidenceFused;


  PoseFused(Pose PoseLine, Pose PoseCorner) {
    this.PoseLine = PoseLine;
    this.PoseCorner = PoseCorner;
  }
  
  public void fused() {
    
    confidenceFused = PoseCorner.confidence / (PoseLine.confidence + PoseCorner.confidence);
    RFused = (PoseCorner.R.times(confidenceFused)).plus(PoseLine.R.times(1-confidenceFused));
    tFused = (PoseCorner.t.times(confidenceFused)).plus(PoseLine.t.times(1-confidenceFused))
    
  }
  
  
}
