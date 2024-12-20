let xPos; // Array of x-positions for the ellipses (waves)
let numOfEllipses = 20; // Number of ellipses
let Speed = 0.005; // Speed of waves movement
let Amplitude = 50; // Amplitude of the waves
let Frequency = 0.1; // Frequency of the waves

let starX, starY, starSize; // Arrays for star positions and sizes
let maxStars = 50; // Maximum number of stars
let frameInterval = 40; // Interval between new stars
let starIndex = 0; // Index for managing stars

let angle = 0; // Angle for moon rotation
let craterX, craterY, craterSize; // Arrays for moon craters
let numCraters = 10; // Number of moon craters

let boatX = 500;
let boatY = 400; // Position above waves
let targetX = boatX; // Target position for the boat
let boatSpeed = 2; // Speed of the boat

function setup() {
  createCanvas(1000, 500);
  noStroke();

  // Initialize x-positions for ellipses (waves)
  xPos = new Array(numOfEllipses);
  for (let i = 0; i < numOfEllipses; i++) {
    xPos[i] = map(i, 0, numOfEllipses - 1, 0, width);
  }

  // Initialize arrays for stars
  starX = new Array(maxStars).fill(0);
  starY = new Array(maxStars).fill(0);
  starSize = new Array(maxStars).fill(0);

  // Initialize arrays for moon craters
  craterX = new Array(numCraters);
  craterY = new Array(numCraters);
  craterSize = new Array(numCraters);

  for (let i = 0; i < numCraters; i++) {
    craterX[i] = random(-50, 50);
    craterY[i] = random(-50, 50);
    craterSize[i] = random(10, 30);
  }
}

function draw() {
  background(3, 22, 92);

  // Waves
  let lowerOffset = height * 0.8;
  let distance = 60; // Distance between two ellipses

  for (let i = 0; i < numOfEllipses; i++) {
    let y = Amplitude * sin(Frequency * xPos[i] + frameCount * Speed);
    let size = 30 + 10 * sin(Frequency * xPos[i] + frameCount * Speed);

    fill(0, 100, 255);
    ellipse(xPos[i], lowerOffset + y, size, size);
    ellipse(xPos[i], lowerOffset + y + distance, size, size);

    xPos[i] += 0.5;
    if (xPos[i] > width) {
      xPos[i] = -size;
    }
  }

  // Stars
  for (let i = 0; i < maxStars; i++) {
    fill(255);
    ellipse(starX[i], starY[i], starSize[i], starSize[i]);
  }

  if (frameCount % frameInterval === 1) {
    starX[starIndex] = random(width);
    starY[starIndex] = random(0, 350);
    starSize[starIndex] = random(3, 7);
    starIndex = (starIndex + 1) % maxStars;
  }

  // Moon and craters
  push();
  translate(500, 100);
  rotate(angle);
  fill(255);
  ellipse(0, 0, 150, 150);

  for (let i = 0; i < numCraters; i++) {
    fill(100, 100, 100);
    ellipse(craterX[i], craterY[i], craterSize[i], craterSize[i]);
  }
  pop();

  angle += 0.02;

  // Boat
  updateBoat();
  drawBoat();
}

function mousePressed() {
  targetX = mouseX;
}

function drawBoat() {
  fill(150, 75, 0);
  rect(boatX - 20, boatY - 10, 40, 20);
  fill(255);
  triangle(boatX, boatY - 10, boatX - 10, boatY - 30, boatX + 10, boatY - 30);
}

function updateBoat() {
  if (abs(boatX - targetX) > 1) {
    boatX += boatSpeed * (targetX > boatX ? 1 : -1);
  }
}
