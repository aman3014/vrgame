void settings() {
  size(1000, 1000, P2D);
}

void setup() { 
}

float scale = 1f;
final float scalingFactor = 1.05f;
float prevMouse;
void mouseDragged() {
  float diff = mouseY - prevMouse;
  if (diff > 0) {
    if (scale < 5.0) {
      scale *= scalingFactor;
    }
  } else {
    if (scale > 0.2) {
      scale /= scalingFactor;
    }
  }
}

float angleX = 0f;
float angleY = 0f;
final float rotationAngle = 0.01f;
 
void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);

  if (keyPressed) {
    switch (keyCode) {
      case UP: angleX += rotationAngle; break;
      case DOWN: angleX -= rotationAngle; break; //<>//
      case RIGHT: angleY += rotationAngle; break;
      case LEFT: angleY -= rotationAngle; break;
      default: return;
    }
  }

  //centered
  float[][] scaled = scaleMatrix(scale, scale, scale);
  input3DBox = transformBox(input3DBox, scaled);
  
  float[][] translation = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, translation);
  
  float[][] xrotation = rotateXMatrix(angleX);
  input3DBox = transformBox(input3DBox, xrotation);
  
  float[][] yrotation = rotateYMatrix(angleY);
  input3DBox = transformBox(input3DBox, yrotation);
  
  projectBox(eye, input3DBox).render();
  prevMouse = mouseY;
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  My3DPoint translated = new My3DPoint(p.x - eye.x, p.y - eye.y, p.z - eye.z);
  float factor = 1 / (-translated.z/eye.z);
  return new My2DPoint(translated.x * factor, translated.y * factor);
}

My2DBox projectBox(My3DPoint eye, My3DBox box) {
  My2DPoint[] table = new My2DPoint[box.p.length];
  for (int i = 0; i < box.p.length; ++i) {
    table[i] = projectPoint(eye, box.p[i]);
  }
  
  return new My2DBox(table);
}

float[] homogeneous3DPoint(My3DPoint p) {
  return new float[] {p.x, p.y, p.z , 1}; 
}

My3DPoint euclidian3DPoint (float[] a) {
  return new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] table = new My3DPoint[box.p.length];
  for (int i = 0; i < box.p.length; ++i) {
    table[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  }
  
  return new My3DBox(table);
}


float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), -sin(angle) , 0},
                        {0, sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}

float[][] rotateYMatrix(float angle) {
  return new float[][] {{cos(angle), 0, sin(angle), 0},
                        {0, 1, 0, 0},
                        {-sin(angle), 0, cos(angle), 0},
                        {0, 0, 0, 1}};
}

float[][] rotateZMatrix(float angle) {
  return new float[][] {{cos(angle), -sin(angle), 0, 0},
                        {sin(angle), cos(angle), 0, 0},
                        {0, 0, 1, 0},
                        {0, 0, 0, 1}};
}

float[][] scaleMatrix(float x, float y, float z) {
  return new float[][] {{x, 0, 0, 0},
                        {0, y, 0, 0},
                        {0, 0, z, 0},
                        {0, 0, 0, 1}};
}

float[][] translationMatrix(float x, float y, float z) {
  return new float[][] {{1, 0, 0, x},
                        {0, 1, 0, y},
                        {0, 0, 1, z},
                        {0, 0, 0, 1}};
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] ans = new float[b.length];
  
  for (int i = 0; i < b.length; ++i) {
    int dot = 0;
    for (int j = 0; j < b.length; ++j) {
      dot += a[i][j] * b[j];
    }
    
    ans[i] = dot;
  }
  
  return ans;
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  
  void render() {
    for (int i = 0; i < 4; ++i) {
      int j = (i + 1) % 4;
      drawLine(s[i], s[j]);
      drawLine(s[i + 4], s[j + 4]);
      drawLine(s[i], s[i + 4]);
    }
  }
   
  void drawLine(My2DPoint one, My2DPoint two) {
    line(one.x, one.y, two.x, two.y);
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x,y+dimY,z+dimZ),
                             new My3DPoint(x,y,z+dimZ),
                             new My3DPoint(x+dimX,y,z+dimZ),
                             new My3DPoint(x+dimX,y+dimY,z+dimZ),
                             new My3DPoint(x,y+dimY,z),
                             origin,
                             new My3DPoint(x+dimX,y,z),
                             new My3DPoint(x+dimX,y+dimY,z)
                             };
  }
  
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

class My2DPoint {
  float x, y;
  
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x, y, z;
  
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}
