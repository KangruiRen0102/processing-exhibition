// Definitions for waves
float[] xPos; // Array of x-positions for the ellipses (waves)
int numOfEllipses = 20;  // # ellipses
float Speed = 0.005; // Speed of waves movement
float Amplitude = 50; // Amplitude of the waves
float Frequency = 0.1; // Frequency of the waves

//Definitions for stars
float[] starX, starY, starSize; // Arrays for star positions and sizes 
int maxStars = 50; // This is the max # of stars I want on the screen 
int frameInterval = 40; // Interval between each new star 
int starIndex = 0; // Index to keep track of which star to delete first when we have reached the star maximum

//Definition for moon & creater
float angle = 0; // Initial angle for rotation
float[] craterX, craterY, craterSize; // Arrays for crater (for moon) positions and sizes 
int numCraters = 10; // Number of craters (holes) on the moon to make the motion visible

//Definition for the boat
float boatX = 500;
float boatY = 4*height; // position above waves
float targetX = boatX; // Target position for the boat
float boatSpeed = 2; // Speed of the boat

void setup() {
  size(1000, 500);
  noStroke();
  
  //In this section I am defining the x-positions of the ellipses (for the waves)
  xPos = new float[numOfEllipses]; // xPos is now an array filled with the # of ellipses
  for (int i = 0; i < numOfEllipses; i++) { //after each loop we increase the i value by 1 (through i++)
    xPos[i] = map(i, 0, numOfEllipses - 1, 0, width);  // This helps me place the ellipses across the 1000x500 screen
  }
  
   // start arrays for stars
  starX = new float[maxStars];
  starY = new float[maxStars];
  starSize = new float[maxStars];
  
  // start arrays for creater (for moon)
  craterX = new float[numCraters];
  craterY = new float[numCraters];
  craterSize = new float[numCraters];
  
  for (int i = 0; i < numCraters; i++) { //here I created a for loop to fill the creater values randomly on the arrays we have set
    craterX[i] = random(-50, 50); // Random horizontal offset from the moon's center
    craterY[i] = random(-50, 50); // Random vertical offset from the moon's center
    craterSize[i] = random(10, 30); // Random size
  }
}

void draw() {
  background(3, 22, 92);
  
  //This section makes and adjustes the waves 
  // location offset to move the wave 
  float lowerOffset = height * 0.8; 
  // Distance between the two ellipses
  float distance = 60; 
  
  for (int i = 0; i < numOfEllipses; i++) { //here I created a for loop to keep the ellipses moving both upwards and forwards
    // Calculate the y position for each ellipse based on a sine wave
    float y = Amplitude * sin(Frequency * xPos[i] + frameCount * Speed);
    
    // Calculate size based on the sine function 
    float size = 30 + 10 * sin(Frequency * xPos[i] + frameCount * Speed);
    
    // Draw the first ellipse (the higher one)
    fill(0, 100, 255);
    ellipse(xPos[i], lowerOffset + y, size, size);  // First ellipse at the defined lowerOffset
    
    // Draw the second ellipse (the lower one)
    ellipse(xPos[i], lowerOffset + y + distance, size, size); 
    
    // changes the x-position of the ellipses to move them horizontally
    xPos[i] += 0.5; // Move the ellipses forward
    
    // Reset the position at the left side when an ellipse goes off the screen to make it more realistic
    if (xPos[i] > width) { 
      xPos[i] = -size;  // Reset to the left side when it goes off the 1000x500 screen
    }
  
  }
  
  
  //This section makes and adjustes the stars 
  // Makes all the stars
  for (int i = 0; i < maxStars; i++) { //We created this for loop to keep going and making stars
    fill(255); // White color stars (pretty basic I know)
    ellipse(starX[i], starY[i], starSize[i], starSize[i]);
  }
  if (frameCount % frameInterval == 1) {
    // create the star properties in the arrays we have set
    starX[starIndex] = random(width); // Random X position
    starY[starIndex] = random(0, 350); // Random Y position above a speciifc horizontal line
    starSize[starIndex] = random(3, 7); // Random size for the star
    // the index keeps incrteases until we reach the max and then return back and stars over
    starIndex = (starIndex + 1) % maxStars;
  }
  
  
  //This section makes and adjustes the moon and craters
  pushMatrix(); // This allows us to make sure the motion only affects the moon and creaters 
  translate(500, 100); // here we set the origin to the moon's center for the motion
  rotate(angle); // Rotate the moon by the defined angle
  fill(255); 
  ellipse(0, 0, 150, 150); // Draw moon at (500,100) after translation
  
  for (int i = 0; i < numCraters; i++) { // This loop draws the craters on the moon from the arrays we have created
    fill(100, 100, 100); // Dark gray color for craters
    ellipse(craterX[i], craterY[i], craterSize[i], craterSize[i]); // Draws each crater
  }
  popMatrix(); // This allows us to make sure the motion only affects the moon and creaters 
  angle += 0.02;  //This allows us to chnage the angle and keep the motion going
  
  // Boat functionality
  updateBoat();
  drawBoat();
}

void mousePressed() {
  targetX = mouseX; // Update boat's target X position on mouse click
}

void drawBoat() {
  fill(150, 75, 0); // Boat base color
  rect(boatX - 20, boatY - 10, 40, 20); // defines the boat's base
  fill(255); // white for the flag
  triangle(boatX, boatY - 10, boatX - 10, boatY - 30, boatX + 10, boatY - 30); // triangle to represent the boat's flag
}

void updateBoat() {
  if (abs(boatX - targetX) > 1) { // allows the boat to move toward the target position the user presses
    boatX += boatSpeed * (targetX > boatX ? 1 : -1);
  }
}
