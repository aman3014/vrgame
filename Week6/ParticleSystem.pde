// A class to describe a group of Particles
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float particleRadius = 10;
  ParticleSystem(PVector origin) {
    this.origin = origin.copy();
    particles = new ArrayList<Particle>();
    particles.add(new Particle(origin, particleRadius));
  }
  void addParticle() {
    PVector center;
    int numAttempts = 100;
    for (int i=0; i<numAttempts; i++) {
      // Pick a cylinder and its center.
      int index = int(random(particles.size()));
      center = particles.get(index).center.copy();
      // Try to add an adjacent cylinder.
      float angle = random(TWO_PI);
      center.x += sin(angle) * 2*particleRadius;
      center.y += cos(angle) * 2*particleRadius;
      if (checkPosition(center)) {
        particles.add(new Particle(center, particleRadius));
        break;
      }
    }
  }
  // Check if a position is available, i.e.
  // - would not overlap with particles that are already created
  // (for each particle, call checkOverlap())
  // - is inside the board boundaries
  boolean checkPosition(PVector center) {
    for (Particle p : particles) {
      if (checkOverlap(center, p.center)) return false;
    }
    
    if (center.x < 0 || center.y < 0 || center.x >= width 
          || center.y >= height) return false;
    
    return true;
  }
  // Check if a particle with center c1
  // and another particle with center c2 overlap.
  boolean checkOverlap(PVector c1, PVector c2) {
    return c1.dist(c2) <= particleRadius * 2;
  }
  // Iteratively update and display every particle,
  // and remove them from the list if their lifetime is over.
  void run() {
    System.out.println(frameRate);
    if (frameCount * 10 % frate == 0) addParticle();  //<>//
    for (int i = particles.size() - 1; i >= 0; --i) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
