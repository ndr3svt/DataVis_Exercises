import geomerative.*;
RShape sMap;
RShape polyshp;
RPoint[] mapPoints;


PGraphics graphFromVector;

PVector zurich = new PVector(8.496956,47.375867);
PVector mexicoCity = new PVector( -99.168956, 19.411533);
PVector greenwhichUK = new PVector( -0.011586, 51.488753);
PVector mitadDelMundoEcuador = new PVector( -78.455817,-0.002206);
ArrayList<PVector> vertexMap = new ArrayList<PVector>();
ArrayList<PVector> vertexMapOrdered = new ArrayList<PVector>();
ArrayList<PVector> clPr =new ArrayList<PVector>();
ArrayList<PVector> coordinates = new ArrayList<PVector>();
boolean debugFlag = false;

void setup() {
	size(1440, 720,FX2D);
	RG.init(this);
	graphFromVector = createGraphics(width,height);
	frameRate(60);
	sMap = RG.loadShape("data/m10.svg");
	mapPoints = sMap.getPoints();
	println("map width: " + sMap.width +  " , map height:" + sMap.height);
	// mapVector.disableStyle();
	createLatLonCSV();
}

float longX;
float latY;
void draw() {
	background(0,0,30);
	drawPolygonMap();
	showDebugInfo();
}


void showDebugInfo(){
	if(debugFlag){
		longX = map(mouseX,0,width,-180,180);
		latY = map(mouseY,0,height,90,-90);
	 	fill(0,0,255);
	 	text(frameRate,25,25);
	 	// // drawing the meridian
	 	strokeWeight(0.25);
	 	stroke(0,255,100);
	 	line(width/2,0,width/2,height);
	 	// // drawing the equator
	 	stroke(0,255,0);
	 	line(0,height/2,width,height/2);
	 	text(longX + " , " + latY, mouseX,mouseY);
	 	fill(0,0,255);
	 	ellipse(map(zurich.x,-180,180,0,width), map(zurich.y,90,-90,0,height),10,10);
	 	ellipse(map(mexicoCity.x,-180,180,0,width), map(mexicoCity.y,90,-90,0,height),10,10);
	 	ellipse(map(greenwhichUK.x,-180,180,0,width), map(greenwhichUK.y,90,-90,0,height),10,10);
	 	ellipse(map(mitadDelMundoEcuador.x,-180,180,0,width), map(mitadDelMundoEcuador.y,90,-90,0,height),10,10);
	 }
}


	


void createLatLonCSV(){
	Table geoTable = new Table();
		geoTable.addColumn("latitude");
		geoTable.addColumn("longitude");
	for (int i=0;i < mapPoints.length; i ++){

		// TableRow newRow = geoTable.addRow();
		geoTable.addRow();
		// maping the x y values on the SVG Map to geographic degrees - latitude for y values longitude for x values
		float factorWidth = width/sMap.width;
		float factorHeight = factorWidth;
		PVector convertMapPoints = new PVector(mapPoints[i].x*factorWidth, mapPoints[i].y*factorHeight);
		float lat =	map(convertMapPoints.y, 0, height, 90,-90);
		float lon = map(convertMapPoints.x, 0, width, -180,180);
		// storing those mapped values in an array
		// notice
		coordinates.add(new PVector(lat, lon));
		geoTable.setFloat(i,0,lon);
		geoTable.setFloat(i,1,lat);

	}
	// saveTable(geoTable, "data/geoCoordEarthMap.csv");
}
// void genMap
void drawPolygonMap(){
	int step=int(map(mouseX,0,width,1,30));
	int offset = 3;
	stroke(100,100,255);
	strokeWeight(0.75);
	

	float factorWidth = width/sMap.width;
	float factorHeight = factorWidth;
	fill(255,255,255,100);

	// noFill();
	int colorIndex=0;
	boolean shaped=false;
	for(int i=0; i<mapPoints.length-step; i+=step){
		if(i>0){
			PVector d = new PVector(mapPoints[i].x,mapPoints[i].y);
			PVector p = new PVector(mapPoints[i-step].x,mapPoints[i-step].y);
			float delta= d.dist(p);
			// 80 - 2
			// ?  - 120
			if(delta< 80+step && !shaped){
				colorIndex=0;
				// start the drawing of the polygon
				beginShape();
				shaped=true;
				vertex(mapPoints[i].x*factorWidth, mapPoints[i].y*factorHeight);				
			}else{
				if(shaped && delta < 80+step){
					vertex(mapPoints[i].x*factorWidth, mapPoints[i].y*factorHeight);
					colorIndex++;
					// fill(255-colorIndex*0.25,0+ colorIndex*0.125,25+colorIndex*0.75,200-colorIndex*0.125);
					
					// an example to draw something only each 32 indexes
					// if(i%32 == 0){
						// vertex(mapPoints[i].x*factorWidth + random(-15,15), mapPoints[i].y*factorHeight + random(-15,15));
						// ellipse(mapPoints[i].x*factorWidth, mapPoints[i].y*factorHeight,5,5);
					// }
				}else{
					if(delta>80+step){
						endShape(CLOSE);
						shaped=false;
					}
				}
			}
		}
	}
	
}


void keyPressed(){

	if(key == 'd' || key == 'D'){
		debugFlag = !debugFlag ;
	}
}


