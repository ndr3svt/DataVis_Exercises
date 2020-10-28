// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin

import peasy.PeasyCam;

PShape earth;

PImage surftex1;
PImage surftex2;
PImage cloudtex;
float angleY;
float angleX = -0.04;
float angleCloud = 0;
PeasyCam cam;
float r = 400;
boolean easycamIntialized =false;
public void settings() {
  fullScreen( P3D, 2);

  smooth(0);
}

void setup() {
  // frameRate(60);
   cam = new PeasyCam(this, 800);
   if(!easycamIntialized){
    //easycam = new Dw.EasyCam(this._renderer, {distance:1500, center:[0,0,0]}) ;
    //cam.
    cam.setMinimumDistance(100);
    cam.setMaximumDistance(r*60);
    easycamIntialized=true;
  }
  surftex1 = loadImage("data/earth_min.jpg");  
  // surftex1.resize(surftex1.width, surftex1.height);
  surftex2 = loadImage("data/earth_sat.jpg");

  sphereDetail(40);
  noStroke();
  earth = createShape(SPHERE, height/2.8);
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
  //image(starfield, 0, 0, width, height);
  hint(ENABLE_DEPTH_MASK);
  directionalLight(255, 0,0, -1, -1, -1);
  ambientLight(0, 0, 255);
  shape(earth);
  // enables drawing according to the relative of the Camera
  // is isolating the transformation matrix 
  // - similar to push() /pop() or pushMatrix() /popMatrix()
  // the last functions wouldn't work inthis context as the apply to the main context and not the camera context
  cam.beginHUD();
  textSize(12);
  fill(255,0,0);
  text("fps : " +frameRate,100,100);
  cam.endHUD();
  // if(frameCount%120 == 0) println(frameRate);
}

