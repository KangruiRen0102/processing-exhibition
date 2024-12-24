let cocoonStage = true;
let changeBackground = false;
let butterflyPos;
let rightTreeLeaves = [];
let rightLowerBranchLeaves = [];

function setup() {
  createCanvas(800, 600);
  butterflyPos = createVector(width / 2, height / 2);

  for (let i = 0; i < 50; i++) {
    rightTreeLeaves.push(createVector(random(450, 650), random(100, 250)));
  }

  for (let i = 0; i < 20; i++) {
    rightLowerBranchLeaves.push(createVector(random(500, 650), random(300, 400)));
  }
}

function draw() {
  drawForest();

  if (cocoonStage) {
    drawCocoon();
  } else {
    drawButterfly();
    followMouse();
  }
}

function drawForest() {
  if (changeBackground) {
    for (let i = 0; i < height; i++) {
      let inter = map(i, 0, height, 0, 1);
      stroke(255, 140 + inter * 60, 50 + inter * 150);
      line(0, i, width, i);
    }
  } else {
    for (let i = 0; i < height; i++) {
      let inter = map(i, 0, height, 0, 1);
      stroke(50, 100 + inter * 100, 50 + inter * 200);
      line(0, i, width, i);
    }
  }

  stroke(60, 40, 20);
  strokeWeight(10);
  line(600, height, 600, 250);

  strokeWeight(8);
  line(600, 250, 500, 150);
  line(600, 400, 700, 350);

  fill(34, 139, 34);
  noStroke();
  for (let leaf of rightTreeLeaves) {
    ellipse(leaf.x, leaf.y, 30, 20);
  }

  for (let leaf of rightLowerBranchLeaves) {
    ellipse(leaf.x, leaf.y, 40, 20);
  }
}

function drawCocoon() {
  stroke(100);
  strokeWeight(2);
  line(500, 150, 500, 200);

  fill(150, 100, 50);
  noStroke();
  ellipse(500, 200, 40, 80);
}

function drawButterfly() {
  noStroke();
  fill(50, 30, 20);
  rect(butterflyPos.x - 5, butterflyPos.y - 30, 10, 60, 5);

  ellipse(butterflyPos.x, butterflyPos.y - 40, 20, 20);

  stroke(50, 30, 20);
  strokeWeight(2);
  line(butterflyPos.x - 5, butterflyPos.y - 50, butterflyPos.x - 15, butterflyPos.y - 70);
  line(butterflyPos.x + 5, butterflyPos.y - 50, butterflyPos.x + 15, butterflyPos.y - 70);

  let wingFlap = sin(frameCount * 0.1) * 10;

  fill(200, 100, 255);
  ellipse(butterflyPos.x - 40, butterflyPos.y + wingFlap, 80, 100);
  ellipse(butterflyPos.x - 30, butterflyPos.y + 50 + wingFlap, 60, 80);

  ellipse(butterflyPos.x + 40, butterflyPos.y - wingFlap, 80, 100);
  ellipse(butterflyPos.x + 30, butterflyPos.y + 50 - wingFlap, 60, 80);
}

function followMouse() {
  let lerpSpeed = 0.05;
  butterflyPos.x = lerp(butterflyPos.x, mouseX, lerpSpeed);
  butterflyPos.y = lerp(butterflyPos.y, mouseY, lerpSpeed);
}

function mousePressed() {
  if (cocoonStage) {
    cocoonStage = false;
    changeBackground = !changeBackground;
  }
}
