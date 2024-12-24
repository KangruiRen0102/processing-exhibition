let numWaves = 10;
let numFish = 5;
let sharkX = 50;
let sharkSpeed = 0.5;
let waveSpeed = 0.02;
let time = 0;
let lightningActive = false;
let lightningTimer = 0;
let stormIntensity = 1.0;
let boatX;

function setup() {
  createCanvas(800, 600);
  noStroke();
  boatX = width / 2;
}

function draw() {
  background(20, 50, 100);
  drawLightning();
  drawWaves();
  drawRain();
  drawMarineAnimals();
  drawBoat();
  time += waveSpeed * stormIntensity;

  // Control lightning flicker
  lightningTimer -= 1 / 60.0;
  if (lightningTimer <= 0) {
    lightningActive = random(1) > 0.90 / stormIntensity;
    if (lightningActive) {
      lightningTimer = random(0.1, 0.2);
    }
  }
}

function keyPressed() {
  if (keyCode === UP_ARROW) {
    stormIntensity = constrain(stormIntensity + 0.2, 1, 3);
  }
  if (keyCode === DOWN_ARROW) {
    stormIntensity = constrain(stormIntensity - 0.2, 1, 3);
  }
  if (keyCode === LEFT_ARROW) {
    boatX -= 10;
  }
  if (keyCode === RIGHT_ARROW) {
    boatX += 10;
  }
}

function mousePressed() {
  lightningActive = true;
  lightningTimer = 0.2;
}

function drawLightning() {
  if (lightningActive) {
    fill(255, 255, 255, 150);
    rect(0, 0, width, height / 3);
    for (let i = 0; i < 3; i++) {
      let startX = random(width);
      let startY = random(height / 6);
      let endX = startX + random(-50, 50);
      let endY = startY + random(50, 150);
      stroke(255, 255, 255, 200);
      strokeWeight(2);
      line(startX, startY, endX, endY);
    }
    noStroke();
  }
}

function drawWaves() {
  for (let i = 0; i < numWaves; i++) {
    let waveY = map(i, 0, numWaves, height / 3, height / 2);
    for (let x = 0; x < width; x += 5) {
      let waveHeight = sin(x * 0.03 + time * (0.5 + i * 0.2)) * 20 * stormIntensity;
      fill(50, 100 + i * 10, 180 + i * 5, 150);
      ellipse(x, waveY + waveHeight, 10, 20);
    }
  }
}

function drawRain() {
  for (let i = 0; i < 50 * stormIntensity; i++) {
    let rx = random(width);
    let ry = random(-50, height);
    stroke(200, 200, 255, 150);
    line(rx, ry, rx, ry + 10 * stormIntensity);
  }
}

function drawMarineAnimals() {
  for (let i = 0; i < numFish; i++) {
    let fishX = map(i, 0, numFish, 50, width - 50);
    let fishY = height * 0.7 + sin(time + i) * 20;

    if (dist(mouseX, mouseY, fishX, fishY) < 100) {
      fishX += random(-20, 20);
      fishY += random(-20, 20);
    }

    let size = random(15, 30);
    drawFish(fishX, fishY, size);
  }

  drawShark();
}

function drawFish(x, y, size) {
  fill(200, 100, 50);
  ellipse(x, y, size * 1.5, size);
  triangle(x - size * 0.8, y, x - size * 1.5, y - size * 0.5, x - size * 1.5, y + size * 0.5);
  fill(0);
  ellipse(x + size * 0.5, y, size * 0.2, size * 0.2);
}

function drawShark() {
  let sharkY = height * 0.7 + sin(time * 0.5) * 30;
  let size = 70;

  sharkX = lerp(sharkX, mouseX, 0.02);

  fill(100, 100, 120);
  ellipse(sharkX, sharkY, size * 2, size);
  triangle(sharkX - size * 1.5, sharkY, sharkX - size * 2.2, sharkY - size * 0.6, sharkX - size * 2.2, sharkY + size * 0.6);
}

function drawBoat() {
  let waveY = height / 3 + sin(boatX * 0.03 + time * 2) * 20 * stormIntensity;

  fill(150, 75, 0);
  rect(boatX - 40, waveY - 20, 80, 40);
  fill(255);
  triangle(boatX, waveY - 50, boatX - 20, waveY - 20, boatX + 20, waveY - 20);
}
