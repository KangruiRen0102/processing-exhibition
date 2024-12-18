// Import necessary libraries
import processing.core.*;

color dawnColor, morningColor, dayColor, eveningColor, nightColor, brownColor, greenColor, yellowColor;
float growthFactor = 0; // Controls the growth stage of the tree
float growthRate = 0.002; // Rate at which the tree grows
boolean isGrowing = false; // Flag to indicate if the tree is currently growing
float stemHeight = 100; // Initial height of the tree stem
float maxHeight = 200; // Maximum height the tree stem can reach (twice the original height)
PVector[] leaves; // Array to store leaf positions and fall state
color[] leafColors; // Array to store leaf colors
PVector[] stars; // Array to store star positions

void setup() {
  // Set up canvas size and initialize colors
  size(800, 600);
  dawnColor = color(0); // Black (Night)
  morningColor = color(255, 255, 0); // Yellow (Morning)
  dayColor = color(0, 255, 255); // Cyan (Day)
  eveningColor = color(75, 0, 130); // Purple (Evening)
  nightColor = color(0, 0, 139); // Dark Blue (Night)
  greenColor = color(34, 139, 34); // Green for growth
  brownColor = color(139, 69, 19); // Brown for maturity
  yellowColor = color(255, 215, 0); // Yellow for leaves

  // Set background to dawn color at the start
  background(dawnColor);
  
  // Initialize arrays for leaves and stars
  leaves = new PVector[6]; // Initialize leaf positions
  leafColors = new color[6]; // Initialize leaf colors
  stars = new PVector[100]; // Initialize star positions

  // Set initial positions for leaves and stars
  for (int i = 0; i < 6; i++) {
    leaves[i] = new PVector(width / 2, height / 2); // Initialize at tree center
    leafColors[i] = greenColor; // Initial leaf color
  }
  for (int i = 0; i < 100; i++) {
    stars[i] = new PVector(random(width), random(height / 2)); // Random star positions
  }
}

void draw() {
  // Update background color based on growth stage (time of day)
  if (growthFactor < 1) {
    if (growthFactor < 0.25) {
      background(lerpColor(dawnColor, morningColor, growthFactor * 4)); // Dawn to morning
    } else if (growthFactor < 0.5) {
      background(lerpColor(morningColor, dayColor, (growthFactor - 0.25) * 4)); // Morning to day
    } else if (growthFactor < 0.75) {
      background(lerpColor(dayColor, eveningColor, (growthFactor - 0.5) * 4)); // Day to evening
    } else {
      background(lerpColor(eveningColor, nightColor, (growthFactor - 0.75) * 4)); // Evening to night
    }
  } else {
    background(nightColor); // Complete night
  }

  // Draw stars with fade effect
  for (int i = 0; i < stars.length; i++) {
    float alpha;
    if (growthFactor < 0.25 || growthFactor >= 0.75) {
      alpha = 1; // Fully visible during night
    } else if (growthFactor < 0.5) {
      alpha = 1 - (growthFactor - 0.25) * 4; // Fade out during morning
    } else {
      alpha = (growthFactor - 0.5) * 4; // Fade in during evening
    }
    fill(255, 255, 255, alpha * 255); // White color with varying transparency
    noStroke();
    ellipse(stars[i].x, stars[i].y, 2, 2); // Draw star
  }

  // Increase growth factor if the tree is growing
  if (isGrowing) {
    if (growthFactor < 1) {
      growthFactor += growthRate;
    }
  }

  // Calculate tree height based on growth factor
  float currentHeight = map(growthFactor, 0, 0.5, stemHeight, maxHeight);
  if (growthFactor > 0.5) {
    currentHeight = maxHeight;
  }

  // Calculate tree color based on growth factor
  color treeColor;
  if (growthFactor < 0.25) {
    treeColor = greenColor;
  } else {
    treeColor = lerpColor(greenColor, brownColor, (growthFactor - 0.25) * 4);
  }

  // Draw the sun and its movement across the sky
  float sunX = width * growthFactor;
  float sunY = height * 0.75 - (height * 0.75) * sin(PI * growthFactor);
  fill(255, 204, 0); // Yellow color for the sun
  noStroke();
  ellipse(sunX, sunY, 50, 50); // Sun size

  // Draw the ground
  fill(139, 69, 19);
  rect(0, height / 2, width, height / 2);

  // Draw the tree stem
  fill(treeColor);
  rect(width / 2 - 10, height / 2 - currentHeight, 20, currentHeight);

  // Draw branches
  stroke(treeColor);
  strokeWeight(4);
  for (int i = 0; i < 3; i++) {
    float branchY = height / 2 - (currentHeight / 3) * (i + 1);
    line(width / 2 - 10, branchY, width / 2 - 50, branchY - 20); // Left branch
    line(width / 2 + 10, branchY, width / 2 + 50, branchY - 20); // Right branch
  }
  noStroke();

  // Update and draw leaves
  for (int i = 0; i < leaves.length; i++) {
    // Start leaves at the end of branches
    if (growthFactor < 0.75) {
      leaves[i] = new PVector(width / 2 + (i % 2 == 0 ? -60 : 60), height / 2 - (currentHeight / 3) * ((i % 3) + 1) - 20);
      leafColors[i] = greenColor;
    } else if (growthFactor >= 0.75 && growthFactor < 0.85) {
      leafColors[i] = lerpColor(greenColor, yellowColor, (growthFactor - 0.75) * 10); // Gradual transition to yellow
    } else if (growthFactor >= 0.85) {
      leafColors[i] = yellowColor;
      leaves[i].y += random(1, 3); // Make leaves fall after turning yellow
      leafColors[i] = lerpColor(yellowColor, brownColor, map(leaves[i].y, height / 2 - 100, height, 0, 1)); // Change color to brown
    }
    fill(leafColors[i]);
    ellipse(leaves[i].x, leaves[i].y, 20, 10); // Position leaves
  }
}

void mousePressed() {
  isGrowing = true; // Start growing the tree
}

void mouseReleased() {
  isGrowing = false; // Stop growing the tree
}
