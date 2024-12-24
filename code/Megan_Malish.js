let particles = []; // Array for snowflakes
let attractMode = true; // Controls if snowflakes are attracted to the mouse
let mouseInteractionEnabled = true; // Controls if mouse interaction is enabled

function setup() {
  createCanvas(1000, 700); // Canvas size
  noStroke(); // Disable shape outlines
  
  // Create initial snowflakes
  for (let i = 0; i < 300; i++) {
    addParticle(random(width), 1); // Adds snowflakes at random positions
  }
  frameRate(100); // Set the frame rate
}

function draw() {
  // Semi-transparent light blue background for trailing effect
  fill(137, 196, 255, 50);
  rect(0, 0, width, height);
  
  // Update and display snowflakes
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update(); // Update position and properties
    p.display(); // Display the snowflake

    // Handle mouse interaction
    if (mouseInteractionEnabled && p instanceof Particle) {
      if (attractMode) {
        p.attract(mouseX, mouseY); // Attract snowflake to the mouse
      }
    }

    // Remove dead particles
    if (p.isDead()) {
      particles.splice(i, 1);
    }
  }

  // Add new snowflakes if below the limit
  if (particles.length < 2000) {
    addParticle(random(width), 1);
  }
}

// Base class for shapes
class Shape {
  constructor(x, y, fillColor) {
    this.x = x; // X position
    this.y = y; // Y position
    this.fillColor = color(255, 255, 255); // Default white color
  }

  // Placeholder methods to be overridden by subclasses
  update() {}
  display() {}
}

// Snowflake class extending Shape
class Particle extends Shape {
  constructor(x, y) {
    super(x, y, 1);
    this.velocity = p5.Vector.random2D(); // Random 2D velocity
    this.velocity.mult(random(1.5, 5)); // Random speed
    this.lifespan = random(400, 600); // Random lifespan
  }

  // Update position, lifespan, and rotation
  update() {
    this.x += this.velocity.x; // Update x position
    this.y += this.velocity.y; // Update y position
    this.lifespan -= 1.25; // Decrease lifespan
    this.velocity.rotate(0.01); // Slight rotation of velocity
  }

  // Attract snowflake to a target position
  attract(targetX, targetY) {
    let attraction = createVector(targetX - this.x, targetY - this.y);
    attraction.normalize(); // Normalize to just direction
    attraction.mult(0.05); // Set attraction strength
    this.velocity.add(attraction); // Apply attraction to velocity
  }

  // Display the snowflake as a fading ellipse
  display() {
    noStroke();
    fill(255, map(this.lifespan, 0, 600, 0, 200)); // Adjust transparency
    ellipse(
      this.x,
      this.y,
      map(this.lifespan, 0, 600, 1, 20), // Size decreases with lifespan
      map(this.lifespan, 0, 600, 1, 15)
    );
  }

  // Check if the snowflake has faded completely
  isDead() {
    return this.lifespan < 0;
  }
}

// Add a new snowflake
function addParticle(x, y) {
  particles.push(new Particle(x, y));
}
