let particles = []; // Array to store all particles
let attractMode = true; // Determines if particles are attracted or repelled by the mouse
let mouseInteractionEnabled = true; // Controls if mouse interaction is enabled
let attractionStrength = 0.01; // Strength of attraction or repulsion

function setup() {
  createCanvas(800, 800); // Create a canvas of 800x800 pixels
  noStroke(); // Disable stroke for shapes

  // Create initial particles
  for (let i = 0; i < 500; i++) {
    addParticle(random(width), random(height));
  }
  frameRate(60); // Set frame rate
}

function draw() {
  // Draw a semi-transparent black background for a trailing effect
  fill(0, 15);
  rect(0, 0, width, height);

  // Draw decorative diamonds
  drawDecorativeDiamonds();

  // Update and display particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    // Apply mouse interactions if enabled
    if (mouseInteractionEnabled) {
      p.applyForce(mouseX, mouseY, attractionStrength, attractMode);

      // Remove dead particles
      if (p.isDead()) {
        particles.splice(i, 1);
      }
    }
  }

  // Maintain particle count up to 1000
  while (particles.length < 1000) {
    addParticle(random(width), random(height));
  }
}

function drawDecorativeDiamonds() {
  push();
  translate(width / 2, height / 2); // Center the transformation
  rotate(PI / 4); // Rotate to create diamond shapes
  let scaleFactor = map(mouseX, 0, width, 0.25, 1.5);
  scaleFactor = constrain(scaleFactor, 0.25, 1.5);
  scale(scaleFactor);

  fill(200, 255, 255); // Light blue diamonds
  rect(100, 10, 15, 15);
  rect(100, 30, 15, 15);
  rect(120, 10, 15, 15);
  rect(120, 30, 15, 15);

  rect(-50, 400, 15, 15);
  rect(-50, 420, 15, 15);
  rect(-70, 400, 15, 15);
  rect(-70, 420, 15, 15);

  rect(300, -360, 15, 15);
  rect(300, -380, 15, 15);
  rect(320, -360, 15, 15);
  rect(320, -380, 15, 15);
  pop();
}

// Base class for particles
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = p5.Vector.random2D().mult(random(0.5, 4));
    this.lifespan = random(100, 400);
    this.fillColor = this.getComplexColor(x, y);
  }

  update() {
    this.x += this.velocity.x;
    this.y += this.velocity.y;
    this.lifespan -= 1.5;
    this.velocity.rotate(0.05);
  }

  applyForce(targetX, targetY, strength, isAttract) {
    let force = createVector(targetX - this.x, targetY - this.y);
    force.normalize();
    force.mult(isAttract ? strength : -strength);
    this.velocity.add(force);
  }

  display() {
    fill(this.fillColor, map(this.lifespan, 0, 400, 0, 255));
    ellipse(this.x, this.y, map(this.lifespan, 0, 400, 1, 8), map(this.lifespan, 0, 400, 1, 8));
  }

  isDead() {
    return this.lifespan < 0;
  }

  getComplexColor(x, y) {
    let distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);
    let r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
    let g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
    let b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;
    return color(r, g, b);
  }
}

// Add a new particle to the list
function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

// Handle key presses for interaction
function keyPressed() {
  switch (key.toLowerCase()) {
    case 'o':
      mouseInteractionEnabled = !mouseInteractionEnabled;
      break;
    case 'a':
      attractMode = !attractMode;
      break;
    case 'n':
      for (let i = 0; i < 100; i++) {
        addParticle(random(width), random(height));
      }
      break;
    case 'c':
      particles = [];
      break;
    case 's':
      for (let p of particles) {
        p.velocity.mult(random(0.5, 1.5));
      }
      break;
    case '+':
      attractionStrength += 0.01;
      break;
    case '-':
      attractionStrength -= 0.01;
      break;
  }
}
