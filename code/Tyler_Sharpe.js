let nParticles = 300; // Number of particles
let particles = [];

function setup() {
  createCanvas(800, 800);
  smooth();
  background(20);

  // Initialize particles
  for (let i = 0; i < nParticles; i++) {
    particles.push(new Particle());
  }
}

function draw() {
  fill(20, 20, 30, 20); // Fading background for motion trails
  noStroke();
  rect(0, 0, width, height);

  translate(width / 2, height / 2);

  // Update and display particles
  for (let p of particles) {
    p.update();
    p.display();
  }

  // Central focal point representing growth and structure
  fill(255, 100, 100, 200);
  noStroke();
  ellipse(0, 0, 50, 50);
}

class Particle {
  constructor() {
    // Initialize position and velocity
    this.position = p5.Vector.random2D().mult(random(100, width / 2));
    this.velocity = p5.Vector.random2D().mult(random(1, 3));
    this.col = color(random(100, 255), random(100, 255), random(100, 255), 200);
  }

  update() {
    // Update position and add randomness for chaos
    this.position.add(this.velocity);
    this.velocity.add(p5.Vector.random2D().mult(0.5));

    // Gradually pull towards the center (growth)
    let center = createVector(0, 0);
    let force = p5.Vector.sub(center, this.position);
    force.mult(0.01); // Strength of pull
    this.velocity.add(force);

    // Constrain particles within the canvas bounds
    this.position.x = constrain(this.position.x, -width / 2, width / 2);
    this.position.y = constrain(this.position.y, -height / 2, height / 2);
  }

  display() {
    stroke(this.col);
    strokeWeight(2);
    point(this.position.x, this.position.y);
  }
}
