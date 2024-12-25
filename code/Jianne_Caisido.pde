int currentSeason = 0; // 0 = Spring, 1 = Summer, 2 = Fall, 3 = Winter
float transitionProgress = 0; // Progress of the transition between seasons
boolean transitioning = false; // Indicates if a transition is happening

void setup() {
  size(800, 600);
  frameRate(60);
}

void draw() {
  background(135, 206, 235); // Sky color
  drawGrass();

  // Draw and handle tree transitions
  if (transitioning) {
    transitionProgress += 0.02;
    if (transitionProgress >= 1) {
      transitionProgress = 0;
      transitioning = false;
      currentSeason = (currentSeason + 1) % 4;
    }
  }

  // Blend tree states based on transition progress
  if (transitioning) {
    drawTransition();
  } else {
    drawSeason(currentSeason);
  }

  // Display the season name
  displaySeasonName();
}

void mousePressed() {
  // Initiate transition on mouse click
  if (!transitioning) {
    transitioning = true;
  }
}

// Display the season name
void displaySeasonName() {
  fill(255);
  textSize(32);
  textAlign(CENTER, TOP);
  text(getSeasonName(currentSeason), width / 2, 10);
}

// Get the season name
String getSeasonName(int season) {
  String[] seasons = {"Spring", "Summer", "Fall", "Winter"};
  return seasons[season];
}

// Draw the grass
void drawGrass() {
  fill(34, 139, 34);
  noStroke();
  rect(0, height - 100, width, 100);
}

// Draw the tree for the current season
void drawSeason(int season) {
  switch (season) {
    case 0:
      drawTree(color(34, 139, 34), color(255, 182, 193)); // Spring: Green leaves and flowers
      break;
    case 1:
      drawTree(color(0, 100, 0), color(0, 100, 0)); // Summer: Dense green leaves
      drawSun();
      break;
    case 2:
      drawTree(color(255, 140, 0), color(255, 69, 0)); // Fall: Orange and red leaves
      drawFallingLeaves();
      break;
    case 3:
      drawTree(color(255, 255, 255), color(255, 255, 255)); // Winter: Bare branches with snow
      drawFallingSnow();
      break;
  }
}

// Draw the tree for blending during transitions
void drawTransition() {
  int nextSeason = (currentSeason + 1) % 4;
  int blendedColor = lerpColor(getLeafColor(currentSeason), getLeafColor(nextSeason), transitionProgress);
  drawTree(blendedColor, blendedColor);
}

// Get the leaf color based on the season
color getLeafColor(int season) {
  switch (season) {
    case 0: return color(34, 139, 34); // Spring
    case 1: return color(0, 100, 0); // Summer
    case 2: return color(255, 140, 0); // Fall
    case 3: return color(255, 255, 255); // Winter
  }
  return color(0);
}

// Draw a tree with branches
void drawTree(color leafColor, color accentColor) {
  noStroke();
  fill(139, 69, 19); // Brown trunk
  rect(width / 2 - 20, height - 100, 40, 100); // Shorter trunk
  drawBranches(width / 2, height - 100, -PI / 2, 100, 6, leafColor, accentColor); // Longer branches
}

// Recursive function to draw branches
void drawBranches(float x, float y, float angle, float length, int depth, color leafColor, color accentColor) {
  if (depth == 0) return; // Stop recursion at depth zero

  float x2 = x + cos(angle) * length;
  float y2 = y + sin(angle) * length;

  // Draw a branch
  stroke(139, 69, 19); // Brown branch color
  strokeWeight(depth * 2);
  line(x, y, x2, y2);

  // Add leaves at branch tips
  if (depth == 1) {
    noStroke();
    fill(leafColor);
    ellipse(x2, y2, 40, 40); // Larger leaves

    fill(accentColor);
    ellipse(x2 + random(-10, 10), y2 + random(-10, 10), 15, 15); // Larger accents (e.g., flowers or snow)
  }

  // Recursively draw branches
  drawBranches(x2, y2, angle - radians(20), length * 0.8, depth - 1, leafColor, accentColor); // Longer branches
  drawBranches(x2, y2, angle + radians(20), length * 0.8, depth - 1, leafColor, accentColor);
}

// Draw the sun (Summer)
void drawSun() {
  fill(255, 255, 0);
  noStroke();
  ellipse(width - 100, 100, 80, 80);
}

// Draw falling leaves (Fall)
void drawFallingLeaves() {
  for (int i = 0; i < 20; i++) {
    fill(random(200, 255), random(100, 200), 0, 200);
    noStroke();
    ellipse(random(width), random(height - 100), 20, 10);
  }
}

// Draw falling snowflakes (Winter)
void drawFallingSnow() {
  for (int i = 0; i < 50; i++) {
    fill(255, 255, 255, 200);
    noStroke();
    ellipse(random(width), random(height - 100), 5, 5);
  }
}