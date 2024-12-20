/* 
Project: Aurora Through Infinity
Author: Subhagya Adhikari
Description: An interpretation of the aurora combined with infinity and a journey.
*/

let t = 0; // Time variable for animation
let stars = []; // Array for cosmic stars
let cracks = []; // List to store cracks
let crackMax = 8, crackCount = 0; // Crack counter and max cracks for when chick spawns
let chickSpawned = false; // Start chick not spawned
let chickX, chickY; // Position of chick

function setup() {
  createCanvas(800, 800);
  noStroke();
  for (let i = 0; i < 150; i++) {
    stars.push(new Star(random(width), random(height), random(1, 3)));
  }
}

function draw() {
  // Cosmic background gradient
  drawCosmicBackground();

  // Twinkling stars
  for (let star of stars) {
    star.twinkle();
  }

  // Dynamic aurora ribbons
  for (let i = 0; i < 5; i++) {
    drawAurora(200 + i * 50, i);
  }

  // Egg and cracks
  if (!chickSpawned) {
    drawEgg();
    addCracks();
  }

  // Spawn chick when crack count is reached
  if (crackCount >= crackMax && !chickSpawned) {
    spawnChick();
    chickSpawned = true;
  }

  // Display the chick
  if (chickSpawned) {
    displayChick();
  }

  // Rotating infinity symbol
  drawRotatingInfinity(width / 2, height / 2, 200, t);

  t += 0.02; // Increment time for animations
}

// Function to draw cosmic gradient background
function drawCosmicBackground() {
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1);
    let c = lerpColor(color(10, 10, 50), color(0, 0, 20), inter);
    stroke(c);
    line(0, y, width, y);
  }
}

// Function to draw dynamic aurora ribbons
function drawAurora(yOffset, index) {
  fill(lerpColor(color(100, 200, 255, 80), color(150, 50, 255, 80), sin(t + index) * 0.5 + 0.5));
  beginShape();
  for (let x = 0; x <= width; x += 10) {
    let y = yOffset + sin((x * 0.05) + t + index) * 50;
    vertex(x, y);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

// Function to draw rotating infinity symbol
function drawRotatingInfinity(x, y, size, time) {
  push();
  translate(x, y);
  rotate(time * 0.5); // Rotational effect
  noFill();
  stroke(255, 255, 255, 150);
  strokeWeight(3);
  beginShape();
  for (let angle = 0; angle < TWO_PI; angle += 0.01) {
    let r = size * 0.5;
    let x1 = r * cos(angle) * (1 + sin(angle));
    let y1 = r * sin(angle) * cos(angle);
    vertex(x1, y1);
  }
  endShape(CLOSE);
  pop();
}

// Draw the egg
function drawEgg() {
  fill(255); // Egg color
  ellipse(width / 2, height / 2, 150, 200); // The egg
}

// Add cracks to the egg
function addCracks() {
  if (frameCount % 40 === 0) {
    cracks.push(new Crack());
    crackCount++;
  }

  for (let c of cracks) {
    c.update();
    c.display();
  }
}

// Spawn the chick
function spawnChick() {
  chickX = width / 2;
  chickY = height / 2 + 50; // Position chick below egg center
}

// Display the chick
function displayChick() {
  fill(255, 255, 0); // Chick body color
  ellipse(chickX, chickY, 50, 50); // Chick body

  // Chick eyes
  fill(0);
  ellipse(chickX - 15, chickY - 10, 8, 8);
  ellipse(chickX + 15, chickY - 10, 8, 8);

  // Chick beak
  fill(255, 165, 0);
  triangle(chickX - 5, chickY + 5, chickX + 5, chickY + 5, chickX, chickY + 12);

  // Chick legs
  stroke(255, 165, 0);
  strokeWeight(3);
  line(chickX - 11, chickY + 25, chickX - 23, chickY + 55);
  line(chickX + 11, chickY + 25, chickX + 23, chickY + 55);

  // Chick arms
  line(chickX - 25, chickY, chickX - 60, chickY - 30);
  line(chickX + 25, chickY, chickX + 60, chickY - 30);
}

// Star class for cosmic background
class Star {
  constructor(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.starColor = color(255, 255, 255, random(100, 255));
  }

  twinkle() {
    fill(this.starColor);
    noStroke();
    ellipse(this.x, this.y, this.radius, this.radius);
    this.starColor = color(255, 255, 255, random(100, 255)); // Random brightness
  }
}

// Crack class
class Crack {
  constructor() {
    this.points = [];
    this.x1 = width / 2 + random(-45, -10);
    this.y1 = height / 2 + random(-80, 80);
    this.points.push(createVector(this.x1, this.y1));
    this.length = 10; // Initial crack length
  }

  update() {
    if (this.length < 20) {
      this.length += random(1, 2);
      let angle = frameCount % 2 === 0 ? PI / 4 : -PI / 4;
      let last = this.points[this.points.length - 1];
      this.points.push(createVector(last.x + this.length * cos(angle), last.y + this.length * sin(angle)));
    }
  }

  display() {
    stroke(0);
    strokeWeight(3);
    for (let i = 0; i < this.points.length - 1; i++) {
      let p1 = this.points[i], p2 = this.points[i + 1];
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
}
