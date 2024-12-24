let maxDepth = 7; // Maximum branching depth
let baseBranchLength = 80; // Initial branch length
let growthFactor = 1; // Controls tree growth over time
let angleOffset; // Branching angle
let sunY = 600; // Starting position of the sun
let isClearing = false; // Tracks if the spacebar is held to clear clouds
let rainDrops = []; // Stores raindrop positions
let numRainDrops = 200; // Number of raindrops

// White clouds for spacebar interaction
let whiteClouds = [];
let numWhiteClouds = 10;
let whiteCloudSpeeds = [];

function setup() {
  createCanvas(800, 600);
  noStroke();
  angleOffset = QUARTER_PI / 3;

  // Initialize raindrops
  for (let i = 0; i < numRainDrops; i++) {
    rainDrops.push(createVector(random(width), random(height / 2)));
  }

  // Initialize white clouds
  for (let i = 0; i < numWhiteClouds; i++) {
    whiteClouds.push(createVector(random(width), random(100, 300)));
    whiteCloudSpeeds.push(random(1, 3));
  }
}

function draw() {
  // Sky background
  let skyColor = isClearing
    ? lerpColor(color(30, 30, 90), color(135, 206, 235), map(sunY, height, 100, 0, 1))
    : color(20, 20, 50);
  background(skyColor);

  // Draw the sun
  if (isClearing) {
    let sunSize = isClearing ? 120 : 80;
    let sunBrightness = isClearing ? 255 : 200;
    fill(sunBrightness, 204, 0);
    ellipse(width / 2, sunY, sunSize, sunSize);
    if (sunY > 100) sunY -= isClearing ? 1.5 : 0.5;
  }

  // Draw dark clouds and rain
  if (!isClearing) {
    drawClouds();
    drawRain();
  }

  // Draw white clouds
  if (isClearing) {
    drawWhiteClouds();
  }

  // Draw growing tree
  push();
  translate(width / 2, height);
  drawBranch(baseBranchLength * growthFactor, 0);
  pop();

  // Simulate tree growth
  if (growthFactor < 1.5) growthFactor += 0.005;
}

function drawBranch(length, depth) {
  if (depth === maxDepth) return;

  // Draw the branch
  stroke(139, 69, 19, 255 - depth * 30);
  strokeWeight(max(1, maxDepth - depth));
  line(0, 0, 0, -length);
  translate(0, -length);

  // Draw child branches recursively
  let newLength = length * 0.7;
  push();
  rotate(-angleOffset);
  drawBranch(newLength, depth + 1);
  pop();

  push();
  rotate(angleOffset);
  drawBranch(newLength, depth + 1);
  pop();

  if (depth > 1) {
    push();
    rotate(angleOffset / 2);
    drawBranch(newLength * 0.8, depth + 1);
    pop();
  }

  // Draw leaves at the end of branches
  if (depth > 2) {
    drawLeaves(length, depth);
  }
}

function drawLeaves(branchLength, depth) {
  let leafSize = map(branchLength, 10, baseBranchLength, 2, 10) * growthFactor;
  if (isClearing) leafSize *= 1.5;
  fill(34, 139, 34, 200);
  for (let i = 0; i < 3; i++) {
    let angle = random(-PI / 6, PI / 6);
    let x = cos(angle) * leafSize * random(1, 1.5);
    let y = sin(angle) * leafSize * random(1, 1.5);
    ellipse(x, y, leafSize, leafSize * 1.2);
  }
}

function drawClouds() {
  fill(50, 50, 50, 200);
  for (let i = 0; i < 5; i++) {
    ellipse(i * 200 - 100, 100, 300, 100);
  }
}

function drawRain() {
  stroke(100, 100, 255, 150);
  strokeWeight(2);
  for (let drop of rainDrops) {
    line(drop.x, drop.y, drop.x, drop.y + 10);
    drop.y += 5;
    if (drop.y > height) {
      drop.y = random(-20, 0);
      drop.x = random(width);
    }
  }
}

function drawWhiteClouds() {
  fill(255, 255, 255, 200);
  for (let i = 0; i < whiteClouds.length; i++) {
    ellipse(whiteClouds[i].x, whiteClouds[i].y, 100, 50);
    whiteClouds[i].x += whiteCloudSpeeds[i];
    if (whiteClouds[i].x > width + 50) {
      whiteClouds[i].x = -50;
    }
  }
}

function keyPressed() {
  if (key === ' ') {
    isClearing = true;
  }
}

function keyReleased() {
  if (key === ' ') {
    isClearing = false;
  }
}
