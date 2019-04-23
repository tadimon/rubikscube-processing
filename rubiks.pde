/**
  Controls :
    C : reset cube
    M : reset and mix cube
    SPACE : reset, mix and solve cube
    [Displayed letter] : select matching face
    UP or RIGHT : Rotate selected face clockwise
    DOWN or LEFT : Rotate selected face counter-clockwise
**/

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;


private static final int MOVE_FRAMES = 20;  // How many animation frames for each move
private static final float SCALE = 16f;     // Drawing scale (faces are drawn with size 1, border width .2)
private static final int MIX_MOVES = 50;    // How many moves to mix cube automatically


// Sketch state
private PGraphics canvas3d;
private boolean caminit = false;
private PeasyCam cam;
private Cube cube;
private Move currentMove = null;
private Move nextMove = null;
private Face selectedFace = null;

private Move[] solveMoves;
private int solveIndex = -1;


// Before any render
public void setup() {
  //size(800, 600, P3D);
  fullScreen(P3D);
  canvas3d = createGraphics(width, height, P3D);
  cam = new PeasyCam(this, canvas3d, 150 - 1);
  cam.setRotations(HALF_PI / 6, HALF_PI / 6, - HALF_PI / 30);
  cube = new Cube();
}

// On each rendering frame
public void draw() {
  
  if (!caminit) {
    cam.setDistance(cam.getDistance() + 1, 1);
    caminit = true;
  }
  
  //If we are solving, chain solving moves
  if (solveIndex >= 0 && solveIndex < solveMoves.length) {
      if (nextMove == null) {
         nextMove = solveMoves[solveIndex++]; 
      }
  }
  
  //Apply next move after current move is done. This allows recording one keyboard input before current animation is complete
  if (currentMove != null) {
    if (currentMove.isDone()) {
      cube.applyMoveIfDone();
      currentMove = null;
      if (nextMove != null) {
        currentMove = nextMove;
        nextMove = null;
        cube.startMove(currentMove);
      }
    } else {
      currentMove.step();
    }
  } else if (nextMove != null) {
    currentMove = nextMove;
    nextMove = null;
    cube.startMove(currentMove);
  }
  
  //Do actual drawing
  canvas3d.beginDraw();
  canvas3d.background(55);
  canvas3d.scale(SCALE);
  canvas3d.rectMode(CENTER);
  cube.show(canvas3d); // <- Cube drawn
  /* now we'll draw the text marker for each face */
  canvas3d.scale(.05f);
  canvas3d.textSize(30);
  canvas3d.textAlign(CENTER, CENTER);
  textFace(Face.UP, 0, -60, 0);
  textFace(Face.DOWN, 0, 60, 0);
  textFace(Face.LEFT, -60, 0, 0);
  textFace(Face.RIGHT, 60, 0, 0);
  textFace(Face.FRONT, -50, -50, 60);
  textFace(Face.BACK, 50, 50, -60);
  canvas3d.endDraw();
  
  //Draw 2D
  hint(DISABLE_DEPTH_TEST);
  noLights();
  image(canvas3d, 0, 0);
  textMode(MODEL);
  fill(255, 0, 255);
  textSize(height / 30f);
  textAlign(LEFT, TOP);
  text("FrameRate: " + frameRate + "fps", 0, 0);
  fill(128);
  float tsz = height / 40f;
  textSize(tsz);
  textAlign(RIGHT, BOTTOM);
  text("[C] Reset, [M] Mix, [SPACE] Mix & solve, [Face letter] Select face, [↑/→] Rotate face \u21bb, [↓/←] Rotate face \u21ba", width, height);
  text("Mouse drag to control view, scroll to zoom, middle button to shift", width, height - tsz);
}

// Key pressed event: manage controls
public void keyPressed() {
  //Special commands (reset-mix, reset, reset-mix-solve)
  if (solveIndex < 0 || solveIndex >= solveMoves.length) {
    if (currentMove == null) {
       switch (key) {
          case 'm':
          case 'M':
            mix();
            return;
          case 'c':
          case 'C':
            cube.reset();
            return;
          case ' ':
            mix();
            fakeSolve();
            return;
       }
    }
    
    //Select face
    Face f = Face.forLetter(key);
    if (f != null) {
      selectedFace = f;
    }
    
    //Rotate selected
    Direction dir = null;
    switch (keyCode) {
    case UP:
    case RIGHT:
      dir = Direction.CLOCKWISE;
      break;
    case DOWN:
    case LEFT:
      dir = Direction.COUNTER_CLOCKWISE;
      break;
    }
    //Apply move if direction chosen
    if (dir != null && selectedFace != null) {
      nextMove = new Move(selectedFace, dir);
    }
    
  }
}


// Draw text for a face at given position (using first letter in face name)
private void textFace(Face face, float x, float y, float z) {
  canvas3d.fill(face == selectedFace ? color(255, 0, 255) : color(255));
  canvas3d.text(face.getLetter(), x, y, z);
}

// Mix the Rubik's cube (make a sequence of MIX_MOVES moves for fake-solving and apply it backwards)
private void mix() {

  cube.reset();
  
  solveMoves = new Move[MIX_MOVES];
  for (int i = 0; i < solveMoves.length; i++) {
    boolean notSet = true;
    Face face = null;
    Direction dir = null;
    while (notSet) { // Avoid back and forth rotations, and prevent repeating moves more than twice, which makes no sense
      face = Face.values()[int(random(6))];
      dir = Direction.values()[int(random(2))];
      if (i < 1) {
        notSet = false;
      } else {
         Move pm = solveMoves[i - 1];
         if (pm.getFace() != face) {
            notSet = false; 
         } else if (pm.getDirection() != dir) {
            continue; 
         }
         if (i > 1) {
           pm = solveMoves[i - 2];
           if (pm.getFace() != face) {
              notSet = false; 
           }
         }
      }
    }
    solveMoves[i] = new Move(face, dir);
  }
  
  for (int i = solveMoves.length - 1; i >= 0; i--) {
    Move m = solveMoves[i].invert();
    cube.rotateFace(m.getFace(), m.getDirection());
  }
}

//Start fake solving (playing recorded solving moves)
private void fakeSolve() {
  if (solveMoves.length > 0 && (solveIndex < 0 || solveIndex >= solveMoves.length)) {
   solveIndex = 0; //Will trigger solving in draw()
  }
}
