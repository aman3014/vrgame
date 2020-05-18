import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import java.util.HashSet;
import java.util.HashMap;
import java.util.Map;

class BlobDetection {
  PImage findConnectedComponents(PImage input, boolean onlyBiggest) {
    int [] labels = new int [input.width*input.height];
    List<TreeSet<Integer>> labelEquivalences = new ArrayList<TreeSet<Integer>>();
    int currentLabel = 1;
    labelEquivalences.add(new TreeSet<Integer>());
    labelEquivalences.get(0).add(0);
    input.loadPixels();

    // First pass: label the pixels and store labels' equivalences
    for (int row = 0; row < input.height; ++row) {
      for (int col = 0; col < input.width; ++col) {
        int currIndex = row * input.width + col;

        if (input.pixels[currIndex] == color(0)) {
          labels[currIndex] = 0;
          continue;
        }

        TreeSet<Integer> neighbors = new TreeSet<Integer>();

        // getting all the neighbors' labels
        for (int i = -1; i <= 1; ++i) {
          int index = currIndex - input.width + i;
          if (validIndex(input, row - 1, col + i) && labels[index] != 0) neighbors.add(labels[index]);
        }
        if (col > 0 && labels[currIndex - 1] != 0) neighbors.add(labels[currIndex - 1]);

        // no neighbors
        if (neighbors.isEmpty()) {
          labels[currIndex] = currentLabel;
          labelEquivalences.add(new TreeSet<Integer>());
          labelEquivalences.get(currentLabel).add(currentLabel++);
          continue;
        }

        TreeSet<Integer> eq = new TreeSet<Integer>();

        for (int label : neighbors) {
          eq.addAll(labelEquivalences.get(label));
        }

        for (int label : neighbors) {
          labelEquivalences.get(label).addAll(eq);
        }

        labels[currIndex] = eq.first();
      }
    }

    // Second pass: re-label the pixels by their equivalent class
    for (int i = 0; i < labels.length; ++i) {
      labels[i] = labelEquivalences.get(labels[i]).first();
    }

    PImage result = createImage(input.width, input.height, RGB);

    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    if (!onlyBiggest) {
      int[] colors = new int[labelEquivalences.size()];
      colors[0] = color(0);

      for (int i = 0; i < colors.length; ++i) {
        colors[i] = color(random(0, 255), random(0, 255), random(0, 255));
      }

      for (int i = 0; i < result.pixels.length; ++i) {
        result.pixels[i] = colors[i];
      }

      result.updatePixels();
      return result;
    }

    // if onlyBiggest==true, count the number of pixels for each label
    int[] counts = new int[labelEquivalences.size()];
    for (int l : labels) ++counts[l];

    // output an image with the biggest blob in white and others in black
    int maxCount = 0;
    int maxLabel = -1;

    for (int i = 1; i < counts.length; ++i) {
      if (counts[i] > maxCount) {
        maxCount = counts[i];
        maxLabel = i;
      }
    }

    if (maxLabel == -1) {
      for (int i = 0; i < labels.length; ++i) {
        result.pixels[i] = color(0);
      }
    } else {
      for (int i = 0; i < labels.length; ++i) {
        result.pixels[i] = labels[i] == maxLabel ? color(255) : color(0);
      }
    }

    result.updatePixels();
    return result;
  }

  boolean validIndex(PImage img, int r, int c) {
    return 0 <= r && r < img.height && 0 <= c && c < img.width;
  }
}
