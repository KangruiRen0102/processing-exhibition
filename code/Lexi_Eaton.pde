int numCircles = 500;  // Number of chaotic circles
int glowLayers = 50;   // Layers for the glowing effect
int numParticles = 100; // Number of particles for hope
int maxDepth = 10;     // Maximum recursion depth for plant growth
float treeGrowth = 0;  // Progress of the tree growth
boolean isGrowing = true; // Control for tree growth

void setup() {
  size(800, 800);  // Set canvas size
  background(0);   // Black background
  frameRate(30);   // Set frame rate for interactivity
}

void draw() {
  background(0);    // Clear the screen each frame
  drawChaos();      // Background: Chaos
  drawHope();       // Middle layer: Hope
  drawGrowth(width / 2, height - 100, -90, 150, 10, (int)treeGrowth); // Foreground: Growth

  if (isGrowing) {
    treeGrowth += 0.1; // Gradually grow the tree
    if (treeGrowth > maxDepth) {
      treeGrowth = maxDepth;
      isGrowing = false; // Stop growth when fully grown
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    treeGrowth = 0; // Reset tree growth
    isGrowing = true;
  }
}

void drawChaos() {
  noStroke();
  for (int i = 0; i < numCircles; i++) {
    float x = random(width);
    float y = random(height);
    float size = random(20, 80);
    fill(random(255), random(255), random(255), 80);  // Semi-transparent colors
    ellipse(x, y, size, size);
  }
}

void drawHope() {
  noStroke();
  float centerX = width / 2;
  float centerY = height / 2;

  // Glowing central light
  for (int i = 0; i < glowLayers; i++) {
    float size = 20 + i * 20;
    int alpha = 255 - (i * 5);
    fill(255, 200, 50, alpha);  // Gradient from yellow to dim orange
    ellipse(centerX, centerY, size, size);
  }

  // Glowing particles
  for (int i = 0; i < numParticles; i++) {
    float x = random(width);
    float y = random(height);
    float size = random(10, 30);
    fill(255, 230, 80, random(80, 180));  // Light yellow particles
    ellipse(x, y, size, size);
  }
}

void drawGrowth(float x, float y, float angle, float length, float thickness, int depth) {
  if (depth == 0) return;  // Base case: stop recursion

  // Calculate end point of branch
  float xEnd = x + cos(radians(angle)) * length;
  float yEnd = y + sin(radians(angle)) * length;

  // Draw branch
  strokeWeight(thickness);
  stroke(34, 139, 34, 200);  // Green branches
  line(x, y, xEnd, yEnd);

  // Recursively draw smaller branches
  drawGrowth(xEnd, yEnd, angle - 30, length * 0.7, thickness * 0.7, depth - 1);
  drawGrowth(xEnd, yEnd, angle + 30, length * 0.7, thickness * 0.7, depth - 1);

  // Add leaves
  if (depth == 1) {
    for (int i = 0; i < 10; i++) {
      float leafX = xEnd + random(-10, 10);
      float leafY = yEnd + random(-10, 10);
      float size = random(5, 15);
      fill(50, random(150, 200), 50, 150);  // Shades of green
      noStroke();
      ellipse(leafX, leafY, size, size);
    }
  }
}
