// Store star positions in arrays
float[] starX, starY; // X and Y coordinates for stars
int numStars = 100; // draw 100 stars in sky

// Building variables
float[] barHeights, barTargetHeights; // set current and target heights for dynamic buildings
int barClicks = 0; // Counter for mouse clicks to cycle building height animation
float[] barMinHeights, barMaxHeights; // Max/min heights for buildings

// Tree variables
float[] treeHeights; // store tree heights in arrays
float treeGrowth = 5; // change height by 5 with arrow clicks
float maxTreeHeight = 150; // Max tree heights
float minTreeHeight = 50; // Min tree heights

// student variables
float[] studentX, studentY; // X and Y positions for students
int numStudents = 5; // show 5 students
//void indicates that the function does not return a value
void setup() {
  size(800, 800); // 800x800 canvas
  background(30, 30, 80); // blue background colour

  // random star positions in top 1/2 of canvas
  starX = new float[numStars];
  starY = new float[numStars];
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(width); // random x position across the width
    starY[i] = random(height / 2); // random y position in upper half
  }

  // use building variables
  int numBars = width / 100; // 1 building per 100 pixels
  barHeights = new float[numBars]; // current building height
  barTargetHeights = new float[numBars]; // building target heights
  barMinHeights = new float[numBars]; // Min height
  barMaxHeights = new float[numBars]; // Max height

  // initial building variable values
  for (int i = 0; i < numBars; i++) {
    barMinHeights[i] = random(200, 400); // randomizing minimum height
    barMaxHeights[i] = random(500, 700); // randomizing maximum height
    barHeights[i] = random(barMinHeights[i], barMaxHeights[i]); // initial random height
    barTargetHeights[i] = barHeights[i]; // initial target = current height
  }

  // random tree heights in allowable range
  int numTrees = 6; // six trees
  treeHeights = new float[numTrees];
  for (int i = 0; i < numTrees; i++) {
    treeHeights[i] = random(minTreeHeight, maxTreeHeight); // give each tree random height
  }

  // student positions on ground
  studentX = new float[numStudents];
  studentY = new float[numStudents];
  for (int i = 0; i < numStudents; i++) {
    studentX[i] = random(50 + i * 150, 100 + i * 150); // even spacing of students
    studentY[i] = height - 80; // student y-axis placement
  }
}

void draw() {
  background(30, 30, 80); // for animating purposes the background is redrawn 

  drawStars(); // draw the stars
  drawSkyline(); // draw buildings
  drawPark(); // ground and trees
  drawStudents(); // students
}

void drawStars() {
  for (int i = 0; i < numStars; i++) {
    fill(255, 255, 50); // yellow stars
    ellipse(starX[i], starY[i], 5, 5); // circular stars
  }
}

void drawSkyline() {
  fill(50, 50, 50); // building colour
  for (int i = 0; i < barHeights.length; i++) {
    // building height adjusts to target
    barHeights[i] += (barTargetHeights[i] - barHeights[i]) * 0.01; 
    rect(i * 100 + 50, height - barHeights[i], 80, barHeights[i]); // draw buildings
  }
}

void drawPark() {
  // draw the ground
  fill(34, 139, 34);
  rect(0, height - 100, width, 100); 

  // draw trees (trunk and green)
  for (int i = 0; i < treeHeights.length; i++) {
    float x = i * 150 + 50; // tree x-position
    fill(139, 69, 19); // trunk colour
    rect(x, height - 100 - treeHeights[i], 20, treeHeights[i]); // trunk drawn
    fill(34, 139, 34); // leaf colour
    ellipse(x + 10, height - 100 - treeHeights[i] - 20, 60, 60); // circular leaf
  }
}

void drawStudents() {
  for (int i = 0; i < numStudents; i++) {
    float d = dist(mouseX, mouseY, studentX[i], studentY[i]); // distance from mouse to student
    boolean isHovered = d < 30; // check if the mouse is close enough to the student
    float size = isHovered ? 40 : 30; // student size increases when hovered
    fill(isHovered ? color(255, 255, 0) : color(0, 200, 255)); // colour changes to yellow when hovered

    ellipse(studentX[i], studentY[i], size, size); // head
    stroke(255); // legs and body
    line(studentX[i], studentY[i] + size / 2, studentX[i], studentY[i] + size * 2); // draw body
    line(studentX[i], studentY[i] + size * 1.5, studentX[i] - 10, studentY[i] + size * 2); // left leg
    line(studentX[i], studentY[i] + size * 1.5, studentX[i] + 10, studentY[i] + size * 2); // right leg
  }
}

void mousePressed() {
  barClicks++; // click counter
  if (barClicks > 5) barClicks = 0; // clicks reset after 6

  for (int i = 0; i < barHeights.length; i++) {
    if (barClicks <= 2) {
      // height increases on first three clicks
      barTargetHeights[i] = barMinHeights[i] + barClicks * (barMaxHeights[i] - barMinHeights[i]) / 3;
    } else {
      // height decreases over next three clicks
      barTargetHeights[i] = barMaxHeights[i] - (barClicks - 3) * (barMaxHeights[i] - barMinHeights[i]) / 3;
    }
  }
}

void keyPressed() {
  if (keyCode == UP) {
    // tree heights increase with up arrow
    for (int i = 0; i < treeHeights.length; i++) {
      treeHeights[i] = min(treeHeights[i] + treeGrowth, maxTreeHeight); //keep trees below maximum height
    }
  } else if (keyCode == DOWN) {
    // tree heights decrease with down arrow
    for (int i = 0; i < treeHeights.length; i++) {
      treeHeights[i] = max(treeHeights[i] - treeGrowth, minTreeHeight); // keep trees above minimum height
    }
  }
}
