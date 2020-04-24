PImage img;
PImage correct;
HScrollbar scrollMin, scrollMax;

void settings() {
  size(1600, 600);
}

void setup() {
  img = loadImage("../../resources/board1.jpg");
  correct = loadImage("../../resources/board1Thresholded.bmp");
  scrollMin = new HScrollbar(0, img.height - 40, img.width, 20);
  scrollMax = new HScrollbar(0, img.height - 20, img.width, 20);
}

void draw() {
  image(img, 0, 0);
  PImage result = thresholdHSB(img, 100, 200, 100, 255, 45, 100);
  image(result, img.width, 0);
  
  assert(imagesEqual(result, correct));
}

/* Hue thresholding with two scroll bars
void draw() {
 scrollMax.update();
 scrollMin.update();
 
 float minH = map(scrollMin.getPos(), 0, 1, 0, 255);
 float maxH = map(scrollMax.getPos(), 0, 1, 0, 255);
 
 image(img, 0, 0);//show image
 PImage result = hueRange(img, minH, maxH);
 image(result, img.width, 0);
 
 scrollMin.display();
 scrollMax.display();
 }*/

PImage hueMap(PImage img) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.pixels.length; ++i) {
    result.pixels[i] = color(hue(img.pixels[i]));
  }

  result.updatePixels();
  return result;
}

PImage hueRange(PImage img, float minH, float maxH) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.pixels.length; ++i) {
    float hue = hue(img.pixels[i]);
    result.pixels[i] = hue <= maxH && hue >= minH ? img.pixels[i] : color(0);
  }

  result.updatePixels();
  return result;
}

PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.pixels.length; ++i) {
    int pixel = img.pixels[i];
    float h = hue(pixel);
    float s = saturation(pixel);
    float b = brightness(pixel);

    if (minH <= h && h <= maxH && minS <= s && s <= maxS && minB <= b && b <= maxB) {
      result.pixels[i] = color(255);
    }
  }

  result.updatePixels();
  return result;
}

boolean imagesEqual(PImage img1, PImage img2) {
  if (img1.width != img2.width || img1.height != img2.height)
    return false;
  for (int i = 0; i < img1.width*img1.height; i++)
    //assuming that all the three channels have the same value
    if (red(img1.pixels[i]) != red(img2.pixels[i]))
      return false;
  return true;
}
