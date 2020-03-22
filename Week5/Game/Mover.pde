class Mover {
  PVector location;
  PVector velocity;
  PVector friction = new PVector();
  PVector gForce = new PVector();
  final float gravity = 0.2;
  final float radius = 40;
  final float normalForce = 1;
  final float mu = 0.01;
  final float frictionMagnitude = normalForce * mu;
  final float restitution = 0.8;
  final float high = -(radius + plateThickness / 2);
  float rx, ry, rz;
  
  PImage img;
  PShape globe;

  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    img = loadImage("earth.jpg");
    globe = createShape(SPHERE, radius);
    globe.setStroke(false);
    globe.setTexture(img);
  }
  
  void display(float xangle, float zangle) {
    gForce.x = sin(zangle) * gravity;
    gForce.z = - sin(xangle) * gravity;

    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    checkCylinderCollision();
    checkEdges();
    update();
    
    pushMatrix();
    translate(location.x, high, location.z);
    rotateX(PI/2);
    globe.rotateX(rx);
    globe.rotateY(rz);
    shape(globe);
    popMatrix();
  }
  
  void displayTop() {
    pushMatrix();
    translate(location.x, 0, -location.z);
    rotateX(rx);
    rotateY(ry);
    rotateZ(rz);
    shape(globe);
    popMatrix();
  }
  
  void update() {
    velocity.add(friction).add(gForce);
    location.add(velocity);
    if (Math.abs(velocity.x) > 0.1) rz = velocity.x / radius;
    else rz = 0;
    if (Math.abs(velocity.z) > 0.1) rx = -velocity.z / radius;
    else rx = 0;
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
  
  void checkCylinderCollision() {
    for (Cylinder c : cylinders) {
      if (location.dist(c.location) <= Cylinder.diameter + radius) {
        PVector normal = location.copy().sub(c.location).normalize();
        velocity.sub(normal.copy().mult(velocity.dot(normal) * 2));
        location = c.location.copy().add(normal.mult(Cylinder.diameter + radius));
      }
    }
  }
}
