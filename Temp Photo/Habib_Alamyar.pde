PVector[] stars; // Precomputed star positions
float auroraOffset = 0; // Offset for aurora animation

void setup() {
  size(800, 800); // Canvas size
  stars = new PVector[100];
  
  // Precompute star positions
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new PVector(random(width), random(height / 2));
  }
}

void draw() {
  background(10, 15, 30); // Twilight background

  // Draw Aurora
  for (int i = 0; i < 15; i++) { // Increased thickness
    noFill();
    strokeWeight(10);
    // Three-color gradient: green to blue to purple
    color col1 = lerpColor(color(0, 255, 0, 150), color(0, 128, 255, 150), i / 15.0); // Green to blue
    color col2 = lerpColor(color(0, 128, 255, 150), color(128, 0, 255, 150), i / 15.0); // Blue to purple
    stroke(lerpColor(col1, col2, i / 15.0)); // Combine gradients
    beginShape();
    for (float x = 0; x < width; x += 10) {
      float y = 200 + 150 * noise(i * 10, x * 0.01 + auroraOffset); // Shifted downward
      vertex(x, y);
    }
    endShape();
  }
  // Animate aurora
  auroraOffset += 0.005;

  // Draw Moon
  fill(200);
  noStroke();
  ellipse(650, 150, 80, 80); // Moon
  fill(10, 15, 30);
  ellipse(660, 140, 60, 60); // Crater effect

  // Draw Stars
  for (PVector star : stars) {
    float starSize = random(2, 5); // Static size
    fill(255, 255, 200, random(150, 255));
    noStroke();
    ellipse(star.x, star.y, starSize, starSize);
  }

  // Draw Skyline Silhouette
  drawSkyline();

  // Draw Ground Elements
  drawGround();
}

void drawGround() {
  // Draw Grass
  fill(50, 200, 50);
  rect(0, height - 150, width, 150); // Extended to connect to the bottom of the image

  // Add static snow patches
  addSnowPatches();

  // Draw Street
  fill(60);
  rect(0, height - 180, width, 30);

  // Draw Street Lines
  stroke(255, 255, 0);
  strokeWeight(2);
  for (int i = 0; i < width; i += 40) {
    line(i, height - 165, i + 20, height - 165);
  }

  // Draw Sidewalk
  fill(200);
  rect(0, height - 200, width, 20);

  // Move Faculty of Engineering Arch (spread apart)
  float archX = width / 3 - 60; // Move closer to the first section
  float archY = height - 300; // Keep the y position

  fill(20);
  rect(archX, archY, 20, 100); // Left pillar
  rect(archX + 100, archY, 20, 100); // Right pillar
  rect(archX, archY - 20, 120, 20); // Top beam

  // Text position inside the top beam of the arch
  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER); // Center text both horizontally and vertically
  text("Faculty of Engineering", archX + 60, archY - 10); // Positioned inside the top beam

  // Add Yellow I-Beam Tree 
  fill(255, 200, 0);
  rect(550, height - 300, 20, 100); // Trunk
  rect(520, height - 250, 80, 20); // Top horizontal beam
  rect(535, height - 270, 50, 20); // Middle horizontal beam
  rect(545, height - 290, 30, 20); // Small top beam
}

// Function to add snow patches on the ground
void addSnowPatches() {
  fill(255); // White color for snow
  noStroke();
  
  // Create snow patches
  ellipse(150, height - 50, 70, 50); // Snow patch 1 
  ellipse(300, height - 100, 85, 85); // Snow patch 2 
  ellipse(500, height - 80, 100, 75); // Snow patch 3 
  ellipse(650, height - 60, 95, 95); // Snow patch 4 
  ellipse(700, height - 20, 110, 85); // Snow patch 5 
  ellipse(100, height - 60, 80, 80); // Snow patch 6 
  ellipse(400, height - 100, 95, 50); // Snow patch 7 
  ellipse(550, height - 125, 80, 100); // Snow patch 8 
}

void drawSkyline() {
  fill(30, 30, 60);
  noStroke();
  int numBuildings = 3; // Number of buildings 
  float buildingWidth = width / numBuildings;
  
  // Center building
  float buildingHeightCenter = 300; 
  float buildingWidthCenter = buildingWidth * 1.5; 
  rect(buildingWidth - buildingWidth / 4, height - 150 - buildingHeightCenter, buildingWidthCenter, buildingHeightCenter);

  // Left building
  float buildingHeightLeft = 200; 
  float buildingWidthLeft = buildingWidth * 0.6; 
  rect(0, height - 150 - buildingHeightLeft, buildingWidthLeft, buildingHeightLeft);

  // Right building 
  float buildingHeightRight1 = 250; // Height 
  float buildingWidthRight1 = buildingWidth * 0.8; // Width 
  float rightBuildingX1 = buildingWidth + buildingWidthCenter; // Position
  rect(rightBuildingX1, height - 150 - buildingHeightRight1, buildingWidthRight1, buildingHeightRight1);

  // For Names of Buildings
  fill(255, 255, 0); // Yellow color for text
  textSize(20);
  textAlign(CENTER, CENTER); // Center the text horizontally, align vertically to the center

  // Left building label: "NREF"
  text("NREF", buildingWidthLeft / 2, height - 150 - buildingHeightLeft + 20); // On the left building, near the top

  // Center building label: "DICE"
  text("DICE", buildingWidth + buildingWidthCenter / 2, height - 150 - buildingHeightCenter + 20); // On the center building, near the top

  // Right building label: "ETLC"
  text("ETLC", rightBuildingX1 + buildingWidthRight1 / 2, height - 150 - buildingHeightRight1 + 20); // On the right building, near the top
}
