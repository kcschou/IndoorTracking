import processing.serial.*;
import processing.net.*;
import java.util.*;
import Jama.*;

// setup of server so python can send it data
Server myServer;
int val = 0;
int port = 5204;


Client pythonClient;

// Serial myPort;  // Create object from Serial class
// String val;     // Data received from the serial port
float x;
float y;
float distance;
float angle;
int scale = 10;
//InsertionSort insertionSort = new InsertionSort();

//ArrayList<Float[]> pointArray = new ArrayList<Float[]>();


//Vi laver en liste som indeholder alle målte Points
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Point> filteredPoints = new ArrayList<Point>();

//henter clusterhandler
ClusterHandler clusterHandler = new ClusterHandler();

float minimumAngleDifference = 0.1;

GUI gui;

int count = 0;

void setup()
{
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  //String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  //myPort = new Serial(this, portName, 115200);
  size(800, 600);

  //Vi laver en ny server
  myServer = new Server(this, port); 


  gui = new GUI();
  
  //Tænkte at det ville være bedre at lave tests i en seperat klasse fremfor i main (Desværre ikke Unit-tests, så fancy er jeg ikke)
  TestingEnvironment t = new TestingEnvironment();

  //scale(1, -1);
  //translate(0, -height);
  //println("InsertionSort test resultat: " + insertionSort.test());

  //Laver 5 "tilfældige2 Points, for at teste
  Point firstPoint = new Point(100, 50, scale);
  Point secondPoint = new Point(100, 359, scale);
  Point thirdPoint = new Point(100, 10, scale);
  Point fourthPoint = new Point(100, 70, scale);
  Point fifthPoint = new Point(100, 150, scale);

  //Smider alle Points i vores liste
  points.add(firstPoint);
  points.add(secondPoint);
  points.add(thirdPoint);
  points.add(fourthPoint);
  points.add(fifthPoint);

  //Gemmer den usortede liste, igen, som test, vi fylder den ud med alle de Point den anden liste har
  //(Vi kan ikke sige unsortedPoints = points da den i en sort() vil opdatere begge
  //for (int i = 0; i < points.size(); i++) {

  //  unsortedPoints.add(points.get(i));

  //}

  //Sortere listen (orkede ikke at importere Collections library (dovenskab), så har bare refereret til den helt
  //Collections.sort(points);

  //clusterHandler.updateList(points);

  //clusterHandler.isConnected(firstPoint, secondPoint);

  ////Printer alle vores Points ud
  //for (int i = 0; i < points.size(); i++) {

  //  println("Ikke sortede Points: " + unsortedPoints.get(i).angle + " Sorterede Points: " + points.get(i).angle);

  //}
}

void draw()
{
  // pythonClient is defiend here because it needs a client to be conected when it's looking for an available client, so it dosen't work when done in setup
  pythonClient = myServer.available();


  scale(1, -1);
  translate(0, -height);

  //if ( myPort.available() > 0) 
  //{  // If data is available,
  //  val = myPort.readStringUntil('\n');         // read it and store it in val
  //}

  //  if (val != null) {
  //    String[] valueRead = split(val, ','); 

  if (pythonClient !=null) {
    String whatClientSaid = pythonClient.readString();
    if (whatClientSaid != null) {
      String[] valueRead = split(whatClientSaid, ',');

      //println(valueRead[1]);

      if (valueRead.length > 1 &&!Float.isNaN(float(valueRead[0])) && !Float.isNaN(float(valueRead[1]))) {
        //println(count);

        distance = float(valueRead[0]);
        angle = float(valueRead[1]);
        //println("Correct numbers: " + distance/scale + " " + angle);
        y = cos(radians(angle)) * (distance/scale);

        x = sin(radians(angle)) * (distance/scale);

        //println("x: " + x+ " y: " + y);  
        //line(width/2, height/2, x + (width/2), y + (height/2));




        //point(x + (width/2), y+(height/2));

        //kan udkommenteres hvis point array virker. dette er til float array
        //Float[] Values = new Float[2];
        //Values[0] = distance;
        //Values[1] = angle;

        //pointArray.add(Values);

        Point everyPoint = new Point(distance, angle, scale);

        points.add(everyPoint);

        if (valueRead.length > 2 && valueRead[2].charAt(0) == '1') {
          //points = new ArrayList<Point>();
          //points.clear();
          //println("Points cleared, points:" + points);

          //Collections.sort(pointArray);
          Collections.sort(points);
          filteredPoints = new ArrayList<Point>();
          if (filteredPoints.size()==0){
          filteredPoints.add(points.get(0));
          }
          for (int i = 1; i < points.size()-1; i++) {
            if (abs(points.get(i).angle-filteredPoints.get(filteredPoints.size()-1).angle)>minimumAngleDifference) {
              filteredPoints.add(points.get(i));
            }
          }
          
          clusterHandler.updateList(filteredPoints);
          
          println("UnfilteredPoints size: " + points.size() + " FilteredPoints size: " + filteredPoints.size() + " Draw Point Size (Lines): " + clusterHandler.lines.size()
          + " Draw Point Size (Corners): " + clusterHandler.corners.size());
          
          if(clusterHandler.corners.size() > 0) {
            println("Corner x: " + clusterHandler.corners.get(0).x + " Corner y: " + clusterHandler.corners.get(0).y);
          }
            
          
          
          //er kommer igennem clusterHandler
          //println("er kommer igennem clusterHandler");
          gui.update(clusterHandler.lines, clusterHandler.corners);
        }

        //for (int i = 0; i < points.size(); i++){
        //   println(" Sorterede Points.angle: " + points.get(i).angle);
        //}
      }
      //}

      //println(val); //print it out in the console

      //print("angle: " + angle[1]);
      //println(" distance: " + radius[1]);
      //println("val: "+ val);

      //
    }
  }
  count++;
}
