//a position to scale from
PVector mouse = new PVector();
//a scale value
float scale = 1.0;
//drawing dimensions - this depends on your actual content

void setup(){
  size(400,400);
  rectMode(CENTER);
}
void draw(){
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
    ellipse(mouse.x-width*.5,mouse.y-height*.5,35,35);
  }
}
//just a bunch of boxes as a placeholder
void drawStuff(){
  for(int i = 0 ; i < 400; i++){
    int x = i % 20;
    int y = i / 20;
    pushMatrix();
    translate(x * 20, y * 20);
    rotate(radians(i));
    scale(sin(radians(i)) + 1.1);
    fill(i % 400);
    rect(0,0,15,15);
    popMatrix();
  }
}
//set the transformation centre
void mousePressed(){
  // mouse.set(mouseX,mouseY);
}
//change scale by moving mouse on X axis
void mouseDragged(){
  // scale = map(mouseX,0,width,0.25,2.0);
}


void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    mouse.set(mouseX,mouseY);
    scale += e / 100;
    // scale = map(mouseX,0,width,0.25,2.0);



}