
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
    radius = _r +0.5; // with 10 units away from earth's surface
    location = new PVector(
      radius* cos (radians(latitude)) * cos(radians(longitude)),
      radius * cos(radians(latitude)) * sin(radians(longitude)),
      radius * sin(radians(latitude))
    );
    name = _name;
    i = _i;
  }

  void update(PGraphics _canvas){
    scrnPnt.set(
      _canvas.screenX(-location.x,location.y,location.z), 
      _canvas.screenY(-location.x,location.y,location.z),
      _canvas.screenZ(-location.x,location.y,location.z)
    );
  }
  void display3D(PGraphics _canvas){
    _canvas.strokeWeight(10);
    _canvas.stroke(255,0,0);
    _canvas.point(-location.x,location.y,location.z);
    
  }

  void display2D(){
    fill(0,0,255);
    strokeWeight(0.5);
    stroke(0,0,255,100);
    

    stroke(0,0,255);
    strokeWeight(4);
    point(scrnPnt.x,scrnPnt.y);
    
  }
  void interact(PVector _human){
    if(_human.dist(scrnPnt)< 10){
      strokeWeight(0.5);
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

      if(mousePressed && enableFocus){
         cam.lookAt(-location.x,location.y,location.z);
      }
    }

  }


}
