public static class Cluster implements Comparable, Serializable {

  ArrayList<Point> cluster = new ArrayList<Point>();

  // color clusterColor = color(255, 192, 203);

  static Random r;

  Cluster(ArrayList<Point> givenPoints) {

    //Skal lige sikre mig senere at den ikke bare ændre reference punktet.
    cluster = givenPoints;
  }

  public boolean belongInCluster(Point givenPoint) {

    return true;
  }

  public boolean addToCluster(Point givenPoint) {

    return true;
  }

  //Eftersom at vi gerne vil sortere i vores punkter, Processing ikke ved hvordan man sortere
  //en hjemmebrygget klasse, så benyttes compareTo metoden (dette er grunden til at Comparable bliver
  //implementeret helt øverst. Det er denne metode som sort() bruger
  int compareTo (Object o) {
    int checkedPoints = 4;
    //Først checker vi om det objekt vi sammenligner et Point med også er et Point
    if (o instanceof Cluster) {
      Cluster otherCluster = (Cluster)o;
      for (int i = 0; i <  checkedPoints; i++) {
        //int random = (int) random(this.cluster.size()-1);
        r = new Random(this.cluster.size()-1);
        int random = r.nextInt();
        Point randomPoint = this.cluster.get(random);
        if (!otherCluster.cluster.contains(randomPoint)) {
          return -1;
        }
      }
    }
    //Hvis det objekt som vores Point bliver sammenlignet med ikke er et Point så returneres 0 (ofte vil man lave noget ekstra
    //kode her for at sikre sig, at der sker noget andet, men det er meget sjældent at den kommer til at sammenligne et Point med noget andet)s
    return 0;
  }
}
