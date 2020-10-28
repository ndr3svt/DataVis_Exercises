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

public class zoomInOut extends PApplet {

//a position to scale from
PVector mouse = new PVector();
//a scale value
float scale = 1.0f;
//drawing dimensions - this depends on your actual content

public void setup(){
  
  rectMode(CENTER);
}
public void draw(){
  background(255);
  //move everything to centre
  // translate(width * .5, height * .5);
  //isolate coordinate space
  pushMatrix();
  //move in the opposite direction by half of the drawing size => transform from drawing centre
  // translate(-width * .5,-height * .5);
  //move to where the transformation centre should be (this can be mixed with the above, but I left it on two lines so it's easier to understand)
  translate(mouse.x,mouse.y);
  //transform from set position
  scale(scale);
  //move the transformation back
  translate(-mouse.x,-mouse.y);
  //draw what you need to draw
  drawStuff();
  //return to global coordinate space
  popMatrix();

  //draw a preview of the transformation centre
  if(mousePressed){
    fill(192,0,0);
    ellipse(mouse.x-width*.5f,mouse.y-height*.5f,35,35);
  }
}
//just a bunch of boxes as a placeholder
public void drawStuff(){
  for(int i = 0 ; i < 400; i++){
    int x = i % 20;
    int y = i / 20;
    pushMatrix();
    translate(x * 20, y * 20);
    rotate(radians(i));
    scale(sin(radians(i)) + 1.1f);
    fill(i % 400);
    rect(0,0,15,15);
    popMatrix();
  }
}
//set the transformation centre
public void mousePressed(){
  // mouse.set(mouseX,mouseY);
}
//change scale by moving mouse on X axis
public void mouseDragged(){
  // scale = map(mouseX,0,width,0.25,2.0);
}


public void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    mouse.set(mouseX,mouseY);
    scale += e / 100;
    // scale = map(mouseX,0,width,0.25,2.0);



}
  public void settings() {  size(400,400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "zoomInOut" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
