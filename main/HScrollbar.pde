float barWidth;  //Bar's width in pixels
float barHeight; //Bar's height in pixels
float xPosition;  //Bar's x position in pixels
float yPosition;  //Bar's y position in pixels

float sliderPosition, newSliderPosition;    //Position of slider
float sliderPositionMin, sliderPositionMax; //Max and min values of slider

boolean mouseOver;  //Is the mouse over the slider?
boolean locked;     //Is the mouse clicking and dragging the slider now?

/**
 * @brief Creates a new horizontal scrollbar
 * 
 * @param x The x position of the top left corner of the bar in pixels
 * @param y The y position of the top left corner of the bar in pixels
 * @param w The width of the bar in pixels
 * @param h The height of the bar in pixels
 */
void initScrollbar (float x, float y, float w, float h) {
  barWidth = w;
  barHeight = h;
  xPosition = x;
  yPosition = y;

  sliderPosition = xPosition + barWidth/2 - barHeight/2;
  newSliderPosition = sliderPosition;

  sliderPositionMin = xPosition;
  sliderPositionMax = xPosition + barWidth - barHeight;
}

/**
 * @brief Updates the state of the scrollbar according to the mouse movement
 */
void updateSB() {
  if (isMouseOver()) {
    mouseOver = true;
  } else {
    mouseOver = false;
  }
  if (mousePressed && mouseOver) {
    locked = true;
  }
  if (!mousePressed) {
    locked = false;
  }
  if (locked) {
    newSliderPosition = con(mouseX - barHeight/2, sliderPositionMin, sliderPositionMax);
  }
  if (abs(newSliderPosition - sliderPosition) > 1) {
    sliderPosition = sliderPosition + (newSliderPosition - sliderPosition);
  }
}

/**
 * @brief Clamps the value into the interval
 * 
 * @param val The value to be clamped
 * @param minVal Smallest value possible
 * @param maxVal Largest value possible
 * 
 * @return val clamped into the interval [minVal, maxVal]
 */
float con(float val, float minVal, float maxVal) {
  return min(max(val, minVal), maxVal);
}

/**
 * @brief Gets whether the mouse is hovering the scrollbar
 *
 * @return Whether the mouse is hovering the scrollbar
 */
boolean isMouseOver() {
  if (mouseX > xPosition && mouseX < xPosition+barWidth &&
    mouseY > yPosition && mouseY < yPosition+barHeight) {
    return true;
  } else {
    return false;
  }
}

/**
 * @brief Draws the scrollbar in its current state
 */
void displaySB() {
  scroll.noStroke();
  scroll.fill(204);
  scroll.rect(xPosition, yPosition, barWidth, barHeight);
  if (mouseOver || locked) {
    scroll.fill(0, 0, 0);
  } else {
    scroll.fill(102, 102, 102);
  }
  scroll.rect(sliderPosition, yPosition, barHeight, barHeight);
}

/**
 * @brief Gets the slider position
 * 
 * @return The slider position in the interval [0,1] corresponding to [leftmost position, rightmost position]
 */
float getSBPos() {
  return (sliderPosition - xPosition)/(barWidth - barHeight);
}
