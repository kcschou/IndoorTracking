public class GUI {

   GUI() {
    
    
    
  }
  
  
  
  void update(ArrayList<Cluster> lines, ArrayList<Corner> corners){
    background(255);
    stroke(255, 0, 0);
    strokeWeight(5);
    point(width/2, height/2);
    //går tilbage til sort prik i størrelse 1
    //stroke(0);
    //strokeWeight(1);
    
    for(int i = 0; i < corners.size(); i++){
      
      stroke(corners.get(i).pointColor);
      strokeWeight(corners.get(i).strokeWeight);
      //println("corner farve: "+corners.get(i).pointColor+ " corner strokeweight: " + corners.get(i).strokeWeight);
      point(corners.get(i).x, corners.get(i).y);
    }
    for(int i = 0; i < lines.size(); i++){
      
      stroke(lines.get(i).cluster.get(0).pointColor);
      strokeWeight(lines.get(i).cluster.get(0).strokeWeight);
      for(int j = 0; j < lines.get(i).cluster.size(); j++){
         point(lines.get(i).cluster.get(j).x, lines.get(i).cluster.get(j).y);
         //line(width/2,height/2,givenClusters.get(i).cluster.get(j).x,givenClusters.get(i).cluster.get(j).y);
      }
    }
  }
}
