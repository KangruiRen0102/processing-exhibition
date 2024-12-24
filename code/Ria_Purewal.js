let blooms = []; // Array for bloom objects
let numBlooms = 50;

// Variables for chaotic background
let chaosPhase = 0;
let twilightColor;

function setup() {
  createCanvas(800, 600); // Size of the canvas

  // Initialize bloom objects
  for (let i = 0; i < numBlooms; i++) {
    blooms.push(new Bloom(random(width), random(height)));
  }
}

function draw() {
  // Moving twilight background
  twilightColor = color(
    50 + 50 * sin(chaosPhase),
    20 + 20 * sin(chaosPhase + PI / 2),
    80 + 80 * sin(chaosPhase + PI)
  );
  background(twilightColor);

  // Render chaotic circles
  drawChaos();

  // Display blooming patterns
  for (let bloom of blooms) {
    bloom.display();
    bloom.grow();
  }

  // Update chaos phase
  chaosPhase += 0.02;
}

function drawChaos() {
  noStroke();
  for (let i = 0; i < 100; i++) {
    fill(100 + 50 * sin(chaosPhase + i * 0.1), 30, 100, 50);
    let x = width / 2 + 150 * cos(chaosPhase + i * 0.2);
    let y = height / 2 + 150 * sin(chaosPhase + i * 0.2);
    ellipse(x, y, random(10, 30), random(10, 30));
  }
}

// Class for Bloom patterns
class Bloom {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.bloomColor = color(random(200, 255), random(100, 200), random(150, 250));
  }

  display() {
    noStroke();
    fill(this.bloomColor, 150);
    ellipse(this.x, this.y, this.size, this.size);
  }

  grow() {
    this.size += random(0.1, 0.5);
    if (this.size > 50) { // Regenerate bloom
      this.size = random(5, 15);
      this.x = random(width);
      this.y = random(height);
    }
  }
}
