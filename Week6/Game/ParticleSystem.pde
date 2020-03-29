// A class to describe a group of Particles
class ParticleSystem {
  ArrayList<Cylinder> cylinders;
  PVector origin;
  boolean running;

  PShape villain = constructVillain();

  PShape constructVillain() {
    PImage texture = loadImage("robotnik.png");
    PShape villain = loadShape("robotnik.obj");
    villain.setStroke(false);
    villain.setTexture(texture);

    return villain;
  }

  ParticleSystem() {
    cylinders = new ArrayList<Cylinder>();
  }

  void activate(PVector origin) {
    if (running) deactivate();
    running = true;
    this.origin = origin.copy();
    cylinders.add(new Cylinder(origin));
  }

  void deactivate() {
    assert(running);
    cylinders.clear();
    running = false;
  }

  void addParticle() {
    assert(running);

    PVector center;
    int numAttempts = 100;
    for (int i=0; i < numAttempts; i++) {
      // Pick a cylinder and its center.
      int index = int(random(cylinders.size()));
      center = cylinders.get(index).location.copy();
      // Try to add an adjacent cylinder.
      float angle = random(TWO_PI);
      center.x += sin(angle) * Cylinder.radius * 2;
      center.z += cos(angle) * Cylinder.radius * 2;
      if (checkCylinderPlacement(center)) {
        cylinders.add(new Cylinder(center));
        break;
      }
    }
  }

  boolean checkCylinderPlacement(PVector tentative) {
    float x = tentative.x + plateSize/2;
    float z = tentative.z + plateSize/2;
    
    // Distance from the edges of the plate
    if (x < Cylinder.radius || x > plateSize - Cylinder.radius ||
      z < Cylinder.radius || z > plateSize - Cylinder.radius) {

      return false;
    }

    // Distance from other cylinders
    for (Cylinder c : cylinders)
      if (tentative.dist(c.location) <= Cylinder.radius * 2) return false;

    // Distance from the mover
    if (tentative.dist(mover.location) <= Cylinder.radius / 2 + mover.radius) 
      return false;

    return true;
  }

  void update() {
    if (!running) return;
    for (int i = cylinders.size() - 1; i >= 0; --i) {
      Cylinder c = cylinders.get(i);
      if (mover.location.dist(c.location) <= Cylinder.radius + mover.radius) {
        PVector normal = mover.location.copy().sub(c.location).normalize();
        mover.velocity.sub(normal.copy().mult(mover.velocity.dot(normal) * 2));
        mover.location = c.location.copy().add(normal.mult(Cylinder.radius + mover.radius));
        if (i == 0) deactivate();
        else cylinders.remove(i);
        break;
      }
    }
    if (frameCount * 2 % fRate == 0) ps.addParticle();
    ps.display();
  }

  void display() {
    if (!running) return;
    for (Cylinder c : cylinders) c.display();
    
    float yangle = (float) Math.atan2(- mover.location.x + origin.x, -mover.location.z + origin.z);

    pushMatrix();
    translate(origin.x, -Cylinder.hauteur -plateThickness/2, origin.z);
    scale(-75);
    villain.resetMatrix();
    villain.rotateY(yangle);
    shape(villain);
    popMatrix();
  }

  void displayTop() {
    if (!running) return;
    for (Cylinder c : cylinders) c.displayTop();
    
    float yangle = (float) Math.atan2(-mover.location.x + origin.x, -mover.location.z + origin.z);
    
    pushMatrix();
    translate(origin.x, Cylinder.hauteur, -origin.z);
    scale(75);
    villain.resetMatrix();
    villain.rotateY(-yangle);
    shape(villain);
    popMatrix();
  }
}
