import java.util.List;

int HOUGH_VOTES_CUTOFF = 150;

void detect(PImage img) {
  PImage board = thresholdHSB(img, 90, 140, 100, 255, 0, 150);
  PImage blurred = gaussBlur(board);
  PImage blobed = findConnectedComponents(blurred, true);
  PImage edges = scharr(blobed);
  PImage onlyBright = thresholdHSB(edges, 0, 255, 0, 255, 175, 255);
  draw_hough(img, hough(onlyBright));
  image(edges, img.width, 0);
}

PImage scharr(PImage img) {
  float[][] vKernel = {
    { 3, 0, -3 }, 
    { 10, 0, -10 },
    { 3, 0, -3 } };

  float[][] hKernel = {
    { 3, 10, 3 }, 
    { 0, 0, 0 }, 
    { -3, -10, -3 } };

  PImage result = createImage(img.width, img.height, ALPHA);

  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }

  float max = 0;
  float[] buffer = new float[img.width * img.height];

  PImage sum_h = convolute(img, hKernel, 1);
  PImage sum_v = convolute(img, vKernel, 1);
  
  for (int i = 0; i < img.pixels.length; ++i) {
    float sum = sqrt(pow(sum_h.pixels[i], 2) + pow(sum_v.pixels[i], 2));
    if (sum > max) max = sum;
    buffer[i] = sum;
  }

  for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width - 1; x++) { // Skip left and right
      int val = (int) ((buffer[y * img.width + x] / max) * 255);
      result.pixels[y * img.width + x] = color(val);
    }
  }
  
  result.updatePixels();
  return result;
}

PImage convolute(PImage img, float[][] kernel, float normFactor) {
  PImage result = createImage(img.width, img.height, ALPHA);

  for (int i = 1; i < result.height - 1; ++i) {
    for (int j = 1; j < result.width - 1; ++j) {
      result.pixels[i * result.width + j] = (int) (dot(img, kernel, i, j) / normFactor);
    }
  }

  result.updatePixels();
  return result;
}

PImage gaussBlur(PImage img) {
  float[][] kernel = { {9, 12, 9}, {12, 15, 12}, {9, 12, 9} };
  int normFactor = 99;
  
  PImage result = createImage(img.width, img.height, ALPHA);

  for (int i = 0; i < result.height; ++i) {
    for (int j = 0; j < result.width; ++j) {
      if (i == 0 || j == 0 || i == result.height - 1 || j == result.width - 1) {
        result.pixels[i * result.width +j] = color(0);
      } else {
        result.pixels[i * result.width + j] = color(dot(img, kernel, i, j) / normFactor);
      }
    }
  }

  result.updatePixels();
  return result;
}

float dot(PImage img, float[][] kernel, int row, int col) {
  float ans = 0;

  for (int i = 0; i < kernel.length; ++i) {
    for (int j = 0; j < kernel.length; ++j) {
      int r = row - kernel.length/2 + i;
      int c = col - kernel.length/2 + j;
      ans += brightness(img.pixels[r * img.width + c]) * kernel[i][j];
    }
  }

  return ans;
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
    } else {
      result.pixels[i] = color(0);
    }
  }

  result.updatePixels();
  return result;
}
