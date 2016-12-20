//detecta el punto mas brillante y ubica un globo que flota hacia arriba

import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;
int mode = 1;
int startMills = 0;
int lastCreationMills = 0;
int treshhold = 253;
ArrayList<float[]> shapes = new ArrayList<float[]>();
float sizeCoef = 0.3;
float alphaCoef = 1;
float velocity = 1;
float delayMills = 0;

void setup() {  
  size(1280, 720
  );
  
  cam = new Capture(this, 1280, 720, 30);
  opencv = new OpenCV(this, 1280, 720);
  cam.start();     
  background(255);
}

void draw() {
    background(255);  
    startMills = millis();
    
    float maxBr = 0;
    int[] maxLoc = new int[2];
    opencv.loadImage(cam);  
    PImage output = opencv.getOutput();
    image( cam, 0, 0 );
    
    output.loadPixels(); 
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          int loc = x + y*width;
          if( brightness( output.pixels[loc] ) > maxBr ){
            maxBr = brightness( output.pixels[loc] );
            maxLoc[0] = x;
            maxLoc[1] = y;
          }                    
        }
      }
      
    if( maxBr > treshhold && ( (startMills - lastCreationMills > delayMills || lastCreationMills == 0 ) )  ){
                          
      float[] shape = { maxLoc[0], maxLoc[1], 4, 4, 250, random(-2,2) };
      
      shapes.add(shape);
      lastCreationMills = millis();
    } 
    
    updateShapes();  
    
   //saveFrame("frames/"+millis()+".tif");
  
}

void updateShapes(){
  
  for (int i = 0; i < shapes.size(); i++) {
    float[] shape = shapes.get(i);
    stroke(0, shape[4]-= mode==1?alphaCoef:0.1 );
    fill(0, shape[4]-= alphaCoef );
    strokeWeight(1);     
    ellipse( shape[0] += shape[5] , shape[1] -= mode==1?velocity:0, shape[2] += mode==1?sizeCoef:0, shape[3] += mode==1?sizeCoef:0 );
  }
  
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  if (key == 49) {
    mode = 1;
  } else if ( key == 50 ) {
    mode = 2;
  }
}