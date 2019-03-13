public class Line extends Cluster {

  //ArrayList<Point> cluster = new ArrayList<Point>();
  
   Line(ArrayList<Point> givenPoints) {
   
    //Skal lige sikre mig senere at den ikke bare ændre reference punktet.
     super(givenPoints);
     //println(cluster);
     //super.clusterColor = color(0,0,255);
  }
  
  
  public boolean belongInCluster(Point givenPoint) {

    return true;
  }

  public boolean addToCluster(Point givenPoint) {

    return true;
  }
}
