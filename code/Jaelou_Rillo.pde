//Storing background gradient and Sea image into data files
PImage bg;
PImage img; 
//Storing variable in order to move the wave
float offset = 0;
float easing = 0.001;
//Storing variables for the clock
int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;

void setup() {
  size(1000, 800);
  //upload and resize background image (gradient of sunset)
  bg = loadImage("Sunset.jpg"); 
  bg.resize (1000,800);
  //upload and resize WaveOfKanagawa to fit canvas size
  img = loadImage("WaveOfKanagawa.png");
  img.resize (1000, 800);
  
  //defining the length of each clock hand using radius
  int radius = min(width, height) / 2;
  secondsRadius = radius * 0.42;
  minutesRadius = radius * 0.40;
  hoursRadius = radius * 0.20;
  clockDiameter = radius * 1.8;
  //placing clock in the center of canvas
  cx = width / 2;
  cy = height / 2;
}

// Defining star function to create the sun
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void draw(){
  background(bg);
  image(img,0,0);
  
  //palcing, sizing, and rotating the sun
  pushMatrix();
  translate(width/2 + 20, height/2);
  rotate(frameCount / -250.0);
  fill(245, 245, 7);
  star(0, 0, 150, 350, 20); 
  popMatrix();
  
  //making clock hands display current time
  float s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  
  //line thickness and color of each clock hand
  stroke(140, 13, 8);
  strokeWeight(2);
  line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius); //seconds hand
  strokeWeight(4);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius); //minutes hand
  strokeWeight(6);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius); //hours hand
  
  //making the wave follow the horizontal movement of the mouse 
  float dx = (mouseX-img.width/2) - offset;
  offset += dx * easing;
  image(img, offset, 10);
  
}
