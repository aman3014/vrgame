// A class to describe a group of Particles
class ParticleSystem {
  ArrayList<Cylinder> cylinders;
  PVector origin;
  boolean running;

  PShape villain = constructVillain();

  PShape constructVillain() {
    PImage texture = loadImage("../resources/robotnik.png");
    PShape villain = loadShape("../resources/robotnik.obj");
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
    if (!running) return;
    cylinders.clear();
    running = false;
  }

  void addParticle() {
    if (!running) return;

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
        totalScore -= 10;
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

        int score = (int) mover.velocity.mag() * 3;
        totalScore += score;
        lastScore = score;
        
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

    gameSurface.pushMatrix();
    gameSurface.translate(origin.x, -Cylinder.hauteur -plateThickness/2, origin.z);
    gameSurface.scale(-75);
    villain.resetMatrix();
    villain.rotateY(yangle);
    gameSurface.shape(villain);
    gameSurface.popMatrix();
  }

  void displayTop() {
    if (!running) return;
    for (Cylinder c : cylinders) c.displayTop();
    
    float yangle = (float) Math.atan2(-mover.location.x + origin.x, -mover.location.z + origin.z);
    
    gameSurface.pushMatrix();
    gameSurface.translate(origin.x, Cylinder.hauteur, -origin.z);
    gameSurface.scale(75);
    villain.resetMatrix();
    villain.rotateY(-yangle);
    gameSurface.shape(villain);
    gameSurface.popMatrix();
  }
  
  void drawTopView() {
    if (!running) return;
    topSurface.fill(200, 0, 0);
    cylinders.get(0).drawTopView();
    topSurface.fill(255, 255, 255);
    for (int i = 1; i < cylinders.size(); ++i) cylinders.get(i).drawTopView();
  }
}
