ParticleSystem ps;
int frate = 20;

void settings() {
 size(500, 500, P2D); 
}

void setup() {
  ps = new ParticleSystem(new PVector(width/2, height/2));
  frameRate(frate);
}

void draw() {
  ps.run();
}
