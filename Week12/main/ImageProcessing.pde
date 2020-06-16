import processing.video.*;
import gab.opencv.*;

class ImageProcessing extends PApplet {
  int w = 800, h = 480;

  Movie movie;
  OpenCV opencv;
  TwoDThreeD transform = new TwoDThreeD(w, h, fRate);
  QuadGraph qg = new QuadGraph();

  PVector rotation = new PVector(0, 0, 0);
  BoardDetection detection = new BoardDetection(w, h);

  void settings() {
    size(w, h);
  }
  
  void setup() {
    movie = new Movie(this, "C:/Users/amanb.DESKTOP-ODLI3IU/vrgame/Week12/resources/testvideo.avi");
    movie.frameRate(fRate);
    movie.loop();
    
    opencv = new OpenCV(this, 100, 100);
    frameRate(fRate);
  }
  
  void draw() {
    if (movie.available()) {
      movie.read();
      PImage img = movie.get(0, 0, w, h);
      image(img, 0, 0);
      List<PVector> lines = detection.hough_lines(img);
      draw_hough(img, lines);
      rotation = transform.get3DRotations(corners(lines, img));
    }
  }
  
  PVector getRotation() {
    return rotation;
  }

  List<PVector> corners(List<PVector> lines, PImage img) {
    List<PVector> corners = qg.findBestQuad(lines, img.width, img.height,
                        img.width * img.height * 3 / 4, img.width * img.height / 16, false);
    if (!corners.isEmpty()) {
      stroke(0, 0, 0);
      fill(255, 0, 0, 100);
      circle(corners.get(0).x, corners.get(0).y, 70);
      fill(0, 255, 0, 100);
      circle(corners.get(1).x, corners.get(1).y, 70);
      fill(0, 0, 255, 100);
      circle(corners.get(2).x, corners.get(2).y, 70);
      fill(255, 255, 0, 100);
      circle(corners.get(3).x, corners.get(3).y, 70);
    }

    for (int i = 0; i < corners.size(); ++i) {
      corners.set(i, new PVector(corners.get(i).x, corners.get(i).y, 1));
    }

    return corners;
  }

  void draw_hough(PImage edgeImg, List<PVector> lines) {
    for (int idx = 0; idx < lines.size(); idx++) {
      PVector line = lines.get(idx);
      float r = line.x;
      float phi = line.y;
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      // Finally, plot the lines
      stroke(0, 0, 255);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
    }
  }
}
