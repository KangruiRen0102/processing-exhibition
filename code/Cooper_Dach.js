let numParticles = 300;
let particles = [];

function setup() {
  createCanvas(800, 600); // Sets the size of the canvas for the image
  frameRate(60); // Sets the rate at which frames will appear for the animation

  // Creates the particles to signify hope, memory, and discovery
  for (let i = 0; i < numParticles; i++) {
    // Creates the starting point for the particles at the center of the screen
    let angle = random(TWO_PI);
    let speed = random(1, 3);
    // Enables the particles to travel with random speed and direction
    particles.push(new Particle(width / 2, height / 2, cos(angle) * speed, sin(angle) * speed, random(255), random(150, 255), random(255)));
  }
}

function draw() {
  background(30, 30, 50); // Creates the dark background, emphasizing the glow of hope from the particles

  // Displays and updates the particles
  for (let particle of particles) {
    particle.update(); // Recreates the particle's state and position
    particle.display(); // Displays the particles
  }
}

class Particle {
  constructor(x, y, dx, dy, r, g, b) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.c = color(r, g, b); // Assigns color to the particle, with bright colors symbolizing hope
    this.alpha = 255; // Makes the particles fully visible at the starting point
  }

  // Updates the movement and fading effect of the particles over time
  update() {
    this.x += this.dx; // Updates the horizontal position of the particle with respect to velocity
    this.y += this.dy; // Updates the vertical position of the particle with respect to velocity

    this.alpha -= 1; // Gradually fades the particle, symbolizing memories

    // Resets particles after they fade out
    if (this.alpha < 0) {
      this.alpha = 255; // Restores the full visibility of the particle
      this.x = width / 2; // Resets the particle's position to the center
      this.y = height / 2;
      this.dx = random(-2, 2); // Assigns random direction and speed
      this.dy = random(-2, 2);
    }
  }

  // Displays the particles with their color and transparency effect
  display() {
    noStroke(); // Ensures no outline for the particles
    fill(this.c, this.alpha); // Applies the fading alpha along with the color
    ellipse(this.x, this.y, 10, 10); // Draws the particle as an ellipse
  }
}
