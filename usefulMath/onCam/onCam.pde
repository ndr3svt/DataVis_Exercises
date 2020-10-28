// towards projecting 3D points in to the 2D space/screen
import peasy.*;

PGraphics3D g3;
PeasyCam cam;

Point[] points;

float w = 1000;
float h = 1000;
float d = 1000;

void setup() { 
  size(700, 700, P3D);

  g3 = (PGraphics3D) g;

  cam = new PeasyCam(this, 1500);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(3000);

  points = new Point[14];
  for(int i = 0; i < points.length; i++) {
    float x = random(-w/2, w/2);
    float y = random(-h/2, h/2);
    float z = random(-d/2, d/2);

    points[i] = new Point(x, y, z, 10);
  }
}

void draw() {

  background(0);

  for(int i = 0; i < points.length; i++) {
    points[i].update();
    pushMatrix();
    points[i].display();
    popMatrix();
  }

  noFill();
  stroke(255);

  for(int i = 0; i < points.length; i++) {

    float ix = points[i].mx;
    float iy = points[i].my;

    cam.beginHUD();
      fill(0,255,0);
      ellipse(points[i].mx,points[i].my,10,10);
    cam.endHUD();
    for(int j = 0; j < i; j++) {

      float jx = points[j].mx;
      float jy = points[j].my;

      if(dist(ix, iy, jx, jy) < 200) {
        line(points[i].x, points[i].y, points[i].z,
          points[j].x, points[j].y, points[j].z);
      }
      
    }
  }
}


class Point {

  float x, y, z;
  float mx, my, mz;
  float d;

  Point(float x, float y, float z, float d) {

    this.x = x;
    this.y = y;
    this.z = z;

    this.d = d;
  }

  void update() {
    pushMatrix();
    applyMatrix(g3.camera);
    mx = modelX(x,y,z);
    my = modelY(x,y,z);
    mz = modelZ(x,y,z);
    popMatrix();
  }

  void display() {
    translate(x, y, z);
    sphereDetail(10);
    noStroke();
    fill(255);
    sphere(d);
    translate(-x, -y, -z);
  }
}