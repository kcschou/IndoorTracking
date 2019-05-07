public class ClusterHandler {

  private ArrayList<Point> points = new ArrayList<Point>();

  public ArrayList<Cluster> clusters = new ArrayList<Cluster>(); 

  //kan ændres til Corner-liste og Line-liste
  public ArrayList<Point> corners = new ArrayList<Point>(); 
  public ArrayList<Cluster> lines = new ArrayList<Cluster>(); 

  float maxDistance = 300/scale;
  float minDistance = 3/scale; 

  int minClusterSize = 5;

  int assocLength = 30;

  //ClusterHandler(ArrayList<Point> givenPoints) {

  //  //Skal lige sikre mig senere at den ikke bare ændre reference punktet.
  //  points = givenPoints;
  //}

  public void updateList(ArrayList<Point> givenPoints) {
    points.clear();
    points = givenPoints;
    corners.clear();
    lines.clear();
    createClusters();
  }

  public void createClusters() {

    int lastStop = 0;

    for (int i = 0; i < points.size()-1; i++) {

      if (!isConnected(points.get(i), points.get(i+1))) {

        ArrayList<Point> newPoints = new ArrayList<Point>();

        for (int j = lastStop; j < i; j++) {

          newPoints.add(points.get(j));
        }

        //if (newPoints.size()>minClusterSize) {
        //  Cluster cluster = new Cluster(newPoints); 

        //  clusters.add(cluster);
        //}

        //println("før isItALine");
        if(newPoints.size() > minClusterSize){
        isItALineCluster(newPoints);
        //println("efter isItALine");
        }
        //if (newPoints.size()>minCluterSize && isItALineCluster(newPoints)) {
        //  Line line = new Line(newPoints);
        //  clusters.add(line);
        //} else if(newPoints.size()>minClusterSize) {
        //  Corner corner = new Corner(newPoints);
        //  clusters.add(corner);
        //  //println("CORNER!!!");
        //}

        lastStop = i;
      }
    }
    //TestCluster(); //prints data about number of cluster types
  }

  public boolean isConnected(Point first, Point second) {
    //println("dist! "+dist(first.x, first.y, second.x, second.y));
    if (dist(first.x, first.y, second.x, second.y) < maxDistance && dist(first.x, first.y, second.x, second.y) > minDistance) {
      //println("distance is more than " + maxDistance);
      //println("distance: " + dist(first.x, first.y, second.x, second.y));
      //println("first x: " + first.x + " first y: " + first.y + "\n "+ "second x: " + second.x + " second y: "+ second.y);
      return true;
    }
    //println("distance is less than " + maxDistance +" = points are connected");
    //println("distance: " + dist(first.x, first.y, second.x, second.y));
    //println("first x: " + first.x + " first y: " + first.y + "\n "+ "second x: " + second.x + " second y: "+ second.y);
    return false;
  }


  public void isItALineCluster(ArrayList<Point> givenPoints) {
    Point firstPoint = givenPoints.get(0);
    Point lastPoint = givenPoints.get(givenPoints.size()-1);
    int cornerPlace = -1;
    float cornerDistance =0;

    //vi skal lave en linje mellem punkterne og finde hældningen (slope)
    //float slope = (firstPoint.y - lastPoint.y)/(firstPoint.x - lastPoint.x);
    ////finder startpunkt, hvor hældningen skal begynde
    //float offset = firstPoint.y - (slope * firstPoint.x);
    //if (givenPoints.size() > minClusterSize) {
      for (int i = 0; i < givenPoints.size()-1; i++) {
        float distanceToLine = (abs((lastPoint.y - firstPoint.y)*givenPoints.get(i).x 
          - (lastPoint.x - firstPoint.x)*givenPoints.get(i).y + lastPoint.x*firstPoint.y-lastPoint.y*firstPoint.x)/ 
          sqrt(pow(lastPoint.y-firstPoint.y, 2) + pow(lastPoint.x-firstPoint.x, 2)));

        if (distanceToLine > assocLength) {
          //hvis den er større end vores angivede afstand til linjen mellem to punkter, er det et hjørne
          if (distanceToLine > cornerDistance) {
            cornerPlace = i;
            cornerDistance = distanceToLine;
          }
        }
      }
      if (cornerPlace != -1) {
        corners.add(new Corner(givenPoints.get(cornerPlace).distance,givenPoints.get(cornerPlace).angle,givenPoints.get(cornerPlace).scale, height, width));

        if (cornerPlace > minClusterSize) {
          ArrayList<Point> lineBeforeCorner = new ArrayList <Point> (givenPoints.subList(0, cornerPlace-1));
          lines.add(new Line(lineBeforeCorner));
        }
        if (givenPoints.size()-cornerPlace > minClusterSize) {
          ArrayList<Point> lineAfterCorner = new ArrayList <Point> (givenPoints.subList(cornerPlace+1, givenPoints.size()));
          lines.add(new Line(lineAfterCorner));
        }
      } else {
        lines.add(new Line(givenPoints));
      }
    //}
  }

  public void TestCluster() {
    println("Der er oprettet " + clusters.size() + " test clustere. ");
    for (int i = 0; i < clusters.size()-1; i++) {
      println("Test cluster " + i + " er en " + clusters.get(i).getClass().getName() + " og inholder " + clusters.get(i).cluster.size() + " points. ");
    }
  }
}
