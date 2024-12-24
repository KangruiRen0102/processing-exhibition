// Array to store all the particles
let particles = [];

// Flags to manage interaction modes
let attractMode = false; // Determines whether particles are attracted or repelled by the mouse
let mouseInteractionEnabled = false; // Controls if mouse interaction is enabled
let attractionStrength = 0.05;

// Timer for transitioning from red circle to particle effect
let startTime;
let showParticles = false;

// Timer for delaying the particle effect by 3 seconds after red circle
let delayTime = 3000; // 3 seconds in milliseconds

function setup() {
  createCanvas(1200, 800); // Set the canvas size
  noStroke(); // Disable the stroke for shapes

  // Create initial particles
  for (let i = 0; i < 500; i++) {
    addParticle(random(width), random(height));
  }

  frameRate(60); // Set frame rate to 60 frames per second
  startTime = millis(); // Record the start time
}

function draw() {
  if (!showParticles) {
    // Display red circle for 3 seconds
    background(255); // white background
    fill(255, 0, 0); // Red color
    ellipse(width / 2, height / 2, 200, 200); // Red circle in the center

    // Check if 3 seconds have passed since the start time
    if (millis() - startTime > delayTime) {
      showParticles = true; // Transition to particle effect after the delay
    }
  } else {
    // Particle effect
    fill(0, 15); // Set a semi-transparent black fill to create a trailing effect
    rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

    // Update and display each particle
    for (let i = particles.length - 1; i >= 0; i--) {
      let p = particles[i];
      p.update(); // Update particle position and state
      p.display(); // Display the particle

      // Apply mouse interactions if enabled
      if (mouseInteractionEnabled) {
        p.applyForce(mouseX, mouseY, attractionStrength, attractMode); // Unified attraction/repulsion
      }

      // Remove dead particles
      if (p.isDead()) {
        particles.splice(i, 1);
      }
    }

    if (particles.length === 0) {
      // Draw the yellow dot in the center of the screen
      fill(255, 255, 0); // Set the fill color to yellow
      ellipse(width / 2, height / 2, 50, 50); // Draw the yellow dot at the center
    }

    // Maintain particle count at a maximum of 1000 (disabled by default)
    while (particles.length < 1000 && false) {
      addParticle(random(width), random(height));
    }
  }
}

// Particle class
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = p5.Vector.random2D(); // Assign a random 2D velocity
    this.velocity.mult(random(0.5, 2)); // Scale the velocity
    this.lifespan = random(200, 600); // Assign a random lifespan
    this.fillColor = getComplexColor(x, y); // Get a dynamic color based on position
  }

  // Update the particle's position and state
  update() {
    this.x += this.velocity.x; // Update x position based on velocity
    this.y += this.velocity.y; // Update y position based on velocity
    this.lifespan -= 1.5; // Decrease lifespan over time
    this.velocity.rotate(0.02); // Slightly rotate velocity direction
  }

  // Unified method to apply attraction or repulsion
  applyForce(targetX, targetY, strength, isAttract) {
    let force = createVector(targetX - this.x, targetY - this.y);
    force.normalize();
    force.mult(isAttract ? strength : -strength); // Attraction or repulsion based on mode
    this.velocity.add(force);
  }

  // Display the particle as a fading ellipse
  display() {
    noStroke();
    fill(this.fillColor, map(this.lifespan, 0, 400, 0, 255)); // Adjust transparency based on lifespan
    ellipse(this.x, this.y, map(this.lifespan, 0, 400, 1, 8), map(this.lifespan, 0, 400, 1, 8)); // Draw the particle
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

// Generate a complex color based on position
function getComplexColor(x, y) {
  let distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);

  // Calculate RGB values using sine functions for a dynamic effect
  let r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
  let g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
  let b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;

  return color(r, g, b); // Return the calculated color
}

// Handle key presses for different interactions
function keyPressed() {
  switch (key.toLowerCase()) {
    case 'o':
      mouseInteractionEnabled = !mouseInteractionEnabled; // Toggle mouse interaction
      break;

    case 'a':
      attractMode = !attractMode; // Toggle attraction/repulsion mode
      break;

    case 'n':
      // Add 100 new particles
      for (let i = 0; i < 100; i++) {
        addParticle(random(width), random(height));
      }
      break;

    case 'c':
      particles = []; // Clear all particles
      break;

    case 's':
      // Randomly adjust the speed of all particles
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
