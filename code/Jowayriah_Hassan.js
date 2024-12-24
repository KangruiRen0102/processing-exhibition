let motherX, motherY, childX, childY;
let orbX, orbY, orbSize;
let animationRunning = true;
let childGrowing = false;
let bgBrightness = 0;
let childScale = 1.0;

function setup() {
  createCanvas(800, 600);
  motherX = width / 4;
  motherY = height / 2 + 50;
  childX = width / 2 + 150;
  childY = height / 2 + 50;
  orbX = motherX;
  orbY = motherY - 20;
  orbSize = 30;
  textAlign(CENTER, CENTER);
}

function draw() {
  // Draw the house interior
  drawHouseInterior();

  // Draw mother and child
  drawMother(motherX, motherY);
  push();
  translate(childX, childY);
  scale(childScale);
  drawChild(0, 0);
  pop();

  // Draw the glowing orb
  drawOrb(orbX, orbY, orbSize);

  // Draw labels and instructions
  drawLabels();

  // Animation logic
  if (animationRunning) {
    orbX = lerp(orbX, childX, 0.02);
    orbY = lerp(orbY, childY - 60, 0.02);

    if (dist(orbX, orbY, childX, childY - 60) < 50) {
      childGrowing = true;
    }

    if (dist(orbX, orbY, childX, childY - 60) < 2) {
      animationRunning = false;
    }
  }

  if (childGrowing) {
    childScale = lerp(childScale, 1.5, 0.01);
    bgBrightness = lerp(bgBrightness, 255, 0.01);
  }

  if (!animationRunning) {
    fill(0, 0, 0, 150);
    text("Click to Restart", width / 2, height - 50);
  }
}

function drawHouseInterior() {
  // Striped wallpaper
  for (let i = 0; i < width; i += 20) {
    fill(i % 40 === 0 ? color(240, 220, 200) : color(250, 240, 230));
    rect(i, 0, 20, height - 100);
  }

  // Floor
  fill(139, 69, 19);
  rect(0, height - 100, width, 100);

  // Window
  drawWindow(width / 2 - 160, 100);

  // Couch
  drawCouch(width / 4, height - 150);
}

function drawWindow(x, y) {
  fill(100, 60, 40);
  rect(x - 10, y - 10, 320, 220);

  fill(173, 216, 230);
  rect(x, y, 300, 200);

  stroke(139, 69, 19);
  strokeWeight(4);
  line(x, y + 100, x + 300, y + 100);
  line(x + 100, y, x + 100, y + 200);
  line(x + 200, y, x + 200, y + 200);
}

function drawCouch(x, y) {
  fill(100, 70, 50);
  rect(x - 140, y - 50, 280, 50);
  rect(x - 140, y - 110, 280, 60);

  fill(80, 50, 40);
  rect(x - 160, y - 110, 20, 110);
  rect(x + 140, y - 110, 20, 110);

  fill(140, 90, 60);
  rect(x - 110, y - 100, 60, 40);
  rect(x - 30, y - 100, 60, 40);
  rect(x + 50, y - 100, 60, 40);
}

function drawMother(x, y) {
  fill(255, 200, 150);
  ellipse(x, y - 60, 50, 50);

  drawEyes(x, y - 60, 10, 5);

  fill(255, 111, 97);
  ellipse(x, y, 60, 100);

  fill(255, 200, 150);
  ellipse(x - 40, y - 20, 20, 20);
  ellipse(x + 40, y - 20, 20, 20);

  noFill();
  stroke(0);
  strokeWeight(2);
  arc(x, y - 60, 30, 20, 0, PI);
}

function drawChild(x, y) {
  fill(255, 230, 180);
  ellipse(x, y - 60, 40, 40);

  drawEyes(x, y - 60, 8, 4);

  fill(255, 215, 0);
  ellipse(x, y, 50, 80);

  noFill();
  stroke(0);
  strokeWeight(1.5);
  arc(x, y - 60, 20, 15, 0, PI);
}

function drawEyes(x, y, eyeWidth, pupilSize) {
  fill(255);
  ellipse(x - 10, y - 5, eyeWidth, eyeWidth);
  ellipse(x + 10, y - 5, eyeWidth, eyeWidth);

  let dx = orbX - x;
  let dy = orbY - y;
  let angle = atan2(dy, dx);
  let pupilOffset = 3;

  fill(0);
  ellipse(x - 10 + pupilOffset * cos(angle), y - 5 + pupilOffset * sin(angle), pupilSize, pupilSize);
  ellipse(x + 10 + pupilOffset * cos(angle), y - 5 + pupilOffset * sin(angle), pupilSize, pupilSize);
}

function drawOrb(x, y, size) {
  for (let i = 5; i > 0; i--) {
    noStroke();
    fill(255, 255, 255, map(i, 5, 0, 50, 0));
    ellipse(x, y, size + i * 10, size + i * 10);
  }
  fill(255);
  ellipse(x, y, size, size);
}

function drawLabels() {
  fill(0);
  textSize(18);
  text("Mother", motherX, motherY - 120);
  text("Child", childX, childY - 120);
}

function mousePressed() {
  if (!animationRunning) {
    resetAnimation();
  }
}

function resetAnimation() {
  orbX = motherX;
  orbY = motherY - 20;
  childScale = 1.0;
  bgBrightness = 0;
  childGrowing = false;
  animationRunning = true;
}
