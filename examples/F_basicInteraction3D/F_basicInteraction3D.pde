// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin


import peasy.*;
PGraphics canvas;
PeasyCam cam;

PShape earth;
boolean easycamIntialized =false;
PImage surftex1;


float radius = 400;
float angle;

// earth transformations to adjust UV Map and Geo System
int rX=-90;
int rY=0;
int rZ=0;

void setup() {
  size(displayWidth, displayHeight, P2D);
  canvas = createGraphics(width, height, P3D);
  cam = new PeasyCam(this, 800);
  cam.setWheelScale(0.05);

  frameRate(60);
  if (!easycamIntialized) {

    cam.setMinimumDistance(20);
    cam.setMaximumDistance(radius*600);
    easycamIntialized=true;
  }

  surftex1 = loadImage("data/earth_min.jpg");  
  sphereDetail(40);
  noStroke();
  earth = canvas.createShape(SPHERE, radius);
  earth.setTexture(surftex1);
}

void draw() {
  // Even we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.

  canvas.beginDraw();
  canvas.background(255);
  // Disabling writing to the depth mask so the 
  // background image doesn't occludes any 3D object.
  canvas.hint(DISABLE_DEPTH_MASK);
  canvas.hint(ENABLE_DEPTH_MASK);
  //canvas.push();
  canvas.directionalLight(255, 0, 0, -10, -10, -10);
  canvas.directionalLight(240, 255, 240, 0, 0, 10);
  canvas.directionalLight(255, 240, 240, 0, 10, 0);
  canvas.directionalLight(180, 180, 255, 10, -10, -10);
  //canvas.directionalLight(240, 240, 255,10,10,1);
  //canvas.rotateX(radians(90+mouseX));
  //canvas.rotateY(radians(-angle));

  canvas.push();
  canvas.rotateX(radians(rX));
  canvas.shape(earth);
  canvas.pop();
  singleGPS(52.51126128723546, 13.444715958643222, "Berlin", canvas);
  //canvas.pop();
  //angle+=0.1;
  canvas.endDraw();
  // applies the matrix transformations from the peasy cam into the 3D canvas from our scene
  cam.getState().apply(canvas);
  image(canvas, 0, 0);   

  interact2Dfrom3D(52.51126128723546, 13.444715958643222, "Berlin", canvas);
  textSize(12);
  fill(255, 0, 0);
  text("fps : " +frameRate, 100, 100);
}
void singleGPS(float lat, float lon, String name, PGraphics _canvas) {
  float R = radius+2;
  float phi = radians(lat);
  float theta = radians(lon);
  float x = R * cos(phi) * cos(theta);
  float y = R * cos(phi) * sin(theta);
  float z = R * sin(phi); 
  PVector loc = new PVector(x, y, z);
  _canvas.stroke(255, 0, 0);
  _canvas.strokeWeight(10);
  _canvas.point(-loc.x, loc.y, loc.z);
  _canvas.push();
  _canvas.translate(-loc.x, loc.y, loc.z +50);
  _canvas.fill(255, 0, 0);
  _canvas.text(name, 0, 0);
  _canvas.pop();
}

void interact2Dfrom3D(float lat, float lon, String name, PGraphics _canvas) {
  PVector human = new PVector(mouseX, mouseY);
  
  // the usual conversion stuff from lat lon to x y z
  float R = radius+2;
  float phi = radians(lat);
  float theta = radians(lon);
  float x = R * cos(phi) * cos(theta);
  float y = R * cos(phi) * sin(theta);
  float z = R * sin(phi); 
  // the target location
  PVector loc = new PVector(x, y, z);
  // a new vector to store the proyections of the target location on 2D screen
  PVector scrnPnt = new PVector();
  // calculating the actual projections using the screenX screenY screenZ functions
  scrnPnt.set(
    _canvas.screenX(-loc.x, loc.y, loc.z), 
    _canvas.screenY(-loc.x, loc.y, loc.z), 
    _canvas.screenZ(-loc.x, loc.y, loc.z)
    );
  // comparing the interactions between cursor and target point on screen
  if (human.dist(scrnPnt)<10) {
    fill(0, 255, 0);
    textSize(40);
    text(name, scrnPnt.x, scrnPnt.y);
  } else {
    fill(255, 255, 0);
    textSize(40);
    text(name, scrnPnt.x, scrnPnt.y);
  }
}
