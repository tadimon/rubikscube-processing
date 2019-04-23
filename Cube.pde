private class Cube {

  private Cubie[] qbs; //All cubies (small cube elements) in this Rubik's cube

  public Cube() {
    qbs  = new Cubie[26];
    int index = 0;
    for (int x = -1; x < 2; x++) {
      for (int y = -1; y < 2; y++) {
        for (int z = -1; z < 2; z++) {
          if (x == 0 && y == 0 && z == 0) //No Cubie in center
            continue;
          qbs[index++] = new Cubie(x, y, z);
        }
      }
    }
  }

  //Draw cube
  public void show(PGraphics g) {
    for (Cubie qb : qbs)
      qb.show(g);
  }

  //Do a move with animation (rotate a given face in a given direction)
  public void startMove(Move move) {
    Cubie[] faceElems = selectFace(move.getFace());
    for (Cubie qb : faceElems)
      qb.setCurrentMove(move);
  }

  //Apply current move as soon as animation is complete
  public void applyMoveIfDone() {
    for (Cubie qb : qbs)
      qb.applyMoveIfDone();
  }

  //Immediately rotate a given face in the given direction with no animation
  public void rotateFace(Face face, Direction dir) {
    Cubie[] faceElems = selectFace(face);
    //Rotation angle will be PI/2 on the same axis as the face's center, negated if direction is counter-clockwise
    PVector angles = face.getCenter().copy().setMag(HALF_PI).mult(dir.getDir());
    for (Cubie qb : faceElems)
      qb.rotateAbout(face.getCenter(), angles);
  }

  //Restore initial state
  public void reset() {
    for (Cubie qb : qbs) {
      qb.reset();
    }
  }

  //Select all Cubies making up a Cube Face
  //i.e. based on each Cubie's current transformation, get the 9 ones that are shifted in the same direction as Face center from Cube center (0, 0, 0)
  private Cubie[] selectFace(Face face) {
    Cubie[] faceElems = new Cubie[9];
    PVector fc = face.getCenter();
    int index = 0;
    PVector pos = new PVector();
    //println("---- in face (", fc.x, fc.y, fc.z, ") ------");
    for (Cubie qb : qbs) {
      qb.putCurrentPos(pos);
      pos.x = round(pos.x * 100); // Consider only 2 decimals to compensate for float approximations around 0
      pos.y = round(pos.y * 100);
      pos.z = round(pos.z * 100);
      if (
        fc.x > 0 && pos.x > 0 ||
        fc.x < 0 && pos.x < 0 ||
        fc.y > 0 && pos.y > 0 ||
        fc.y < 0 && pos.y < 0 ||
        fc.z > 0 && pos.z > 0 ||
        fc.z < 0 && pos.z < 0
        ) {
        //println(index, ": Put Cubie (", qb.pos.x, qb.pos.y, qb.pos.z, ") @ [", pos.x, pos.y, pos.z, "]");
        faceElems[index++] = qb;
      }
    }
    return faceElems;
  }
}
