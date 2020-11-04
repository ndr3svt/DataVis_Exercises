boolean showCO2;
boolean showDebug=true;
boolean showReforest;
boolean enableRotation;
boolean enableFocus;
void keyPressed(){
  if(key == 'c' || key == 'C'){
    
    showCO2 = !showCO2;
  }
  if(key == 'd' || key == 'D'){
    
    showDebug = !showDebug;
  }
  if(key == 'g' || key == 'G'){
   
    showReforest = !showReforest;
  }
  if(key == 'r' || key == 'R'){
   
    enableRotation = !enableRotation;
  }
  if(key == 'f' || key == 'F'){
    enableFocus = !enableFocus;
  }
}
