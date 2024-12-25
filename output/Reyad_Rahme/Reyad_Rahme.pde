// Number of snowflakes
int snowflakeCount = 200; 
// Array for snowflakes
Snowflake[] snowflakes = new Snowflake[snowflakeCount]; 
// Font for the clock
PFont font; 
float clockX, clockY, clockSize;
// Initial height of the tree
float treeHeight = 50; 
// Rate at which the tree will grow
float growthRate = 0.2; 
 // Initial height of the pile of snow
float snowpileHeight = 0;
boolean treeFullyGrown = false;
// A toggle to start mkaing the snowman
boolean transformingToSnowman = false; 
// Toggle to start transition to spring
boolean transitioningToSpring = false; 
float transformationProgress = 0; 
float springTransitionProgress = 0; 
int snowmanFormedTime = -1; 
String typedInput = ""; 

ArrayList<Flower> flowers = new ArrayList<Flower>(); 

void setup() {
  size(800, 600); // Window size
  font = createFont("Arial", 18); 
   // Clock position (top-right corner)
  clockX = width - 80;
  clockY = 80;
  clockSize = 100; // Clock size
  
  for (int i = 0; i < snowflakeCount; i++) {
    snowflakes[i] = new Snowflake();
  }
}

void draw() {
  if (!transitioningToSpring) {
    // The winter background 
    drawWinterBackground(); 
  } else {
    drawSpringBackground(); 
  }
  
  drawGround(); // Draw ground (snow or grass depending on season)
  
  // Draw snowflakes (only in winter)
  if (!transitioningToSpring) {
    for (int i = 0; i < snowflakeCount; i++) {
      snowflakes[i].fall();
      snowflakes[i].display();
    }
  }
  
  // Draws the frozen clock 
  drawFrozenClock();
  
  // Draw and grow the evergreen tree
  drawFrozenTree();
  growTree();

  // If the tree is fully grown, form the snowpile
  if (treeFullyGrown && !transformingToSnowman && !transitioningToSpring) {
    formFlatSnowpile();
  }

  // Transform the snowpile into a snowman
  if (transformingToSnowman) {
    transformPileToSnowman();
  }

  // Goes form winter to spring after snowman is formed for a bit
  if (transitioningToSpring) {
    transitionToSpring();
  }

  // Draw flowers in the spring scene
  for (Flower flower : flowers) {
    flower.display();
  }
}

// Function to draw the winter background
void drawWinterBackground() {
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerpColor(color(30, 50, 80), color(200, 220, 255), t));
    line(0, i, width, i);
  }
}

// Function to draw the spring background 
void drawSpringBackground() {
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerpColor(color(200, 220, 255), color(135, 206, 235), springTransitionProgress * t));
    line(0, i, width, i);
  }

  // Draw the sun with rays during the spring transition
  drawSun();
}

// Function to draw the sun in the top left corner with rays
void drawSun() {
  // Position and size of the sun
  float sunX = 100; 
  float sunY = 100; 
  float sunRadius = 50; 

  // Draw the sun 
  fill(255, 223, 0);
  noStroke();
  ellipse(sunX, sunY, sunRadius * 2, sunRadius * 2);

  // Drawing the sun rays
  stroke(255, 223, 0, 150); // Yellow rays
  strokeWeight(3);
  for (int i = 0; i < 12; i++) {
    float angle = map(i, 0, 12, 0, TWO_PI);
    float rayLength = sunRadius * 2; 
    float x1 = sunX + cos(angle) * sunRadius; 
    float y1 = sunY + sin(angle) * sunRadius;
    float x2 = sunX + cos(angle) * (sunRadius + rayLength); 
    float y2 = sunY + sin(angle) * (sunRadius + rayLength);
    line(x1, y1, x2, y2);
  }
}


void drawGround() {
  noStroke();
  if (transitioningToSpring) {
    fill(lerpColor(color(240, 240, 255), color(34, 139, 34), springTransitionProgress)); // Snow to grass
  } else {
    fill(240, 240, 255); // Snowy ground
  }
  rect(0, height - 100, width, 100);
}

