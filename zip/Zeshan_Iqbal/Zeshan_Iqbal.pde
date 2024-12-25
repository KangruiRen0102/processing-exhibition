float auroraAlpha = 0;  // Alpha transparency for aurora, determines its visibility
float chaosFactor = 1.0;  // Factor that controls the intensity of chaos effect
float auroraSpeed = 0.05; // Speed of aurora flickering effect
float auroraSize = 200; // Base size of the aurora
float[] auroraColors = new float[3];  // RGB color values for aurora colors
float lastChangeTime = 0;  // Tracks the last time chaos intensity changed
int auroraEffectType = 0; // Type of aurora effect (0: standard, 1: pulse)
int chaosEffectType = 0; // Type of chaos effect (0: standard, 1: wave)

int instructionDuration = 5000; // Duration to show instructions (5 seconds)
int instructionStartTime = -1; // Time when instructions started to display

void setup() {
  size(800, 600);  // Set canvas size
  noStroke();  // Disable stroke for shapes
  smooth();  // Enable anti-aliasing for smoother shapes
}

void draw() {
  // Twilight sky gradient representing a calm yet intense atmosphere
  background(40, 60, 100);  // Set the background color to represent twilight (blue to dark gradient)

  // Generate the aurora effect with chaotic fluctuations
  generateAuroraEffect();  // Call to generate aurora based on current effect type

  // Display chaos effect (lines or waves)
  displayChaosEffect();  // Display either random lines or swirling waves to represent chaos
  
  // Draw aurora trails that flicker and move across the screen
  displayAuroraTrails();  // Render aurora trails to create a flowing, ethereal effect

  // Adjust chaos intensity over time or based on mouse position
  updateChaos();  // Update the chaos effect based on the time and mouse input

  // Display instructions for a few seconds
  if (instructionStartTime != -1 && millis() - instructionStartTime < instructionDuration) {
    displayInstructions();  // Show on-screen instructions for user interaction
  }
}

// Function to generate the aurora effect with colors changing over time
void generateAuroraEffect() {
  // Map sine wave functions to create dynamic aurora color shifts
  auroraColors[0] = map(sin(frameCount * 0.01), -1, 1, 100, 255);  // Red color
  auroraColors[1] = map(sin(frameCount * 0.02), -1, 1, 100, 255);  // Green color
  auroraColors[2] = map(sin(frameCount * 0.03), -1, 1, 100, 255);  // Blue color

  fill(auroraColors[0], auroraColors[1], auroraColors[2], auroraAlpha);  // Set aurora color with alpha for transparency
  noStroke();  // Remove outlines for smooth filling

  // Different aurora effects (standard or pulsing)
  if (auroraEffectType == 0) {
    // Standard aurora shape: static ellipse with predefined size
    ellipse(width / 2, height / 3, auroraSize, auroraSize / 2); 
  } else if (auroraEffectType == 1) {
    // Pulsing aurora: changes in size based on sine wave, creating a pulsing effect
    float pulseSize = sin(frameCount * auroraSpeed) * 50 + auroraSize; // Pulse size with sine wave variation
    ellipse(width / 2, height / 3, pulseSize, pulseSize / 2);  // Draw pulsing aurora
  }

  // Flickering aurora transparency (using sine wave for fluctuation)
  auroraAlpha = map(sin(frameCount * 0.1), -1, 1, 50, 200);  // Adjust transparency to create flicker effect
}

