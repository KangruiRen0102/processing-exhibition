let cols = 80; // Increased number of columns for higher resolution
let rows = 80; // Increased number of rows for higher resolution
let cellWidth, cellHeight; // Dimensions of each cell

let waveOffsets = []; // Offset values for wave propagation
let isWaveActive = false; // Is the wave effect active?
let waveSpeed = 0.1; // Speed of the wave propagation
let waveTimer = 0; // Timer for the wave effect

let cloudPositions = []; // Cloud positions

function setup() {
  createCanvas(800, 800); // Canvas size

  // Calculate cell size
  cellWidth = width / cols;
  cellHeight = height / rows;

  // Initialize wave offsets
  for (let i = 0; i < cols; i++) {
    waveOffsets[i] = [];
    for (let j = 0; j < rows; j++) {
      waveOffsets[i][j] = (i + j) * 0.3; // Offset to create diagonal wave
    }
  }

  // Initialize cloud positions
  for (let i = 0; i < 3; i++) {
    cloudPositions.push(createVector(random(0, width), random(height / 2, height)));
  }

  noLoop(); // Draw once
}

function draw() {
  background(220); // Light gray background

  // Update the wave timer if the wave is active
  if (isWaveActive) {
    waveTimer += waveSpeed;
  }

  // Draw the grid of squares with more shades of blue
  let numShades = 10; // Number of shades for smoother gradient
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let x = i * cellWidth;
      let y = j * cellHeight;

      // Calculate wave effect color with more gradient steps and lighter blue
      let waveValue = sin(waveTimer + waveOffsets[i][j]);
      for (let k = 0; k < numShades; k++) {
        let fillColor = lerpColor(color(0, 105, 148), color(173, 216, 230), (waveValue + 1) / 2 * k / (numShades - 1));
        drawSquare(x, y, cellWidth, cellHeight, fillColor);
      }
    }
  }

  // Draw spiral-like clouds
  drawSpiralClouds();

  let centerX = width / 2;
  let centerY = height / 2;

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

function drawSquare(x, y, w, h, fillColor) {
  fill(fillColor);
  noStroke();
  rect(x, y, w, h);
}

function drawRowboat(x, y) {
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
  for (let i = -45; i <= 45; i += 15) {
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

function drawBird(x, y) {
  fill(169, 169, 169); // Grey color
  rect(x - cellWidth, y, cellWidth, cellHeight); // Left part of V
  rect(x + cellWidth, y, cellWidth, cellHeight); // Right part of V
  rect(x, y - cellHeight, cellWidth, cellHeight); // Top part of V
}

function drawBirdInverted(x, y) {
  fill(169, 169, 169); // Grey color
  rect(x, y, cellWidth, cellHeight); // Top part of V
  rect(x - cellWidth, y + cellHeight, cellWidth, cellHeight); // Left part of V
  rect(x + cellWidth, y + cellHeight, cellWidth, cellHeight); // Right part of V
}

function drawRipple(x, y) {
  for (let i = 0; i < 5; i++) { // Create multiple ripple layers
    let offset = i * 20;
    let rippleColor = lerpColor(color(255), color(0, 105, 148), i / 4.0); // Gradient from white to blue
    fill(rippleColor);

    // Original ripple
    rect(x - (i + 2) * cellWidth, y - cellHeight - offset, cellWidth, cellHeight); // Left part of V
    rect(x + (i + 2) * cellWidth, y - cellHeight - offset, cellWidth, cellHeight); // Right part of V

    // Additional duplicates
    for (let j = 1; j <= 3; j++) {
      rect(x - (i + 2) * cellWidth, y - cellHeight - (offset + j * 40), cellWidth, cellHeight); // Left part of V
      rect(x + (i + 2) * cellWidth, y - cellHeight - (offset + j * 40), cellWidth, cellHeight); // Right part of V
    }
  }
}

function drawSpiralClouds() {
  for (let pos of cloudPositions) {
    let angleStep = 0.1;
    let radius = 5;

    for (let angle = 0; angle < TWO_PI * 3; angle += angleStep) {
      let x = pos.x + cos(angle) * radius;
      let y = pos.y - angle * 10;

      if (y < 0) break;

      let cloudColor = lerpColor(color(255, 255, 255, 255), color(169, 169, 169, 0), angle / (TWO_PI * 3));
      fill(cloudColor);
      noStroke();
      rect(x, y, cellWidth / 2, cellHeight * 2); // Stretched vertically
    }
  }
}

function keyPressed() {
  if (key === 'w' || key === 'W') {
    isWaveActive = !isWaveActive; // Toggle the wave effect
    if (isWaveActive) {
      loop(); 
    } else {
      noLoop(); // Stop continuous drawing
      redraw(); // Redraw once to reset the background
    }
  }
}