// Function to draw the frozen clock with moving hands
void drawFrozenClock() {
  // Calculate the current time based on the millis() function
  float seconds = (millis() / 1000) % 60; 
  float minutes = (millis() / 60000) % 60; 
  float hours = (millis() / 3600000) % 12; 

  // Calculate angles for the clock hands
  float secondAngle = map(seconds, 0, 60, -PI / 2, 3 * PI / 2); 
  float minuteAngle = map(minutes, 0, 60, -PI / 2, 3 * PI / 2); 
  float hourAngle = map(hours + minutes / 60.0, 0, 12, -PI / 2, 3 * PI / 2); 
  
  // The clocks colors caused its spring
  color brownRingColor = lerpColor(color(180, 220, 255, 150), color(139, 69, 19, 150), springTransitionProgress);
  color clockFaceColor = lerpColor(color(200, 220, 255, 180), color(240, 240, 240, 180), springTransitionProgress); 
  color crackColor = lerpColor(color(150, 200, 255, 180), color(139, 69, 19, 180), springTransitionProgress); 
  color numberColor = lerpColor(color(255), color(0, 0, 0), springTransitionProgress);

  // Draw frosted edge (icy ring) with color transition to brown
  noFill();
  stroke(brownRingColor);
  strokeWeight(8);
  ellipse(clockX, clockY, clockSize + 10, clockSize + 10);

  // Draw clock face with color transition (icy to neutral)
  fill(clockFaceColor);
  noStroke();
  ellipse(clockX, clockY, clockSize, clockSize);

  // Add a crack with color transition (icy to brown)
  stroke(crackColor);
  strokeWeight(2);
  line(clockX, clockY, clockX + clockSize / 4, clockY - clockSize / 4);

  // Draw frosted numbers with color transition (white to black)
  fill(numberColor);
  textFont(font);
  textAlign(CENTER, CENTER);
  float radius = clockSize / 2.5;
  for (int i = 1; i <= 12; i++) {
    float angle = radians(i * 30 - 90);
    float x = clockX + cos(angle) * radius;
    float y = clockY + sin(angle) * radius;
    text(i, x, y);
  }

  // If it's winter, apply the frosted effect to the hands
  if (!transitioningToSpring) {
    // Frosted effect for clock hands in winter
    stroke(180, 220, 255, 150); 
    strokeWeight(5);
  } else {
    stroke(0);
    strokeWeight(4);
  }

  // Draw the clock hands
  line(clockX, clockY, clockX + cos(hourAngle) * clockSize / 4, clockY + sin(hourAngle) * clockSize / 4); 
  strokeWeight(3);
  line(clockX, clockY, clockX + cos(minuteAngle) * clockSize / 2, clockY + sin(minuteAngle) * clockSize / 2); 
  stroke(255, 0, 0); // Red color for second hand
  strokeWeight(2);
  line(clockX, clockY, clockX + cos(secondAngle) * clockSize / 2, clockY + sin(secondAngle) * clockSize / 2); 
}

// Function to draw the evergreen tree with snow
void drawFrozenTree() {
  // Position of the tree
  float treeX = width / 4; 
  float treeY = height - 100; 
  float trunkWidth = 10;
  float trunkHeight = treeHeight / 4;

  // Draw the trees trunk
  fill(100, 50, 0); // Brown color for the trunk
  noStroke();
  rect(treeX - trunkWidth / 2, treeY - trunkHeight, trunkWidth, trunkHeight);

  
  int layerCount = 5; 
  float layerHeight = (treeHeight - trunkHeight) / layerCount;
  for (int i = 0; i < layerCount; i++) {
    float layerBaseWidth = treeHeight * 0.8 - i * 20;
    float layerX1 = treeX - layerBaseWidth / 2;
    float layerX2 = treeX + layerBaseWidth / 2;
    float layerY = treeY - trunkHeight - i * layerHeight;

    // Draws the trees green branches
    fill(30, 100, 30); 
    triangle(layerX1, layerY, layerX2, layerY, treeX, layerY - layerHeight);

    // Add snow on the tree branches
    if (!transitioningToSpring) {
      float snowWidth = layerBaseWidth * 0.6; 
      float snowY = layerY - layerHeight / 2;
      fill(255, 255, 255, 200); 
      noStroke();
      ellipse(treeX, snowY, snowWidth, 10); // Smaller snow piles
    }
  }
}

// The function tjay grows the tree over time
void growTree() {
  if (treeHeight < 150) { // Maximum tree height
    treeHeight += growthRate;
  } else {
    treeFullyGrown = true;
  }
}

// Function to form a snowpile
void formFlatSnowpile() {
  float snowpileX = width - 200; 
  float snowpileY = height - 100; 

  fill(255, 255, 255, 200);
  noStroke();

  
  for (int i = 0; i < snowpileHeight; i += 5) {
    float ellipseWidth = 100 - i * 0.5; 
    ellipse(snowpileX, snowpileY - i, ellipseWidth, 10);
  }

 
  if (snowpileHeight < 150) { 
    snowpileHeight += 0.2;
  }
}

