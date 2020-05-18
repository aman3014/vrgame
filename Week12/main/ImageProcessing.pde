import processing.video.*;
import gab.opencv.*;

class ImageProcessing extends PApplet {
  int w = 640, h = 480;

  Capture cam;
  PImage img;

  OpenCV opencv;
  
  PVector rotation = new PVector(0, 0, 0);
  BoardDetection detection = new BoardDetection(w, h, fRate);

  void settings() {
    size(w*2, h);
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
    opencv = new OpenCV(this, 100, 100);
    frameRate(fRate);
  }
  
  void draw() {
    if (cam.available()) {
      cam.read();
    }
    img = cam.get();
    image(img, 0, 0);
    rotation = detection.detectRotation(img);
  }
  
  PVector getRotation() {
    return rotation;
  }
}
