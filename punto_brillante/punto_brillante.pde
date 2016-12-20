//detecta el punto mas brillante y lo va siguiendo con una linea

import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;
int treshhold = 250;

void setup() {  
  size(640, 480);
  
  cam = new Capture(this, 640, 480, 30);
  opencv = new OpenCV(this, 640, 480);
  cam.start();     
  background(255);    
}

void draw() {
    
    float maxBr = 0;
    int[] maxLoc = new int[2];
    opencv.loadImage(cam);  
    PImage output = opencv.getOutput();
    
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
      
    if( maxBr > treshhold ){
      stroke(0, 0, 0);
      fill(0);
      strokeWeight(5);    
      ellipse(maxLoc[0], maxLoc[1], 1, 1);
    } 
    
  
}

void captureEvent(Capture c) {
  c.read();
}