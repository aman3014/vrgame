class Mover {
  PVector location;
  PVector velocity;
  PVector friction = new PVector();
  PVector gForce = new PVector();
  final float gravity = 0.2;
  final float radius = 20;
  final float normalForce = 1;
  final float mu = 0.01;
  final float frictionMagnitude = normalForce * mu;
  final float restitution = 0.8;

  Mover() {
    location = new PVector(0, -(radius + plateThickness / 2), 0);
    velocity = new PVector(0, 0, 0);
  }
  
  void display(float xangle, float zangle) {
    gForce.x = sin(zangle) * gravity;
    gForce.z = - sin(xangle) * gravity;

    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    checkEdges();
    update();
    
    fill(127);
    translate(location.x, location.y, location.z);
    sphere(20);
  }
  
  void update() {
    velocity.add(friction).add(gForce);
    location.add(velocity);
  }
  
  void checkEdges() {
    if (location.x + radius > plateSize / 2 || location.x - radius < - plateSize / 2) {
      location.x = clamp(-plateSize / 2 + radius, plateSize/2 - radius, location.x);
      velocity.x *= -restitution;
    }
    
    if (location.z + radius > plateSize / 2 || location.z - radius < - plateSize / 2) {
      location.z = clamp(-plateSize / 2 + radius, plateSize/2 - radius, location.z);
      velocity.z *= -restitution;
    }
  }
  
  float clamp(float low, float high, float val) {
    if (val < low) return low;
    if (val > high) return high;
    return val;
  }
}
