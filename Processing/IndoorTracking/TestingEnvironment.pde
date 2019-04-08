public class TestingEnvironment {

  Location l;

  TestingEnvironment() {

    //Udkommenter den her hvis der ikke ønskes tests, eventuelt tilføj flere test funktioner.
    tests();
    //locatioObjectCreateTest();
  }

  public void locatioObjectCreateTest() {


    File f = dataFile(dataPath("TestLocationModel"));
    if (!f.isFile()) {
      writeToFile(f.getPath(), l);
    } else {

      locationModel = (Location) readFromFile(f.getPath());
      println("I am a file");
      println(locationModel.Corners.get(0).x);
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

  public void tests() {


    //Laver en masse points jeg kan teste med
    Point first = new Point(1200, 50, scale, height, width);
    Point second = new Point(11000, 359, scale, height, width);
    Point third = new Point(120.21, 10, scale, height, width);
    Point fourth = new Point(130.98, 70, scale, height, width);
    Point fifth = new Point(140.11, 150, scale, height, width);
    Point sixth = new Point(150.23, 50, scale, height, width);
    Point seventh = new Point(160.1, 359, scale, height, width);
    Point eigth = new Point(175.9, 10, scale, height, width);
    Point ninth = new Point(180.6, 70, scale, height, width);
    Point tenth = new Point(190.5, 150, scale, height, width);

    //Laver nogle hjørner jeg kan teste med
    ArrayList<Corner> corners = new ArrayList<Corner>();
    //corners.add(first);
    //corners.add(second);
    //corners.add(seventh);
    // corners.add(sixth);
    ArrayList<Point> corners2 = new ArrayList<Point>();
    corners2.add(eigth);
    corners2.add(ninth);
    corners2.add(tenth);
    corners2.add(third);

    //Derefter laver jeg sørme også nogle punkter til linjer jeg kan teste med
    ArrayList<Point> pointLine1 = new ArrayList<Point>();
    pointLine1.add(third);
    pointLine1.add(fourth);
    pointLine1.add(fifth);
    ArrayList<Point> pointLine2 = new ArrayList<Point>();
    pointLine2.add(sixth);
    pointLine2.add(seventh);
    //Laver punkterne om til linje
    Line line1 = new Line(pointLine1);
    Line line2 = new Line(pointLine2);
    //Laver to linje lister og gemmer linjerne i dem
    ArrayList<Cluster> lines1 = new ArrayList<Cluster>();
    ArrayList<Cluster> lines2 = new ArrayList<Cluster>();
    lines1.add(line1);
    lines2.add(line2);

    //Ud fra de linjer og hjørner jeg har lavet laver jeg to lokationer (en til data og en til model)

    Location modelLocation1 = new Location(lines1, corners2);
    Location dataLocation2 = new Location(lines2, corners2);

    l = modelLocation1;

    //Laver en poseCorner og en poseLine ud fra lokationerne
    //PoseCorner pCorner = new PoseCorner(modelLocation1, dataLocation2);
    PoseLine pLine = new PoseLine(modelLocation1, dataLocation2);
    pLine.argmin();
    
    println("Minimum Rotation: " + pLine.minR);
    println("Minimum Translation: " + "x: " + pLine.minT.x + " y: " + pLine.minT.y);
    
    //Tester om de kan beregne Data og Model Matricerne
    //pCorner.calculateDataMatrix();
    //pCorner.calculateModelMatrix();

    //pCorner.ICP();

    //println(pLine.modelMatrix.getArray().length);

    //for (int i = 0; i < pLine.dataMatrix.getArray().length; i++) {
    //  for (int j = 0; j < pLine.dataMatrix.getArray()[i].length; j++) {
    //    println("DM " + i + " " + j+ " : " +pLine.dataMatrix.get(i, j));
    //  }
    //}

    //Tester om de kan beregne Model og Data vector
    //pCorner.calculateModelVector();
    //pCorner.calculateDataVector();

    //pCorner.calculateS();



    //Matrix test = pCorner.R.uminus().transpose().times(pCorner.t);

    //for (int i = 0; i < test.getArray().length; i++) {
    //  for (int j = 0; j < test.getArray()[i].length; j++) {
    //    println("t " + i + " " + j+ " : " +test.get(i, j));
    //  }
    //  println();
    //}

    //println(pCorner.modelVector.get(0).y);
    //println(pLine.modelVector.get(0).x);
  }
}
