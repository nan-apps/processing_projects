import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

int thresh = 40;
int poly_sides = 1;
int poly_sides_thresh = 2000;

int time = millis();
int wait = 200;

PImage bg;

void setup() {
  size(1280, 720);
  noFill(); //interesante deshabilitar esto
   

  video = new Capture(this, 1280, 720);
  //initialize OpenCV only once
  opencv = new OpenCV(this, 1280, 720);

  video.start();
  
  bg = loadImage("moon.jpg");
  
}

void draw() {
 //  scale(4);

  if (millis() - time >= wait){
    //update OpenCV with video feed
    opencv.loadImage(video);
  //  image(video, 0, 0 );
    background(255);
    //background(bg);

    time = millis();
    opencv.gray();
    opencv.threshold( thresh );
    contours = opencv.findContours();
    for (Contour contour : contours) {
      
      
      ArrayList<PVector> points = contour.getPoints(); 
      
      fill(0, 0, 0, 50);
      stroke( 0 );
      strokeWeight(1);
      beginShape();
      
      if( points.size() > poly_sides  && points.size() < poly_sides_thresh  ){
      //  println( points.size() );print("*******************************************");   
        for (int i = 0; i < points.size(); i++) {
          if( i+1 < points.size() ){
            PVector point_0 = points.get(i);
            PVector point_1 = points.get(i+1);
            
            //mode 1            
            vertex( point_0.x, point_0.y);
            
            
            //mode 2            
            //stroke(0, 10);
            //fill( 0,  10 );
            //ellipse( point_0.x, point_0.y, 30, 30 );
            
          }
        }
      }
      
      endShape(CLOSE);
      

      
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  if (key == 43) {
    poly_sides = poly_sides + 10;
  } else if ( key == 45 ) {
    poly_sides = poly_sides <= 0 ? 0 : poly_sides - 10;
  }
  
  if (key == 17) {
    thresh = thresh + 1;
  } else if ( key == 18 ) {
    thresh = thresh <= 0 ? 0 : thresh - 1;
  }
  
  println("thresh: "+thresh);
  println("poly_sides: "+poly_sides);
}