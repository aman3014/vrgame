/* Uses the libarary video-2.0-beta1.zip from 
   https://github.com/processing/processing-video/releases/tag/r3-v2.0-beta1
*/

import processing.video.*;
int w = 640, h = 480;

Capture cam;
PImage img;

void settings() {
  size(2 * w, h);
}

void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, w, h, cameras[0]);
    cam.start();
  }
  precomputations(); // filling sin and cos tables
}
void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  img = cam.get();
  image(img, 0, 0);
  detect(img);  
}
