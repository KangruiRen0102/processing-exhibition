/**
 * KEY WORDS: Discovery, Sea, and Journey
 * 
 * THEME SENTENCE:
 *    "Through rough seas and changing skies, a solo boat begins
 *     a long journey towards discovering the unknown."
 * 
 * VISUAL/ANIMATION CONCEPT:
 *    - The background color changes to represent day and night
 *    - Sine-wave lines simulate the motion of the sea.
 *    - A small boat travels across the horizon.
 *    
 * ANNOTATIONS:
 *    1) The sky in the background shows the length of a journey
 *    2) The waves show the natural flow of the sea
 *    3) The boat is kept simple to highlight its path over the sea and shows
 *       allusion to the excitement of new discoveries.
 *    4) The boat’s x-position changes with time, showing continuous forward
 *       motion (the journey).
 *    5) Stars appear at "night" to enhance the time change            
 */

float boatX;            // x-position of the boat
float boatY = 300;      // y-position of the boat 
float waveAmplitude = 15; 
float waveFrequency = 0.02;
int numWaves = 4;       // number of wavy lines
int starCount = 100;    // number of stars
float[] starX = new float[starCount];
float[] starY = new float[starCount];

void setup() {
  size(800, 600);
  // Initialize boat at the left
  boatX = -100;
  
  // Randomly place stars
  for(int i=0; i<starCount; i++){
    starX[i] = random(width);
    starY[i] = random(height/2); // upper half for stars
  }
}

void draw() {
  backgroundGradient();
  drawStars();
  drawWaves();
  drawBoat();
  updateBoatPosition();
}

// Background with shifting color to show time change
void backgroundGradient() {
  // frameCount to animate color over time
  // Map sine function to cycle every 1000 frames
  float cycle = sin(frameCount * 0.002);
  
  // skyColor transitions between day (blueish) and night (dark purple)
  // cycle range: -1 to +1 -> remap to day/night
  float r = map(cycle, -1, 1, 30, 150);
  float g = map(cycle, -1, 1, 30, 200);
  float b = map(cycle, -1, 1, 60, 255);
  
  // Gradient from top to bottom
  for (int y=0; y<height; y++) {
    float inter = map(y, 0, height, 0, 1);
    stroke(
      lerpColor(color(r, g, b), color(0, 20, 60), inter)
    );
    line(0, y, width, y);
  }
}

// Draw stars that only appear when sky is dark
void drawStars() {
  // Evaluate how dark the sky is (if cycle < 0, it's night)
  float cycle = sin(frameCount * 0.002);
  if (cycle < 0) {
    fill(255);
    noStroke();
    for(int i=0; i<starCount; i++){
      ellipse(starX[i], starY[i], 2, 2);
    }
  }
}

// Draw sine-waves to represent the sea
void drawWaves() {
  stroke(0, 50, 150);
  noFill();
  for (int w=0; w<numWaves; w++) {
    beginShape();
    for (int x=0; x<=width; x+=10) {
      float y = height/2 
                + w*waveAmplitude*2 
                + sin(x*waveFrequency + (frameCount*0.03) + w*PI/2)*waveAmplitude;
      vertex(x, y);
    }
    endShape();
  }
}

// Draw a boat at the current boat position
void drawBoat() {
  // Boat base
  fill(139,69,19);  // brown color
  noStroke();
  rectMode(CENTER);
  rect(boatX, boatY, 50, 15);

  // Sail
  fill(255);
  triangle(boatX, boatY - 20, boatX, boatY, boatX + 25, boatY - 10);
}

// Move boat forward, reset at boundary to create a loop
void updateBoatPosition() {
  boatX += 1.0;
  // If boat goes off the right, reset to left
  if (boatX > width + 100) {
    boatX = -100;
  }
}