// Function to display chaotic effects (random lines or wave-like patterns)
void displayChaosEffect() {
  float chaosTime = millis();  // Get the current time for creating time-based chaos

  if (chaosEffectType == 0) {
    // Standard chaotic effect (random lines with some rotation)
    for (int i = 0; i < 10; i++) {
      float chaosX = random(width);  // Random X position
      float chaosY = random(height); // Random Y position
      float chaosSize = random(20, 50); // Random size for chaos elements
      float chaosRotation = sin(chaosTime * 0.002) * random(PI);  // Random rotation for each line
      stroke(255, 255, 255, 150);  // Set white color with transparency for chaotic effect
      strokeWeight(2);  // Set stroke weight for chaotic lines
      // Draw chaotic lines using rotated positions
      line(chaosX + chaosSize * cos(chaosRotation), chaosY + chaosSize * sin(chaosRotation),
           chaosX + chaosSize * cos(chaosRotation + PI), chaosY + chaosSize * sin(chaosRotation + PI));
    }
  } else if (chaosEffectType == 1) {
    // Wave-like chaotic effect (swirling movement)
    for (int i = 0; i < 10; i++) {
      float chaosX = width * 0.5 + sin(chaosTime * 0.01 + i) * chaosFactor;  // X position with wave motion
      float chaosY = height * 0.5 + cos(chaosTime * 0.01 + i) * chaosFactor;  // Y position with wave motion
      float chaosSize = random(20, 40); // Random size for each chaos element
      ellipse(chaosX, chaosY, chaosSize, chaosSize);  // Draw swirling ellipses to represent chaotic movement
    }
  }
}

// Function to display aurora trails that shift and fade over time
void displayAuroraTrails() {
  float trailLength = 30;  // Number of aurora trails to display
  for (int i = 0; i < trailLength; i++) {
    float trailX = width * 0.5 + random(-200, 200);  // Random X position for each trail
    float trailY = height / 3 + random(-50, 50);  // Random Y position for each trail
    float trailAlpha = map(i, 0, trailLength, 50, 255);  // Gradually fade trails based on position in array
    fill(auroraColors[0], auroraColors[1], auroraColors[2], trailAlpha);  // Set color and transparency for trail
    ellipse(trailX, trailY, random(20, 50), random(10, 40));  // Draw the aurora trail with varying size
  }
}

// Function to update the chaos effect intensity
void updateChaos() {
  float currentTime = millis();  // Get the current time
  // Randomly change chaos intensity every 1 to 5 seconds
  if (currentTime - lastChangeTime > random(1000, 5000)) {
    chaosFactor = random(1, 5);  // Randomize the chaos intensity
    lastChangeTime = currentTime;  // Update the last change time
  }

  // Optionally, adjust chaos factor based on mouse position
  chaosFactor = map(mouseX, 0, width, 1, 5);  // The further the mouse goes, the more intense the chaos
}

// Function to display instructions on screen for a few seconds
void displayInstructions() {
  fill(255, 255, 255, 200); // White text with some transparency
  textSize(18);  // Set text size
  textAlign(CENTER, CENTER);  // Center-align the text
  // Display the instructions on how to interact with the effects
  text("Press 'R' to toggle aurora effects", width / 2, height / 2 - 50);
  text("Press 'C' to toggle chaos effects", width / 2, height / 2);
  text("Press '1', '2', or '3' to change aurora color", width / 2, height / 2 + 50);
  text("Click to reset chaos intensity", width / 2, height / 2 + 100);
}

// Function to handle key press events for changing aurora and chaos effects
void keyPressed() {
  // Toggle between aurora effects (standard vs pulsing)
  if (key == 'r' || key == 'R') {
    auroraEffectType = (auroraEffectType + 1) % 2;  // Cycle through aurora effects (0: standard, 1: pulse)
  } else if (key == 'c' || key == 'C') {
    chaosEffectType = (chaosEffectType + 1) % 2;  // Cycle through chaos effects (0: lines, 1: waves)
  } else if (key == '1') {
    // Set aurora to red
    auroraColors[0] = 255;  
    auroraColors[1] = 0;
    auroraColors[2] = 0;
  } else if (key == '2') {
    // Set aurora to green
    auroraColors[0] = 0;  
    auroraColors[1] = 255;
    auroraColors[2] = 0;
  } else if (key == '3') {
    // Set aurora to blue
    auroraColors[0] = 0;  
    auroraColors[1] = 0;
    auroraColors[2] = 255;
  }
}

// Function to handle mouse press events for resetting chaos intensity and aurora speed
void mousePressed() {
  // Randomize aurora speed and chaos intensity on mouse click
  auroraSpeed = random(0.02, 0.1);  // Speed up or slow down the aurora flicker
  chaosFactor = random(1, 10);  // Reset the chaos factor with a random value

  // If instructions are showing, hide them by setting the start time to -1
  if (instructionStartTime == -1) {
    instructionStartTime = millis();  // Start displaying instructions
  }
}
