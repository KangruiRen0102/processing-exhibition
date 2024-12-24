let numParticles = 169; // Number of particles
let particles = []; // Array to store particles
let center;
let chaosMode = false;
let time = 0;

function setup() {
  createCanvas(699, 699);
  center = createVector(width / 2, height / 2);

  // Initialize particles at random positions on the canvas
  for (let i = 0; i < numParticles; i++) {
    particles.push(new Particle(random(width), random(height)));
  }
}

function draw() {
  background(20, 34, 69, 25); // Ocean-colored background

  // Update and display particles
  for (let p of particles) {
    p.update(); // Update position and behavior
    p.display(); // Render particles on screen
  }

  // Draw the infinity symbol
  drawInfinitySymbol();

  // Increment time for animation effects
  time += 0.01;
}

function drawInfinitySymbol() {
  noFill();
  stroke(100, 150, 255, 150);
  strokeWeight(2);
  let a = 150; // Size of the symbol
  let b = 100; // Height of loops
  beginShape();
  for (let t = 0; t < TWO_PI; t += 0.01) {
    let x = center.x + (a * cos(t)) / (1 + pow(sin(t), 2));
    let y = center.y + (b * sin(t) * cos(t)) / (1 + pow(sin(t), 2));
    vertex(x, y);
  }
  endShape(CLOSE);
}

function mousePressed() {
  chaosMode = !chaosMode; // Toggle chaos mode when the mouse is pressed
}

class Particle {
  constructor(x, y) {
    this.position = createVector(x, y);
    this.velocity = p5.Vector.random2D();
    this.lifespan = 269; // For fading effect
  }

  update() {
    // Update position
    this.position.add(this.velocity);

    // Apply forces based on chaos mode
    let force = chaosMode
      ? p5.Vector.sub(this.position, center)
      : p5.Vector.sub(center, this.position);
    force.normalize();
    force.mult(0.2);
    this.velocity.add(force);

    // Reduce lifespan for fading effect
    this.lifespan -= 0.5;

    // Wrap around screen edges
    if (this.position.x < 0) this.position.x = width;
    if (this.position.x > width) this.position.x = 0;
    if (this.position.y < 0) this.position.y = height;
    if (this.position.y > height) this.position.y = 0;

    // Reset the particle if lifespan reaches zero
    if (this.lifespan <= 0) {
      this.position = createVector(random(width), random(height));
      this.lifespan = 255;
    }
  }

  display() {
    let hue = map(this.position.x, 0, width, 180, 240); // Particle color based on x-position
    stroke(hue, 200, 269, this.lifespan);
    fill(hue, 200, 269, this.lifespan / 2);
    ellipse(this.position.x, this.position.y, 6, 6);
  }
}
