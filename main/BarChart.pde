ArrayList<Integer> bars = new ArrayList<Integer>();
float max = 1;

void displayBarChart(float scrollBar) {
  float barHeight = 20;
  float barWidth = scrollBar * barHeight * 2;
  int barScale = 10;
  barChart.stroke(255, 255, 255);

  for (int i = 0; i < bars.size(); ++i) {
    barChart.fill(150, 0, 200);
    if (bars.get(i) < 0) {
      for (int j = bars.get(i); j <= 0; j += barScale) {
        barChart.rect(i * barWidth, barChart.height/2 - (j/barScale) * barWidth, barWidth, barWidth);
      }
    } else {
      for (int j = 0; j < bars.get(i); j += barScale) {
        barChart.rect(i * barWidth, barChart.height/2 - (j/barScale) * barWidth, barWidth, barWidth);
      }
    }
  }

}

void addBar(int score) {
  bars.add(score);
  if (abs(score) > max) max = abs(score);
}
