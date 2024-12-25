void setup() {
  size(800, 600);
  noLoop();
}

void draw() {
  background(135, 206, 235); // Sky blue

  drawMountains();
  drawGrass();
  drawRiver();
  drawTrees();
  drawWildfires(); // Increased wildfires
  drawStreet();
  drawAnimals(); // Animals moved to the land behind the river
  drawTourists();
}

// Function to draw the mountains
void drawMountains() {
  noStroke();
  fill(120, 120, 120); // Gray mountains
  triangle(150, 300, 400, 50, 650, 300); // Center peak
  fill(160, 160, 160); // Lighter peak
  triangle(0, 400, 200, 100, 400, 400); // Left peak
  triangle(400, 400, 600, 150, 800, 400); // Right peak

  // Snow caps
  fill(255);
  triangle(320, 150, 400, 50, 480, 150); 
  triangle(100, 150, 200, 100, 260, 150); 
  triangle(540, 150, 600, 150, 650, 200); 
}

// Function to draw grassy area
void drawGrass() {
  fill(34, 139, 34); // Green grass
  rect(0, height - 300, width, 200); // Grass area
}

// Function to draw a river
void drawRiver() {
  fill(0, 191, 255, 200); // Blue with transparency
  beginShape();
  vertex(0, height - 150);
  bezierVertex(200, height - 200, 400, height - 100, 800, height - 180);
  vertex(800, height);
  vertex(0, height);
  endShape(CLOSE);
}

// Function to draw trees
void drawTrees() {
  // More trees near the mountains
  for (int i = 0; i < 20; i++) {
    float x = random(50, 750); // More evenly spread out
    float y = random(height - 300, height - 200);
    if (y > height - 150 && y < height - 130) continue; // Avoid placing trees too close to the river
    // Add trees closer to mountains
    if (x > 100 && x < 700 && y > 150 && y < 300) { // Near the base of mountains
      drawTree(x, y);
    }
  }

  // Random trees in the grassy area
  for (int i = 0; i < 30; i++) {
    float x = random(width);
    float y = random(height - 300, height - 200);
    if (y > height - 150 && y < height - 130) continue; // Avoid placing trees too close to the river
    drawTree(x, y);
  }
}

void drawTree(float x, float y) {
  fill(139, 69, 19); // Trunk color
  rect(x - 5, y + 20, 10, 40); // Trunk
  fill(0, 100, 0); // Dark green leaves
  triangle(x - 20, y + 20, x, y - 30, x + 20, y + 20); // Triangle leaves
}

// Function to draw multiple wildfires
void drawWildfires() {
  for (int i = 0; i < 5; i++) { // More wildfires added
    // Move wildfires closer to the center near the mountains
    drawWildfire(random(200, 600), random(200, 300));
  }
}

void drawWildfire(float x, float y) {
  fill(255, 69, 0, 150); // Semi-transparent orange for fire
  ellipse(x, y, 100, 100); 
  ellipse(x + 20, y + 20, 80, 80);
  fill(255, 0, 0, 100); // Red for inner flames
  ellipse(x, y, 60, 60);
  fill(105, 105, 105, 200); // Smoke
  for (int i = 0; i < 10; i++) {
    ellipse(x - 20 + random(40), y - 50 + random(50), 30 + random(20), 30 + random(20));
  }
}

// Function to draw a busy street
void drawStreet() {
  fill(50); // Asphalt
  rect(0, height - 100, width, 100);
  stroke(255);
  strokeWeight(2);
  for (int i = 0; i < width; i += 40) {
    line(i, height - 50, i + 20, height - 50); // Dashed road line
  }
  noStroke();
}

// Function to draw animals (all on land behind the river)
void drawAnimals() {
  // Draw smaller detailed elk
  drawElk(300, height - 250);

  // Draw bear on land behind the river
  fill(80, 50, 30); // Dark brown
  ellipse(600, height - 240, 80, 60); // Body
  ellipse(620, height - 280, 40, 40); // Head
  ellipse(605, height - 300, 20, 20); // Left ear
  ellipse(635, height - 300, 20, 20); // Right ear
}

// Function to draw detailed elk (smaller)
void drawElk(float x, float y) {
  fill(139, 69, 19); // Brown for body
  rect(x, y, 30, 40); // Body (smaller)
  ellipse(x + 15, y - 20, 45, 30); // Head (smaller)

  // Antlers
  stroke(139, 69, 19);
  strokeWeight(4);
  line(x + 10, y - 30, x - 20, y - 60); // Antler left
  line(x + 30, y - 30, x + 50, y - 60); // Antler right
  line(x + 15, y - 30, x - 10, y - 80); // Antler left upper part
  line(x + 25, y - 30, x + 45, y - 80); // Antler right upper part
  noStroke();

  // Legs
  fill(139, 69, 19);
  rect(x - 10, y + 40, 8, 30); // Front left leg
  rect(x + 20, y + 40, 8, 30); // Front right leg
  rect(x - 10, y + 70, 8, 30); // Back left leg
  rect(x + 20, y + 70, 8, 30); // Back right leg

  // Ears
  fill(255);
  ellipse(x + 5, y - 30, 8, 12); // Left ear
  ellipse(x + 35, y - 30, 8, 12); // Right ear
}

// Function to draw tourists
void drawTourists() {
  for (int i = 0; i < 6; i++) {
    drawTourist(random(width), height - 120);
  }
}

void drawTourist(float x, float y) {
  fill(random(100, 255), random(100, 255), random(100, 255)); // Random colors
  ellipse(x, y - 10, 20, 20); // Head
  rect(x - 10, y, 20, 30); // Body
  fill(0);
  ellipse(x - 5, y - 12, 5, 5); // Left eye
  ellipse(x + 5, y - 12, 5, 5); // Right eye
  line(x - 5, y + 10, x - 15, y + 20); // Left arm
  line(x + 5, y + 10, x + 15, y + 20); // Right arm
}
