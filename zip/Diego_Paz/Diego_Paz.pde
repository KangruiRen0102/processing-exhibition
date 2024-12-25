float bridgeAngle = 0; // Angle of the drawbridge
int numSegments = 100; // Number of segments for the river
float waveSpeed = 0.01; // Speed of turbulence
float boatX = -100; // Boat's initial position (offscreen)
float boatSpeed = 2; // Boat speed

void setup() {
  size(800, 600);
  background(0, 0, 200); // Makes the sky blue
}

void draw() {
  background(135, 206, 250); // Clear the screen each frame
  drawGround();
  drawRiver();
  drawBridgeSupports();
  drawDrawbridge();
  drawBoat();
}

void drawGround() {
  // Ground on both sides
  fill(34, 139, 34); // Grass green
  rect(0, height / 2 + 100, width, height / 2 - 100); // Left ground
}

void drawRiver() {
  noStroke();
  fill(0, 190, 250); // Water color

  beginShape();
  float segmentWidth = width / float(numSegments);

  for (int i = 0; i < numSegments; i++) {
    float x = i * segmentWidth;
    float noiseVal = noise(i * 0.1, frameCount * waveSpeed); // Turbulence with Perlin noise
    float y = height / 2 + 150 + sin(frameCount * 0.02 + i * 0.3) * 10 + noiseVal * 20; // Sine wave + turbulence
    vertex(x, y);
  }

  vertex(width, height); // Bottom-right corner
  vertex(0, height);     // Bottom-left corner
  endShape(CLOSE);
}

void drawDrawbridge() {
  // Adjust bridge angle based on mouse position
  bridgeAngle = map(mouseY, 0, height, -PI / 3, 0); // Bridge angle changes with mouseY

  // Left bridge half
  pushMatrix();
  translate(width / 4, height / 2 + 100); // Pivot point
  rotate(bridgeAngle); // Rotate based on angle
  fill(50); // Bridge color
  rect(0, -10, width / 4, 20); // Bridge rectangle
  popMatrix();

  // Right bridge half
  pushMatrix();
  translate(3 * width / 4, height / 2 + 100); // Pivot point
  rotate(-bridgeAngle); // Rotate in the opposite direction
  fill(50); // Bridge color
  rect(-width / 4, -10, width / 4, 20); // Bridge rectangle
  popMatrix();
}

void drawBridgeSupports() {
  // Bridge supports on both sides
  fill(105, 105, 105); // Gray
  rect(width / 4 - 20, height / 2 + 100, 40, 50); // Left support
  rect(3 * width / 4 - 20, height / 2 + 100, 40, 50); // Right support
}

void drawBoat() {
  // Boat passes throught the bridge
  if (bridgeAngle <= -PI / 6 && boatX >= width / 4 - 80 && boatX <= 3 * width / 4 + 20) {
    boatX += boatSpeed; // Move boat forward if under the bridge
  } else if (boatX < width) {
    boatX += boatSpeed; // Move the boat forward if not under the bridge
  }

  // Reset boat position when it reaches the right side of the screen
  if (boatX > width) {
    boatX = -100; // Reset to the left side
  }

  // Drawing the boat
  fill(139, 69, 19); // Brown color
  beginShape();
  vertex(boatX, height / 2 + 150);
  vertex(boatX + 100, height / 2 + 150);
  vertex(boatX + 80, height / 2 + 170);
  vertex(boatX + 20, height / 2 + 170);
  endShape(CLOSE);

  // Boat sail
  fill(255, 255, 255); // White sail
  triangle(boatX + 30, height / 2 + 150, boatX + 30, height / 2 + 100, boatX + 80, height / 2 + 150);
}
