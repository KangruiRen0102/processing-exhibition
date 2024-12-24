let wingColor; // Butterfly's initial wing color

function setup() {
  createCanvas(600, 600); // Set canvas size
  background(170, 200, 230); // Light blue background
  wingColor = color(255, 182, 193); // Light pink color for butterfly
}

function draw() {
  drawButterfly(width / 2, height / 2, 50); // Draw butterfly at the center
}

function mousePressed() {
  // Change wing color to a random color when mouse is pressed
  wingColor = color(random(255), random(255), random(255));
}

function keyPressed() {
  // Draw a flower at a random position when a key is pressed
  drawFlower(random(width), random(height), 20);
}

function drawButterfly(x, y, size) {
  noStroke(); // No outlines for wings
  fill(wingColor);

  // Draw the wings
  ellipse(x - size / 2, y - size / 2, size, size * 1.5); // Top left wing
  ellipse(x - size / 2, y + size / 2, size, size * 1.5); // Bottom left wing
  ellipse(x + size / 2, y - size / 2, size, size * 1.5); // Top right wing
  ellipse(x + size / 2, y + size / 2, size, size * 1.5); // Bottom right wing

  // Draw the body with black lines
  stroke(0); // Black outline for the body
  strokeWeight(3);
  line(x, y - size, x, y + size); // Body
  line(x, y - size, x - size / 4, y - size * 1.2); // Left antenna
  line(x, y - size, x + size / 4, y - size * 1.2); // Right antenna
}

function drawFlower(x, y, size) {
  // Draw petals
  fill(210, 100, 200); // Pink color for petals
  noStroke();
  ellipse(x - size / 2, y, size, size); // Left petal
  ellipse(x + size / 2, y, size, size); // Right petal
  ellipse(x, y - size / 2, size, size); // Top petal
  ellipse(x, y + size / 2, size, size); // Bottom petal

  // Draw the center
  fill(255, 223, 0); // Yellow center
  ellipse(x, y, size / 1.5, size / 1.5); // Center circle
}
