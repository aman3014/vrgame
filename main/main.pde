import processing.video.*;

PGraphics gameSurface;
PGraphics topSurface;
PGraphics scoreBoard;
PGraphics barChart;
PGraphics scroll;
PGraphics infoSurface;

ImageProcessing imgproc;

final int fRate = 30;

final int margin = 20;
final int bottom = 300;
final int side = bottom - margin * 2;
final int topSurfaceSize = side; // for the other classes, not to be used in the main

final int windowWidth = 1800;
final int windowHeight = 1000;

void settings() {
  size(windowWidth, windowHeight, P3D);
}

void setup() {
  initialize();
  frameRate(fRate);
  gameSurface = createGraphics(width, height - bottom, P3D);
  infoSurface = createGraphics(width, bottom, P2D);
  topSurface = createGraphics(side, side, P2D);
  scoreBoard = createGraphics(side, side, P2D);
  barChart = createGraphics(width - bottom * 2 - margin, bottom - margin * 3, P2D);
  scroll = createGraphics(width, height);
  initScrollbar(bottom * 2, height - margin*3/2, barChart.width / 3, margin);
  
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
}

void draw() {
  background(175);
  
  // get the board's rotation angles from the image processing class
  PVector rot = imgproc.getRotation();
  float x = rot.x > 0 ? rot.x - PI : rot.x + PI;
  setRotation(-x, -rot.y);

  drawGameSurface();
  image(gameSurface, 0, 0);
  drawInfoSurface();
  image(infoSurface, 0, height - bottom);
  drawTopSurface();
  image(topSurface, margin, height - bottom + margin);
  drawScoreSurface();
  image(scoreBoard, side + margin * 2, height - bottom + margin);
  drawBarSurface();
  image(barChart, bottom * 2, height - bottom + margin);
  drawScroll();
  image(scroll, 0, 0);
}

void drawGameSurface() {
  gameSurface.beginDraw();
  gameSurface.noStroke();
  gameSurface.fill(0, 100, 100);
  drawGame();
  gameSurface.endDraw();
}

void drawInfoSurface() {
  infoSurface.beginDraw();
  infoSurface.background(175);
  infoSurface.endDraw();
}

void drawTopSurface() {
  topSurface.beginDraw();
  topSurface.background(0, 150, 200);
  topSurface.noStroke();
  mover.drawTopView();
  ps.drawTopView();
  topSurface.endDraw();
}

void drawScoreSurface() {
  scoreBoard.beginDraw();
  scoreBoard.stroke(255, 255, 255);
  scoreBoard.strokeWeight(3);
  scoreBoard.background(175);
  scoreBoard.noFill();
  scoreBoard.rect(0, 0, side, side, 10);
  drawScoreBoard();
  scoreBoard.endDraw();
}

void drawBarSurface() {
  barChart.beginDraw();
  barChart.background(240);
  barChart.noStroke();
  barChart.fill(128, 0, 128);
  displayBarChart(getSBPos());
  barChart.endDraw();
}

void drawScroll() {
  scroll.beginDraw();
  updateSB();
  displaySB();
  scroll.endDraw();
}
