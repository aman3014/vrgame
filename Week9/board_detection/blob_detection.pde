import java.util.ArrayList; //<>//
import java.util.List;
import java.util.TreeSet;
import java.util.HashSet;
import java.util.HashMap;
import java.util.Map;

PImage findConnectedComponents(PImage input, boolean onlyBiggest) {
  int [] labels = new int [input.width*input.height];
  List<TreeSet<Integer>> labelEquivalences = new ArrayList<TreeSet<Integer>>();
  int currentLabel = 1;

  // First pass: label the pixels and store labels' equivalences
  for (int row = 0; row < input.height; ++row) {
    for (int col = 0; col < input.width; ++col) {
      int currIndex = row * input.width + col;
      HashSet<Integer> indices = new HashSet<Integer>();

      for (int i = -1; i <= 1; ++i) {
        int index = currIndex - input.width + i;
        if (validIndex(input, row - 1, col + i) && input.pixels[index] == input.pixels[currIndex]) {
          indices.add(index);
        }
      }

      if (col > 0 && input.pixels[currIndex - 1] == input.pixels[currIndex]) {
        indices.add(currIndex - 1);
      }
      
      int minLabel = Integer.MAX_VALUE;
      for (int index : indices) if (labels[index] < minLabel) minLabel = labels[index];

      TreeSet<Integer> eq = new TreeSet<Integer>();
      for (int one : indices) {
        eq.addAll(labelEquivalences.get(labels[one] - 1));
      }
      
      for (int one : indices) {
        labelEquivalences.get(labels[one] - 1).addAll(eq);
      }
      
      if (indices.isEmpty()) {
        labels[currIndex] = currentLabel;
        labelEquivalences.add(new TreeSet<Integer>());
        labelEquivalences.get(currentLabel - 1).add(currentLabel++);
      } else {
        labels[currIndex] = minLabel;
      }
    }
  }
  
  // Second pass: re-label the pixels by their equivalent class
  for (int i = 0; i < labels.length; ++i) {
    labels[i] = labelEquivalences.get(labels[i] - 1).first();
  }

  PImage result = createImage(input.width, input.height, RGB);

  // if onlyBiggest==false, output an image with each blob colored in one uniform color
  if (!onlyBiggest) {
    HashMap<Integer, Integer> colors = new HashMap<Integer, Integer>();
    for (int i = 0; i < labels.length; ++i) {
      if (colors.containsKey(labels[i])) {
        result.pixels[i] = colors.get(labels[i]);
      } else {
        int c = color(random(0, 255), random(0, 255), random(0, 255));
        colors.put(labels[i], c);
        result.pixels[i] = c;
      }
    }  

    result.updatePixels();
    return result;
  }

  // if onlyBiggest==true, count the number of pixels for each label
  HashMap<Integer, Integer> count = new HashMap<Integer, Integer>();
  for (int l : labels) {
    count.put(l, count.getOrDefault(l, 0) + 1);
  }

  // if onlyBiggest==true, output an image with the biggest blob in white and others in black
  int maxCount = 0;
  int maxLabel = -1;

  for (Map.Entry<Integer, Integer> entry : count.entrySet()) {
    if (entry.getValue() > maxCount) {
      maxLabel = entry.getKey();
      maxCount = entry.getValue();
    }
  }

  for (int i = 0; i < labels.length; ++i) {
    if (labels[i] == maxLabel)
      result.pixels[i] = color(255);
    else
      result.pixels[i] = color(0);
  }

  result.updatePixels();
  return result;
}

boolean validIndex(PImage img, int r, int c) {
  return 0 <= r && r <= img.height && 0 <= c && c <= img.width;
}
