/* 
Project: Aurora Through Infinity
Author: Subhagya Adhikari
Description: An interpretation of the aurora combined with infinity and a journey.
*/

let t = 0; // Time variable for animation
let stars = []; // Array for cosmic stars

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

  // Glowing trails
  stroke(255, 255, 255, 50);
  for (let i = 1; i <= 3; i++) {
    let scale = 1.0 - i * 0.1;
    beginShape();
    for (let angle = 0; angle < TWO_PI; angle += 0.01) {
      let r = size * 0.5 * scale;
      let x1 = r * cos(angle) * (1 + sin(angle));
      let y1 = r * sin(angle) * cos(angle);
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }
  pop();
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
