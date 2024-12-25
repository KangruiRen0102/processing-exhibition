
// Array to store all the particles (treated as shapes)
let particles = [];

// Flags to manage interaction modes
let attractMode = false; // Determines whether particles are attracted or repelled by the mouse
let mouseInteractionEnabled = false; // Controls if mouse interaction is enabled
let attractionStrength = 0.05;

// Flock for boids
let flock;

function setup() {
  createCanvas(1200, 800); // Set the canvas size
  noStroke(); // Disable the stroke for shapes

  flock = new Flock(); // Add an initial set of boids into the system

  for (let u = 0; u < 50; u++) {
    flock.addBoid(new Boid(width / 2, height / 2));
  }

  // Create initial particles
  for (let i = 0; i < 500; i++) {
    addParticle(random(width), random(height)); // Add particles at random positions
  }

  frameRate(60); // Set frame rate to 60 frames per second for smoother animation
}

function draw() {
  fill(100, 1); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

  flock.run();

  // Update and display each particle
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update(); // Update particle position and state
    p.display(); // Display the particle

    // Apply mouse interactions if enabled
    if (mouseInteractionEnabled) {
      p.applyForce(mouseX, mouseY, attractionStrength, attractMode); // Unified attraction/repulsion

      // Remove dead particles
      if (p.isDead()) {
        particles.splice(i, 1);
      }
    }
  }

  // Maintain particle count at a maximum of 1000
  while (particles.length < 1000) {
    addParticle(random(width), random(height));
  }
}

// Base class representing a generic shape
class Shape {
  constructor(x, y, fillColor) {
    this.x = x; // Position of the shape
    this.y = y;
    this.fillColor = fillColor; // Fill color of the shape
  }

  update() {}
  display() {}
}

// Particle class extending Shape
class Particle extends Shape {
  constructor(x, y) {
    super(x, y, getComplexColor(x, y)); // Call the parent constructor
    this.velocity = p5.Vector.random2D().mult(random(0.5, 2)); // Assign a random 2D velocity
    this.lifespan = random(200, 400); // Assign a random lifespan
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
  if (key.toLowerCase() === 'c') {
    particles = []; // Clear particles
  }
}

// Boid class for flocking behavior
class Boid {
  constructor(x, y) {
    this.position = createVector(x, y);
    this.velocity = p5.Vector.random2D();
    this.acceleration = createVector(0, 0);
    this.maxSpeed = 2;
    this.maxForce = 0.03;
  }

  run(boids) {
    this.flock(boids);
    this.update();
    this.borders();
    this.render();
  }

  applyForce(force) {
    this.acceleration.add(force);
  }

  flock(boids) {
    let sep = this.separate(boids).mult(1.5);
    let ali = this.align(boids).mult(1.0);
    let coh = this.cohesion(boids).mult(1.0);
    this.applyForce(sep);
    this.applyForce(ali);
    this.applyForce(coh);
  }

  update() {
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.maxSpeed);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  render() {
    let theta = this.velocity.heading() + radians(90);
    fill(200, 100);
    stroke(255);
    push();
    translate(this.position.x, this.position.y);
    rotate(theta);
    beginShape();
    vertex(0, -6);
    vertex(-3, 6);
    vertex(3, 6);
    endShape(CLOSE);
    pop();
  }

  borders() {
    if (this.position.x < -6) this.position.x = width + 6;
    if (this.position.y < -6) this.position.y = height + 6;
    if (this.position.x > width + 6) this.position.x = -6;
    if (this.position.y > height + 6) this.position.y = -6;
  }

  separate(boids) {
    let desiredSeparation = 25.0;
    let steer = createVector(0, 0);
    let count = 0;
    for (let other of boids) {
      let d = p5.Vector.dist(this.position, other.position);
      if (d > 0 && d < desiredSeparation) {
        let diff = p5.Vector.sub(this.position, other.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div(count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(this.maxSpeed);
      steer.sub(this.velocity);
      steer.limit(this.maxForce);
    }
    return steer;
  }

  align(boids) {
    let neighbordist = 50;
    let sum = createVector(0, 0);
    let count = 0;
    for (let other of boids) {
      let d = p5.Vector.dist(this.position, other.position);
      if (d > 0 && d < neighbordist) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(this.maxSpeed);
      let steer = p5.Vector.sub(sum, this.velocity);
      steer.limit(this.maxForce);
      return steer;
    } else {
      return createVector(0, 0);
    }
  }

  cohesion(boids) {
    let neighbordist = 50;
    let sum = createVector(0, 0);
    let count = 0;
    for (let other of boids) {
      let d = p5.Vector.dist(this.position, other.position);
      if (d > 0 && d < neighbordist) {
        sum.add(other.position);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return this.seek(sum);
    } else {
      return createVector(0, 0);
    }
  }

  seek(target) {
    let desired = p5.Vector.sub(target, this.position);
    desired.normalize();
    desired.mult(this.maxSpeed);
    let steer = p5.Vector.sub(desired, this.velocity);
    steer.limit(this.maxForce);
    return steer;
  }
}

// Flock class for managing boids
class Flock {
  constructor() {
    this.boids = [];
  }

  run() {
    for (let boid of this.boids) {
      boid.run(this.boids);
    }
  }

  addBoid(boid) {
    this.boids.push(boid);
  }
}
