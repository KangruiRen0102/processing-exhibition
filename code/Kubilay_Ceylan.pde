int maxDepth = 7; // Maximum branching depth
float baseBranchLength = 80; // Initial branch length
float growthFactor = 1; // Controls tree growth over time
float angleOffset = QUARTER_PI / 3; // Branching angle
float sunY = 600; // Starting position of the sun
boolean isClearing = false; // Tracks if the spacebar is held to clear clouds
PVector[] rainDrops; // Stores raindrop positions
int numRainDrops = 200; // Number of raindrops

// White clouds for spacebar interaction
PVector[] whiteClouds; // Array of white cloud positions
int numWhiteClouds = 10; // Number of white clouds
float[] whiteCloudSpeeds; // Speed of white clouds

void setup() {
  size(800, 600);
  noStroke();
  rainDrops = new PVector[numRainDrops];
  for (int i = 0; i < numRainDrops; i++) {
    rainDrops[i] = new PVector(random(width), random(height / 2)); // Initialize raindrops
  }
  
  // Initialize white clouds
  whiteClouds = new PVector[numWhiteClouds];
  whiteCloudSpeeds = new float[numWhiteClouds];
  for (int i = 0; i < numWhiteClouds; i++) {
    whiteClouds[i] = new PVector(random(width), random(100, 300));
    whiteCloudSpeeds[i] = random(1, 3);
  }
}

void draw() {
  // Sky background
  color skyColor = isClearing 
    ? lerpColor(color(30, 30, 90), color(135, 206, 235), map(sunY, height, 100, 0, 1)) 
    : color(20, 20, 50); // Darker sky when clouds are present
  background(skyColor);

  // Draw the sun (hidden by default when clouds are present)
  if (isClearing) {
    float sunSize = isClearing ? 120 : 80; // Sun grows when spacebar is held
    float sunBrightness = isClearing ? 255 : 200; // Sun becomes brighter when spacebar is held
    fill(sunBrightness, 204, 0);
    ellipse(width / 2, sunY, sunSize, sunSize);
    if (sunY > 100) sunY -= isClearing ? 1.5 : 0.5; // Sun moves faster when clearing
  }

  // Draw dark clouds and rain
  if (!isClearing) {
    drawClouds();
    drawRain();
  }

  // Draw white clouds when spacebar is held
  if (isClearing) {
    drawWhiteClouds();
  }

  // Draw growing tree
  translate(width / 2, height); // Set origin to the base of the tree
  drawBranch(baseBranchLength * growthFactor, 0); // Start drawing the tree
  
  // Simulate tree growth
  if (growthFactor < 1.5) growthFactor += 0.005;
}

void drawBranch(float length, int depth) {
  if (depth == maxDepth) return; // Stop at max depth

  // Draw the branch
  stroke(139, 69, 19, 255 - depth * 30); // Brown color with fading for smaller branches
  strokeWeight(max(1, (maxDepth - depth))); // Thinner branches as depth increases
  line(0, 0, 0, -length); // Draw branch upward
  translate(0, -length); // Move to the end of the branch

  // Draw child branches recursively
  float newLength = length * 0.7; // Reduce branch length for children
  pushMatrix();
  rotate(-angleOffset); // Left branch
  drawBranch(newLength, depth + 1);
  popMatrix();

  pushMatrix();
  rotate(angleOffset); // Right branch
  drawBranch(newLength, depth + 1);
  popMatrix();

  if (depth > 1) {
    pushMatrix();
    rotate(angleOffset / 2); // Optional middle branch for variety
    drawBranch(newLength * 0.8, depth + 1);
    popMatrix();
  }

  // Draw leaves at the end of branches
  if (depth > 2) {
    drawLeaves(length, depth);
  }
}

void drawLeaves(float branchLength, int depth) {
  float leafSize = map(branchLength, 10, baseBranchLength, 2, 10) * growthFactor; // Size based on branch length and growth
  if (isClearing) leafSize *= 1.5; // Increase leaf size when spacebar is held
  fill(34, 139, 34, 200); // Green leaves with slight transparency
  for (int i = 0; i < 3; i++) {
    float angle = random(-PI / 6, PI / 6); // Randomized angle for natural placement
    float x = cos(angle) * leafSize * random(1, 1.5);
    float y = sin(angle) * leafSize * random(1, 1.5);
    ellipse(x, y, leafSize, leafSize * 1.2); // Slightly oval-shaped leaves
  }
}

void drawClouds() {
  fill(50, 50, 50, 200); // Dark gray for clouds
  for (int i = 0; i < 5; i++) {
    ellipse(i * 200 - 100, 100, 300, 100); // Position clouds across the top
  }
}

void drawRain() {
  stroke(100, 100, 255, 150); // Light blue for raindrops
  strokeWeight(2);
  for (int i = 0; i < numRainDrops; i++) {
    line(rainDrops[i].x, rainDrops[i].y, rainDrops[i].x, rainDrops[i].y + 10);
    rainDrops[i].y += 5; // Move raindrop down
    if (rainDrops[i].y > height) {
      rainDrops[i].y = random(-20, 0); // Reset raindrop position
      rainDrops[i].x = random(width);
    }
  }
}

void drawWhiteClouds() {
  fill(255, 255, 255, 200); // White clouds with transparency
  for (int i = 0; i < numWhiteClouds; i++) {
    ellipse(whiteClouds[i].x, whiteClouds[i].y, 100, 50); // Draw white clouds
    whiteClouds[i].x += whiteCloudSpeeds[i]; // Move clouds horizontally
    if (whiteClouds[i].x > width + 50) {
      whiteClouds[i].x = -50; // Reset position when off-screen
    }
  }
}

// Handle key press to trigger interactions
void keyPressed() {
  if (key == ' ') {
    isClearing = true; // Clear clouds and bring the sun when spacebar is pressed
  }
}

// Handle key release to reset interactions
void keyReleased() {
  if (key == ' ') {
    isClearing = false; // Return clouds and hide sun when spacebar is released
  }
}
