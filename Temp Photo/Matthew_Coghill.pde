// Global variables
boolean cocoonStage = true; // Track the stage: cocoon or butterfly
boolean changeBackground = false; // Flag to change the background gradient
PVector butterflyPos; // Position of the butterfly
PVector[] rightTreeLeaves; // Array to hold positions of leaves for the right tree
PVector[] rightLowerBranchLeaves; // Array to hold positions of leaves for the lower branch

void setup() {
  size(800, 600); // Set the canvas size
  butterflyPos = new PVector(width / 2, height / 2); // Initialize butterfly's position to the center

  // Initialize leaf positions for both trees
  rightTreeLeaves = new PVector[50]; // Array to store positions of leaves for the upper branches
  rightLowerBranchLeaves = new PVector[20]; // Array to store positions for the lower branch leaves

  // Populate positions for the upper tree leaves with random x, y coordinates
  for (int i = 0; i < 50; i++) {
    rightTreeLeaves[i] = new PVector(random(450, 650), random(100, 250));
  }

  // Populate positions for the lower branch leaves with random x, y coordinates
  for (int i = 0; i < 20; i++) {
    rightLowerBranchLeaves[i] = new PVector(random(500, 650), random(300, 400));
  }
}

void draw() {
  // Draw the forest background
  drawForest();

  // Depending on the stage, draw cocoon or butterfly
  if (cocoonStage) {
    drawCocoon();
  } else {
    drawButterfly();
    followMouse();
  }
}

// Draw the forest background including gradient sky and lush trees
void drawForest() {
  // Check if the background should change
  if (changeBackground) {
    // Changing to a sunset gradient
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(255, 140 + inter * 60, 50 + inter * 150); // Sunset orange to light purple
      line(0, i, width, i);
    }
  } else {
    // Original gradient sky
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(50, 100 + inter * 100, 50 + inter * 200); // Green to light sky blue gradient
      line(0, i, width, i);
    }
  }

  // Draw tree trunks
  stroke(60, 40, 20);
  strokeWeight(10);
  line(600, height, 600, 250); // Right tree trunk

  // Draw branches
  strokeWeight(8);
  line(600, 250, 500, 150); // Right upper branch
  line(600, 400, 700, 350); // Right lower branch

  // Draw dense leaves for the upper branches
  fill(34, 139, 34); // Green color for leaves
  noStroke();
  for (int i = 0; i < 50; i++) {
    ellipse(rightTreeLeaves[i].x, rightTreeLeaves[i].y, 30, 20); // Draw leaves for the upper branch
  }

  // Draw leaves for the lower branch
  for (int i = 0; i < 20; i++) {
    ellipse(rightLowerBranchLeaves[i].x, rightLowerBranchLeaves[i].y, 40, 20); // Draw leaves for the lower branch
  }
}

// Draw cocoon hanging from the branch
void drawCocoon() {
  // Draw the string that holds the cocoon
  stroke(100);
  strokeWeight(2);
  line(500, 150, 500, 200); // Vertical line representing the string

  // Draw the cocoon
  fill(150, 100, 50); // Brownish color for the cocoon
  noStroke();
  ellipse(500, 200, 40, 80); // Ellipse shape representing the cocoon
}

// Draw butterfly with a body, head, and antennae
void drawButterfly() {
  noStroke();
  
  // Draw butterfly body
  fill(50, 30, 20); // Dark body color
  rect(butterflyPos.x - 5, butterflyPos.y - 30, 10, 60, 5); // Butterfly body (x, y, width, height, roundness)

  // Draw butterfly head
  fill(50, 30, 20); // Same color as body
  ellipse(butterflyPos.x, butterflyPos.y - 40, 20, 20); // Circular head

  // Draw butterfly antennas
  stroke(50, 30, 20); // Same color as body
  strokeWeight(2);
  line(butterflyPos.x - 5, butterflyPos.y - 50, butterflyPos.x - 15, butterflyPos.y - 70); // Left antenna
  line(butterflyPos.x + 5, butterflyPos.y - 50, butterflyPos.x + 15, butterflyPos.y - 70); // Right antenna
  
  // Draw animated wings
  float wingFlap = sin(frameCount * 0.1) * 10; // Flapping motion based on frame count
  
  // Draw left wings
  fill(200, 100, 255); // Purple color for wings
  ellipse(butterflyPos.x - 40, butterflyPos.y + wingFlap, 80, 100); // Left top wing
  ellipse(butterflyPos.x - 30, butterflyPos.y + 50 + wingFlap, 60, 80); // Left bottom wing

  // Draw right wings
  fill(200, 100, 255); // Purple color for wings
  ellipse(butterflyPos.x + 40, butterflyPos.y - wingFlap, 80, 100); // Right top wing
  ellipse(butterflyPos.x + 30, butterflyPos.y + 50 - wingFlap, 60, 80); // Right bottom wing
}

// Make the butterfly follow the mouse smoothly
void followMouse() {
  // Lerp to smoothly move butterfly position toward mouse
  float lerpSpeed = 0.05; // Speed of movement
  butterflyPos.x = lerp(butterflyPos.x, mouseX, lerpSpeed);
  butterflyPos.y = lerp(butterflyPos.y, mouseY, lerpSpeed);
}

// Mouse click to trigger metamorphosis and change the background
void mousePressed() {
  if (cocoonStage) {
    cocoonStage = false; // Transition from cocoon to butterfly
    changeBackground = !changeBackground; // Toggle background color change
  }
}
