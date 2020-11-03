ArrayList<PntFTIFF> pntsFTIFF_co2 = new ArrayList<PntFTIFF>();
ArrayList<PntFTIFF> pntsFTIFF_reforest = new ArrayList<PntFTIFF>();

void dataFromTIFFtoArray(PImage _img, ArrayList<PntFTIFF> _pntsFTIFF, float _scale, color _tc) {
  _img.loadPixels();
  int step = 1;
  for (int i=0; i <  (_img.width*_img.height) - step; i +=step) {

    color c = _img.pixels[i];
    
   
    float x = i % _img.width;
    float y = (i-x)/_img.width;
    //println(x,y);
    x = map(x,0, _img.width,-180,180);
    y = map(y,0, _img.height,90,-90);
    
   //println(brightness + " , " + i + " , x:" + x + ",  y:" + y);
    _pntsFTIFF.add(new PntFTIFF(x, y, c, _scale, _tc));
    //println("data added " + i );
  }
  _img.updatePixels();
}

class PntFTIFF {
  float lon, lat;
  color value;
  PVector loc3D;
  float radius;
  float scale;
  color c;
  PntFTIFF(float _lon, float _lat, color _value, float _scale, color _c){
    scale = _scale;
    c = _c;
    lon = _lon;
    lat = _lat;
    //value = map(_value, 0,255, 0, 50);
    value = _value;
    radius = 400 + 5 ;
    loc3D = new PVector(
      radius* cos (radians(lat)) * cos(radians(lon)),
      radius * cos(radians(lat)) * sin(radians(lon)),
      radius * sin(radians(lat))
    );
  }
  
  void display(PGraphics _canvas){
    //_canvas.strokeWeight(brightness(value));
    //_canvas.push();
    //_canvas.fill(value,100);
    _canvas.strokeWeight(map(brightness(value),0,255,1.2,8)* map(brightness(value),0,255,1.2,8) * scale);
    //_canvas.translate(-loc3D.x,loc3D.y,loc3D.z);
    //_canvas.sphere(brightness(value));
    _canvas.stroke(
    map(brightness(value),0,255,100,0) * red(c), 
    map(brightness(value),0,255,100,0) * green(c), 
    map(brightness(value),0,255,100,0) * blue(c),
    150);
    _canvas.point(-loc3D.x,loc3D.y,loc3D.z);
    //_canvas.pop();
  }
} 
