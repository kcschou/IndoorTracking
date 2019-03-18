public class TestingEnvironment {

  TestingEnvironment() {

    //Udkommenter den her hvis der ikke ønskes tests, eventuelt tilføj flere test funktioner.
    tests();
  }

  public void tests() {


    //Laver en masse points jeg kan teste med
    Point first = new Point(1200, 50, scale);
    Point second = new Point(11000, 359, scale);
    Point third = new Point(120, 10, scale);
    Point fourth = new Point(130, 70, scale);
    Point fifth = new Point(140, 150, scale);
    Point sixth = new Point(150, 50, scale);
    Point seventh = new Point(160, 359, scale);
    Point eigth = new Point(17500, 10, scale);
    Point ninth = new Point(18000, 70, scale);
    Point tenth = new Point(190000, 150, scale);

    //Laver nogle hjørner jeg kan teste med
    ArrayList<Point> corners = new ArrayList<Point>();
    corners.add(first);
    corners.add(second);
    ArrayList<Point> corners2 = new ArrayList<Point>();
    corners2.add(eigth);
    corners2.add(ninth);
    corners2.add(tenth);

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
    ArrayList<Line> lines1 = new ArrayList<Line>();
    ArrayList<Line> lines2 = new ArrayList<Line>();
    lines1.add(line1);
    lines2.add(line2);

    //Ud fra de linjer og hjørner jeg har lavet laver jeg to lokationer (en til data og en til model)

    Location modelLocation1 = new Location(lines1, corners2);
    Location dataLocation2 = new Location(lines2, corners);

    //Laver en poseCorner og en poseLine ud fra lokationerne
    PoseCorner pCorner = new PoseCorner(modelLocation1, dataLocation2);
    PoseLine pLine = new PoseLine(modelLocation1, dataLocation2);

    //Tester om de kan beregne Data og Model Matricerne
    pCorner.calculateDataMatrix();
    pCorner.calculateModelMatrix();

    pCorner.ICP();

    //println(pLine.modelMatrix.getArray().length);

    //for (int i = 0; i < pLine.dataMatrix.getArray().length; i++) {
    //  for (int j = 0; j < pLine.dataMatrix.getArray()[i].length; j++) {
    //    println("DM " + i + " " + j+ " : " +pLine.dataMatrix.get(i, j));
    //  }
    //}

    //Tester om de kan beregne Model og Data vector
    pCorner.calculateModelVector();
    pCorner.calculateDataVector();
    
    pCorner.calculateS();
    
    //for (int i = 0; i < pCorner.R.getArray().length; i++) {
    //  for (int j = 0; j < pCorner.R.getArray()[i].length; j++) {
    //    println("DM " + i + " " + j+ " : " +pCorner.R.get(i, j));
    //  }
    //}

    //println(pCorner.modelVector.get(0).y);
    //println(pLine.modelVector.get(0).x);
  }
}
