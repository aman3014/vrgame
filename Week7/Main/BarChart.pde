ArrayList<Integer> bars = new ArrayList<Integer>();
float max = 1;

void displayBarChart(float scrollBar) {
  if (bars.isEmpty()) return;
  float scale = map(scrollBar, 0, 1, 0.1, 1);
  float rectWidth = (barChart.width / (float) bars.size()) * scale;
  float currX = 0;

  for (int score : bars) {
    float rectHeight = (score / (float) max) * barChart.height/2;
    if (rectHeight > 0) {
      barChart.rect(currX, barChart.height/2 - rectHeight, rectWidth, rectHeight);
    } else {
      barChart.rect(currX, barChart.height/2, rectWidth, abs(rectHeight));
    }

    currX += rectWidth;
  }
}

void addBar(int score) {
  bars.add(score);
  if (abs(score) > max) max = abs(score);
}
