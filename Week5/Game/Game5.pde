Mover mover;

final float plateSize = 700;
final float plateThickness = 10;

final float speedChange = 0.02;

final ArrayList<Cylinder> cylinders = new ArrayList<Cylinder>();

float prevMouseX, prevMouseY;
float rotationSpeed = PI / 200;
float xangle, zangle;

final float[] plateColor = {15, 170, 210};
final float[] cylinderColor = {190, 150, 20};

void settings() {
  size(1000, 1000, P3D);
}

void setup() {
  noStroke();
  mover = new Mover();
}

void draw() {
  background(200);
  lights();
  ambientLight(2.0, 2.0, 2.0);
  changeColor(plateColor);

  if (keyPressed && keyCode == SHIFT) {
    translate(width/2, height/2, 0);
    rotateX(PI/2);
    box(plateSize, 1, plateSize);
    changeColor(cylinderColor);
    for (Cylinder c : cylinders) c.displayTop();
    mover.displayTop();
    return;
  }

  textSize(20);
  text("Rotation X : " + (xangle / PI) * 180, 10, 20);
  text("Rotation Z : " + (zangle / PI) * 180, 10, 40);
  text("Speed : " + (rotationSpeed / PI) * 180, 10, 60);

  translate(width/2, height/2, 0);
  rotateX(xangle);
  rotateZ(zangle);
  box(plateSize, plateThickness, plateSize);
  
  changeColor(cylinderColor);
  for (Cylinder c : cylinders) c.display();

  mover.display(xangle, zangle);

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
    x > Cylinder.diameter / 2 && x < plateSize - Cylinder.diameter / 2 &&
    y > Cylinder.diameter / 2 && y < plateSize - Cylinder.diameter / 2 &&
    checkCylinderPlacement(tentative)) {
    cylinders.add(new Cylinder(tentative));
  }
}

boolean checkCylinderPlacement(PVector tentative) {
  // Distance from other cylinders
  for (Cylinder c : cylinders)
    if (tentative.dist(c.location) <= Cylinder.diameter * 2) return false;

  // Distance from the mover
  if (tentative.dist(mover.location) <= Cylinder.diameter / 2 + mover.radius) return false;

  return true;
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
