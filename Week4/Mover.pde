class Mover {
  final PVector gravity = new PVector(0, 0.2);
  
  PVector location;
  PVector velocity;
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(1, 1);
  }
  void update() {
    velocity.add(gravity);
    location.add(velocity);
  }
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }
  
  void checkEdges() {
    if (location.x + 24 > width || location.x - 24 < 0) {
      velocity = new PVector(-velocity.x, velocity.y);
    } else if (location.y + 24 > height || location.y - 24 < 0) {
      velocity.add(gravity);
      velocity = new PVector(velocity.x, -velocity.y);
    }
  }
}
