//Defines a Face by it's center, which is also its normal vector
private enum Face {
  UP(new PVector(0, -1, 0)),
  DOWN(new PVector(0, 1, 0)),
  LEFT(new PVector(-1, 0, 0)),
  RIGHT(new PVector(1, 0, 0)),
  FRONT(new PVector(0, 0, 1)),
  BACK(new PVector(0, 0, -1)),
  ;
  
  PVector center;
  
  private Face(PVector center) {
     this.center = center; 
  }
  
  //Get Face center
  public PVector getCenter() {
    return center;
  }
  
  //Get letter representing this Face
  public String getLetter() {
    return name().substring(0, 1);
  }
  
  //Given a letter, get a Face represented by it
  public static Face forLetter(char letter) {
    for (Face f : Face.values()) {
       if (f.name().charAt(0) == letter || f.name().toLowerCase().charAt(0) == letter)
         return f;
    }
    return null;
  }
  
}

//Defines a rotation direction with a signed value (clockwise = 1, counter-clockwise = -1)
private enum Direction {
  
  CLOCKWISE(1),
  COUNTER_CLOCKWISE(-1),
  ;
  
  int dir;
  
  private Direction(int dir) {
     this.dir = dir; 
  }
  
  //get rotation direction
  public int getDir() {
    return dir;
  }
    
}
