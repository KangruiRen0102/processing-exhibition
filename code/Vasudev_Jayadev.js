let waveOffset = 0;
let particles = [];

function setup() {
  createCanvas(800, 800); // Canvas size
  background(10, 30, 60); // Dark ocean-like background
  noStroke();
}

function draw() {
  background(10, 30, 60, 50); // Dark background with slight fade effect

  // Draw the "sea" - Moving wave patterns
  drawSea();

  // Draw "infinity" - Spiraling shapes
  drawInfinity();

  // Handle "journey" particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
    if (p.isOffScreen()) {
      particles.splice(i, 1);
    }
  }
}

function mousePressed() {
  // Add particles for "journey" when the mouse is pressed
  for (let i = 0; i < 10; i++) {
    particles.push(new Particle(mouseX, mouseY));
  }
}

// Draw "sea" with flowing waves
function drawSea() {
  waveOffset += 0.05; // Shift waves over time
  for (let y = height / 2; y < height; y += 20) {
    fill(20, 80 + y / 10, 150 + y / 5, 150); // Gradient blues
    beginShape();
    for (let x = 0; x < width; x++) {
      let waveHeight = sin((x * 0.02) + waveOffset + (y * 0.05)) * 20;
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// Draw "infinity" as spiraling shapes
function drawInfinity() {
  push();
  translate(width / 2, height / 3); // Center of the canvas
  for (let i = 0; i < 200; i++) {
    let angle = i * 0.1;
    let radius = 100 + i * 0.5;
    let x = radius * cos(angle);
    let y = radius * sin(angle);
    fill(200, 150, 255, map(i, 0, 200, 255, 50)); // Gradient color
    ellipse(x, y, 5, 5);
  }
  pop();
}

// Particle class for "journey"
class Particle {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.speedX = random(-1, 1);
    this.speedY = random(-2, -1);
    this.size = random(5, 10);
    this.col = color(random(100, 200), random(150, 255), random(200, 255)); // Bright blue and green tones
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    this.size *= 0.98; // Gradual shrink
  }

  display() {
    fill(this.col, 150);
    ellipse(this.x, this.y, this.size, this.size);
  }

  isOffScreen() {
    return this.y < 0 || this.size < 1; // Particle disappears when off-screen or too small
  }
}
