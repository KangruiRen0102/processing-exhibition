float deer1X = 300;  // X-coordinate of the first deer
float deer2X = 500;  // X-coordinate of the second deer
float deer1Y, deer2Y; // Y-coordinates of the deer
boolean draggingDeer1 = false; // To check if deer1 is being dragged
boolean draggingDeer2 = false; // To check if deer2 is being dragged

void setup() {
  size(800, 600); // Canvas size
  noStroke();
  deer1Y = hillY(deer1X) - 15; // Y-coordinate for deer1 based on the hill
  deer2Y = hillY(deer2X) - 15; // Y-coordinate for deer2 based on the hill
  drawStaticBackground(); // Pre-render the background to keep it static
}

void draw() {
  drawStaticBackground(); // Keep the background static
  drawAnimals(); // Draw the animals, now at updated positions
}

// Draws the static background: sky, birds, and landscape
void drawStaticBackground() {
  drawTwilightSky();
  drawHometownLandscape();
  drawBirds(); // Add birds to the background
}

// Draws the twilight sky with gradient effect
void drawTwilightSky() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    color c = lerpColor(color(253, 94, 83), color(90, 48, 152), inter);
    stroke(c);
    line(0, y, width, y);
  }

}

// Draws the landscape for the hometown
void drawHometownLandscape() {
  fill(34, 32, 52); // Dark silhouette color for hills
  beginShape();
  vertex(0, height);
  vertex(0, height - 100);
  bezierVertex(200, height - 150, 400, height - 50, 800, height - 100); // Curved hill
  vertex(width, height);
  endShape(CLOSE);
}

// Function to calculate the y-coordinate of the hill at a specific x-coordinate
float hillY(float x) {
  // Match the curve defined in drawHometownLandscape()
  return bezierPoint(height - 100, height - 150, height - 50, height - 100, x / width);
}

// Draws static birds in the sky
void drawBirds() {
  stroke(0); // Black silhouettes for birds
  strokeWeight(2);
  
  // Example bird positions
  drawBird(100, 100);
  drawBird(200, 150);
  drawBird(350, 120);
  drawBird(500, 80);
  drawBird(700, 130);
}

// Function to draw a simple bird shape
void drawBird(float x, float y) {
  line(x, y, x + 10, y - 10); // Left wing
  line(x + 10, y - 10, x + 20, y); // Right wing
}

// Draws silhouettes of animals
void drawAnimals() {
  fill(0); // Black silhouette color
  drawDeer(deer1X, deer1Y); // Draw first deer at updated position
  drawDeer(deer2X, deer2Y); // Draw second deer at updated position
}

// Function to draw a deer with antlers
void drawDeer(float x, float y) {
  pushMatrix();
  translate(x, y);

  // Body
  ellipse(0, 0, 40, 30); // Body
  ellipse(10, -15, 20, 20); // Head
  
  // Legs
  rect(-10, 15, 5, 20); // Front left leg
  rect(10, 15, 5, 20);  // Front right leg
  rect(-20, 15, 5, 20); // Back left leg
  rect(20, 15, 5, 20);  // Back right leg

  // Antlers
  stroke(0);
  strokeWeight(2);
  line(10, -20, 0, -40); // Left antler main
  line(10, -20, 20, -40); // Right antler main
  line(0, -40, -5, -50);  // Left antler branch
  line(20, -40, 25, -50); // Right antler branch
  noStroke();

  popMatrix();
}

// MousePressed event to detect if the deer is clicked
void mousePressed() {
  // Check if the mouse is over the first deer
  if (dist(mouseX, mouseY, deer1X, deer1Y) < 40) {  // Adjust the 40 based on deer size
    draggingDeer1 = true;
  }
  // Check if the mouse is over the second deer
  if (dist(mouseX, mouseY, deer2X, deer2Y) < 40) {  // Adjust the 40 based on deer size
    draggingDeer2 = true;
  }
}

// MouseDragged event to update the position of the selected deer
void mouseDragged() {
  if (draggingDeer1) {
    deer1X = mouseX; // Move deer1 to the mouse position
    deer1Y = mouseY - 15; // Adjust Y position to stay on the hill
  }
  if (draggingDeer2) {
    deer2X = mouseX; // Move deer2 to the mouse position
    deer2Y = mouseY - 15; // Adjust Y position to stay on the hill
  }
}

// MouseReleased event to stop dragging
void mouseReleased() {
  draggingDeer1 = false;
  draggingDeer2 = false;
}
