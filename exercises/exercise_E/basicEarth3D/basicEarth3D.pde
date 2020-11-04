// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin



PShape earth;

PImage surftex1;


float radius = 400;
boolean easycamIntialized =false;
float angle;

// earth transformations to adjust UV Map and Geo System
int rX=-90;
int rY=0;
int rZ=0;

void setup() {
  size(displayWidth, displayHeight, P3D);
  // frameRate(60);
  // cam = new PeasyCam(this, 800);
  // if(!easycamIntialized){
  //  //easycam = new Dw.EasyCam(this._renderer, {distance:1500, center:[0,0,0]}) ;
  //  //cam.
  //  cam.setMinimumDistance(100);
  //  cam.setMaximumDistance(r*60);
  //  easycamIntialized=true;
  //}
  surftex1 = loadImage("data/earth_sat.jpg");  
  // surftex1.resize(surftex1.width, surftex1.height);
  sphereDetail(40);
  noStroke();
  earth = createShape(SPHERE, radius);
  earth.setTexture(surftex1);
}

void draw() {
  // Even we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.
  background(0);
  // Disabling writing to the depth mask so the 
  // background image doesn't occludes any 3D object.
  hint(DISABLE_DEPTH_MASK);
  hint(ENABLE_DEPTH_MASK);
  push();
  directionalLight(255, 200, 200, -1, -1, -1);
  ambientLight(200, 200, 255);
  translate(width/2, height/2);
  rotateX(radians(90+mouseX));
  rotateY(radians(-angle));

  push();
  rotateX(radians(rX));
  shape(earth);
  pop();
  singleGPS(52.51126128723546, 13.444715958643222, "Berlin");
  pop();
  angle+=0.1;


  textSize(12);
  fill(255, 0, 0);
  text("fps : " +frameRate, 100, 100);

}
void singleGPS(float lat, float lon, String name) {
  float R = radius+2;
  float phi = radians(lat);
  float theta = radians(lon);
  float x = R * cos(phi) * cos(theta);
  float y = R * cos(phi) * sin(theta);
  float z = R * sin(phi); 
  PVector loc = new PVector(x, y, z);
  stroke(255, 0, 0);
  strokeWeight(10);
  point(-loc.x, loc.y, loc.z);
  push();
  translate(-loc.x, loc.y, loc.z +50);
  fill(255, 0, 0);
  text(name, 0, 0);
  pop();
}
