// Variables
int numFish = 50;  // Initial number of fish
float[] fishX = new float[1000];       // Array to store x-coordinates
float[] fishY = new float[1000];       // Array to store y-coordinates
float[] fishSpeedX = new float[1000]; // Array to store x-speeds
float[] fishSpeedY = new float[1000]; // Array to store y-speeds
float[] fishRadius = new float[1000];  // Array to store radii
int currentFish = 0;  // Current number of fish

// Variables for crab movement
float crabX = 0;
float crabSpeed = 2;

// Setup function
void setup() {
  size(800, 600);  // Set canvas size
  smooth();         // Enable smooth drawing
  frameRate(40);    // Increased frame rate
  noStroke();       // Disable drawing outlines
  
  // Initialize fish positions and speeds
  for (int i = 0; i < numFish; i++) {  
    fishX[i] = random(width);  
    fishY[i] = random(height - 100);  // Adjusted y-coordinate range
    fishSpeedX[i] = random(-3, 3);  
    fishSpeedY[i] = random(-3, 3);  
    fishRadius[i] = random(5, 10);
  }
  
  currentFish = numFish;  // Set current number of fish
}

// Draw crab family
void drawCrabFamily() {
  // Update crab position
  crabX += crabSpeed;
  
  // Reverse direction if crab hits edge
  if (crabX > 200 || crabX < -200) {
    crabSpeed *= -1;
  }
  
  // Draw crab
  fill(165, 42, 42);  // Brown fill color
  ellipse(width/2 + crabX, height - 30, 50, 30);  // Body
  ellipse(width/2 + crabX - 20, height - 40, 20, 20);  // Claw
  ellipse(width/2 + crabX + 20, height - 40, 20, 20);  // Claw
  line(width/2 + crabX - 25, height - 45, width/2 + crabX - 35, height - 30);  // Claw line
  line(width/2 + crabX + 25, height - 45, width/2 + crabX + 35, height - 30);  // Claw line
  triangle(width/2 + crabX - 15, height - 20, width/2 + crabX - 25, height - 10, width/2 + crabX - 5, height - 10);  // Leg
  triangle(width/2 + crabX + 15, height - 20, width/2 + crabX + 25, height - 10, width/2 + crabX + 5, height - 10);  // Leg
 
}

// Draw function
void draw() {
  background(0);  // Black background
  
  // Draw gradient blue background
  for (int y = 0; y < height - 50; y++) {  // Adjusted y-coordinate range
    int blueValue = (int)map(y, 0, height - 50, 255, 0);  // Map y-coordinate to blue value
    blueValue = constrain(blueValue, 0, 255);  // Constrain blue value
    fill(0, 0, blueValue);  // Blue fill color
    rect(0, y, width, 1);  // Draw horizontal line
  }
  
  // Draw curved wave
  noFill();  // No fill color
  stroke(0, 0, 255, 100);  // Light blue stroke color
  strokeWeight(2);  // Stroke weight
  int numWaves = 6;  // Number of waves
  for (int j = 0; j < numWaves; j++) {
    beginShape();  // Begin shape
    for (int x = 0; x < width; x++) {
      float y = (height - 150) + j * 50 + sin(x*0.01 + frameCount*0.01 + j * 0.1) * 50;  // Raised wave position
      vertex(x, y);  // Add vertex
    }
    vertex(width, height - 50);  // Add vertex
    vertex(0, height - 50);  // Add vertex
    endShape(CLOSE);  // End shape
  }
  
  // Draw beige bottom
  fill(245, 245, 220);  // Beige fill color
  rect(0, height - 50, width, 50);  // Draw rectangle
  
  // Draw crab family
  drawCrabFamily();
  
  // Update fish positions
  for (int i = 0; i < currentFish; i++) {  
    fishX[i] += fishSpeedX[i];  
    fishY[i] += fishSpeedY[i];  
    
    // Boundary check
    if (fishX[i] < 0 || fishX[i] > width) {  
      fishSpeedX[i] *= -1;  
    }
    if (fishY[i] < 0 || fishY[i] > height - 50) {  
      fishSpeedY[i] *= -1;  
    }
    
    // Draw fish
    fill(255, 255, 0);  // Yellow
    ellipse(fishX[i], fishY[i], fishRadius[i]*2, fishRadius[i]);  // Body
    triangle(fishX[i]-fishRadius[i], fishY[i], 
             fishX[i]-fishRadius[i]*1.5, fishY[i]-fishRadius[i]/2, 
             fishX[i]-fishRadius[i]*1.5, fishY[i]+fishRadius[i]/2);  // Fin
  }
}

// Mouse clicked function
void mousePressed() {
  // Add new fish
  if (currentFish < 1000) {
    fishX[currentFish] = mouseX;  
    fishY[currentFish] = mouseY;  
    if (fishY[currentFish] > height - 50) {  
      fishY[currentFish] = height - 50;
    }
    fishSpeedX[currentFish] = random(-3, 3);  
    fishSpeedY[currentFish] = random(-3, 3);  
    fishRadius[currentFish] = random(5, 10);
    currentFish++;
  }
}
