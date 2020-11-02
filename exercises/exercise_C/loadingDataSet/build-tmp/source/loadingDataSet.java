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

public class loadingDataSet extends PApplet {

Table futureCities;
ArrayList<String> cities  = new ArrayList<String>(); // names of the cities
ArrayList<PVector> geoCoords = new ArrayList<PVector>();
ArrayList<String> futCities = new ArrayList<String>(); // names of the future cities
ArrayList<PVector> futGeoCoords = new ArrayList<PVector>();


PImage map ;


public void setup(){
	
	frameRate(30);
	tint(255,240,250);
	map = loadImage("data/earth_min.jpg");
	loadData();
	rectMode(CENTER);
}

public void draw(){
	background(255);

	image(map,0,0,width,height);
	for(int i=0; i<cities.size();i++){


		PVector human = new PVector(mouseX,mouseY);
		fill(0,0,255);
		float lon = map(geoCoords.get(i).x, -180, 180, 0, width); //x
		float lat = map(geoCoords.get(i).y, 90,-90,0,height); // y

		ellipse(lon, lat, 10,10);

		PVector locPresent = new PVector(lon,lat);
		float lon2 = map(futGeoCoords.get(i).x, -180, 180, 0, width); //x
		float lat2 = map(futGeoCoords.get(i).y, 90,-90,0,height); // y

		PVector locFuture = new PVector(lon2, lat2);

		// text(cities.get(i),  );



		fill(255,0,0);
		
		
		
		if(human.dist(locPresent)< 10){

			text(cities.get(i),lon,lat);
			ellipse(lon2, lat2, 10,10);
			text(futCities.get(i), lon2, lat2 );
			break;
		}

		// text(futCities.get(i), lon2, lat2 );


	}



}

public void loadData(){


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

	    if(city.length()>0){
	    	// println(city, longitude, latitude );
	    	cities.add(city);
	    	geoCoords.add(new PVector(longitude,latitude));

	    	futCities.add(futureCity);
	    	futGeoCoords.add(new PVector(longFut, latFut));

		}


  	}

}










  public void settings() { 	size(1440, 720,FX2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "loadingDataSet" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
