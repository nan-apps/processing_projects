//detecta el punto mas brillante y ubica un globo que flota hacia arriba

import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;
int mode = 1;
int startMills = 0;
int lastCreationMills = 0;
int treshhold = 250;
ArrayList<float[]> shapes = new ArrayList<float[]>();
float sizeCoef = 1;
float alphaCoef = 1;
float velocity = 0;
float delayMills = 1000;
int m = 0;

void setup() {  
  size(640, 480);
  
  cam = new Capture(this, 640, 480, 30);
  opencv = new OpenCV(this, 640, 480);
  cam.start();     
  background(255);
  rectMode(CENTER);
  
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
      //float[] = sahpe = {coord1, coord2, w, h, alpha, pendiente, rotate}
      float[] shape = { maxLoc[0], maxLoc[1], 4, 4, 250, random(m*-1,m), 0 };
      shapes.add(shape);
      lastCreationMills = millis();
    } 
    
    updateShapes();  
    
   //saveFrame("frames/"+millis()+".tif");
  
}

void updateShapes(){
  
  for (int i = 0; i < shapes.size(); i++) {
    float[] shape = shapes.get(i);    
    
    stroke(0, shape[4] );
    fill(0, shape[4] );
    strokeWeight(1);    
    
    pushMatrix();    
    translate( shape[0] += shape[5],  shape[1] -= mode==1?velocity:0 );
    rotate( radians( shape[6]) );
    rect(0, 0, shape[2] += mode==1?sizeCoef:0, shape[3] += mode==1?sizeCoef:0 );
    popMatrix();
    
    //next values
    shape[4] = getAlpha( shape[4] );
    shape[6] = getRotate( shape[6] );
    
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

float getAlpha( float shapeAlpha ){  
  return shapeAlpha - alphaCoef; 
}
float getRotate( float deegres ){  
  return deegres==360 ? 0 : deegres+10; 
}