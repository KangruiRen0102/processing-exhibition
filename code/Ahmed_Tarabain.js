let buildingColors, buildingHeights;

function setup() {
  createCanvas(800, 600);
  noLoop();

  // Define building colors
  buildingColors = [
    color(255, 69, 0),    // Red-orange
    color(34, 139, 34),   // Forest green
    color(30, 144, 255),  // Dodger blue
    color(255, 215, 0),   // Gold
    color(138, 43, 226),  // Blue violet
    color(255, 105, 180), // Hot pink
    color(0, 255, 255),   // Cyan
    color(255, 140, 0)    // Dark orange
  ];

  // Heights of buildings
  buildingHeights = [200, 300, 250, 220, 400, 180, 320, 270];
}

function draw() {
  drawNightSky(); // Nighttime sky with stars, moon, and auroras

  drawGround(); // Dark ground

  drawBuildings(); // Vibrant Edmonton skyline with glowing windows

  drawTrees(); // Green trees (triangles)

  drawCars(); // Add a few cars with headlights
}

// Function to draw the night sky with stars, moon, and auroras
function drawNightSky() {
  background(10, 10, 35); // Dark blue night sky

  // Draw stars
  for (let i = 0; i < 150; i++) {
    let x = random(width);
    let y = random(height / 2);
    fill(255, random(150, 255)); // White/yellowish stars with random brightness
    noStroke();
    ellipse(x, y, random(2, 5), random(2, 5));
  }

  // Draw the moon
  fill(240, 240, 200);
  noStroke();
  ellipse(650, 100, 80, 80); // Moon at the top-right

  // Draw auroras
  drawAurora(120, 180, 150); // Greenish aurora
  drawAurora(255, 105, 150); // Pink aurora
}

// Function to draw an aurora borealis with given hues
function drawAurora(hueLow, hueHigh, alpha) {
  noFill();
  for (let i = 0; i < 5; i++) {
    let hue = random(hueLow, hueHigh); // Randomized hues
    strokeWeight(8);
    stroke(color(0, hue, random(200, 255), alpha)); // Semi-transparent colors

    // Create wavy bands
    beginShape();
    for (let x = 0; x <= width; x += 20) {
      let y = map(noise(x * 0.01 + i, i), 0, 1, 50, 150) + i * 20;
      curveVertex(x, y);
    }
    endShape();
  }
}

// Function to draw the dark ground
function drawGround() {
  noStroke();
  fill(20, 50, 20); // Dark green ground
  rect(0, height - 50, width, 50);
}

// Function to draw vibrant buildings with glowing windows
function drawBuildings() {
  for (let i = 0; i < buildingHeights.length; i++) {
    let buildingWidth = 60;
    let x = 80 + i * (buildingWidth + 20);
    let y = height - 50 - buildingHeights[i];
    fill(buildingColors[i % buildingColors.length]); // Vibrant building colors
    rect(x, y, buildingWidth, buildingHeights[i]);

    // Add glowing windows
    drawWindows(x, y, buildingWidth, buildingHeights[i]);
  }
}

// Function to draw glowing windows for a building
function drawWindows(x, y, buildingWidth, buildingHeight) {
  fill(255, 255, 0); // Bright yellow windows
  for (let wy = y + 20; wy < y + buildingHeight; wy += 30) {
    for (let wx = x + 10; wx < x + buildingWidth - 10; wx += 20) {
      rect(wx, wy, 10, 10); // Small windows
    }
  }
}

// Function to draw green trees
function drawTrees() {
  fill(34, 139, 34); // Forest green for trees
  triangle(500, height - 50, 550, height - 200, 600, height - 50); // Left tree
  triangle(620, height - 50, 670, height - 180, 720, height - 50); // Right tree
}

// Function to draw cars with headlights
function drawCars() {
  fill(255, 0, 0); // Red car
  rect(150, height - 70, 40, 20);
  fill(0);
  ellipse(160, height - 50, 10, 10); // Left wheel
  ellipse(180, height - 50, 10, 10); // Right wheel

  // Headlights
  fill(255, 255, 100, 200); // Yellowish light
  ellipse(190, height - 65, 15, 5);

  fill(0, 0, 255); // Blue car
  rect(300, height - 70, 40, 20);
  fill(0);
  ellipse(310, height - 50, 10, 10); // Left wheel
  ellipse(330, height - 50, 10, 10); // Right wheel

  // Headlights
  fill(255, 255, 100, 200); // Yellowish light
  ellipse(340, height - 65, 15, 5);
}
