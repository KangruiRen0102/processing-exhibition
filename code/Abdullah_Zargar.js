let waveOffset = 0;
let valleyWaveOffset = 0;
let gateOpen = false;
let valleyDraining = false;
let reservoirWaterLevel = 80;
let valleyWaterLevel = -10;
let damHeight = 100;

let cloudCount = 3;
let cloudX = [100, 220, 550];
let cloudY = [50, 80, 40];
let rainDropCount = 35;
let rainDropX = [];
let rainDropY = [];

let mountainHeight = 280;
let mountainCount = 3;
let mountainX = [-50, 200, 500];

let sunX = 600;
let sunY = 100;
let sunRadius = 50;

function setup() {
  createCanvas(800, 400);

  for (let i = 0; i < rainDropCount; i++) {
    let cloudIndex = int(random(cloudCount));
    rainDropX[i] = random(cloudX[cloudIndex] - 50, cloudX[cloudIndex] + 50);
    rainDropY[i] = random(cloudY[cloudIndex] + 20, cloudY[cloudIndex] + 50);
  }
}

function draw() {
  background(135, 206, 235);

  drawMountains();
  drawSun();
  drawSeaAndValley();
  drawDam();
  drawCloudsAndRaindrops();

  if (gateOpen) {
    drawWaterFlow();
  }

  if (valleyDraining) {
    drainValley();
  }

  if (!gateOpen && reservoirWaterLevel < damHeight) {
    reservoirWaterLevel += 0.1;
  }
}

function drawSeaAndValley() {
  fill(0, 0, 255);
  noStroke();

  for (let x = 0; x < width / 2; x += 10) {
    let y = 320 - min(reservoirWaterLevel, damHeight) + 10 * sin((x + waveOffset) * 0.05);
    rect(x, y, 10, height - y);
  }

  for (let x = width / 2; x < width; x += 10) {
    let y = height - valleyWaterLevel + 5 * sin((x + valleyWaveOffset) * 0.05);
    rect(x, y, 10, height - y);
  }

  waveOffset += 1.5;

  if (gateOpen) {
    valleyWaveOffset += 1.5;
    valleyWaterLevel = min(valleyWaterLevel + 0.5, 150);
    reservoirWaterLevel = max(reservoirWaterLevel - 0.5, 0);
  }
}

function drawDam() {
  fill(150);
  stroke(0);
  strokeWeight(2);

  beginShape();
  vertex(width / 2 - 50, 200);
  vertex(width / 2 + 50, 200);
  vertex(width / 2 + 80, 400);
  vertex(width / 2 - 80, 400);
  endShape(CLOSE);
}

function drawWaterFlow() {
  fill(0, 0, 255);
  noStroke();

  beginShape();
  vertex(width / 2 + 50, 250);
  vertex(width / 2 + 50, 400);
  vertex(width / 2 + 80, 400);
  endShape(CLOSE);
}

function drainValley() {
  valleyWaterLevel = max(valleyWaterLevel - 1, 0);

  if (valleyWaterLevel === 0) {
    valleyDraining = false;
  }
}

function mousePressed() {
  if (!gateOpen && !valleyDraining) {
    gateOpen = true;
  } else if (gateOpen && !valleyDraining) {
    gateOpen = false;
    valleyDraining = true;
  }
}

function drawCloudsAndRaindrops() {
  fill(255);
  noStroke();

  for (let i = 0; i < cloudCount; i++) {
    ellipse(cloudX[i], cloudY[i], 100, 50);
    ellipse(cloudX[i] + 30, cloudY[i] - 10, 80, 40);
    ellipse(cloudX[i] - 40, cloudY[i] - 10, 80, 40);
  }

  stroke(0, 0, 255);

  for (let i = 0; i < rainDropCount; i++) {
    let x = rainDropX[i];
    let y = rainDropY[i];

    line(x, y, x, y + 3);
    rainDropY[i] += 1;

    if (rainDropY[i] > height) {
      let cloudIndex = int(random(cloudCount));
      rainDropY[i] = random(cloudY[cloudIndex] + 20, cloudY[cloudIndex] + 50);
    }
  }
}

function drawMountains() {
  fill(34, 139, 34);
  noStroke();

  for (let i = 0; i < mountainCount; i++) {
    beginShape();
    vertex(mountainX[i], height);
    vertex(mountainX[i] + 200, height - mountainHeight);
    vertex(mountainX[i] + 400, height);
    endShape(CLOSE);
  }
}

function drawSun() {
  fill(255, 223, 0);
  noStroke();
  ellipse(sunX, sunY, sunRadius * 2, sunRadius * 2);
}
