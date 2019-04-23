private class CubieFace {

  private color col;            //Face color
  private PMatrix3D relTransf;  //Transform (translation and rotation) from parent cubie

  // relpos is CubieFace center position relative to its parent cubie. It's also the face's normal vector
  // CubieFace transform is shifted by relPos and rotated according to it's normal
  // CubieFace color is col
  public CubieFace(color col, PVector relpos) {
    this.col = col;
    this.relTransf = new PMatrix3D();
    this.relTransf.translate(relpos.x, relpos.y, relpos.z);
    if (relpos.y != 0)
      this.relTransf.rotateX(HALF_PI);
    if (relpos.x != 0)
      this.relTransf.rotateY(HALF_PI);
  }

  //draw face as as square (side 1, border .2) of color col, according to its relative transformation
  public void show(PGraphics g) {
    g.pushMatrix();
    g.applyMatrix(relTransf); //Apply relative transformation.
    g.fill(col);
    g.stroke(0);
    g.strokeWeight(.2);
    g.square(0, 0, 1);
    g.popMatrix();
  }
}
