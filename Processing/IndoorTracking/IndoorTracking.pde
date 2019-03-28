import processing.serial.*;
import processing.net.*;
import java.util.*;
import Jama.*;

boolean calibrate = true;

Location locationModel;
Location locationData;

int val = 0;
int port = 5204;

Client myClient;

float x;
float y;
float distance;
float angle;
int scale = 15;


//Vi laver en liste som indeholder alle målte Points
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Point> filteredPoints = new ArrayList<Point>();

//henter clusterhandler
ClusterHandler clusterHandler = new ClusterHandler();

float minimumAngleDifference = 0.1;

GUI gui;

int count = 0;

boolean connected = false;

PrintWriter printWriter;

void setup()
{
  size(1200, 800);

  gui = new GUI();

  //Tænkte at det ville være bedre at lave tests i en seperat klasse fremfor i main (Desværre ikke Unit-tests, så fancy er jeg ikke)
  TestingEnvironment t = new TestingEnvironment();

  //printWriter = createWriter(dataPath("LocationModel.txt"));
  //printWriter.println("test");
  //printWriter.flush();
  //printWriter.close();
}

void draw()
{
  if (!connected) {
    myClient = new Client(this, "localhost", 10002);
    if (myClient.active()) {
      connected = true;
    }
  }

  scale(1, -1);
  translate(0, -height);

  if (myClient !=null) {
    String whatClientSaid = myClient.readString();
    if (whatClientSaid != null) {
      String[] valueRead = split(whatClientSaid, ',');

      if (valueRead.length > 1 &&!Float.isNaN(float(valueRead[0])) && !Float.isNaN(float(valueRead[1]))) {
        distance = float(valueRead[0]);
        angle = float(valueRead[1]);
        y = cos(radians(angle)) * (distance/scale);
        x = sin(radians(angle)) * (distance/scale);

        Point everyPoint = new Point(distance, angle, scale);

        points.add(everyPoint);

        //println("NewScan: " + valueRead[2]);

        // if newScan == '1'
        if (valueRead.length > 2 && valueRead[2].equals("True")) {
          Collections.sort(points);
          filteredPoints = new ArrayList<Point>();
          if (filteredPoints.size()==0) {
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

          if (clusterHandler.corners.size() > 0) {
            println("Corner x: " + clusterHandler.corners.get(0).x + " Corner y: " + clusterHandler.corners.get(0).y);
          }
          //er kommer igennem clusterHandler
          //println("er kommer igennem clusterHandler");
          gui.update(clusterHandler.lines, clusterHandler.corners);
          if (calibrate) {
            locationModel = new Location(clusterHandler.lines, clusterHandler.corners);
            if (clusterHandler.lines.size() > 5) {
              calibrate = false;
            }
          } else {
            locationData = new Location(clusterHandler.lines, clusterHandler.corners);
          }
          if (locationData != null && clusterHandler.lines.size() > 3) {
            //PoseCorner pCorner = new PoseCorner(locationModel, locationData);
            PoseLine pLine = new PoseLine(locationModel, locationData);
          }
          update();
        }
      }
    } else {
      update();
    }
  } else {
    update();
  }
  count++;
}

public void update() {
  if (myClient.active()) {
    myClient.write(1);
  }
}
