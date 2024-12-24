let bodyColor;
let cocoonBroken = false;

// Movement for clouds variables
let cloud1X = 150, cloud2X = 400, cloud3X = 550;
let cloudSpeed = 0.3;

// Color for cocoon
let cocoonColor;

// Tree properties
let treeX, treeHeight = 250;
let branchLength = 120;
let branchHeight = -70;

function setup() {
  createCanvas(600, 600); // Set canvas size
  noStroke();
  bodyColor = color(0, 0, 0);
  cocoonColor = color(210, 180, 140);
  treeX = width / 2 - 50;
}

function draw() {
  background(135, 206, 235); // Blue sky

  // Draw elements
  drawClouds();
  drawGrass();
  drawFlowers();
  drawTree();

  if (!cocoonBroken) {
    drawCocoon(); // Cocoon is displayed if not broken
  } else {
    drawButterfly(); // Butterfly is displayed if cocoon is broken
  }
}

// Draw the tree
function drawTree() {
  // Trunk
  fill(139, 69, 19);
  rect(treeX, height - 90 - treeHeight, 50, treeHeight);

  // Tree top
  fill(34, 139, 34);
  ellipse(treeX + 25, height - 90 - treeHeight - 60, 280, 200);

  // Tree branch
  stroke(139, 69, 19);
  strokeWeight(8);
  line(treeX - branchLength, height - 90 - treeHeight + branchHeight, 
       treeX + 50 + branchLength, height - 90 - treeHeight + branchHeight);
  noStroke();
}

// Draw the cocoon
function drawCocoon() {
  fill(cocoonColor);
  ellipse(treeX + 50, height - 90 - treeHeight + branchHeight, 40, 60);
}

// Draw the butterfly
function drawButterfly() {
  // Wing color changes with mouse movement
  let wingColor = color(map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 0, 255), 255);

  // Wings
  fill(wingColor);
  ellipse(mouseX - 25, mouseY - 20, 60, 80);
  ellipse(mouseX - 25, mouseY + 20, 60, 80);
  ellipse(mouseX + 25, mouseY - 20, 60, 80);
  ellipse(mouseX + 25, mouseY + 20, 60, 80);

  // Body
  bodyColor = color(map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 0, 255), 0);
  fill(bodyColor);
  rect(mouseX - 4, mouseY - 60, 8, 120);
}

// Draw the clouds
function drawClouds() {
  fill(255, 255, 255, 200);

  // Update cloud positions
  cloud1X += cloudSpeed;
  cloud2X += cloudSpeed;
  cloud3X += cloudSpeed;

  // Loop clouds back
  if (cloud1X > width) cloud1X = -180;
  if (cloud2X > width) cloud2X = -200;
  if (cloud3X > width) cloud3X = -150;

  // Draw clouds
  ellipse(cloud1X, 100, 180, 100);
  ellipse(cloud2X, 120, 200, 120);
  ellipse(cloud3X, 80, 150, 90);
}

// Draw the grass
function drawGrass() {
  fill(34, 139, 34);
  rect(0, height - 90, width, 90);
}

// Draw flowers
function drawFlowers() {
  fill(255, 0, 0);
  ellipse(100, height - 60, 30, 30);
  ellipse(200, height - 70, 30, 30);
  ellipse(300, height - 50, 30, 30);
  ellipse(400, height - 70, 30, 30);
  ellipse(500, height - 60, 30, 30);

  fill(255, 255, 0);
  ellipse(100, height - 60, 15, 15);
  ellipse(200, height - 70, 15, 15);
  ellipse(300, height - 50, 15, 15);
  ellipse(400, height - 70, 15, 15);
  ellipse(500, height - 60, 15, 15);
}

// Handle key presses to break the cocoon
function keyPressed() {
  if (!cocoonBroken) {
    cocoonBroken = true;
  }
}
