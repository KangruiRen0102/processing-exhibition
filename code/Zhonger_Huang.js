let numStructures = 5; // Number of city structures to be drawn
let xPositions = [];
let yPositions = [];
let structureWidths = [];
let structureHeights = [];
let auroraColor1, auroraColor2;

function setup() {
  createCanvas(800, 600);

  // Initialize the position and sizes of the structures
  for (let i = 0; i < numStructures; i++) {
    xPositions[i] = random(width);
    yPositions[i] = random(height / 2, height); // Only in the lower half to keep the sky clear
    structureWidths[i] = random(50, 150);
    structureHeights[i] = random(100, 300);
  }

  auroraColor1 = color(0, 255, 180, 150); // Light cyan
  auroraColor2 = color(255, 100, 255, 150); // Light purple
}

function draw() {
  background(0); // Black background to symbolize the infinite night sky

  // Draw the aurora borealis effect
  drawAurora();

  // Draw civil and environmental engineering structures
  drawStructures();
}

function drawAurora() {
  // Simulate the shifting aurora colors in the sky
  noStroke();
  let auroraWave = sin(millis() * 0.0005) * 100; // Simulate a slow wave effect in aurora movement
  for (let i = 0; i < width; i++) {
    let alpha = map(sin(i * 0.02 + millis() * 0.002), -1, 1, 50, 255);
    if (i % 2 === 0) {
      fill(red(auroraColor1), green(auroraColor1), blue(auroraColor1), alpha);
    } else {
      fill(red(auroraColor2), green(auroraColor2), blue(auroraColor2), alpha);
    }
    ellipse(i, height / 3 + auroraWave, random(10, 50), random(50, 150)); // Create floating aurora patterns
  }
}

function drawStructures() {
  // Simulate civil engineering structures blending with nature
  for (let i = 0; i < numStructures; i++) {
    fill(100, 100, 200, 200); // Blue structures, to represent human-built engineering
    rect(xPositions[i], yPositions[i], structureWidths[i], structureHeights[i]);

    // Add a small environmental touch, like trees (represented by simple circles)
    if (i % 2 === 0) {
      fill(34, 139, 34); // Green color for trees
      ellipse(
        xPositions[i] + structureWidths[i] / 2,
        yPositions[i] - 30,
        30,
        30
      ); // Tree on top of the structure
    }
  }

  // Add a river flowing through the bottom of the screen to represent the environmental aspect
  fill(0, 0, 255, 150); // Water color
  beginShape();
  for (let i = 0; i < width; i++) {
    let riverY = height - 50 + sin(i * 0.05 + millis() * 0.003) * 10; // River waves
    vertex(i, riverY);
  }
  endShape(CLOSE);
}
