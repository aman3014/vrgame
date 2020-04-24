PImage img, correct;

void settings() {
  size(1600, 600);
}

void setup() {
  img = loadImage("../../resources/board1.jpg");
  correct = loadImage("../../resources/board1Blurred.bmp");
}

void draw() {
  int[][] kernel1 = { {0, 0, 0}, {0, 2, 0}, {0, 0, 0} };
  int[][] kernel2 = { {0, 1, 0}, {1, 0, 1}, {0, 1, 0} };
  int[][] gauss = { {9, 12, 9}, {12, 15, 12}, {9, 12, 9} };
  int gaussNormFactor = 99;

  image(img, 0, 0);
  PImage result = convolute(img, gauss, gaussNormFactor);
  image(result, img.width, 0);

  assert(imagesEqual(result, correct));
}

PImage convolute(PImage img, int[][] kernel, float normFactor) {
  PImage result = createImage(img.width, img.height, ALPHA);

  for (int i = 1; i < result.height-1; ++i) {
    for (int j = 1; j < result.width-1; ++j) {
      result.pixels[i * result.width + j] = color(dot(img, kernel, i, j) / normFactor);
    }
  }

  result.updatePixels();
  return result;
}

int dot(PImage img, int[][] kernel, int row, int col) {
  int ans = 0;

  for (int i = 0; i < kernel.length; ++i) {
    for (int j = 0; j < kernel.length; ++j) {
      int r = row - kernel.length/2 + i;
      int c = col - kernel.length/2 + j;
      ans += brightness(img.pixels[r * img.width + c]) * kernel[i][j];
    }
  }

  return ans;
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
