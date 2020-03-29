class Cylinder {
  static final float radius = 40;
  static final float hauteur = 100;
  static final int resolution = 40;

  PShape shape = constructCylinder();
  PShape constructCylinder() {
    PShape cylinder = new PShape();
    float angle;
    float[] x = new float[resolution + 1];
    float[] y = new float[resolution + 1];
    //get the x and y position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * radius;
      y[i] = -cos(angle) * radius;
    }

    cylinder = createShape();
    cylinder.beginShape(QUAD_STRIP);

    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      cylinder.vertex(x[i], 0, y[i]);
      cylinder.vertex(x[i], hauteur, y[i]);
    }
    cylinder.endShape();

    cylinder.beginShape(TRIANGLE_FAN);
    for (int i = 0; i < x.length - 1; i += 1) {
      cylinder.vertex(0, hauteur, 0);
      cylinder.vertex(x[i], hauteur, y[i]);
      cylinder.vertex(x[i+1], hauteur, y[i+1]);

      cylinder.vertex(0, 0, 0);
      cylinder.vertex(x[i], 0, y[i]);
      cylinder.vertex(x[i+1], 0, y[i+1]);
    }
    cylinder.endShape();
    return cylinder;
  }

  PVector location;
  Cylinder(PVector location) {
    this.location = location.copy();
  }

  void display() {
    pushMatrix();
    translate(location.x, -hauteur - plateThickness/2, location.z);    
    shape(shape);
    popMatrix();
  }
  
  void displayTop() {
    pushMatrix();
    translate(location.x, 0, -location.z);
    shape(shape);
    popMatrix();
  }
}
