import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class loading2DEarthMap extends PApplet {

// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin

PImage map;
public void setup(){
	
	frameRate(30);
	// loading the image file
	// you can replace this with any other map image, just remember
	// the map image needs to be compliant to the Geo Coordinate System
	// the easiest way to be sure about it, is to use this image as scale reference
	map = loadImage("data/earth.jpg");
}
public void draw(){
	background(0);
	displayMap();
	displayAxes();
	displayGeoCoordinates();
}

// showing the map as an image
public void displayMap(){
	image(map,0,0,width,height);
}
// showing meridian and equator
public void displayAxes(){
	strokeWeight(0.5f);
	stroke(255,0,0);
	line(width/2,0,width/2,height);
	line(0,height/2,width,height/2);
}

// printing coordinates on screen following the cursor
public void displayGeoCoordinates(){

	fill(0,255,255);
	float longitude = map(mouseX,0,width,-180,180);
	float latitude = map(mouseY,0,height,90,-90);
	text(longitude + " , " + latitude, mouseX,mouseY);
}
  public void settings() { 	size(1440, 720,FX2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "loading2DEarthMap" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
