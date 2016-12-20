import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

int thresh = 100;
int poly_sides = 1;

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
    //image(video, 0, 0 );
    background(255);
  //  background(bg);

    time = millis();
    opencv.gray();
    opencv.threshold( thresh );
    contours = opencv.findContours();
    for (Contour contour : contours) {
      
      //mode 1
      fill(0, 0, 0, 50);
      stroke( 0 );
      contour.draw();
      ArrayList<PVector> points = contour.getPoints();     
      
      if( points.size() > thresh  ){
      //  println( points.size() );print("*******************************************");   
        for (int i = 0; i < points.size(); i++) {
          if( i+1 < points.size() ){
            PVector point_0 = points.get(i);
            PVector point_1 = points.get(i+1);          
            
            //mode 2
            /*fill(0, 255);
            stroke( 255 );
            line( point_0.x, point_0.y, point_1.x, point_1.y  );*/
            
            //mode 3            
            //stroke(0, 10);
            //fill( 0,  10 );
            //ellipse( point_0.x, point_0.y, 30, 30 );
            
          }
        }
      }
      

     /* stroke(255, 0, 0);
      beginShape();
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape();*/
      
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}