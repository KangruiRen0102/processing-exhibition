let numCircles = 500;  // Number of chaotic circles
let glowLayers = 50;   // Layers for the glowing effect
let numParticles = 100; // Number of particles for hope
let maxDepth = 10;     // Maximum recursion depth for plant growth
let treeGrowth = 0;  // Progress of the tree growth
let isGrowing = true; // Control for tree growth

function setup() {
  createCanvas(800, 800);  // Set canvas size
  background(0);   // Black background
  frameRate(30);   // Set frame rate for interactivity
}

function draw() {
  background(0);    // Clear the screen each frame
  drawChaos();      // Background: Chaos
  drawHope();       // Middle layer: Hope
  drawGrowth(width / 2, height - 100, -90, 150, 10, floor(treeGrowth)); // Foreground: Growth

  if (isGrowing) {
    treeGrowth += 0.1; // Gradually grow the tree
    if (treeGrowth > maxDepth) {
      treeGrowth = maxDepth;
      isGrowing = false; // Stop growth when fully grown
    }
  }
}

function keyPressed() {
  if (key === 'r' || key === 'R') {
    treeGrowth = 0; // Reset tree growth
    isGrowing = true;
  }
}

function drawChaos() {
  noStroke();
  for (let i = 0; i < numCircles; i++) {
    let x = random(width);
    let y = random(height);
    let size = random(20, 80);
    fill(random(255), random(255), random(255), 80);  // Semi-transparent colors
    ellipse(x, y, size, size);
  }
}

function drawHope() {
  noStroke();
  let centerX = width / 2;
  let centerY = height / 2;

  // Glowing central light
  for (let i = 0; i < glowLayers; i++) {
    let size = 20 + i * 20;
    let alpha = 255 - (i * 5);
    fill(255, 200, 50, alpha);  // Gradient from yellow to dim orange
    ellipse(centerX, centerY, size, size);
  }

  // Glowing particles
  for (let i = 0; i < numParticles; i++) {
    let x = random(width);
    let y = random(height);
    let size = random(10, 30);
    fill(255, 230, 80, random(80, 180));  // Light yellow particles
    ellipse(x, y, size, size);
  }
}

function drawGrowth(x, y, angle, length, thickness, depth) {
  if (depth === 0) return;  // Base case: stop recursion

  // Calculate end point of branch
  let xEnd = x + cos(radians(angle)) * length;
  let yEnd = y + sin(radians(angle)) * length;

  // Draw branch
  strokeWeight(thickness);
  stroke(34, 139, 34, 200);  // Green branches
  line(x, y, xEnd, yEnd);

  // Recursively draw smaller branches
  drawGrowth(xEnd, yEnd, angle - 30, length * 0.7, thickness * 0.7, depth - 1);
  drawGrowth(xEnd, yEnd, angle + 30, length * 0.7, thickness * 0.7, depth - 1);

  // Add leaves
  if (depth === 1) {
    for (let i = 0; i < 10; i++) {
      let leafX = xEnd + random(-10, 10);
      let leafY = yEnd + random(-10, 10);
      let size = random(5, 15);
      fill(50, random(150, 200), 50, 150);  // Shades of green
      noStroke();
      ellipse(leafX, leafY, size, size);
    }
  }
}
