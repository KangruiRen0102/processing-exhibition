let stage = 0; // Current stage of metamorphosis
let progress = 0; // Transition progress
let caterpillarX = 50; // Initial position of the caterpillar
let butterflyX, butterflyY; // Position of the butterfly
let butterflyFlying = false; // Whether the butterfly is flying
let wingAngle = 0; // Wing flap angle

function setup() {
  createCanvas(800, 600);
  butterflyX = width / 2;
  butterflyY = height / 3 + 50;
}

function draw() {
  drawJungleBackground(); // Jungle background

  if (stage === 0) {
    // Stage 0: Caterpillar crawling
    drawCaterpillar(caterpillarX, height / 2 + 50);
    caterpillarX += 0.5; // Caterpillar crawls slowly
    if (caterpillarX > width / 2) { // Transition to chrysalis stage
      stage = 1;
      progress = 0;
    }
  } else if (stage === 1) {
    // Stage 1: Chrysalis hanging
    drawChrysalis(width / 2, height / 3);
    progress += 0.2; // Simulate time passing
    if (progress > 400) {
      stage = 2;
      progress = 0;
    }
  } else if (stage === 2) {
    // Stage 2: Emerging butterfly
    drawChrysalis(width / 2, height / 3);
    drawEmergingButterfly(width / 2, height / 3 + 50, progress / 200.0);
    progress += 1;
    if (progress >= 200) {
      stage = 3;
      butterflyFlying = true; // Butterfly begins to fly
    }
  } else if (stage === 3) {
    // Stage 3: Butterfly flying
    if (butterflyFlying) {
      butterflyX += random(-2, 2);
      butterflyY -= random(0, 1); // Butterfly flutters upward
      if (butterflyY < 0) butterflyY = height / 3 + 50; // Reset if flying too high
    }
    drawButterfly(butterflyX, butterflyY);
    animateWings(); // Wing flapping
  }
}

// Jungle background with trees, grass, and sky
function drawJungleBackground() {
  // Sky
  background(135, 206, 235);

  // Grass
  fill(34, 139, 34);
  rect(0, height / 2 + 50, width, height / 2 - 50);

  // Trees
  for (let i = 0; i < width; i += 150) {
    drawTree(i + 50, height / 2 - 50);
  }
}

// Tree with trunk and leaves
function drawTree(x, y) {
  // Trunk
  fill(139, 69, 19);
  rect(x - 15, y, 30, 100);

  // Leaves (canopy)
  fill(34, 139, 34);
  ellipse(x, y - 20, 100, 100);
  ellipse(x - 40, y, 70, 70);
  ellipse(x + 40, y, 70, 70);
}

function drawCaterpillar(x, y) {
  for (let i = 0; i < 6; i++) {
    fill(i % 2 === 0 ? color(50, 200, 50) : color(255, 255, 0));
    ellipse(x + i * 25, y, 30, 20); // Body segments
  }
  fill(50, 150, 50);
  ellipse(x - 15, y, 30, 20); // Head
  stroke(0);
  line(x - 20, y - 10, x - 30, y - 20); // Left antenna
  line(x - 10, y - 10, x, y - 20); // Right antenna
  noStroke();
}

function drawChrysalis(x, y) {
  fill(80, 150, 80);
  ellipse(x, y, 40, 60);
  stroke(50, 100, 50);
  line(x, y - 30, x, y - 50); // Attachment line
  noStroke();
}

function drawEmergingButterfly(x, y, scale) {
  fill(200, 100, 200, 150);
  push();
  translate(x, y);
  rotate(-PI / 4 * (1 - scale));
  ellipse(-30, -30, 60 * scale, 100 * scale); // Left wing
  rotate(PI / 2 * (1 - scale));
  ellipse(30, -30, 60 * scale, 100 * scale); // Right wing
  pop();
}

function drawButterfly(x, y) {
  push();
  translate(x, y);
  fill(200, 100, 200);
  rotate(wingAngle);
  ellipse(-40, 0, 80, 100); // Left wing
  ellipse(40, 0, 80, 100); // Right wing
  fill(150, 50, 150);
  ellipse(-40, 0, 60, 80); // Left inner wing
  ellipse(40, 0, 60, 80); // Right inner wing
  fill(50, 20, 50);
  rect(-5, -30, 10, 60); // Body
  stroke(0);
  line(-5, -30, -15, -50); // Left antenna
  line(5, -30, 15, -50); // Right antenna
  noStroke();
  pop();
}

function animateWings() {
  wingAngle = sin(frameCount * 0.2) * PI / 8; // Smooth wing flapping
}

function keyPressed() {
  if (key === 'r') {
    // Reset animation
    stage = 0;
    progress = 0;
    caterpillarX = 50;
    butterflyX = width / 2;
    butterflyY = height / 3 + 50;
    butterflyFlying = false;
  }
}
