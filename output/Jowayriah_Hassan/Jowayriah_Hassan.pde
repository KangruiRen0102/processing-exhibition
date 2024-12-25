float motherX, motherY, childX, childY;
float orbX, orbY, orbSize;
boolean animationRunning = true;
boolean childGrowing = false;
float bgBrightness = 0;
float childScale = 1.0;

void setup() {
  size(800, 600);
  motherX = width / 4;
  motherY = height / 2 + 50;
  childX = width / 2 + 150;
  childY = height / 2 + 50;
  orbX = motherX;
  orbY = motherY - 20;
  orbSize = 30;
  textFont(createFont("Arial", 18));
  textAlign(CENTER, CENTER);
}

void draw() {
  // Draw the house interior with wallpaper and decor
  drawHouseInterior();

  // Draw mother and child
  drawMother(motherX, motherY);
  pushMatrix();
  translate(childX, childY);
  scale(childScale);
  drawChild(0, 0);
  popMatrix();

  // Draw the glowing orb
  drawOrb(orbX, orbY, orbSize);

  // Draw labels and instructions
  drawLabels();

  // Animation logic
  if (animationRunning) {
    orbX = lerp(orbX, childX, 0.02); 
    orbY = lerp(orbY, childY - 60, 0.02);

    if (dist(orbX, orbY, childX, childY - 60) < 50) {
      childGrowing = true;
    }

    if (dist(orbX, orbY, childX, childY - 60) < 2) {
      animationRunning = false;
    }
  }

  if (childGrowing) {
    childScale = lerp(childScale, 1.5, 0.01); 
    bgBrightness = lerp(bgBrightness, 255, 0.01);
  }

  if (!animationRunning) {
    fill(0, 0, 0, 150);
    text("Click to Restart", width / 2, height - 50);
  }
}

// Draw the interior of the house
void drawHouseInterior() {
  // Striped Wallpaper
  for (int i = 0; i < width; i += 20) {
    fill(i % 40 == 0 ? color(240, 220, 200) : color(250, 240, 230));
    rect(i, 0, 20, height - 100);
  }

  // Floor
  fill(139, 69, 19);
  rect(0, height - 100, width, 100);

  // Large Window with Frame
  drawWindow(width / 2 - 160, 100);

  // Larger Couch with Cushions
  drawCouch(width / 4, height - 150);
}

// Draw a large window with a frame
void drawWindow(float x, float y) {
  // Window frame
  fill(100, 60, 40);
  rect(x - 10, y - 10, 320, 220); // Outer frame

  // Glass panes
  fill(173, 216, 230);
  rect(x, y, 300, 200);

  // Window dividers
  stroke(139, 69, 19);
  strokeWeight(4);
  line(x, y + 100, x + 300, y + 100); // Horizontal divider
  line(x + 100, y, x + 100, y + 200); // Left vertical divider
  line(x + 200, y, x + 200, y + 200); // Right vertical divider
}

// Draw a larger couch with cushions
void drawCouch(float x, float y) {
  fill(100, 70, 50); // Main body of the couch
  rect(x - 140, y - 50, 280, 50); // Base
  rect(x - 140, y - 110, 280, 60); // Backrest

  fill(80, 50, 40); // Couch arms
  rect(x - 160, y - 110, 20, 110); // Left arm
  rect(x + 140, y - 110, 20, 110); // Right arm

  fill(140, 90, 60); // Cushions
  rect(x - 110, y - 100, 60, 40); // Left cushion
  rect(x - 30, y - 100, 60, 40); // Middle cushion
  rect(x + 50, y - 100, 60, 40); // Right cushion
}

// Draw the mother
void drawMother(float x, float y) {
  fill(255, 200, 150);
  ellipse(x, y - 60, 50, 50);

  // Eyes
  drawEyes(x, y - 60, 10, 5);

  fill(255, 111, 97);
  ellipse(x, y, 60, 100);

  fill(255, 200, 150);
  ellipse(x - 40, y - 20, 20, 20);
  ellipse(x + 40, y - 20, 20, 20);

  noFill();
  stroke(0);
  strokeWeight(2);
  arc(x, y - 60, 30, 20, 0, PI);
}

// Draw the child
void drawChild(float x, float y) {
  fill(255, 230, 180);
  ellipse(x, y - 60, 40, 40);

  // Eyes
  drawEyes(x, y - 60, 8, 4);

  fill(255, 215, 0);
  ellipse(x, y, 50, 80);

  noFill();
  stroke(0);
  strokeWeight(1.5);
  arc(x, y - 60, 20, 15, 0, PI);
}

// Draw eyes with pupils
void drawEyes(float x, float y, float eyeWidth, float pupilSize) {
  fill(255); 
  ellipse(x - 10, y - 5, eyeWidth, eyeWidth);
  ellipse(x + 10, y - 5, eyeWidth, eyeWidth);

  float dx = orbX - x;
  float dy = orbY - y;
  float angle = atan2(dy, dx);
  float pupilOffset = 3;

  fill(0);
  ellipse(x - 10 + pupilOffset * cos(angle), y - 5 + pupilOffset * sin(angle), pupilSize, pupilSize);
  ellipse(x + 10 + pupilOffset * cos(angle), y - 5 + pupilOffset * sin(angle), pupilSize, pupilSize);
}

// Draw the glowing orb
void drawOrb(float x, float y, float size) {
  for (int i = 5; i > 0; i--) {
    noStroke();
    fill(255, 255, 255, map(i, 5, 0, 50, 0));
    ellipse(x, y, size + i * 10, size + i * 10);
  }
  fill(255);
  ellipse(x, y, size, size);
}

// Draw labels and instructions
void drawLabels() {
  fill(0, 0, 0);
  textSize(18);
  text("Mother", motherX, motherY - 120);
  text("Child", childX, childY - 120);
}

// Restart animation on mouse click
void mousePressed() {
  if (!animationRunning) {
    resetAnimation();
  }
}

// Reset the animation
void resetAnimation() {
  orbX = motherX;
  orbY = motherY - 20;
  childScale = 1.0;
  bgBrightness = 0;
  childGrowing = false;
  animationRunning = true;
}
