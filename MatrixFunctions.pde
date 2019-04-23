//Apply a rotation about center by xyz angles given in axisAngles to an already existing transformation matrix
public static void rotateMatrixAround(PMatrix3D transf, PVector center, PVector axisAngle) {
  //translate to rotation center
  transf.translate(center.x, center.y, center.z);
  //rotate about all 3 axes as defined by axisAngles
  if (axisAngle.x != 0)
    transf.rotateX(axisAngle.x);
  if (axisAngle.y != 0)
    transf.rotateY(axisAngle.y);
  if (axisAngle.z != 0)
    transf.rotateZ(axisAngle.z);
  //translate back
  PVector reverse = center.copy().mult(-1);
  transf.translate(reverse.x, reverse.y, reverse.z);
}
