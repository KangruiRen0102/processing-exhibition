let offset = 0; // Tracks the horizontal movement of sine wave.
let waveDip = 0; // Tracks the vertical dip of the wave.
let waveMovementSpeed = 2; // Controls horizontal and vertical wave speed.
let particles = []; // Array to store multiple Particle objects.
let waveColor; // Color of the wave.

function setup() {
  createCanvas(800, 800); // Canvas size
  waveColor = color(0, 0, 255); // Initial wave color

  for (let i = 0; i < 2; i++) {
    // Create two particle objects with random positions.
    particles.push(new Particle(random(width), random(height)));
  }
  frameRate(60); // Set a higher frame rate for smoother animation.
}

function draw() {
  background(173, 216, 230); // Light blue background
  stroke(waveColor); // Use the current wave color
  noFill();

  // Draw the sine wave
  beginShape();
  for (let x = 0; x < width; x++) {
    let y = sin((x + offset) * 0.02) * height / 4 + height / 2 + waveDip; // Calculate y-coordinate for wave
    vertex(x, y);
  }
  endShape();

  offset += waveMovementSpeed; // Move the wave horizontally
  waveDip -= waveMovementSpeed; // Move the wave downward
  if (waveDip < 0) waveDip = 0; // Prevent wave dip from going below canvas

  // Update and display particles
  for (let p of particles) {
    p.update();
    p.display();

    if (p.interactWithWave()) {
      waveDip = min(waveDip + 30, height / 2); // Move wave downward temporarily
      p.resetPosition(); // Reset particle position
    }
  }
}

function mousePressed() {
  waveColor = color(random(255), random(255), random(255)); // Change wave color randomly
  for (let p of particles) {
    p.resetPosition(); // Reset particle positions
  }
}

class Particle {
  constructor(x, y) {
    this.x = x; // Initial x-coordinate
    this.y = y; // Initial y-coordinate
    this.speedX = random(-10, 10); // Horizontal speed
    this.speedY = random(-10, 10); // Vertical speed
    this.size = 30; // Particle size
  }

  update() {
    this.x += this.speedX; // Move horizontally
    this.y += this.speedY; // Move vertically

    // Bounce off edges of the canvas
    if (this.x < 0 || this.x > width) {
      this.speedX *= -1;
    }
    if (this.y < 0 || this.y > height) {
      this.speedY *= -1;
    }
  }

  display() {
    stroke(255, 0, 0); // Red color for particle
    strokeWeight(this.size); // Particle size
    point(this.x, this.y); // Draw particle as a point
  }

  interactWithWave() {
    let ix = constrain(int(this.x), 0, width - 1); // Ensure x is within canvas bounds
    let waveY = this.getWaveY(ix); // Get wave's y-coordinate at particle's x-coordinate
    return abs(this.y - waveY) < this.size; // Check if particle interacts with wave
  }

  getWaveY(x) {
    // Calculate wave's y-coordinate at a given x position
    return sin((x + offset) * 0.02) * height / 4 + height / 2 + waveDip;
  }

  resetPosition() {
    this.x = random(width); // Reset to a random x-coordinate
    this.y = random(height); // Reset to a random y-coordinate
  }
}
