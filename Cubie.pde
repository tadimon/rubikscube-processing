private class Cubie {

  private final PVector initPos; //Initial position
  private final PMatrix3D transforms; //Transformation matrix from cube center (current state)
  private final CubieFace[] faces;

  private Move currentMove = null; //Move being currently applied (animation, then result)

  public Cubie(int x, int y, int z) {
    this.initPos = new PVector(x, y, z); 
    this.transforms = new PMatrix3D(); 
    this.transforms.translate(x, y, z);
    //Create all faces according to Face Enum
    this.faces = new CubieFace[6];
    Face[] allFaces = Face.values();
    for (int index = 0; index < allFaces.length; index++) {
      Face face = allFaces[index];
      PVector facePos = face.getCenter().copy().div(2);
      //Decide color depending on relative position (which is also a normal vector)
      color col = color(0);
      float colorize = x * facePos.x + y * facePos.y + z * facePos.z;
      if (colorize > 0) {
        switch (face) {
          case RIGHT:
            col = color(255, 0, 0);   //red
            break;
          case LEFT:
            col = color(255, 128, 0); //orange
            break;
          case DOWN:
            col = color(255, 255, 0); //yellow
            break;
          case UP:
            col = color(255);         //white
            break;
          case FRONT:
            col = color(0, 255, 0);   //green
            break;
          case BACK:
            col = color(0, 0, 255);   //blue
            break;
        }
      }
      faces[index] = new CubieFace(col, facePos);
    }
  }

  public void setCurrentMove(Move move) {
    this.currentMove = move;
  }

  //Copy current position according to transforms into result vector
  public void putCurrentPos(PVector result) {
    //transformation matix contains current position in its last column
    result.set(transforms.m03, transforms.m13, transforms.m23);
  }

  //Immediately apply a rotation about a center with xyz angles given in a vector (move with no animation)
  public void rotateAbout(PVector center, PVector axisAngle) {
    PMatrix3D transf = new PMatrix3D();
    rotateMatrixAround(transf, center, axisAngle);
    transforms.preApply(transf);
  }
  
  //Restore initial position (clear transforms and move)
  public void reset() {
    transforms.reset();
    this.transforms.translate(this.initPos.x, this.initPos.y, this.initPos.z);
    currentMove = null;
  }
  
  //Apply current move as soon as animation is complete
  public void applyMoveIfDone() {
    if (currentMove != null && currentMove.isDone()) { // Apply current move as soon as animation is complete
      transforms.set(currentMove.combineTransform(transforms));
      currentMove = null;
    }
  }

  //Draw all faces in the right position and orientation.
  public void show(PGraphics g) {
    //Combine animation with applied transformations
    PMatrix3D transf = transforms;
    if (currentMove != null) {
      transf = currentMove.combineTransform(transforms);
    }

    g.pushMatrix();
    g.applyMatrix(transf); // Applies Cubie transformation to drawing plane.
    for (CubieFace face : faces) //Draw each face
      face.show(g);
    g.popMatrix();
  }
}
