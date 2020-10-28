// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin


// reference to Spherical Coordinate System
// https://en.wikipedia.org/wiki/Spherical_coordinate_system
// how to calculate x y z in an spherical coordinate system

import peasy.*;

PShape earth;
PImage surftex1;
PImage surftex2;

PGraphics3D g3;
PeasyCam cam;
PMatrix3D currCameraMatrix;

float r = 400;
boolean easycamIntialized =false;

int rX=-90;
int rY=0;
int rZ=0;



public void settings() {
  fullScreen( P3D, 2);
  smooth(5);
}

void setup() {
  frameRate(120);
   cam = new PeasyCam(this, 800);

   g3 = (PGraphics3D) g;

   if(!easycamIntialized){
     
    //easycam = new Dw.EasyCam(this._renderer, {distance:1500, center:[0,0,0]}) ;
    //cam.
    cam.setMinimumDistance(100);
    cam.setMaximumDistance(r*60);
    easycamIntialized=true;
  }
  surftex1 = loadImage("data/earth_min.jpg");  
  surftex1.resize(surftex1.width, surftex1.height);
  surftex2 = loadImage("data/earth_sat.jpg");
  // surftex1.resize(width,height);

  sphereDetail(30);
  noStroke();
  earth = createShape(SPHERE, r);
  earth.setTexture(surftex1);

}

void draw() {
    currCameraMatrix = new PMatrix3D(g3.camera);
  // Even we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.
  background(255);

  // Disabling writing to the depth mask so the 
  // background image doesn't occludes any 3D object.
  hint(DISABLE_DEPTH_MASK);
  //image(starfield, 0, 0, width, height);
  hint(ENABLE_DEPTH_MASK);

  directionalLight(255, 0,0, -1, -1, -1);

  // ambientLight(255, 0, 235);
  ambientLight(0, 0, 255);
  push();
  rotateX(radians( rX));
  rotateY(radians(rY));
  rotateZ(radians(rZ));
  shape(earth);
  pop();
  cam.beginHUD();
  textSize(12);
  fill(255,0,0);
  text("fps : " +frameRate,100,100);
  text(" rx :  " + rX,100,115);
  text(" ry :  " + rY,100,130);
  text(" rz :  " + rZ,100,145);
  cam.endHUD();
  displayOneGPSLocation(55.66174835669238, 12.513764710947195, "Copenhagen", 0);
  displayOneGPSLocation(48.827829637474956, 2.334334953320408, "Paris", 1);
  displayOneGPSLocation(-33.89517888896039, -58.656823360705175, "Buenos Aires", 2);
  displayOneGPSLocation(19.395175071159112, -99.16421378630378, "Ciudad de México", 3);
  // if(frameCount%120 == 0) println(frameRate);

  g3.camera = currCameraMatrix;
}



void displayOneGPSLocation(float latitude, float longitude, String name, int i){

  // lat long to > x y for vis in 2D
  // x = output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start)
  // x = 0 + ((width - 0) / (180 - (-180))) * (longitude - (-180))
  // PVector location = new PVector(
  //   map(longitude, -180,180,0,width),
  //   map(latitude,90,-90,0,height)
  // );

  // lat long to > x y z for visualization in 3D
  // R is radius, phi = latitude in radians , theta = longitude in radians
  // x = R * cos(phi) * cos(theta);
  // y = R * cos(phi) * sin(theta);
  // z = R * sin(phi);

  // note if you want to add altitude instead of using radius alone
  // add the altitude to the R
  // R = R + altitude;
  // x = R* cos (latitude in radians) * cos(longitude in radians);
  // y = R * cos(latitude in radians) * sin(longitude in radians);
  // z = R * sin(latitude in radians )
  float radius = r + 10; // with 10 units away from earth's surface
  PVector location = new PVector(
    radius* cos (radians(latitude)) * cos(radians(longitude)),
    radius * cos(radians(latitude)) * sin(radians(longitude)),
    radius * sin(radians(latitude))
  );

  
  Proj2DPoint loc2D = new Proj2DPoint();
  loc2D.screenPoint(location.x,location.y,location.z);

  strokeWeight(10);
  stroke(255,0,0);
  point(-location.x,location.y,location.z);
  push();
  translate(-location.x, location.y, location.z);
  text(name, 10,10);
  pop();

  cam.beginHUD();
  text(loc2D.m.x + " ,  " + loc2D.m.y, 100,160+ 15*i);
  cam.endHUD();

  // text(name,location.x+25,location.y+30);
  // stroke(255,0,0);
  // line(location.x,location.y,location.x+25,location.y+25);
}


class Proj2DPoint{
  float x, y, z;
  PVector m;

  Proj2DPoint(){
    
    this.m = new PVector();
  }
  void screenPoint(float x, float y, float z){
    pushMatrix();
    applyMatrix(g3.camera);
    this.m.x = modelX(x,y,z);
    this.m.y = modelY(x,y,z);
    this.m.z = modelZ(x,y,z);
    popMatrix();

   
  }

}

