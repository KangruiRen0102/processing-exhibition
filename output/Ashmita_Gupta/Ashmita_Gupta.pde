// sketch.pde
int age = 0; // Simulated age for the tree
int weatherStage = 0; // 0: Lightning/chaotic rain, 1: Calm sunny, 2: Drought
float transitionProgress = 0; // Smooth transition between weather stages
int weatherCycleCount = 0; // Count the number of completed weather cycles
boolean isGrowing = true; // Determines if the tree is still growing

void setup() {
  size(800, 600);
  frameRate(60);
}

void draw() {
  if (weatherCycleCount >= 3) {
    // End the program gracefully after 5 weather cycles
    background(135, 206, 235); // Bright blue background at the end
    drawGrass(); // Final grass patch
    drawTree(width / 2, height, 1000); // Fully grown tree
    
    // Display thank you message
    fill(255); // White text
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Thank You for Watching", width / 2, height / 2 - 50);
    
    noLoop(); // Stop the program
    return;
  }

  background(0); // Clear frame

  // Draw permanent patch of grass
  drawGrass();

  // Simulate weather based on the stage
  drawWeather(weatherStage, transitionProgress);

  // Draw the tree if it's still growing
  if (isGrowing) {
    drawTree(width / 2, height, age);
  }

  // Increment growth and handle weather transitions
  if (frameCount % 4 == 0 && isGrowing) { // Slightly faster tree growth
    age += 1;
  }
  transitionProgress += 0.005;
  if (transitionProgress > 1) {
    transitionProgress = 0;
    weatherStage = (weatherStage + 1) % 3; // Cycle through weather stages
    if (weatherStage == 0) {
      weatherCycleCount++; // Increment cycle count only after completing all 3 stages
    }
  }

  // Stop tree growth after the tree fully matures
  if (age >= 1000) {
    isGrowing = false;
  }
}


void drawWeather(int stage, float progress) {
  if (stage == 0) {
    // Chaotic lightning and rain weather
    drawLightning(progress);
    drawRain();
  } else if (stage == 1) {
    // Calm sunny weather
    drawSunnySky(progress);
  } else if (stage == 2) {
    // Drought-like bright sunny condition
    drawDroughtSky(progress);
  }
}

void drawGrass() {
  // Grass permanently beneath the tree
  fill(34, 139, 34); // Grass green color
  noStroke();
  rect(0, height - 50, width, 50); // Grass patch

  // Draw visible blades of grass
  stroke(0, 100, 0);
  for (int i = 0; i < width; i += 10) {
    float bladeHeight = random(20, 40);
    line(i, height - 50, i, height - 50 - bladeHeight);
  }
}

void drawLightning(float progress) {
  // Transition to grayish background
  float bgColor = lerp(30, 100, progress);
  background(bgColor);
  
  // Random flashes of lightning
  if (random(1) < 0.1) {
    stroke(255, 255, 255, random(100, 255));
    strokeWeight(3);
    float startX = random(width);
    float startY = 0;
    for (int i = 0; i < 5; i++) {
      float endX = startX + random(-30, 30);
      float endY = startY + random(30, 50);
      line(startX, startY, endX, endY);
      startX = endX;
      startY = endY;
    }
  }
}

void drawRain() {
  // Falling rain
  stroke(173, 216, 230, 150); // Light blue rain color
  strokeWeight(2);
  for (int i = 0; i < 200; i++) {
    float x = random(width);
    float y = random(height);
    line(x, y, x, y + 10); // Small rain streaks
  }
}

void drawSunnySky(float progress) {
  // Transition to blue sky with sun
  for (int y = 0; y < height; y++) {
    float colorLerp = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(135, 206, 235), color(255, 255, 255), colorLerp));
    line(0, y, width, y);
  }
  
  // Draw the sun
  float sunSize = lerp(50, 80, progress);
  noStroke();
  fill(255, 204, 0);
  ellipse(width - 100, 100, sunSize, sunSize);

  // Draw clouds
  fill(255, 255, 255, 200);
  for (int i = 0; i < 3; i++) {
    float cloudX = lerp(-200, width, progress) + i * 150;
    ellipse(cloudX, 150, 100, 50);
    ellipse(cloudX + 50, 140, 70, 40);
    ellipse(cloudX - 50, 140, 70, 40);
  }
}

void drawDroughtSky(float progress) {
  // Transition to bright golden background
  for (int y = 0; y < height; y++) {
    float colorLerp = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(255, 204, 0), color(255, 255, 102), colorLerp));
    line(0, y, width, y);
  }
  
  // Draw brighter sun
  float sunSize = lerp(80, 100, progress);
  noStroke();
  fill(255, 255, 102);
  ellipse(width - 100, 100, sunSize, sunSize);
}

void drawTree(float x, float y, int age) {
  // Trunk growth
  float trunkHeight = map(age, 0, 1000, 20, 300); // Slowly grows to 300 px tall
  float trunkWidth = map(age, 0, 1000, 5, 80);    // Trunk widens as it grows
  
  fill(139, 69, 19); // Brown trunk color
  noStroke();
  rect(x - trunkWidth / 2, y - trunkHeight, trunkWidth, trunkHeight); // Draw trunk

  // Leaves growth
  float leafSize = map(age, 0, 1000, 20, 250); // Leaves grow larger
  float spread = map(age, 0, 1050, 30, 150);   // Leaves spread wider
  
  // Calculate the position where branches will start (midway on the trunk)
  float branchStartY = y - trunkHeight / 1; // Midway point of the trunk
  
  // Connect leaves to trunk with branches (starting from the middle of the trunk)
  stroke(139, 69, 19);
  strokeWeight(map(age, 0, 1000, 1, 25)); // Branches thicken as tree grows
  
  // Left branch (going up and to the left)
  line(x, branchStartY, x - spread, branchStartY - leafSize / 2);
  
  // Right branch (going up and to the right)
  line(x, branchStartY, x + spread, branchStartY - leafSize / 2);
 
   // Draw leaves (no outline for leaves)
  noStroke();  // Ensures no outline for leaves

  // Draw leaves
  fill(34, 139, 34, 200); // Green leaves with some transparency
  ellipse(x, branchStartY - leafSize / 2, leafSize, leafSize); // Center top leaves
  ellipse(x - spread, branchStartY - leafSize / 2, leafSize / 1.5, leafSize / 1.5); // Left leaves
  ellipse(x + spread, branchStartY - leafSize / 2, leafSize / 1.5, leafSize / 1.5); // Right leaves
}
