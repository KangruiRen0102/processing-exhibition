let particles = []; // Array to store all the particles (treated as shapes)
let spin = 0; // This variable controls the rotation of the particle paths
let size = 250; // This variable controls the size of the firework explosions
let freeze = 1; // This variable controls whether animations are frozen

function setup() {
  createCanvas(1200, 800); // Set the canvas size
  noStroke(); // Disable the stroke for shapes
  frameRate(60); // Set frame rate to 60 frames per second for smoother animation
}

function draw() {
  fill(0, 15); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

  // Update and display each particle
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update(); // Update particle position and state
    p.display(); // Display the particle
    if (p.isDead()) {
      particles.splice(i, 1); // Remove dead particles
    }
  }
}

// Particle class representing individual particles
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = p5.Vector.random2D().mult(random(0.5, 6));
    this.lifespan = random(250, 350);
    this.fillColor = getComplexColor(x, y);
  }

  update() {
    this.x += this.velocity.x * freeze; // Update x position based on velocity and freeze
    this.y += this.velocity.y * freeze; // Update y position based on velocity and freeze
    this.lifespan -= 1.5 * freeze; // Decrease lifespan over time unless frozen
    this.velocity.rotate(freeze * spin); // Slightly rotate velocity direction based on spin unless frozen
  }

  display() {
    noStroke();
    fill(this.fillColor, map(this.lifespan, 0, 400, 0, 255)); // Adjust transparency based on lifespan
    ellipse(this.x, this.y, map(this.lifespan, 0, 400, 1, 8), map(this.lifespan, 0, 400, 1, 8)); // Draw the particle
  }

  isDead() {
    return this.lifespan < 0; // Check if the particle is dead
  }
}

function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

function getComplexColor(x, y) {
  let distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);

  // Calculate RGB values using sine functions for a dynamic effect
  let r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
  let g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
  let b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;

  return color(r, g, b);
}

function keyPressed() {
  switch (key.toLowerCase()) {
    case 'p':
      // Adds a new group of particles as a firework explosion
      for (let i = 0; i < size * freeze; i++) {
        addParticle(mouseX, mouseY);
      }
      break;

    case 'n':
      // Increases the size of the firework explosion
      size += 100;
      break;

    case 'm':
      // Decreases the size of the firework explosion
      size = max(100, size - 100);
      break;

    case 'k':
      // Increases the explosion's twist clockwise
      spin += 0.01 * freeze;
      break;

    case 'l':
      // Increases the explosion's twist counterclockwise
      spin -= 0.01 * freeze;
      break;

    case 'd':
      // Freezes time by stopping particle movement, spin, and aging
      freeze = 0;
      break;

    case 's':
      // Unfreezes time by resuming particle movement, spin, and aging
      freeze = 1;
      break;

    case 'r':
      // Resets the canvas to the original conditions
      particles = []; // Clears all particles
      spin = 0; // Resets spin
      size = 250; // Resets size
      freeze = 1; // Unfreezes time
      break;
  }
}
