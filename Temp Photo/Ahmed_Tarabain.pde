void setup() {
  size(800, 600); // Canvas size
  noLoop();
}

void draw() {
  drawNightSky(); // Nighttime sky with stars, moon, and auroras
  
  drawGround(); // Dark ground
  
  drawBuildings(); // Vibrant Edmonton skyline with glowing windows
  
  drawTrees(); // Green trees (triangles)
  
  drawCars(); // Add a few cars with headlights
}

// Function to draw the night sky with stars, moon, and auroras
void drawNightSky() {
  background(10, 10, 35); // Dark blue night sky

  // Draw stars
  for (int i = 0; i < 150; i++) {
    float x = random(width);
    float y = random(height / 2);
    fill(255, random(150, 255)); // White/yellowish stars with random brightness
    noStroke();
    ellipse(x, y, random(2, 5), random(2, 5));
  }

  // Draw the moon
  fill(240, 240, 200);
  noStroke();
  ellipse(650, 100, 80, 80); // Moon at the top-right

  // Draw auroras
  drawAurora(120, 180, 150); // Greenish aurora
  drawAurora(255, 105, 150); // Pink aurora
}

// Function to draw an aurora borealis with given hues
void drawAurora(float hueLow, float hueHigh, float alpha) {
  noFill();
  for (int i = 0; i < 5; i++) {
    float hue = random(hueLow, hueHigh); // Randomized hues
    strokeWeight(8);
    stroke(color(0, hue, random(200, 255), alpha)); // Semi-transparent colors
    
    // Create wavy bands
    beginShape();
    for (int x = 0; x <= width; x += 20) {
      float y = map(noise(x * 0.01 + i, i), 0, 1, 50, 150) + i * 20;
      curveVertex(x, y);
    }
    endShape();
  }
}

// Function to draw the dark ground
void drawGround() {
  noStroke();
  fill(20, 50, 20); // Dark green ground
  rect(0, height - 50, width, 50);
}

// Function to draw vibrant buildings with glowing windows
void drawBuildings() {
  color[] buildingColors = {
    color(255, 69, 0),    // Red-orange
    color(34, 139, 34),   // Forest green
    color(30, 144, 255),  // Dodger blue
    color(255, 215, 0),   // Gold
    color(138, 43, 226),  // Blue violet
    color(255, 105, 180), // Hot pink
    color(0, 255, 255),   // Cyan
    color(255, 140, 0)    // Dark orange
  };

  int[] buildingHeights = {200, 300, 250, 220, 400, 180, 320, 270}; // Heights of buildings
  for (int i = 0; i < buildingHeights.length; i++) {
    int buildingWidth = 60;
    int x = 80 + i * (buildingWidth + 20);
    int y = height - 50 - buildingHeights[i];
    fill(buildingColors[i % buildingColors.length]); // Vibrant building colors
    rect(x, y, buildingWidth, buildingHeights[i]);

    // Add glowing windows
    drawWindows(x, y, buildingWidth, buildingHeights[i]);
  }
}

// Function to draw glowing windows for a building
void drawWindows(int x, int y, int buildingWidth, int buildingHeight) {
  fill(255, 255, 0); // Bright yellow windows
  for (int wy = y + 20; wy < y + buildingHeight; wy += 30) {
    for (int wx = x + 10; wx < x + buildingWidth - 10; wx += 20) {
      rect(wx, wy, 10, 10); // Small windows
    }
  }
}

// Function to draw green trees
void drawTrees() {
  fill(34, 139, 34); // Forest green for trees
  triangle(500, height - 50, 550, height - 200, 600, height - 50); // Left tree
  triangle(620, height - 50, 670, height - 180, 720, height - 50); // Right tree
}

// Function to draw cars with headlights
void drawCars() {
  fill(255, 0, 0); // Red car
  rect(150, height - 70, 40, 20);
  fill(0);
  ellipse(160, height - 50, 10, 10); // Left wheel
  ellipse(180, height - 50, 10, 10); // Right wheel

  // Headlights
  fill(255, 255, 100, 200); // Yellowish light
  ellipse(190, height - 65, 15, 5);
  
  fill(0, 0, 255); // Blue car
  rect(300, height - 70, 40, 20);
  fill(0);
  ellipse(310, height - 50, 10, 10); // Left wheel
  ellipse(330, height - 50, 10, 10); // Right wheel

  // Headlights
  fill(255, 255, 100, 200); // Yellowish light
  ellipse(340, height - 65, 15, 5);
}
