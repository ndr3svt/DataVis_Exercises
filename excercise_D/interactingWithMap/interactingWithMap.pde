// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin

Table futureCities;
ArrayList<String> cities  = new ArrayList<String>();
ArrayList<PVector> geoCoords = new ArrayList<PVector>();
ArrayList<String> futCities = new ArrayList<String>();
ArrayList<PVector> futGeoCoords = new ArrayList<PVector>();


//drawing dimensions - this depends on your actual content
float scale = 1.0;

PVector mouse = new PVector();
PVector smoothMouse = new PVector();
PVector shift = new PVector();
// ArrayList<Float> longs = new ArrayList<Float>();
PImage map ;
void setup(){
	size(1440, 720,FX2D);
	frameRate(30);

	tint(255,240,250);
	map = loadImage("data/earth_min.jpg");
	loadData();
	rectMode(CENTER);
}


void draw(){
	background(255,240,250);
	zoomInOut();
	drag();
}

boolean dragged = false;
float lastMouseX = 0;
float lastMouseY = 0;
void drag(){
	if(mousePressed){
		// dragged =true;
		lastMouseX = 	mouseX-lastMouseX;
		lastMouseY =	mouseY - lastMouseY;
		shift.x = shift.x-lastMouseX;
		shift.y = shift.y-lastMouseY;
		// println(lastMouseX);
	}
	lastMouseX = mouseX;
	lastMouseY = mouseY;
	
}



void zoomInOut(){
	//isolate coordinate space
	pushMatrix();
	//move to where the transformation centre should be (this can be mixed with the above, but I left it on two lines so it's easier to understand)
	translate(smoothMouse.x,smoothMouse.y);
	//transform from set position
	scale(scale);
	//move the transformation back adding the shift
	translate(-smoothMouse.x-shift.x,-smoothMouse.y-shift.y);
	// //draw what you need to draw
	displayStuff();
	// //return to global coordinate space
	popMatrix();
	smoothMouse.set(smoothMouse.x *0.5 + mouse.x*0.5, smoothMouse.y *0.5 + mouse.y*0.5);
}
void displayStuff(){
	image(map,0,0,width,height);
	displayData();
	fill(0,255,0);
	ellipse(human.x,human.y,10,10);
}
float deltaX;
void mouseWheel(MouseEvent event) {
  	float e = event.getCount();
	float newWidth = width*scale;
	float newHeight = height* scale;
	float widthRatio = (mouseX-mouse.x)/newWidth;
	float heightRatio = (mouseY-mouse.y)/newHeight;
	float tX = widthRatio * width;
	float tY = heightRatio * height;
	if(scale>1.5){
		mouse.set(mouseX,mouseY);
	}	else{
		mouse.set(mouseX ,mouseY);
	}
    scale += e / 100;
    if(scale<1.0){
    	scale = 1.0;
    }

}



void loadData(){
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
PVector human= new PVector();

void displayData(){
	float newWidth = (width)*scale;
	float newHeight = height* scale;
	float widthRatio = (mouseX-mouse.x)/newWidth;
	float heightRatio = (mouseY-mouse.y)/newHeight;
	float tX = widthRatio * width;
	float tY = heightRatio * height;

	human = new PVector(mouse.x+tX+shift.x,mouse.y +tY +shift.y);	
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


void displayFutureCities(){
	noStroke();
	for (int i = 0; i < cities.size(); i ++){
		float fut_x = map(futGeoCoords.get(i).x, -180,180,0,width);
		float fut_y = map(futGeoCoords.get(i).y, 90, -90, 0, height);
		fill(0,0,250,25);
		ellipse(fut_x,fut_y,15,15);
	}
}
void displayFuture(int index){
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

