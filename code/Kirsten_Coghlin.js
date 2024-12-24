let waveOffset = 0;
let bubbles = [];

function setup() {
  createCanvas(800, 800);
  noStroke();
  for (let i = 0; i < 50; i++) {
    bubbles.push(new Bubble(random(width), random(height, height * 1.5)));
  }
}

function draw() {
  background(10, 30, 60); // Deep sea background

  drawWaves();
  drawRock();
  drawBubbles();
  drawDecorativeShapes(); // Draw the new shapes once
  drawFishAndHeart(); // Draw fish and heart shapes
}

// Draw flowing waves
function drawWaves() {
  for (let y = 0; y < height; y += 30) {
    fill(10, 50 + y / 10, 120 + y / 5, 100); // Gradient blue for depth
    beginShape();
    for (let x = 0; x <= width; x += 20) {
      let waveHeight = 10 * sin((x + waveOffset) * 0.02 + y * 0.1);
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  waveOffset += 2;
}

// Draw rising bubbles
function drawBubbles() {
  for (let b of bubbles) {
    b.move();
    b.display();
  }
}

class Bubble {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(10, 20);
    this.speed = random(1, 3);
  }

  move() {
    this.y -= this.speed;
    if (this.y < -this.size) {
      this.y = height + this.size;
      this.x = random(width);
    }
  }

  display() {
    fill(255, 100);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

// Draw a rock-like structure
function drawRock() {
  fill(50, 30, 20); // Dark brown/gray for the rock
  beginShape();
  vertex(width * 0, height * 0.8); // Base left
  vertex(width * 0, height * 0.2); // Peak left
  vertex(width * 0.6, height * 0.65); // Peak right
  vertex(width * 0.8, height * 0.85); // Base right
  vertex(width, height); // Bottom right corner
  vertex(0, height); // Bottom left corner
  endShape(CLOSE);
}

// Draw decorative shapes (semi-circles and diamonds)
function drawDecorativeShapes() {
  // Draw 3 pink semi-circles
  fill(255, 182, 193); // Light pink color
  for (let i = 0; i < 3; i++) {
    let x = width - 80 + i * 25;
    let y = height - 50;
    arc(x, y, 30, 30, PI, TWO_PI);
  }

  // Draw 3 orange diamond shapes
  fill(255, 165, 0); // Orange color
  for (let i = 0; i < 3; i++) {
    let x = width - 80 + i * 25;
    let y = height - 100;
    beginShape();
    vertex(x, y - 10);
    vertex(x + 10, y);
    vertex(x, y + 10);
    vertex(x - 10, y);
    endShape(CLOSE);
  }
}

// Draw two fish shapes and a heart shape
function drawFishAndHeart() {
  // Draw Fish 1
  drawFish(width - 200, height - 100, 50, color(255, 0, 0)); // Red Fish

  // Draw Fish 2
  drawFish(width - 250, height - 150, 40, color(0, 255, 0)); // Green Fish

  // Draw Heart
  drawHeart(width - 300, height - 150, 40); // Heart shape
}

function drawFish(x, y, size, bodyColor) {
  fill(bodyColor);
  ellipse(x, y, size, size / 2); // Fish body
  triangle(x + size / 2, y, x + size, y - size / 4, x + size, y + size / 4); // Fish tail
}

function drawHeart(x, y, size) {
  fill(255, 0, 0); // Red color
  beginShape();
  vertex(x, y);
  bezierVertex(x - size / 2, y - size / 2, x - size, y + size / 4, x, y + size);
  bezierVertex(x + size, y + size / 4, x + size / 2, y - size / 2, x, y);
  endShape(CLOSE);
}
