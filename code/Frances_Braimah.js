let numParticles = 500;
let particleX = [];
let particleY = [];
let particleSize = [];
let particleSpeed = [];
let isBouncing = false;
let isGrow = false;
let particleSpeedMultiplier = 1.0;

let numBlooms = 30;
let bloomX = [];
let bloomY = [];
let bloomSize = [];
let bloomAngle = [];
let petalAngle = [];
let petalSpeed = [];
let bloomGrowth = [];
let bloomOpacity = [];
let bloomColors = [];
let petalColors = [];
let rotationAngle = [];

let hours, minutes, seconds;
let showWelcomeScreen = true;
let colorOffset = 0;

function setup() {
  createCanvas(800, 600);
  noStroke();

  for (let i = 0; i < numParticles; i++) {
    particleX[i] = random(width);
    particleY[i] = random(height);
    particleSize[i] = random(2, 5);
    particleSpeed[i] = random(0.5, 2);
  }

  for (let i = 0; i < numBlooms; i++) {
    bloomX[i] = random(width);
    bloomY[i] = random(height);
    bloomSize[i] = random(30, 60);
    bloomAngle[i] = random(TWO_PI);
    petalAngle[i] = random(TWO_PI);
    petalSpeed[i] = random(0.01, 0.05);
    bloomGrowth[i] = 1;
    bloomOpacity[i] = 0;
    rotationAngle[i] = 0;
    bloomColors[i] = color(random(150, 255), random(150, 255), random(150, 255));
    petalColors[i] = color(random(150, 255), random(150, 255), random(255));
  }
}

function draw() {
  if (showWelcomeScreen) {
    drawWelcomeScreen();
    return;
  }

  fill(20, 30);
  rect(0, 0, width, height);

  drawAurora();
  drawBlooms();
  drawParticles();
  drawTimeDisplay();
}

function drawWelcomeScreen() {
  for (let i = 0; i < height; i++) {
    let lerpValue = map(i, 0, height, 0, 1);
    let gradientColor = lerpColor(
      color(255, 102, 178 + sin(colorOffset) * 50),
      color(51 + cos(colorOffset) * 50, 153, 255),
      lerpValue
    );
    fill(gradientColor);
    rect(0, i, width, 1);
  }
  colorOffset += 0.02;

  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Welcome to the Bloom Garden", width / 2, height / 2 - 20);
  textSize(20);
  text("Press any key to start", width / 2, height / 2 + 40);
}

function keyPressed() {
  if (showWelcomeScreen) {
    showWelcomeScreen = false;
    return;
  }

  if (key === 'B' || key === 'b') {
    isGrow = !isGrow;
  }

  if (key === 'S' || key === 's') {
    isBouncing = !isBouncing;
  }

  if (key === 'P' || key === 'p') {
    particleSpeedMultiplier = (particleSpeedMultiplier === 1.0) ? 1.5 : 1.0;
  }
}

function drawAurora() {
  for (let i = 0; i < height; i++) {
    let lerpValue = map(i, 0, height, 0, 1);
    let auroraColor = lerpColor(color(62, 6, 95), color(107, 47, 221), lerpValue);
    fill(auroraColor, 80);
    rect(0, i, width, 1);
  }
}

function drawBlooms() {
  for (let i = 0; i < numBlooms; i++) {
    let sparkleFactor = random(0.8, 1.2);

    if (isGrow) {
      bloomGrowth[i] = lerp(bloomGrowth[i], 2 * sparkleFactor, 0.1);
    } else {
      bloomGrowth[i] = lerp(bloomGrowth[i], 1 * sparkleFactor, 0.1);
    }

    bloomOpacity[i] = lerp(bloomOpacity[i], 255, 0.1);
    rotationAngle[i] = lerp(rotationAngle[i], 0, 0.1);

    push();
    translate(bloomX[i], bloomY[i]);
    rotate(rotationAngle[i]);

    fill(bloomColors[i], bloomOpacity[i] * sparkleFactor);
    ellipse(0, 0, bloomSize[i] * bloomGrowth[i] / 3, bloomSize[i] * bloomGrowth[i] / 3);

    let numPetals = 12;
    let angleStep = TWO_PI / numPetals;
    for (let j = 0; j < numPetals; j++) {
      let petalX = cos(petalAngle[i] + j * angleStep) * bloomSize[i] * bloomGrowth[i] / 2;
      let petalY = sin(petalAngle[i] + j * angleStep) * bloomSize[i] * bloomGrowth[i] / 2;
      fill(petalColors[i], bloomOpacity[i] * sparkleFactor);
      ellipse(petalX, petalY, bloomSize[i] * bloomGrowth[i] / 4, bloomSize[i] * bloomGrowth[i] / 2);
    }
    pop();

    petalAngle[i] += petalSpeed[i];
  }
}

function drawParticles() {
  for (let i = 0; i < numParticles; i++) {
    if (isBouncing) {
      if (particleX[i] <= 0 || particleX[i] >= width) {
        particleSpeed[i] *= -1;
      }
      if (particleY[i] <= 0 || particleY[i] >= height) {
        particleSpeed[i] *= -1;
      }
    }

    particleX[i] += cos(frameCount * 0.01 + i) * particleSpeed[i] * particleSpeedMultiplier;
    particleY[i] += sin(frameCount * 0.01 + i) * particleSpeed[i] * particleSpeedMultiplier;

    if (particleX[i] < 0) particleX[i] = width;
    if (particleX[i] > width) particleX[i] = 0;
    if (particleY[i] < 0) particleY[i] = height;
    if (particleY[i] > height) particleY[i] = 0;

    let sparkle = random(0.5, 1.5);
    fill(255, 150 * sparkle);
    ellipse(particleX[i], particleY[i], particleSize[i] * sparkle, particleSize[i] * sparkle);
  }
}

function drawTimeDisplay() {
  hours = hour();
  minutes = minute();
  seconds = second();

  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text(nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2), width / 2, height - 50);
}
