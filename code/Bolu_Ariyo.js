// Global variables for detailed aurora and interactivity
let auroraColors;
let waveOffset = 0;
let currentAuroraColor = 0;
let auroraLayer;
let stars = [];

function setup() {
  createCanvas(1000, 600);
  auroraColors = [
    color(0, 255, 255, 255), // Brighter cyan
    color(255, 0, 255, 255), // Brighter magenta
    color(0, 255, 100, 255), // Brighter green
    color(255, 200, 50, 255) // Brighter yellow-orange
  ];
  auroraLayer = createGraphics(width, height);
  generateStars();
}

function draw() {
  drawBackground();
  drawDetailedAurora();
  drawStars();
  drawBigTwilightStar();
  drawSea();
}

// Draw a twilight gradient background
function drawBackground() {
  for (let y = 0; y < height; y++) {
    let t = map(y, 0, height, 0, 1);
    let skyColor = lerpColor(color(25, 25, 112), color(72, 61, 139), t);
    stroke(skyColor);
    line(0, y, width, y);
  }
}

// Draw the detailed aurora
function drawDetailedAurora() {
  auroraLayer.clear();
  auroraLayer.noFill();

  // Create multiple layers of aurora for depth
  for (let layer = 0; layer < 12; layer++) {
    auroraLayer.stroke(
      lerpColor(
        auroraColors[(currentAuroraColor + layer) % auroraColors.length],
        color(0),
        0.1
      )
    ); // Subtle transparency for better blending
    auroraLayer.strokeWeight(3 + layer * 0.5); // Slightly thicker for prominence
    auroraLayer.beginShape();

    for (let x = 0; x < width; x += 3) {
      let y =
        height / 2 -
        layer * 15 +
        noise((x + mouseX) * 0.01, waveOffset + layer * 0.2) * 150 +
        40 * sin((x + mouseX) * 0.05 + waveOffset);
      auroraLayer.curveVertex(x, y);
    }
    auroraLayer.endShape();
  }

  image(auroraLayer, 0, 0);
  waveOffset += 0.01; // Animate aurora
}

// Draw the moving sea at the bottom
function drawSea() {
  noStroke();
  for (let y = height - 100; y < height; y++) {
    let t = map(y, height - 100, height, 0, 1);
    fill(lerpColor(color(0, 0, 139), color(0, 191, 255), t));
    beginShape();
    for (let x = 0; x <= width; x += 10) {
      let waveHeight = 10 * sin((x + waveOffset * 100) * 0.02 + t * 5);
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// Draw twinkling stars
function drawStars() {
  for (let star of stars) {
    fill(255, random(200, 255));
    noStroke();
    ellipse(star.x, star.y, random(3, 5), random(3, 5));
  }
}

// Draw a single large twilight star in the top-right corner
function drawBigTwilightStar() {
  let x = width - 100;
  let y = 100;
  fill(255, 220, 150, 200);
  noStroke();

  // Draw glowing layers for the star
  for (let i = 40; i > 0; i -= 10) {
    fill(255, 220 + i, 150 + i, 150 - i * 3);
    ellipse(x, y, i * 2, i * 2);
  }

  // Draw the diamond shape
  fill(255, 255, 255, 255);
  beginShape();
  vertex(x, y - 20); // Top point
  vertex(x + 15, y); // Right point
  vertex(x, y + 20); // Bottom point
  vertex(x - 15, y); // Left point
  endShape(CLOSE);
}

// Generate random stars
function generateStars() {
  for (let i = 0; i < 600; i++) {
    stars.push(createVector(random(width), random(height)));
  }
}

// Change aurora colors on mouse click
function mousePressed() {
  currentAuroraColor = (currentAuroraColor + 1) % auroraColors.length;
  // Add more stars for extra sparkle effect
  generateStars();
}
