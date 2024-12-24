let particles = []; // Array to store all particles
let attractMode = false; // Determines whether particles are attracted or repelled by the mouse
let mouseInteractionEnabled = false; // Controls if mouse interaction is enabled

function setup() {
  createCanvas(1200, 800); // Set the canvas size
  noStroke(); // Disable stroke for shapes

  // Create initial particles
  for (let i = 0; i < 500; i++) {
    addParticle(random(width), random(height)); // Add particles at random positions
  }
}

function draw() {
  fill(0, 15); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

  // Update and display each particle
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update(); // Update particle position and state
    p.display(); // Display the particle

    // Apply mouse interactions if enabled
    if (mouseInteractionEnabled) {
      if (attractMode) {
        p.attract(mouseX, mouseY); // Attract the particle towards the mouse
      } else {
        p.repel(mouseX, mouseY); // Repel the particle away from the mouse
      }
    }

    // Remove dead particles
    if (p.isDead()) {
      particles.splice(i, 1);
    }
  }

  // Add new particles if the number is below 1000
  if (particles.length < 1000) {
    addParticle(random(width), random(height));
  }
}

// Particle class representing a shape
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = p5.Vector.random2D().mult(random(0.5, 2)); // Assign a random velocity
    this.lifespan = random(200, 400); // Assign a random lifespan
    this.fillColor = getBlueShade(x, y); // Set the color to a random blue shade
  }

  // Update the particle's position and state
  update() {
    this.x += this.velocity.x;
    this.y += this.velocity.y;
    this.lifespan -= 1.5;
    this.velocity.rotate(0.02); // Slightly rotate velocity direction
  }

  // Attract the particle towards a target (e.g., mouse position)
  attract(targetX, targetY) {
    let attraction = createVector(targetX - this.x, targetY - this.y);
    attraction.normalize();
    attraction.mult(0.05); // Control strength of attraction
    this.velocity.add(attraction);
  }

  // Repel the particle away from a target
  repel(targetX, targetY) {
    let repelForce = createVector(this.x - targetX, this.y - targetY);
    repelForce.normalize();
    repelForce.mult(0.1); // Control strength of repulsion
    this.velocity.add(repelForce);
  }

  // Display the particle as a fading ellipse
  display() {
    fill(this.fillColor.levels[0], this.fillColor.levels[1], this.fillColor.levels[2], map(this.lifespan, 0, 400, 0, 255));
    ellipse(this.x, this.y, map(this.lifespan, 0, 400, 1, 8), map(this.lifespan, 0, 400, 1, 8));
  }

  // Check if the particle is dead
  isDead() {
    return this.lifespan < 0;
  }
}

// Function to add a new particle to the list
function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

// Randomly generate blue shades
function getBlueShade(x, y) {
  let blueIntensity = random(50, 225); // Generate random blue intensities
  return color(0, 0, blueIntensity); // Return a color with red and green set to 0 and varying blue
}

// Handle key presses for different interactions
function keyPressed() {
  if (key === 'o' || key === 'O') {
    mouseInteractionEnabled = !mouseInteractionEnabled; // Toggle mouse interaction
  }

  if (key === 'a' || key === 'A') {
    attractMode = !attractMode; // Toggle attraction/repulsion mode
  }

  if (key === 'n' || key === 'N') {
    // Add 100 new particles
    for (let i = 0; i < 100; i++) {
      addParticle(random(width), random(height));
    }
  }

  if (key === 'c' || key === 'C') {
    particles = []; // Clear all particles
  }

  if (key === 's' || key === 'S') {
    // Randomly adjust the speed of all particles
    for (let p of particles) {
      p.velocity.mult(random(0.5, 1.5));
    }
  }
}
