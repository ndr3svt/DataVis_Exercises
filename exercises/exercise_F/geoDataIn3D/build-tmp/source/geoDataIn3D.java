import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class geoDataIn3D extends PApplet {

// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin


// reference to Spherical Coordinate System
// https://en.wikipedia.org/wiki/Spherical_coordinate_system
// how to calculate x y z in an spherical coordinate system



PShape earth;
PImage surftex1;
PImage surftex2;

PFont myFont, myFontH;

PGraphics3D g3;
PeasyCam cam;
PMatrix3D currCameraMatrix;

float r = 400;
boolean easycamIntialized =false;

int rX=-90;
int rY=0;
int rZ=0;
PGraphics canvas;
// examples of manually added points
PointOfInterest pOI_0, pOI_1, pOI_2, pOI_3,pOI_4;
PVector human  = new PVector();

// for loading data from future cities database
Table futureCities;
ArrayList<String> cities  = new ArrayList<String>(); // names of the cities
ArrayList<PVector> geoCoords = new ArrayList<PVector>();
ArrayList<String> futCities = new ArrayList<String>(); // names of the future cities
ArrayList<PVector> futGeoCoords = new ArrayList<PVector>();

public void setup() {
  
  canvas = createGraphics(width, height, P3D);
  cam = new PeasyCam(this, 800);
  cam.setWheelScale(0.05f);
  myFont = createFont("Helvetica", 12);
  myFontH = createFont("Helvetica", 64);
  
  frameRate(60);
  pOI_0 = new PointOfInterest(19.395175071159112f, -99.16421378630378f, "CDMX", r, 0);
  pOI_1 = new PointOfInterest(55.66174835669238f, 12.513764710947195f, "Copenhagen", r,1);
  pOI_2 = new PointOfInterest(-33.89517888896039f, -58.656823360705175f, "Buenos Aires",r, 2);
  pOI_3 = new PointOfInterest(48.868755553906496f, 2.3463870250755137f, "Paris",r, 3);
  pOI_4 = new PointOfInterest(47.37578791948954f, 8.531219466080843f, "Zürich",r, 4);


  if(!easycamIntialized){

    cam.setMinimumDistance(20);
    cam.setMaximumDistance(r*600);
    easycamIntialized=true;
  }

  // surftex1 =loadImage("data/earth_sat.jpg"); 
  surftex1 =loadImage("data/earth_min.jpg"); 


  canvas.sphereDetail(32);
  canvas.noStroke();
  earth = canvas.createShape(SPHERE, r);
  earth.setTexture(surftex1);

  loadData();

}

public void draw() {
  human.set(mouseX,mouseY);
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
  canvas.directionalLight(255, 0,0, -10, -10, -10);
  canvas.directionalLight(100, 255, 50, 0,0,10);
  canvas.directionalLight(255, 100, 50, 0,10,0);
  canvas.directionalLight(180, 180, 255, 10,-10,-10);
  // this rotation is applied to correct the rotation of the texture according to 
  canvas.push();
  canvas.rotateX(radians( rX));
  canvas.rotateY(radians(rY));
  canvas.rotateZ(radians(rZ));
  canvas.shape(earth);
  canvas.pop();
  pOI_0.display3D(canvas);
  pOI_1.display3D(canvas);
  pOI_2.display3D(canvas);
  pOI_3.display3D(canvas);
  pOI_4.display3D(canvas);
  displayMultiplePOI3D();

  cam.beginHUD();
  // example to draw stuff on 2D outside the 3D context
  // fill(255,0,0);
  // textSize(12);
  // text("fps : " +frameRate,100,100);
  // text(" rx :  " + rX,100,115);
  // text(" ry :  " + rY,100,130);
  // text(" rz :  " + rZ,100,145);
  cam.endHUD();
 
  canvas.endDraw();
  cam.getState().apply(canvas);
  image(canvas, 0, 0);

  pOI_0.update(canvas);
  pOI_0.display2D();
  pOI_0.interact(human);
  pOI_1.update(canvas);
  pOI_1.display2D();
  pOI_1.interact(human);
  pOI_2.update(canvas);
  pOI_2.display2D();
  pOI_2.interact(human);
  pOI_3.update(canvas);
  pOI_3.display2D();
  pOI_3.interact(human);
  pOI_4.update(canvas);
  pOI_4.display2D();
  pOI_4.interact(human);
  // if(frameCount%120 == 0) println(frameRate);

  displayMultiplePOI2D();

  // g3.camera = currCameraMatrix;
}




PointOfInterest [] pOIs;
public void loadData() {


  futureCities = loadTable("data/future_cities_data.csv", "header");
  println(futureCities.getRowCount() + " total rows in table");

  int entriesCount =0;
  for (TableRow row : futureCities.rows()) {
    String city = row.getString("current_city");
    float longitude = row.getFloat("Longitude");
    float latitude = row.getFloat("Latitude");

    String futureCity = row.getString("future_city_1_source");

    float longFut = row.getFloat("future_long");
    float latFut = row.getFloat("future_lat");

    if (city.length()>0) {
      // println(city, longitude, latitude );
      cities.add(city);
      geoCoords.add(new PVector(longitude, latitude));

      futCities.add(futureCity);
      futGeoCoords.add(new PVector(longFut, latFut));

    }
  }
  pOIs = new PointOfInterest[cities.size()];
  multiplePOI();
}

public void multiplePOI(){

   for (int i=0; i<cities.size(); i++) {

    pOIs[i] = new PointOfInterest(geoCoords.get(i).y,geoCoords.get(i).x, cities.get(i), 400, i);

   }
}

public void displayMultiplePOI2D(){
  for (int i=0; i<cities.size(); i++) {
    pOIs[i].update(canvas);
    pOIs[i].display2D();
    pOIs[i].interact(human);
  }
}

public void displayMultiplePOI3D(){
  for (int i=0; i<cities.size(); i++) {

    pOIs[i].display3D(canvas);

  }
}


class  PointOfInterest{

  PVector location;
  float radius;
  PVector scrnPnt =new PVector();
  String name;
  int i;
  float lat, lon;
  PointOfInterest(float latitude, float longitude, String _name, float _r, int _i){

  // some explanation on Geo Coordinates to an spheric system
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
    lat = latitude;
    lon = longitude;
    radius = _r +0.5f; // with 10 units away from earth's surface
    location = new PVector(
      radius* cos (radians(latitude)) * cos(radians(longitude)),
      radius * cos(radians(latitude)) * sin(radians(longitude)),
      radius * sin(radians(latitude))
    );
    name = _name;
    i = _i;
  }

  public void update(PGraphics _canvas){
    scrnPnt.set(
      _canvas.screenX(-location.x,location.y,location.z), 
      _canvas.screenY(-location.x,location.y,location.z),
      _canvas.screenZ(-location.x,location.y,location.z)
    );
  }
  public void display3D(PGraphics _canvas){
    _canvas.strokeWeight(10);
    _canvas.stroke(255,0,0);
    _canvas.point(-location.x,location.y,location.z);
    
  }

  public void display2D(){
    fill(0,0,255);
    strokeWeight(0.5f);
    stroke(0,0,255,100);
    

    stroke(0,0,255);
    strokeWeight(4);
    point(scrnPnt.x,scrnPnt.y);
    
  }
  public void interact(PVector _human){
    if(_human.dist(scrnPnt)< 10){
      strokeWeight(0.5f);
      stroke(0,0,255,100);
      float lx = scrnPnt.x;
      float ly = scrnPnt.y;
      line(lx,0,lx,height);
      line(0,ly,width,ly);
      textFont(myFont);
      text(name, 25,180);
      text("screen coords : " + scrnPnt.x + " ,  " + scrnPnt.y +  " , " + scrnPnt.z, 25,200);
      text("3D coords : "  + -location.x + " ,  " + location.y +  " , " + location.z, 25,220);
      textFont(myFontH);
      text(name, width-300,scrnPnt.y+10);
      textFont(myFont);
      text("lat : " + lat + "lon : " + lon, width-300,scrnPnt.y+50);
      noStroke();
      fill(0,0,255,50);
      ellipse(scrnPnt.x, scrnPnt.y, 40, 40);

      if(mousePressed){
        // cam.lookAt(-location.x,location.y,location.z);
      }
    }

  }


}




// void screenPosition(x, y, z) {

// 			PVector v = new PVector(x, y, z);
// 			// this v2 is to use the diametrically opposed value to see if point is behind or on front the spherical projection
// 			PVector v2 = new PVector(-x,-y,-z);
// 			// Calculate the ModelViewProjection Matrix.
// 			let mvp = (p._renderer.uMVMatrix.copy()).mult(p._renderer.uPMatrix);

// 			// Transform the vector to Normalized Device Coordinate.
// 			let vNDC = multMatrixVector(mvp, v);
// 			let vNDC2 = multMatrixVector(mvp,v2);

// 			// Transform vector from NDC to Canvas coordinates.
// 			let vCanvas = p.createVector();
// 			vCanvas.x = 0.5 * vNDC.x * p.width;
// 			vCanvas.y = 0.5 * -vNDC.y * p.height;
// 			// in case you prefer to ignore z set it to 0
// 			// vCanvas.z = 0;


// 			// to know if z in front or behind the earth / spherical projection
// 			if(vNDC2.z>vNDC.z){
// 				vCanvas.z = 1
// 			}else{
// 				vCanvas.z = -1
// 			}
// 			vCanvas.z = vNDC2.z-vNDC.z

// 			return vCanvas;
// 		}

// }

// void multMatrixVector(m, v) {
// 		// if (!(m instanceof p5.Matrix) || !(v instanceof p5.Vector)) {
// 		// 	print('multMatrixVector : Invalid arguments');
// 		// 	return;
// 		// }

// 		PVector _dest = new PVector();
// 		var mat = m.mat4;

// 		// Multiply in column major order.
// 		_dest.x = mat[0] * v.x + mat[4] * v.y + mat[8] * v.z + mat[12];
// 		_dest.y = mat[1] * v.x + mat[5] * v.y + mat[9] * v.z + mat[13];
// 		_dest.z = mat[2] * v.x + mat[6] * v.y + mat[10] * v.z + mat[14];
// 		var w = mat[3] * v.x + mat[7] * v.y + mat[11] * v.z + mat[15];

// 		if (Math.abs(w) > Number.EPSILON) {
// 			_dest.mult(1.0 / w);
// 		}

// 		return _dest;
// 	}
  public void settings() {  size(displayWidth,displayHeight,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "geoDataIn3D" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
