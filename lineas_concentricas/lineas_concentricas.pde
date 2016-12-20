//detecta el punto mas brillante y lo va siguiendo con una linea

import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;
int treshhold = 250;
int[][] lines;  

void setup() {  
  size(640, 480);
  
  cam = new Capture(this, 640, 480, 30);
  opencv = new OpenCV(this, 640, 480);
  cam.start();     
  
    lines = new int[][]{ {0,0},       {320, 0},        {640,0},
                         {0, 240},    /*{320,240},*/       {640, 240},
                         {0,480},     {320, 480},      {640,480} };
     
}

void draw() {
    
    background(255); 
    float maxBr = 0;
    int[] maxLoc = new int[2];
    opencv.loadImage(cam);  
    PImage output = opencv.getOutput();
    image(cam, 0, 0);
    
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
      
      for( int i = 0; i<lines.length; i++ ){
        line(maxLoc[0], maxLoc[1], lines[i][0], lines[i][1]);
      }
      
    } 
    
  
}

void captureEvent(Capture c) {
  c.read();
}