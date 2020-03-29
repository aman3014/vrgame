Mover mover;
ParticleSystem ps;

final float plateSize = 700;
final float plateThickness = 10;

float prevMouseX, prevMouseY;
float rotationSpeed = PI / 200;
float xangle, zangle;

final int fRate = 60;

final float[] blue = {15, 170, 210};
final float[] gold = {190, 150, 20};

void settings() {
  size(1800, 800, P3D);
}

void setup() {
  noStroke();
  frameRate(fRate);
  mover = new Mover();
  ps = new ParticleSystem();
}

void draw() {
  background(200);
  lights();
  ambientLight(3.0, 3.0, 3.0);

  if (keyPressed && keyCode == SHIFT) {
    translate(width/2, height/2, 0);
    rotateX(PI/2);
    changeColor(blue);
    mover.displayTop();
    box(plateSize, 1, plateSize);
    changeColor(gold);
    ps.displayTop();
    return;
  }

  textSize(20);
  text("Rotation X : " + (xangle / PI) * 180, 10, 20);
  text("Rotation Z : " + (zangle / PI) * 180, 10, 40);
  text("Speed : " + (rotationSpeed / PI) * 180, 10, 60);

  translate(width/2, height/2, 0);
  rotateX(xangle);
  rotateZ(zangle);
  changeColor(gold);
  ps.update(); //This must be done before the following line 
               //(as the collisions must be checked before updating the mover)
  
  changeColor(blue);
  mover.display(xangle, zangle);
  box(plateSize, plateThickness, plateSize);

  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void changeColor(float[] rgb) {
  fill(rgb[0], rgb[1], rgb[2]);
}

void mouseClicked() {
  float x = mouseX - width/2 + plateSize/2;
  float y = mouseY - height/2 + plateSize/2;
  PVector tentative = new PVector(mouseX - width/2, 0, mouseY - height/2);
  
  //Distance from the edges of the plate
  if (keyPressed && keyCode == SHIFT && 
    x > Cylinder.radius / 2 && x < plateSize - Cylinder.radius / 2 &&
    y > Cylinder.radius / 2 && y < plateSize - Cylinder.radius / 2 &&
    tentative.dist(mover.location) > Cylinder.radius / 2 + mover.radius) {
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
