let boatX, boatY; // Position of the boat
let lightX, lightY; // Position of the heavenly light
let speed = 0.7; // Speed of the boat following the cursor

// Cloud data
let cloudCount = 6; // Number of clouds
let cloudX = [];
let cloudY = [];
let cloudSpeed = [];
let cloudSize = [];
let cloudShape = [];
let puffOffsetX = [];
let puffOffsetY = [];
let puffSizes = [];

let oarAngle = 0; // Current angle of the oars
let oarSpeed = 0.1; // Speed of the rowing animation

// Rain data
let rainCount = 100; // Number of rain drops
let rainX = [];
let rainY = [];
let rainSpeed = [];

// Water wave data
let waveCount = 10; // Number of waves
let waveSpeed = 0.02;
let waveOffset = 0;

function setup() {
  createCanvas(800, 600);
  boatX = width / 2;
  boatY = height / 2;

  // Initialize cloud positions, sizes, speeds, and shapes
  for (let i = 0; i < cloudCount; i++) {
    initializeCloud(i);
  }

  // Initialize rain positions and speeds
  for (let i = 0; i < rainCount; i++) {
    rainX[i] = random(width);
    rainY[i] = random(height);
    rainSpeed[i] = random(4, 8); // Rain falls at different speeds
  }
}

function draw() {
  background(20, 24, 82); // Night sky (dark blue)

  // Draw the moon
  drawMoon();

  // Draw the clouds and make them drift
  drawClouds();

  // Draw the rain
  drawRain();

  // Draw the ocean waves
  drawWaves();

  // Move the boat toward the cursor with smooth movement
  let dx = mouseX - boatX;
  let dy = mouseY - boatY;
  let distance = sqrt(dx * dx + dy * dy); // Distance to the cursor
  if (distance > 1) {
    let moveX = (dx / distance) * speed;
    let moveY = (dy / distance) * speed;
    boatX += moveX;
    boatY += moveY;
  }

  // Prevent the boat from going above the horizon (y-position)
  boatY = constrain(boatY, height / 2, height);

  // Position the heavenly light at the cursor
  lightX = mouseX;
  lightY = mouseY;

  // Get the maximum y-position of the waves
  let maxWaveY = height / 2 + (waveCount - 1) * 15 + 5;

  // Prevent the boat from going below the bottom-most wave
  boatY = constrain(boatY, height / 2, maxWaveY - 20);

  // Draw the boat
  drawBoat(boatX, boatY, color(255, 0, 0));

  // Draw the heavenly light
  drawLight(lightX, lightY);

  // Update wave offset for animation
  waveOffset += waveSpeed;
}

function drawBoat(x, y, c) {
  fill(139, 69, 19); // Brown color for the boat hull
  beginShape();
  vertex(x - 40, y + 50);
  vertex(x + 40, y + 50);
  vertex(x + 60, y + 20);
  vertex(x - 60, y + 20);
  endShape(CLOSE);

  // Mast
  stroke(0);
  strokeWeight(4);
  line(x, y + 20, x, y - 40);

  // Sail
  fill(255);
  noStroke();
  beginShape();
  vertex(x, y);
  vertex(x + 40, y - 40);
  vertex(x - 40, y - 40);
  endShape(CLOSE);
}

function drawMoon() {
  noStroke();
  fill(255, 255, 224);
  ellipse(width - 100, 100, 80, 80);
}

function initializeCloud(index) {
  cloudX[index] = random(width);
  cloudY[index] = random(50, height / 3);
  cloudSpeed[index] = random(0.2, 1);
  cloudSize[index] = random(30, 80);
  cloudShape[index] = int(random(3, 6));

  puffOffsetX[index] = [];
  puffOffsetY[index] = [];
  puffSizes[index] = [];
  for (let j = 0; j < cloudShape[index]; j++) {
    puffOffsetX[index][j] = random(-cloudSize[index] * 0.5, cloudSize[index] * 0.5);
    puffOffsetY[index][j] = random(-cloudSize[index] * 0.3, cloudSize[index] * 0.3);
    puffSizes[index][j] = random(cloudSize[index] * 0.6, cloudSize[index]);
  }
}

function drawClouds() {
  for (let i = 0; i < cloudCount; i++) {
    drawCloud(cloudX[i], cloudY[i], puffOffsetX[i], puffOffsetY[i], puffSizes[i], cloudShape[i]);
    cloudX[i] += cloudSpeed[i];
    if (cloudX[i] > width + 50) {
      initializeCloud(i);
      cloudX[i] = -50;
    }
  }
}

function drawCloud(x, y, offsetX, offsetY, sizes, puffs) {
  noStroke();
  fill(100, 100, 100, 200);
  for (let i = 0; i < puffs; i++) {
    ellipse(x + offsetX[i], y + offsetY[i], sizes[i], sizes[i] * 0.6);
  }
}

function drawWaves() {
  fill(10, 10, 50);
  rect(0, height / 2, width, height / 2);

  for (let i = 0; i < waveCount; i++) {
    let waveHeight = height / 2 + i * 15;
    stroke(173, 216, 230, 150);
    strokeWeight(2);
    noFill();
    beginShape();
    for (let x = 0; x < width; x += 10) {
      let y = waveHeight + sin((x * 0.05) + waveOffset + i) * 5;
      vertex(x, y);
    }
    endShape();
  }
}

function drawRain() {
  stroke(200, 200, 255, 150);
  strokeWeight(2);
  for (let i = 0; i < rainCount; i++) {
    line(rainX[i], rainY[i], rainX[i] + 2, rainY[i] + 10);
    rainY[i] += rainSpeed[i];
    if (rainY[i] > height) {
      rainY[i] = random(-50, 0);
      rainX[i] = random(width);
    }
  }
}

function drawLight(x, y) {
  noStroke();
  fill(255, 255, 224, 200);
  ellipse(x, y, 60, 60);
}
