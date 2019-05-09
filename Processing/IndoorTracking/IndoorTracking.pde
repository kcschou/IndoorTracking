import processing.serial.*;
import processing.net.*;
import java.util.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.FileReader;
import java.io.FileInputStream;
import java.io.NotSerializableException;
import java.io.FileNotFoundException;
import Jama.*;

import java.io.Serializable;

boolean calibrate = true;
int modelSize = 0; // used to keep track of the number of times the model has been updated under calibration
int modelSizeGoal = 10; // the number of times the model should have updated at the end of the calibration

static Location locationModel;
Location locationData;

//int val = 0;
int port = 5204;

Client myClient;

float x;
float y;
float distance;
float angle;
Boolean newScan; 
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

File dataFile;

ObjectOutputStream objectOutputStream;

void setup()
{
  size(1200, 800);

  gui = new GUI();

  //Tænkte at det ville være bedre at lave tests i en seperat klasse fremfor i main (Desværre ikke Unit-tests, så fancy er jeg ikke)
  //TestingEnvironment t = new TestingEnvironment();

  dataFile = dataFile(dataPath("LocationModel"));

  newScan = false;

  if (dataFile.isFile()) {
    locationModel = (Location) readFromFile(dataFile.getPath());
    calibrate = false;
    println("Loaded LocationModel from file");
  }
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
        if (valueRead.length > 2 && valueRead[2].equals("True")) {
          newScan = true;
        } else {
          newScan = false;
        }
        y = cos(radians(angle)) * (distance/scale);
        x = sin(radians(angle)) * (distance/scale);

        Point everyPoint = new Point(distance, angle, scale, height, width);

        points.add(everyPoint);

        //println("NewScan: " + valueRead[2]);

        // if newScan == '1'
        //println("pointts.size(): "+ points.size() + " newScan: " + newScan);
        if (newScan && points.size()>100) {
          update(0);
          //println("NewScan, points.size: " + points.size());
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

          println("UnfilteredPoints size: " + points.size() + " FilteredPoints size: " + filteredPoints.size()); //+ " Draw Point Size (Lines): " + clusterHandler.lines.size()
          //  + " Draw Point Size (Corners): " + clusterHandler.corners.size());

          //if (clusterHandler.corners.size() > 0) {
          //  println("Corner x: " + clusterHandler.corners.get(0).x + " Corner y: " + clusterHandler.corners.get(0).y);
          //}
          //er kommer igennem clusterHandler
          //println("er kommer igennem clusterHandler");
          gui.update(clusterHandler.lines, clusterHandler.corners);
          if (calibrate) {
            if (modelSize >= modelSizeGoal) {
              locationModel = new Location(clusterHandler.lines, clusterHandler.corners);
              writeToFile(dataPath("LocationModel"), locationModel);
              writeToFile(dataFile.getPath(), locationModel);
              println("LocatoinModel saved to file");
              points.clear();
              clusterHandler = new ClusterHandler();
              calibrate = false;
            } else {
              modelSize++;
            }
          } else {
            locationData = new Location(clusterHandler.lines, clusterHandler.corners);
            points.clear(); // to ensure that the locationData is based on only the latest scan
            //println("LocationModel test data: " + locationModel.Lines.size());
          }
          if (locationData != null && locationModel != null && clusterHandler.lines.size()>0) {
            //PoseCorner pCorner = new PoseCorner(locationModel, locationData);
            PoseLine pLine = new PoseLine(locationModel, locationData);
            //println("Test print of PoseLine transformation matrix\n");
            for (int i = 0; i < pLine.t.getArray().length; i++) {
              for (int j = 0; j < pLine.t.getArray()[i].length; j++) {
                //println("transform " + i + " " + j+ " : " +pLine.t.get(i, j));
              }
              //println();
            }
            //println("Test print of PoseLine rotation matrix\n");
            for (int i = 0; i < pLine.R.getArray().length; i++) {
              for (int j = 0; j < pLine.R.getArray()[i].length; j++) {
                //println("rotation " + i + " " + j+ " : " +pLine.R.get(i, j));
              }
              //println();
            }

            //println("Test print of PoseLine arg min");

            pLine.argmin();

            //println("Minimum Rotation: " + pLine.minR);
            //println("Minimum Translation: " + "x: " + pLine.minT.x + " y: " + pLine.minT.y);


            Matrix test = pLine.R.uminus().transpose().times(pLine.t);
            //println("\nTest print of the matrix: pLine.R.uminus().transpose().times(pLine.t)");
            for (int i = 0; i < test.getArray().length; i++) {
              for (int j = 0; j < test.getArray()[i].length; j++) {
                //print("t " + i + " " + j+ " : " +test.get(i, j));
              }
              //println();
            }
          }
        }
      }
    }
    update(1);
  }
  count++;
}

// the pdate function should take a 1 to get a new scan from the lidar and a 0 to have the python script wait
public void update(int update) {
  if (myClient.active()) {
    myClient.write(update);
  }
}


public void writeToFile(String path, Object data)
{
  try
  {

    ObjectOutputStream write = new ObjectOutputStream(new FileOutputStream(path));
    write.writeObject(data);
    write.close();
  }
  catch(NotSerializableException nse)
  {
    println("writeToFile NotSerializableException: " + nse);
  }
  catch(IOException eio)
  {
    println("writeToFile IOExceptoin: " + eio);
  }
}


public Object readFromFile(String path)
{
  Object data = null;

  try
  {
    FileInputStream fileIn = new FileInputStream(path);
    ObjectInputStream objectIn = new ObjectInputStream(fileIn);

    Object obj = objectIn.readObject();
    objectIn.close();
    return obj;
  }
  catch(ClassNotFoundException cnfe)
  {
    println("readFromFile ClassNotFoundException: " + cnfe);
  }
  catch(FileNotFoundException fnfe)
  {
    println("readFromFile FileNotFoundException: " + fnfe);
  }
  catch(IOException e)
  {
    println("readFromFile IOExceptoin: " + e);
  }
  return data;
}
