color wingColor = color(255, 182, 193); //the color of butterfly is originally light pink
void setup() {
  background(170, 200, 230); //light blue background in setup so flowers will stay on canvas later
  size(600, 600); //canvas size
}

void draw() {
  drawButterfly(width/2, height/2, 50); //draws butterfly at the center of the canvas
}

void mousePressed() {
  wingColor = color(random(255), random(255), random(255)); //butterfly "metamorphosis" into different colors
}
void keyPressed() { //draw a flower at a random position, symbolizing growth and bloom
  drawFlower(random(width), random(height), 20); //drawing flower is further instructed with void draw flower
}
void drawButterfly(float x, float y, float size) { //drawing the wings
  noStroke(); //do no want outlines for the wing circles
  fill(wingColor);
  //making the wings
  ellipse(x-size/2, y-size/2, size, size*1.5); //top left wing
  ellipse(x-size/2, y+size/2, size, size*1.5); //bottom left wing
  ellipse(x+size/2, y-size/2, size, size*1.5); //top right wing
  ellipse(x+size/2, y+size/2, size, size*1.5); //bottom right wing
  //drawing the body with black
  stroke(0); //black outline for the body
  strokeWeight(3);
  line(x, y-size, x, y+size); //this is the main body line in the middle of the wings
  line(x, y-size, x-size/4, y-size*1.2); //this is the left antenna
  line(x, y-size, x+size/4, y-size*1.2); //then this draws the right antenna
}

void drawFlower(float x, float y, float size) { //drawing flowers when key is pressed
  fill(210, 100, 200); //pink color for petals
  noStroke();
  ellipse(x-size/2, y, size, size); //drawing four petals
  ellipse(x+size/2, y, size, size); 
  ellipse(x, y-size/2, size, size);
  ellipse(x, y+size/2, size, size); 
  fill(255, 223, 0); //give flower yellow center
  ellipse(x, y, size/1.5, size/1.5); //this is the flower center circle
}