// Function to transform the pile into a snowman and melt it during spring
void transformPileToSnowman() {
  float snowmanBaseX = width - 200; 
  float snowmanBaseY = height - 100; 

  if (transformationProgress < 1) {
    // Progress snowman formation
    transformationProgress += 0.01;
    if (transformationProgress >= 1) {
      transformationProgress = 1;
      snowmanFormedTime = frameCount; 
    }
  }

  // Calculate scale based on phase
  float scale = transitioningToSpring ? 1 - springTransitionProgress : transformationProgress;

  // Draw bottom, middle, and head with a smooth scaling
  fill(255);
  noStroke();
  ellipse(snowmanBaseX, snowmanBaseY, 60 * scale, 60 * scale); 
  ellipse(snowmanBaseX, snowmanBaseY - 50 * scale, 45 * scale, 45 * scale); 
  ellipse(snowmanBaseX, snowmanBaseY - 90 * scale, 30 * scale, 30 * scale); 

  // Draw a hat and face onto the snowman
  if (scale > 0) {
    // Draw hat
    fill(0); // Black hat
    rect(snowmanBaseX - 15 * scale, snowmanBaseY - 120 * scale, 30 * scale, 10 * scale); 
    rect(snowmanBaseX - 10 * scale, snowmanBaseY - 140 * scale, 20 * scale, 20 * scale);

    // Draw the snowmans face
    fill(0); 
    // Eyes for the snowman
    ellipse(snowmanBaseX - 5 * scale, snowmanBaseY - 95 * scale, 5 * scale, 5 * scale); 
    ellipse(snowmanBaseX + 5 * scale, snowmanBaseY - 95 * scale, 5 * scale, 5 * scale); 
    fill(255, 165, 0); // Orange carrot nose
    triangle(snowmanBaseX, snowmanBaseY - 90 * scale, snowmanBaseX, snowmanBaseY - 85 * scale, snowmanBaseX + 10 * scale, snowmanBaseY - 87 * scale);
    fill(0); 
    for (int i = -8; i <= 8; i += 4) {
      ellipse(snowmanBaseX + i * scale, snowmanBaseY - 80 * scale + abs(i) * 0.2, 3 * scale, 3 * scale);
    }
  }

  // After 5 seconds have passed since snowman was formed transiton to spring
  if (snowmanFormedTime > 0 && frameCount > snowmanFormedTime + 300) { // 5 seconds = 300 frames
    transitioningToSpring = true; // Start the transition into spring
  }
}

// Function to transition from winter to spring
void transitionToSpring() {
  springTransitionProgress += 0.01; 
  if (springTransitionProgress >= 1) {
    springTransitionProgress = 1; 
  }
}

// The "password" for the snowman to form
void keyTyped() {
  if (treeFullyGrown) {
    typedInput += key;
    if (typedInput.equalsIgnoreCase("snowman")) {
      transformingToSnowman = true;
      typedInput = ""; // Reset input
    }
  }
}

// Making flowers
class Flower {
  float x, y; 
  color flowerColor; 
  
  Flower(float x, float y) {
    this.x = x;
    this.y = y;
    // Random flower colors so when you plant a flower
    flowerColor = color(random(255), random(255), random(255)); 
  }

  // Show the flower
  void display() {
    fill(flowerColor);
    noStroke();
    // The flower petals and center
    ellipse(x, y, 20, 20); 
    fill(255, 255, 0); 
    ellipse(x, y, 10, 10); 
  }
}

// When you click a flower will grow on the ground
void mousePressed() {
  if (transitioningToSpring && mouseY > height - 100) {
    // Only grow flowers in the spring scene when clicked on the ground
    flowers.add(new Flower(mouseX, mouseY)); 
  }
}

// Snowflake class
class Snowflake {
  float x, y, speed, size;

  Snowflake() {
    x = random(width);
    y = random(-height, 0); // Start off-screen
    speed = random(1, 3); // Fall speed
    size = random(2, 5); // Size of snowflake
  }

  void fall() {
    // Move down
    y += speed; 
    if (y > height - 100) { // Reset if hits the ground
      y = random(-height, 0);
      x = random(width);
    }
  }

  void display() {
    fill(255);
    noStroke();
    ellipse(x, y, size, size);
  }
}
