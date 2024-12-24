let waveSpeed = 0.05;
let waveFrequency = 0.02;
let offsetLeftToRight = 0;
let offsetRightToLeft = 0;
let fishSpeed = 2;
let numFish = 7;

let fishX = [];
let fishY = [];
let fishBaseHeight = [];
let fishDirection = 1;

let minFishBaseHeight = 380;
let maxFishBaseHeight = 520;

let floorHeights = [];
let floorOffset = 50;

let numGoldCoins = 10;
let numRubies = 10;
let goldCoins = [];
let rubies = [];
let coinAreaStartX = 500;
let coinAreaEndX = 540;
let pileDistanceThreshold = 30;

let maxSparkles = 3;
let sparkleChance = 0.1;
let goldCoinSparkles = [];
let rubySparkles = [];

function setup() {
  createCanvas(1100, 600);
  noStroke();

  for (let i = 0; i < numFish; i++) {
    fishX.push(random(width));
    fishBaseHeight.push(random(minFishBaseHeight, maxFishBaseHeight));
  }

  for (let i = 0; i < width; i++) {
    floorHeights[i] = sin(i * 0.025) * 15 + height - 50;
  }

  for (let i = 0; i < numGoldCoins; i++) {
    goldCoins.push([random(coinAreaStartX, coinAreaEndX), random(height - 50, height - 10), random(8, 12)]);
  }

  for (let i = 0; i < numRubies; i++) {
    rubies.push([random(coinAreaStartX, coinAreaEndX), random(height - 50, height - 10), random(8, 12)]);
  }
}

function draw() {
  background(135, 206, 250);

  fill(56, 113, 151);
  drawFilledWaves(100, 30, offsetRightToLeft);

  fill(30, 64, 97);
  drawFilledWaves(50, 30, offsetLeftToRight);

  drawFishes();
  drawOceanFloor();

  if (mouseX >= coinAreaStartX - pileDistanceThreshold && mouseX <= coinAreaEndX + pileDistanceThreshold) {
    drawGoldCoins();
    drawRubies();
  }

  drawSun();
  drawMagnifyingGlass(mouseX, mouseY);

  offsetLeftToRight -= waveSpeed;
  offsetRightToLeft += waveSpeed;

  updateAndDrawSparkles();
}

function drawFishes() {
  for (let i = 0; i < numFish; i++) {
    fishX[i] += fishDirection * fishSpeed;

    fishY[i] = fishBaseHeight[i];

    if (fishX[i] > width) {
      fishX[i] = 0;
    }

    drawFish(fishX[i], fishY[i]);
  }
}

function drawFish(x, y) {
  fill(255, 204, 0);
  ellipse(x, y, 20, 10);

  fill(255, 140, 0);
  triangle(x - 10, y, x - 15, y - 5, x - 15, y + 5);
}

function drawOceanFloor() {
  fill(112, 85, 56);
  beginShape();
  for (let i = 0; i < width; i++) {
    vertex(i, floorHeights[i]);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

function drawFilledWaves(k, waveHeight, offset) {
  beginShape();
  for (let x = 0; x < width; x++) {
    let y = height / 2 + sin(x * waveFrequency + offset) * waveHeight;
    vertex(x, y - k);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

function drawGoldCoins() {
  fill(255, 223, 0);
  for (let i = 0; i < numGoldCoins; i++) {
    let x = goldCoins[i][0];
    let y = goldCoins[i][1];
    let size = goldCoins[i][2];
    ellipse(x, y, size, size);

    if (random(1) < sparkleChance) {
      goldCoinSparkles.push(new Sparkle(x + random(-5, 5), y + random(-5, 5)));
    }
  }
}

function drawRubies() {
  fill(255, 0, 0);
  for (let i = 0; i < numRubies; i++) {
    let x = rubies[i][0];
    let y = rubies[i][1];
    let size = rubies[i][2];
    ellipse(x, y, size, size);

    if (random(1) < sparkleChance) {
      rubySparkles.push(new Sparkle(x + random(-5, 5), y + random(-5, 5)));
    }
  }
}

function drawSun() {
  fill(255, 204, 0);
  ellipse(width - 100, 100, 80, 80);

  for (let i = 0; i < 12; i++) {
    let angle = radians(i * 30);
    let rayLength = 40;
    let x1 = width - 100 + cos(angle) * 40;
    let y1 = 100 + sin(angle) * 40;
    line(width - 100, 100, x1, y1);
  }
}

class Sparkle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(3, 6);
    this.alpha = 255;
  }

  update() {
    this.alpha -= 5;
  }

  display() {
    fill(255, 255, 255, this.alpha);
    ellipse(this.x, this.y, this.size, this.size);
  }

  isFinished() {
    return this.alpha <= 0;
  }
}

function updateAndDrawSparkles() {
  for (let i = goldCoinSparkles.length - 1; i >= 0; i--) {
    let sparkle = goldCoinSparkles[i];
    sparkle.update();
    sparkle.display();
    if (sparkle.isFinished()) {
      goldCoinSparkles.splice(i, 1);
    }
  }

  for (let i = rubySparkles.length - 1; i >= 0; i--) {
    let sparkle = rubySparkles[i];
    sparkle.update();
    sparkle.display();
    if (sparkle.isFinished()) {
      rubySparkles.splice(i, 1);
    }
  }
}

function drawMagnifyingGlass(x, y) {
  let glassRadius = 30;
  let handleLength = 40;
  fill(255, 255, 255, 150);
  ellipse(x, y, glassRadius * 2, glassRadius * 2);
  fill(100, 100, 100);
  rect(x + glassRadius - 5, y, handleLength, 8);
}
