PGraphics mySurface;
void settings() {
  size(400, 400, P2D);
}

void setup() {
  mySurface = createGraphics(200, 200, P2D);
}

void draw() {
  background(200, 0, 0);
  drawMySurface();
  image(mySurface, 10, 190);
}

void drawMySurface() {
  mySurface.beginDraw();
  mySurface.background(0);
  mySurface.ellipse(50, 50, 25, 25);
  mySurface.endDraw();
}
