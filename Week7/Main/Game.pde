Mover mover;
ParticleSystem ps;

final float plateSize = 600;
final float plateThickness = 10;

float prevMouseX, prevMouseY;
float rotationSpeed = PI / 200;
float xangle, zangle;

final int fRate = 50;

final color blue = color(15, 170, 210);
final color gold = color(190, 150, 20);

int totalScore = 0;
int lastScore = 0;

void initialize() {
  mover = new Mover();
  ps = new ParticleSystem();
}

void drawGame() {
  gameSurface.background(255);
  gameSurface.lights();
  gameSurface.ambientLight(3.0, 3.0, 3.0);
  gameSurface.fill(blue);

  if (keyPressed && keyCode == SHIFT) {
    gameSurface.translate(gameSurface.width/2, gameSurface.height/2, 0);
    gameSurface.rotateX(PI/2);
    ps.displayTop();
    mover.displayTop();
    gameSurface.box(plateSize, 1, plateSize);
    return;
  }

  gameSurface.textSize(20);
  gameSurface.text("Rotation X : " + (xangle / PI) * 180, 10, 20);
  gameSurface.text("Rotation Z : " + (zangle / PI) * 180, 10, 40);
  gameSurface.text("Speed : " + (rotationSpeed / PI) * 180, 10, 60);

  gameSurface.translate(gameSurface.width/2, gameSurface.height/2, 0);
  gameSurface.rotateX(xangle);
  gameSurface.rotateZ(zangle);
  ps.update(); //This must be done before the following line 
               //(as the collisions must be checked before updating the mover)
  
  mover.display(xangle, zangle);
  box(plateSize, plateThickness, plateSize);
  gameSurface.box(plateSize, plateThickness, plateSize);

  prevMouseX = mouseX;
  prevMouseY = mouseY;
  if (frameCount * 2 % fRate == 0) addBar(totalScore);
}

void mouseClicked() {
  float x = mouseX - gameSurface.width/2 + plateSize/2;
  float y = mouseY - gameSurface.height/2 + plateSize/2;
  PVector tentative = new PVector(mouseX - gameSurface.width/2, 0, mouseY - gameSurface.height/2);
  
  //Distance from the edges of the plate
  if (keyPressed && keyCode == SHIFT && 
    x > Cylinder.radius && x < plateSize - Cylinder.radius &&
    y > Cylinder.radius && y < plateSize - Cylinder.radius &&
    tentative.dist(mover.location) > Cylinder.radius + mover.radius) {
    ps.activate(tentative);
  }
}

void mouseWheel(MouseEvent event) {
  if (keyPressed && keyCode == SHIFT) return; //Don't detect in cylinder add mode
  
  //Rotation speed is bounded by PI/1000 and PI/16
  rotationSpeed = Math.max(PI / 1000, Math.min(rotationSpeed - event.getCount() / 100f, PI / 16));
}

void mouseDragged() {
  if (keyPressed && keyCode == SHIFT) return; //Don't detect in cylinder add mode
  if (mouseOver || locked) return; // Scroll bar is being used

  float xChange = mouseX - prevMouseX;
  float yChange = prevMouseY - mouseY;

  if (yChange < 0 && xangle >= - PI / 3) {
    xangle -= rotationSpeed;
  } else if (yChange > 0 && xangle <= PI / 3) {
    xangle += rotationSpeed;
  }

  if (xChange < 0 && zangle >= - PI / 3) {
    zangle -= rotationSpeed;
  } else if (xChange > 0 && zangle <= PI / 3) {
    zangle += rotationSpeed;
  }
}

void drawScoreBoard() {
  scoreBoard.textSize(20);
  scoreBoard.stroke(0, 0, 0);
  scoreBoard.text("Total Score:", 35, 35);
  scoreBoard.text(totalScore, 35, 60);
  scoreBoard.text("Velocity", 35, 100);
  float v = mover.velocity.mag() > 0.1 ? mover.velocity.mag() : 0;
  scoreBoard.text(String.format("%.1f", v), 35, 125);
  scoreBoard.text("Last Score", 35, 165);
  scoreBoard.text(lastScore, 35, 190);
}
