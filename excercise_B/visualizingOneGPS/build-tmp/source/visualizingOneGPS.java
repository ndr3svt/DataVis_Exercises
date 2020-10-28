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

public class visualizingOneGPS extends PApplet {

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
	map = loadImage("data/earth_min.jpg");
}
public void draw(){
	background(0);
	displayMap();
	displayAxes();
	displayGeoCoordinates();

	displayOneGPSLocation(52.52168457877308f, 13.413254286298855f,"Alte National Galerie, Berlin");
	displayOneGPSLocation(47.39019718604871f, 8.510658984734889f,"Toni Areal, Zurich");
}

public void displayOneGPSLocation(float latitude, float longitude, String name){

	PVector location = new PVector(
		map(longitude, -180,180,0,width),
		map(latitude,90,-90,0,height)
	);

	fill(255,0,0);
	ellipse(location.x,location.y,4,4);

	text(name,location.x+25,location.y+30);
	stroke(255,0,0);
	line(location.x,location.y,location.x+25,location.y+25);
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

	fill(0,0,255);
	float longitude = map(mouseX,0,width,-180,180);
	float latitude = map(mouseY,0,height,90,-90);
	text("lat : " +latitude + " , long : " + longitude, mouseX,mouseY);
}
  public void settings() { 	size(1440, 720,FX2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "visualizingOneGPS" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
