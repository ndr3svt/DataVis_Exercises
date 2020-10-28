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

public class loadingMultipleGPSData extends PApplet {

// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin

Table futureCities;
ArrayList<String> cities  = new ArrayList<String>();
ArrayList<PVector> geoCoords = new ArrayList<PVector>();
ArrayList<String> futCities = new ArrayList<String>();
ArrayList<PVector> futGeoCoords = new ArrayList<PVector>();
PVector human= new PVector();

//drawing dimensions - this depends on your actual content
float scale = 1.0f;

PVector mouse = new PVector();
PVector smoothMouse = new PVector();
PVector shift = new PVector();
// ArrayList<Float> longs = new ArrayList<Float>();
PImage map ;
public void setup(){
	
	frameRate(30);
	tint(255,240,250);
	map = loadImage("data/earth_min.jpg");
	loadData();
	rectMode(CENTER);
}


public void draw(){
	background(0);
	displayStuff();
	// zoomInOut();
}

boolean dragged = false;
float lastMouseX = 0;
float lastMouseY = 0;





public void displayStuff(){
	image(map,0,0,width,height);
	displayData();
	fill(0,255,0);
	ellipse(human.x,human.y,10,10);
}



public void loadData(){
	futureCities = loadTable("data/future_cities_data.csv", "header");
	println(futureCities.getRowCount() + " total rows in table");
	int entriesCount =0;
	for (TableRow row : futureCities.rows()) {
	    String city = row.getString("current_city");
	    float latitude = row.getFloat("Latitude");
	    float longitude = row.getFloat("Longitude");

	    String futCity = row.getString("future_city_1_source");
	    float futLatitude = row.getFloat("future_lat");
	    float futLongitude = row.getFloat("future_long");
	    if(city.length()>0){
	    	entriesCount++;
	    	println(" current city : " + city + " , latitude :" + latitude + " , longitude : " + longitude);

	    	cities.add(city);
	    	geoCoords.add(new PVector(longitude, latitude ));
	    	futCities.add(futCity);
	    	futGeoCoords.add(new PVector(futLongitude,futLatitude));
	    }
  	}
  	println(futureCities.getRowCount() + " total rows in table, but only " + entriesCount +" rows contain data " );
  	println("total city names : " + cities.size());
  	println("total geoCoords : " + geoCoords.size());
}

public void displayData(){

	// println(mouse.x + ", m x " + widthRatio);
	human = new PVector(mouseX,mouseY);
	noStroke();
	for(int i=0;i< cities.size();i++){
		float x = map(geoCoords.get(i).x, -180,180,0,width);
		float y = map(geoCoords.get(i).y, 90, -90, 0, height);
		// if not touching points
		if(human.dist(new PVector(x,y))>5){
			fill(180,100,255);
			ellipse(x,y, 5,5);
		}
		
	}
	// textSize(200);
	
	// run the loop again just to print the label and the interest one on top of the other data
	for(int i = 0; i < cities.size();i++){
		float x = map(geoCoords.get(i).x, -180,180,0,width);
		float y = map(geoCoords.get(i).y, 90, -90, 0, height);
		if(human.dist(new PVector(x,y))<5){
			
			displayFuture(i);
			fill(255);
			ellipse(x,y, 20,20);
			textSize(20);
			if(x>width/2){
				fill(100,100,255);
				text(cities.get(i), x+15,y+5);			
			}else{
				fill(100,100,255);
				text(cities.get(i), x-75,y+5);	
			}
			
			// break the loop to avoid running through the rest of the indexes
			// as you already know which one is the closest one to your hand
			break;
		}
		
	}

	displayFutureCities();

}


public void displayFutureCities(){
	noStroke();
	for (int i = 0; i < cities.size(); i ++){
		float fut_x = map(futGeoCoords.get(i).x, -180,180,0,width);
		float fut_y = map(futGeoCoords.get(i).y, 90, -90, 0, height);
		fill(0,0,255,55);
		ellipse(fut_x,fut_y,15,15);
	}
}
public void displayFuture(int index){
	textSize(40);
	float x = map(geoCoords.get(index).x, -180,180,0,width);
	float y = map(geoCoords.get(index).y, 90, -90, 0, height);
	float fut_x = map(futGeoCoords.get(index).x, -180,180,0,width);
	float fut_y = map(futGeoCoords.get(index).y, 90, -90, 0, height);
	stroke(255,0,0);
	line(x,y,fut_x,fut_y);
	fill(255,0,0);
	ellipse(fut_x,fut_y,10,10);
	text(futCities.get(index), fut_x+15,fut_y+5);
}

  public void settings() { 	size(1440, 720,FX2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "loadingMultipleGPSData" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
