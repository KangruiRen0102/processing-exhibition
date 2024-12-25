//Creates floats for the boat where the boat as an object is defined and the speed is defined
float boat1X;
float boat1Speed = 2;
//A boolean that will be used for a mouse click true/false statement
boolean buttonClicked = false;
//Set up for our image
void setup() {
  size(800, 600); 
  background(0);

//Boat width determined by size of image
  boat1X = width - 300;
}
//The main drawing function for our image
void draw() {

  if (buttonClicked) {
    background(10, 180, 300);
  } else {
    background(0); 
  }
  sun();
  sun2();
  barrier();
  drawOcean();
  drawSailboat(boat1X, height / 2 + 140);

  //Makes all shapes of the boat move simutaneously by the defined boat speed
  boat1X += boat1Speed;

  // If the boat reaches one of the edges it goes back and reverses
  if (boat1X > width - 100 || boat1X < 0) {
    boat1Speed *= -1;
  }
}

//Our mouse click true/false statement for the sky colour
void mousePressed() {
    buttonClicked = !buttonClicked; 
}

//A function for the sun rays
void sun() {
  
  stroke(255, 165, 0); 
  strokeWeight(10); 
  noFill();

  
  ellipse(width / 2, height / 2, 300, 300);  
  ellipse(width / 2, height / 2, 500, 500);  
  ellipse(width / 2, height / 2, 700, 700);  
}
//Second sun function for the sun itself
void sun2() {
  stroke(255, 100, 0); 
  fill(255, 0, 0);
  ellipse(width / 2, height / 2, 200, 200);
}
//The ocean function to draw the ocean
void drawOcean() {
  fill(0, 102, 204); // Ocean blue
  noStroke();
  rect(0, height / 2, width, height / 2);
}
// Barrier for the ocean and sky
void barrier() {
  stroke(128, 0, 200);
  strokeWeight(15);
  line(0, height / 2, width, height / 2);
}
  
//Our sailboat function
void drawSailboat(float boatX, float boatY) {
  //Floats for our X and Y coordinates for our sailboat and its shapes, makes it easier to plot the shapes of our object
  float X = boatX + 100 / 2;
  float Y = boatY - 50;
  //Next ten lines make the body, mast, and sail for our boat
  fill(200, 0, 0); 
  rect(boatX, boatY, 100, 30); 

  stroke(139, 69, 19); 
  strokeWeight(4);
  line(X, Y + 50, X, Y - 40); 

  fill(255); 
  noStroke();
  triangle(X, Y - 40, boatX, boatY - 40, boatX + 50, boatY - 40);
}
