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
PGraphics canvas;


// public void settings() {
//   // fullScreen( P3D, 2);

//   smooth(5);
// }

void setup() {
  size(displayWidth,displayHeight,P2D);
  canvas = createGraphics(width, height, P3D);
  cam = new PeasyCam(this, 800);
  frameRate(60);
  


   // g3 = (PGraphics3D) g;

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

  canvas.sphereDetail(30);
  canvas.noStroke();
  earth = canvas.createShape(SPHERE, r);
  earth.setTexture(surftex1);

}

void draw() {
    // currCameraMatrix = new PMatrix3D(g3.camera);

    // cam.getState().apply(canvas);

  // Even we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.
  canvas.beginDraw();
  canvas.background(255);

  // Disabling writing to the depth mask so the 
  // background image doesn't occludes any 3D object.
  canvas.hint(DISABLE_DEPTH_MASK);
  //image(starfield, 0, 0, width, height);
  canvas.hint(ENABLE_DEPTH_MASK);

  canvas.directionalLight(255, 0,0, -10, -10, -10);
  canvas.directionalLight(100, 255, 50, 0,0,10);
  canvas.directionalLight(255, 100, 50, 0,10,0);
  canvas.directionalLight(0, 0, 255, 10,-10,-10);
  canvas.push();
  canvas.rotateX(radians( rX));
  canvas.rotateY(radians(rY));
  canvas.rotateZ(radians(rZ));
  canvas.shape(earth);
  canvas.pop();
  cam.beginHUD();
  canvas.textSize(12);
  fill(255,0,0);
  text("fps : " +frameRate,100,100);
  text(" rx :  " + rX,100,115);
  text(" ry :  " + rY,100,130);
  text(" rz :  " + rZ,100,145);
  cam.endHUD();
  // displayOneGPSLocation(55.66174835669238, 12.513764710947195, "Copenhagen", 0);
  // displayOneGPSLocation(48.827829637474956, 2.334334953320408, "Paris", 1);
  // displayOneGPSLocation(-33.89517888896039, -58.656823360705175, "Buenos Aires", 2);
  displayOneGPSLocation(19.395175071159112, -99.16421378630378, "Ciudad de México", 3);
  canvas.endDraw();
  cam.getState().apply(canvas);
  image(canvas, 0, 0);
  // if(frameCount%120 == 0) println(frameRate);

  // g3.camera = currCameraMatrix;
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

  canvas.strokeWeight(10);
  canvas.stroke(255,0,0);
  canvas.point(-location.x,location.y,location.z);
  canvas.push();
  canvas.translate(-location.x, location.y, location.z);
  canvas.text(name, 10,10);
  canvas.pop();

  cam.beginHUD();
  text(loc2D.m.x + " ,  " + loc2D.m.y +  " , " + loc2D.m.z, 100,160+ 15*i);
  cam.endHUD();

  // text(name,location.x+25,location.y+30);
  // stroke(255,0,0);
  // line(location.x,location.y,location.x+25,location.y+25);
  // canvas.printMatrix();
  // println(canvas.BLUE_MASK);
}


class Proj2DPoint{
  float x, y, z;
  PVector m;

  Proj2DPoint(){
    
    this.m = new PVector();
  }
  void screenPoint(float x, float y, float z){
    canvas.pushMatrix();
    // applyMatrix(g3.camera);
    canvas.applyMatrix(canvas.getMatrix());
    PMatrix m4= canvas.getMatrix();
    // canvas.printMatrix();
    float [] mArray =new float[16];
    m4.get( mArray);
    // canvas.printMatrix();
    // println(m4.n00);
    // println(mArray[0]);
    // float[] get(float[] mArray);
    // canvas.printMatrix();
    this.m.x = canvas.modelX(x,y,z);
    this.m.y = canvas.modelY(x,y,z);
    this.m.z = canvas.modelZ(x,y,z);
    PVector ths = new PVector(x,y,z);
    screenPosition(mArray, ths);
    canvas.popMatrix();

   
  }
  void screenPosition(float [] mat, PVector v){
    PVector vNDC = multMatrixVector(mat, v);
    PVector vCanvas = new PVector();
    vCanvas.x = vNDC.x;
    vCanvas.y = vNDC.y;
    // vCanvas.x = 0.5 * vNDC.x * width;
    // vCanvas.y = 0.5 * -vNDC.y * height;
    cam.beginHUD();
    text("scrn x: "+vCanvas.x,100,400);
    cam.endHUD();
  }
  PVector multMatrixVector(float [] mat, PVector v) {
  // if (!(m instanceof p5.Matrix) || !(v instanceof p5.Vector)) {
  //  print('multMatrixVector : Invalid arguments');
  //  return;
  // }

  PVector _dest = new PVector();
  

  // Multiply in column major order.
  _dest.x = mat[0] * v.x + mat[4] * v.y + mat[8] * v.z + mat[12];
  _dest.y = mat[1] * v.x + mat[5] * v.y + mat[9] * v.z + mat[13];
  _dest.z = mat[2] * v.x + mat[6] * v.y + mat[10] * v.z + mat[14];
  float w = mat[3] * v.x + mat[7] * v.y + mat[11] * v.z + mat[15];

  if (abs(w) > EPSILON) {
  _dest.mult(1.0 / w);
  }

  return _dest;
  }

}

