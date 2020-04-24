PImage img;
HScrollbar hs;

void settings() {
  size(1600, 600);
}

void setup() {
  img = loadImage("../../resources/board4.jpg");
  hs = new HScrollbar(0, img.height - 20, img.width, 20);
}

void draw() {
  hs.update();
  int threshold = (int) map(hs.getPos(), 0, 1, 0, 255);
  image(img, 0, 0);//show image
  PImage filtered = thresholdBinary(img, threshold);
  image(filtered, img.width, 0);
  hs.display();
}

PImage thresholdBinary(PImage img, int threshold) {
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  float max = 0;
  for (int i = 0; i < img.pixels.length; ++i) {
    if (brightness(img.pixels[i]) > max) {
      max = brightness(img.pixels[i]);
    }
  }
  for (int i = 0; i < img.width * img.height; i++) {
    // do something with the pixel img.pixels[i]
    if (brightness(img.pixels[i]) >= threshold)
      result.pixels[i] = color(max);
  }
  result.updatePixels();
  return result;
}

PImage thresholdBinaryInverted(PImage img, int threshold) {
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  float max = 0;
  for (int i = 0; i < img.pixels.length; ++i) {
    if (brightness(img.pixels[i]) > max) {
      max = brightness(img.pixels[i]);
    }
  }
  for (int i = 0; i < img.width * img.height; i++) {
    // do something with the pixel img.pixels[i]
    if (brightness(img.pixels[i]) <= threshold)
      result.pixels[i] = color(max);
  }
  result.updatePixels();
  return result;
}
