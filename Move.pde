//Represents a move being applied to a Rubik's cube face. Useful for animation
private class Move implements Cloneable {
  
  private final Face face;           //Face to move
  private final Direction direction; //Rotation direction
  
  //Animation state
  private int iteration = 0;
  private float angle;
  private final float target;
  private boolean done = false; 
  
  public Move(Face face, Direction direction) {
    this.face = face;
    this.direction = direction;
    target = direction.getDir() * HALF_PI;
  }
  
  /* Getters */
  
  public Face getFace() {
     return face; 
  }
  
  public Direction getDirection() {
    return direction;
  }
  
  public boolean isDone() {
     return done; 
  }
  
  /* End getters */
  
  
  //Advance animation by 1 step. Limit to target angle, mak done if angle exceeded
  public void step() {
    float remain = target - angle;
    float remainsteps = MOVE_FRAMES - iteration++;
    angle += remain / remainsteps;
    if (abs(angle) >= abs(target)) {
      angle = target;
      done = true;
    }
  }
  
  //Combine a base transformation matrix with move being animated. Return a new matrix containing the result
  public PMatrix3D combineTransform(PMatrix3D baseTransform) {
    PMatrix3D transf = new PMatrix3D();
    PVector fc = face.getCenter();
    PVector pos = fc.copy().setMag(1).mult(angle);
    rotateMatrixAround(transf, fc, pos);
    transf.apply(baseTransform);
    return transf;
  }
  
  //Duplicate move (parameters, not state)
  @Override
  public Move clone() {
    return new Move(face, direction);
  }

  //Duplicate move with reversed direction
  public Move invert() {
    return new Move(face, direction == Direction.CLOCKWISE ? Direction.COUNTER_CLOCKWISE : Direction.CLOCKWISE);
  }
  
}
