let particles = []; // Array to store particles (shapes)
let startTime;
let isGrayscale = false; // Flag for color mode
let particleSize = 12; // Initial particle size
let waveAmplitude = 100; // Initial wave amplitude
let waveSpeed = 0.02; // Wave speed
let xSpeed = 1; // Horizontal movement speed

function setup() {
  createCanvas(1200, 800); // Canvas size
  noStroke(); // Disable shape stroke
  startTime = millis();

  // Create initial particles
  for (let i = 0; i < 200; i++) {
    addParticle(random(width), random(height));
  }
  frameRate(60);
}

function draw() {
  // Background with fading effect
  fill(0, 15);
  rect(0, 0, width, height);

  // Handle color transition every 5 seconds
  let elapsedTime = (millis() - startTime) / 1000;
  if (elapsedTime >= 5.0) {
    isGrayscale = !isGrayscale;
    startTime = millis();
  }

  // Update and display all particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
  }

  // Maintain particle count at 200
  while (particles.length < 200) {
    addParticle(random(width), random(height));
  }
}

// Particle class
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.fillColor = this.getColor();
    this.timeOffsetY = random(TWO_PI);
  }

  // Update position and state
  update() {
    this.x += xSpeed; // Horizontal speed

    // Sine wave vertical movement
    let waveMovement = sin((this.x + millis() * waveSpeed) * 0.05 + this.timeOffsetY);
    this.y = height / 2 + waveMovement * waveAmplitude;

    // Reset particle to the left side if it moves off-screen
    if (this.x > width) {
      this.x = 0;
    }

    this.fillColor = this.getColor();
  }

  // Display particle (random shape or number)
  display() {
    noStroke();
    fill(this.fillColor);

    let shapeChoice = int(random(3));
    switch (shapeChoice) {
      case 0: // Circle
        ellipse(this.x, this.y, particleSize, particleSize);
        break;
      case 1: // Rectangle
        rect(this.x, this.y, particleSize, particleSize);
        break;
      case 2: // Random number
        textSize(16);
        textAlign(CENTER, CENTER);
        text(int(random(0, 100)), this.x, this.y);
        break;
    }
  }

  // Get color based on current mode
  getColor() {
    return isGrayscale ? this.getGrayscaleColor() : this.getRainbowColor();
  }

  getRainbowColor() {
    let angle = map(millis() % 5000, 0, 5000, 0, TWO_PI);
    let r = (sin(angle) + 1) * 127;
    let g = (sin(angle + TWO_PI / 3) + 1) * 127;
    let b = (sin(angle + 2 * TWO_PI / 3) + 1) * 127;
    return color(r, g, b);
  }

  getGrayscaleColor() {
    let grayValue = random(100, 200);
    return color(grayValue, grayValue, grayValue);
  }
}

// Function to add a new particle
function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

// Key interactions
function keyPressed() {
  if (key === 'C' || key === 'c') {
    particleSize += 2;
    waveAmplitude *= 0.8;
    waveSpeed *= 0.9;
  }

  if (key === 'R' || key === 'r') {
    resetParticles();
  }

  if (key === 'H' || key === 'h') {
    xSpeed += 0.5;
    waveSpeed *= 1.1;
  }
}

// Reset particles and behavior
function resetParticles() {
  particleSize = 12;
  waveAmplitude = 100;
  waveSpeed = 0.02;
  xSpeed = 1;
  isGrayscale = false;

  particles = [];
  for (let i = 0; i < 200; i++) {
    addParticle(random(width), random(height));
  }
}
