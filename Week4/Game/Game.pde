void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
  mover = new Mover();
}

Mover mover;
float plateSize = 300;
float plateThickness = 10;
float prevMouseX, prevMouseY;
float xangle, zangle;
float rotation = PI / 200;
final float speedChange = 0.02;

void draw() {
  background(200);
  lights();
  ambientLight(2.0, 2.0, 2.0);
  
  textSize(20);
  text("Rotation X : " + (xangle / PI) * 180, 10, 20);
  text("Rotation Z : " + (zangle / PI) * 180, 10, 40);
  text("Speed : " + (rotation / PI) * 180, 10, 60);
  
  translate(width/2, height/2, 0);
  rotateX(xangle);
  rotateZ(zangle);
  box(plateSize, plateThickness, plateSize);
  
  mover.display(xangle, zangle);
 
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mouseWheel(MouseEvent event) {
  rotation = Math.max(PI / 1000, Math.min(rotation - event.getCount() / 100f, PI / 16));
}

void mouseDragged() {
  float xChange = mouseX - prevMouseX;
  float yChange = prevMouseY - mouseY;
  
  if (yChange < 0 && xangle >= - PI / 3) {
    xangle -= rotation;
  } else if (yChange > 0 && xangle <= PI / 3) {
    xangle += rotation;
  }
  
  if (xChange < 0 && zangle >= - PI / 3) {
    zangle -= rotation;
  } else if (xChange > 0 && zangle <= PI / 3) {
    zangle += rotation;
  }
}
