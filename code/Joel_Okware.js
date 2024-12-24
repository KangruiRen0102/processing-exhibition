let particles = []; // Array to store "Aurora" particles
let numParticles = 300; // Number of particles
let reverseDirection = false; // Tracks direction of flow
let journeyColors = []; // Store the color transitions for the journey trail
let colorLerpSpeed = []; // Speed for color interpolation

function setup() {
  createCanvas(800, 800); // Canvas size
  for (let i = 0; i < numParticles; i++) {
    particles.push(new AuroraParticle(random(width), random(height)));
  }

  // Initialize the journey line colors
  for (let i = 0; i < width / 20; i++) {
    journeyColors[i] = getRandomColor(); // Random initial colors
    colorLerpSpeed[i] = random(0.02, 0.05); // Random speed of color transitions
  }

  background(20, 20, 50); // Dark base for persistent trails
  noStroke();
}

function draw() {
  fill(20, 20, 50, 25); // Transparent background for glowing trails
  rect(0, 0, width, height); // Persisting trails effect

  for (let p of particles) {
    p.update();
    p.display();
  }

  drawJourneyTrail(); // Draw dynamic, pulsating journey trails
}

// Class representing aurora particles
class AuroraParticle {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.size = random(3, 8);
    this.currentColor = getRandomColor(); // Initial random color
    this.targetColor = getRandomColor(); // Set the first target color
    this.angle = random(TWO_PI);
  }

  update() {
    // Reverse or normal direction based on interaction
    let direction = reverseDirection ? -1 : 1;
    this.angle += random(-0.05, 0.05) * direction;
    this.x += cos(this.angle) * 2 * direction;
    this.y += sin(this.angle) * 2 * direction;

    // Wrap particles to maintain flow
    if (this.x < 0) this.x = width;
    if (this.x > width) this.x = 0;
    if (this.y < 0) this.y = height;
    if (this.y > height) this.y = 0;

    // Gradually shift to the target color
    this.currentColor = lerpColor(this.currentColor, this.targetColor, 0.02);

    // Change target color periodically
    if (frameCount % 100 === 0) {
      this.targetColor = getRandomColor();
    }
  }

  display() {
    fill(this.currentColor);
    ellipse(this.x, this.y, this.size, this.size); // Draw particle
  }
}

// Helper function to get a random vibrant color
function getRandomColor() {
  return color(random(100, 255), random(100, 255), random(100, 255), 150);
}

// Creates pulsating paths symbolizing a journey
function drawJourneyTrail() {
  for (let i = 0; i < journeyColors.length; i++) {
    // Interpolate the color for each line in the journey
    journeyColors[i] = lerpColor(journeyColors[i], getRandomColor(), colorLerpSpeed[i]);

    let pulse = sin(frameCount * 0.05 + i * 0.1) * 10 + 20; // Pulsating effect
    strokeWeight(2 + pulse * 0.05);
    stroke(journeyColors[i]);

    // Draw the vertical lines of the journey
    let y = height / 2 + sin((frameCount * 0.02) + i * 0.1) * 100;
    line(i * 20, height, i * 20, y); // Adjust position for each vertical line
  }
  noStroke();
}

// Mouse click reverses direction
function mousePressed() {
  reverseDirection = !reverseDirection;
}

// Reset animation when 'R' is pressed
function keyPressed() {
  if (key === 'R' || key === 'r') {
    for (let p of particles) {
      p.x = random(width); // Reset positions
      p.y = random(height);
      p.currentColor = getRandomColor(); // Reset colors
      p.targetColor = getRandomColor();
    }
    reverseDirection = false; // Reset direction
  }
}
