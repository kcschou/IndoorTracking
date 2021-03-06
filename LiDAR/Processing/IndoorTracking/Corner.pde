public static class Corner extends Point implements Comparable, Serializable{

  //ArrayList<Point> cluster = new ArrayList<Point>();
  //color custerColor;
    //Et punkt har en lokation (x,y), en distance ud til det og en vinkel fra Lidar'en
  float x;
  float y;
  float distance;
  float angle;
  
  float acceptableDistance = 10;
  
  static color red = #FF0000;
  
  //color pointColor = color(0,255,0);

  //Når punktet laves får det en distance, en vinkel og en scale på hvor meget distancen reduceres
  //da den måles i mm
    Corner(float givenDistance, float givenAngle, int scale, int sHeight, int sWidth) {
      super(givenDistance, givenAngle, scale, sHeight, sWidth);
    //this.y = (cos(radians(givenAngle)) * (givenDistance/scale))+(height/2);
    //this.x = (sin(radians(givenAngle)) * (givenDistance/scale))+(width/2);
    this.y = (cos(radians(givenAngle)) * (givenDistance/scale))+(sHeight/2);
    this.x = (sin(radians(givenAngle)) * (givenDistance/scale))+(sWidth/2);
      super.strokeWeight = 5;
      //strokeWeight(1);
      super.pointColor = red;
      //super.pointColor = color(0,255,0);
      
      ////Distance og vinkel sættes ud fra de værdier den får
      //this.distance = givenDistance;
      //this.angle = givenAngle;
      ////Lokationen beregnes ud for trigonometriske regler.
      ////der bruger height og width divideret med 2 for at centrere points i gui
      //this.y = (cos(radians(givenAngle)) * (givenDistance/scale))+(height/2);
      //this.x = (sin(radians(givenAngle)) * (givenDistance/scale))+(width/2);   
  }
  
  int compareTo (Object o) {
   return super.compareTo(o); 
  }
  
  //Corner(float givenDistance, float givenAngle, int scale, boolean point) {
  //  super(givenDistance,givenAngle,scale,point);
  //}
   
}
