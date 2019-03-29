public static class Point implements Comparable, Serializable {

  //Et punkt har en lokation (x,y), en distance ud til det og en vinkel fra Lidar'en
  float x;
  float y;
  float distance;
  float angle;

  float acceptableDistance = 10;

  int strokeWeight = 1;
  color pointColor = (0);

  int scale; 

  //Når punktet laves får det en distance, en vinkel og en scale på hvor meget distancen reduceres
  //da den måles i mm
  Point(float givenDistance, float givenAngle, int givenScale, int sHeight, int sWidth) {
    this.scale = givenScale;
    //Distance og vinkel sættes ud fra de værdier den får
    this.distance = givenDistance;
    this.angle = givenAngle;
    //Lokationen beregnes ud for trigonometriske regler.
    //der bruger height og width divideret med 2 for at centrere points i gui
    //this.y = (cos(radians(givenAngle)) * (givenDistance/scale))+(height/2);
    //this.x = (sin(radians(givenAngle)) * (givenDistance/scale))+(width/2);
    this.y = (cos(radians(givenAngle)) * (givenDistance/scale))+(sHeight/2);
    this.x = (sin(radians(givenAngle)) * (givenDistance/scale))+(sWidth/2);
  }
  
  //Indtil jeg finder en mere sexet måde, vælger jeg bare at kunne give muligheden for at lave et Point med et givent (x,y), da det gør vektor beregningerne nemmere
  Point(float x, float y) {
   
    this.x = x;
    this.y = y;
    
  }

  Point(float givenDistance, float givenAngle, int givenScale, boolean point) {
    
  }

  //Eftersom at vi gerne vil sortere i vores punkter, Processing ikke ved hvordan man sortere
  //en hjemmebrygget klasse, så benyttes compareTo metoden (dette er grunden til at Comparable bliver
  //implementeret helt øverst. Det er denne metode som sort() bruger
  int compareTo (Object o) {
    //Først checker vi om det objekt vi sammenligner et Point med også er et Point
    if (o instanceof Point) {
      //Laver et nyt Point objekt ud fra det objekt vi modtager (som vi nu ved er et Point)
      Point point = (Point) o;
      //Det som i vores tilfælde gør et Point større end et andet Point er udelukkende vinklen
      //hvis vinklen på det Point som vi sammenligner med er størst, så er det Point størst
      if (point.angle > this.angle) {
        //Vi returner -1 for at fortælle, at eftersom at vinklen på det andet Point er størst, så
        //dette Point mindst
        return -1;
      }
      //Omvendt, hvis vinklen på det Point vi sammenligner med er mindst, så er dette Point størst
      else if (point.angle < this.angle) {
        //Og vi returnere 1 for at vise, at dette point er større
        return 1;
      } else if (point.angle == this.angle && abs(point.distance - this.distance) < acceptableDistance) {
        //Hvis vinklen mellem de to Points hverken er mindre eller større så må de være ligeså store, derfor returneres 0
        return 0;
      }
    }
    //Hvis det objekt som vores Point bliver sammenlignet med ikke er et Point så returneres 0 (ofte vil man lave noget ekstra
    //kode her for at sikre sig, at der sker noget andet, men det er meget sjældent at den kommer til at sammenligne et Point med noget andet)s
    return -1;
  }
}
