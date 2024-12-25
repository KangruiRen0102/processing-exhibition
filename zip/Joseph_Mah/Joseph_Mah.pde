// Grid settings
int cols = 80; // Increased number of columns for higher resolution
int rows = 80; // Increased number of rows for higher resolution
float cellWidth, cellHeight; // Dimensions of each cell

float[][] waveOffsets; // Offset values for wave propagation
boolean isWaveActive = false; // Is the wave effect active?
float waveSpeed = 0.1; // Speed of the wave propagation
float waveTimer = 0; // Timer for the wave effect

// Cloud positions
PVector[] cloudPositions;

void setup() {
  size(800, 800); // Canvas size

  // Calculate cell size
  cellWidth = width / float(cols);
  cellHeight = height / float(rows);

  // Initialize wave offsets
  waveOffsets = new float[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      waveOffsets[i][j] = (i + j) * 0.3; // Offset to create diagonal wave
    }
  }
  noSmooth(); // Ensure sharp edges for pixel art
  noLoop(); // Draw once

  // Initialize cloud positions
  cloudPositions = new PVector[3];
  for (int i = 0; i < cloudPositions.length; i++) {
    cloudPositions[i] = new PVector(random(0, width), random(height / 2, height));
  }
}

void draw() {
  background(220); // Light gray background

  // Update the wave timer if the wave is active
  if (isWaveActive) {
    waveTimer += waveSpeed;
  }

  // Draw the grid of squares with more shades of blue
  int numShades = 10; // Number of shades for smoother gradient
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * cellWidth;
      float y = j * cellHeight;

      // Calculate wave effect color with more gradient steps and lighter blue
      float waveValue = sin(waveTimer + waveOffsets[i][j]);
      for (int k = 0; k < numShades; k++) {
        color fillColor = lerpColor(color(0, 105, 148), color(173, 216, 230), (waveValue + 1) / 2 * k / float(numShades - 1));
        drawSquare(x, y, cellWidth, cellHeight, fillColor);
      }
    }
  }

  // Draw spiral-like clouds
  drawSpiralClouds();

  int centerX = width / 2;
  int centerY = height / 2;

  // Draw the rowboat (top-down view)
  drawRowboat(centerX, centerY);

  // Draw birds with closer spacing, offset, and one inverted
  drawBird(width - 200, height - 600); // First bird
  drawBird(width - 230, height - 620); // Second bird, offset and closer
  drawBirdInverted(width - 215, height - 640); // Third bird, inverted and offset

  // Draw birds in the bottom left
  drawBird(100, 600); // First bird
  drawBird(70, 620); // Second bird, offset and closer
  drawBirdInverted(85, 640); // Third bird, inverted and offset

  // Draw ripple effect behind the boat
  drawRipple(centerX, centerY - 80);
}

// Draw a square at (x, y) that fills the cell width and height
void drawSquare(float x, float y, float w, float h, color fillColor) {
  fill(fillColor);
  noStroke();
  rect(x, y, w, h);
}

void drawRowboat(int x, int y) {
  // Base of the boat (brown)
  fill(139, 69, 19); // Brown color
  beginShape();
  vertex(x - 30, y - 60); // Top-left
  vertex(x, y - 80);      // Top-center point
  vertex(x + 30, y - 60); // Top-right
  vertex(x + 30, y + 60); // Bottom-right
  vertex(x, y + 80);      // Bottom-center point
  vertex(x - 30, y + 60); // Bottom-left
  endShape(CLOSE);

  // Interior planks (lighter brown)
  fill(210, 180, 140); // Light brown color
  for (int i = -45; i <= 45; i += 15) {
    rect(x - 20, y + i, 40, 10);
  }

  // Add the rim of the boat
  stroke(0);
  noFill();
  beginShape();
  vertex(x - 30, y - 60); // Top-left
  vertex(x, y - 80);      // Top-center point
  vertex(x + 30, y - 60); // Top-right
  vertex(x + 30, y + 60); // Bottom-right
  vertex(x, y + 80);      // Bottom-center point
  vertex(x - 30, y + 60); // Bottom-left
  endShape(CLOSE);
}

void drawBird(int x, int y) {
  color birdColor = color(169, 169, 169); // Grey color
  fill(birdColor);

  // Draw the V shape for the bird pointing to the top
  rect(x - cellWidth, y, cellWidth, cellHeight); // Left part of V
  rect(x + cellWidth, y, cellWidth, cellHeight); // Right part of V
  rect(x, y - cellHeight, cellWidth, cellHeight); // Top part of V
}

void drawBirdInverted(int x, int y) {
  color birdColor = color(169, 169, 169); // Grey color
  fill(birdColor);

  // Draw the inverted V shape for the bird pointing downwards
  rect(x, y, cellWidth, cellHeight); // Top part of V
  rect(x - cellWidth, y + cellHeight, cellWidth, cellHeight); // Left part of V
  rect(x + cellWidth, y + cellHeight, cellWidth, cellHeight); // Right part of V
}

void drawRipple(int x, int y) {
  for (int i = 0; i < 5; i++) { // Create multiple ripple layers
    int offset = i * 20;
    color rippleColor = lerpColor(color(255), color(0, 105, 148), i / 4.0); // Gradient from white to blue
    fill(rippleColor);

    // Original ripple
    rect(x - (i + 2) * cellWidth, y - cellHeight - offset, cellWidth, cellHeight); // Left part of V
    rect(x + (i + 2) * cellWidth, y - cellHeight - offset, cellWidth, cellHeight); // Right part of V
    
    // First duplicate
    rect(x - (i + 2) * cellWidth, y - cellHeight - (offset + 40), cellWidth, cellHeight); // Left part of V
    rect(x + (i + 2) * cellWidth, y - cellHeight - (offset + 40), cellWidth, cellHeight); // Right part of V
    
    // Second duplicate
    rect(x - (i + 2) * cellWidth, y - cellHeight - (offset + 80), cellWidth, cellHeight); // Left part of V
    rect(x + (i + 2) * cellWidth, y - cellHeight - (offset + 80), cellWidth, cellHeight); // Right part of V
    
    // Third duplicate
    rect(x - (i + 2) * cellWidth, y - cellHeight - (offset + 120), cellWidth, cellHeight); // Left part of V
    rect(x + (i + 2) * cellWidth, y - cellHeight - (offset + 120), cellWidth, cellHeight); // Right part of V
  }
}

void drawSpiralClouds() {
  for (PVector pos : cloudPositions) {
    float angleStep = 0.1;
    float radius = 5;

    for (float angle = 0; angle < TWO_PI * 3; angle += angleStep) {
      float x = pos.x + cos(angle) * radius;
      float y = pos.y - angle * 10;

      if (y < 0) break;

      color cloudColor = lerpColor(color(255, 255, 255, 255), color(169, 169, 169, 0), angle / (TWO_PI * 3));
      fill(cloudColor);
      noStroke();
      rect(x, y, cellWidth / 2, cellHeight * 2); // Stretched vertically
    }
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    isWaveActive = !isWaveActive; // Toggle the wave effect
    if (isWaveActive) {
      loop(); 
       } else {
      noLoop(); // Stop continuous drawing
      redraw(); // Redraw once to reset the background
    }
  }
}
