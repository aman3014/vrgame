/* Uses the libarary video-2.0-beta1.zip from 
   https://github.com/processing/processing-video/releases/tag/r3-v2.0-beta1
*/

import processing.video.*;

Capture cam;
PImage img;

void settings() {
  size(1280, 480);
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
    cam = new Capture(this, 640, 480, cameras[0]);
    cam.start();
  }
}
void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  img = cam.get();
  image(img, 0, 0);
  detect(img);  
}
