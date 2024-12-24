// Simulation parameters and initialization variables
let particles = []; // Array to hold all particles
let foDura = 400; // Time for the lines to fade out
let fiDura = 300; // Time for the squares to fade in
let CongregationTime; // Frame when transition starts
let iTransition = false; // Flag to determine if transition has started
let CongregationZones = []; // Define three symmetrical target regions
let lopacity = 255; // Opacity of the random lines
let sopacity = 0; // Opacity of the squares
let pCongregation = false; // Flag to trigger particle transition

function setup() {
  createCanvas(1920, 1080); // Set canvas size

  // Create particles at random positions
  for (let i = 0; i < 500; i++) {
    particles.push(new Particle(random(width), random(height)));
  }

  // Define three symmetrical target regions
  CongregationZones.push(createVector(width / 4, height / 3)); // Top-left target region
  CongregationZones.push(createVector(width / 2, (2 * height) / 3)); // Bottom-center target region
  CongregationZones.push(createVector((3 * width) / 4, height / 3)); // Top-right target region
}

function draw() {
  background(10, 70, 125); // Blue background

  if (!iTransition) {
    // Draw chaotic background with random lines
    for (let i = 0; i < 50; i++) {
      stroke(15, 160, 45, lopacity); // Random lines with decreasing opacity
      line(random(width), random(height), random(width), random(height));
    }
    lopacity -= 200 / foDura; // Gradually reduce opacity

    if (lopacity <= 0) {
      iTransition = true;
      CongregationTime = frameCount; // Mark the start of the transition
    }
  } else {
    // Draw squares with increasing opacity
    let progress = (frameCount - CongregationTime) / fiDura;
    if (progress <= 1.0) {
      sopacity = progress * 200;
    }
    drawSquares();

    if (progress >= 1.0 && !pCongregation) {
      pCongregation = true; // Start particle transition after squares are fully visible
      for (let p of particles) {
        p.setTargetRegion(CongregationZones); // Assign target regions to particles
        p.startTransition();
      }
    }
  }

  for (let p of particles) {
    p.update(); // Update particle positions
    p.display(); // Draw particles on canvas
  }
}

// Function to draw the target squares as the order phase starts
function drawSquares() {
  noFill();
  stroke(255, 200, 100, sopacity);
  strokeWeight(5);
  for (let target of CongregationZones) {
    rect(target.x - 50, target.y - 50, 100, 100); // Draw square around each target region
  }
}

// Class definition for particles, including movement and rendering
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velx = random(-4, 4);
    this.vely = random(-4, 4);
    this.target = null;
    this.iTransition = false;
  }

  // Assigns a random target region for a particle to move toward
  setTargetRegion(regions) {
    this.target = random(regions);
  }

  // Tells the particle to begin transitioning to its target
  startTransition() {
    this.iTransition = true;
  }

  // Updates the particle's position and velocity
  update() {
    if (this.iTransition) {
      this.velx = (this.target.x - this.x) * 0.01;
      this.vely = (this.target.y - this.y) * 0.01;
    }
    this.x += this.velx;
    this.y += this.vely;
  }

  // Shows the particle as a circle on the canvas
  display() {
    fill(200, 150, 100, 150);
    noStroke();
    ellipse(this.x, this.y, 15, 15);
  }
}
