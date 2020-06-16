import java.util.Collections;

class Hough {
  float discretizationStepsPhi = 0.1;
  float discretizationStepsR = 2;
  int minVotes = 50;
  int neighborhood = 10;

  public Hough() {
    float ang = 0;
    float inverseR = 1 / discretizationStepsR;

    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      tabSin[accPhi] = (float) Math.sin(ang) * inverseR;
      tabCos[accPhi] = (float) Math.cos(ang) * inverseR;
    }
  }

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi + 1);

  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];

  List<PVector> hough(PImage edgeImg, int nLines) {
    //The max radius is the image diagonal, but it can be also negative
    int rDim = (int) ((sqrt(edgeImg.width*edgeImg.width + edgeImg.height*edgeImg.height) * 2)
      / discretizationStepsR + 1);

    // our accumulator
    int[] accumulator = new int[phiDim * rDim];

    // Fill the accumulator: on edge points (ie, white pixels of the edge
    // image), store all possible (r, phi) pairs describing lines going
    // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {
        // Are we on an edge?
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
          // ...determine here all the lines (r, phi) passing through
          // pixel (x,y), convert (r,phi) to coordinates in the
          // accumulator, and increment accordingly the accumulator.
          // Be careful: r may be negative, so you may want to center onto
          // the accumulator: r += rDim / 2

          for (int phi = 0; phi < phiDim; ++phi) {
            int r = (int) (x * tabCos[phi] + y * tabSin[phi]);
            r += rDim / 2;
            ++accumulator[phi * rDim + r];
          }
        }
      }
    }

    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();

    for (int idx = 0; idx + neighborhood <= accumulator.length; idx += neighborhood) {
      int max = 0;
      int maxIndex = 0;
      for (int i = 0; i < neighborhood; ++i) {
        if (accumulator[idx + i] > max) {
          max = accumulator[idx + i];
          maxIndex = idx + i;
        }
      }

      if (max > minVotes) {
        bestCandidates.add(maxIndex);
      }
    }

    Collections.sort(bestCandidates, new HoughComparator(accumulator));

    ArrayList<PVector> lines = new ArrayList<PVector>();

    if (bestCandidates.isEmpty()) return lines;

    for (Integer idx : bestCandidates.subList(0, Math.min(bestCandidates.size(), nLines) - 1)) {
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim));
      int accR = idx - (accPhi) * (rDim);
      float r = (accR - (rDim) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      lines.add(new PVector(r, phi));
    }

    return lines;

    /*
  PImage houghImg = createImage(rDim, phiDim, ALPHA);
     for (int i = 0; i < accumulator.length; i++) {
     houghImg.pixels[i] = color(min(255, accumulator[i]));
     }
     // You may want to resize the accumulator to make it easier to see:
     houghImg.resize(400, 400);
     houghImg.updatePixels();
     image(houghImg, img.width, 0);
     */
  }
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }

  @Override
    public int compare(Integer i, Integer j) {
    if (accumulator[i] > accumulator[j] || (accumulator[i] == accumulator[j] && i < j))
      return -1;

    return 1;
  }
}
