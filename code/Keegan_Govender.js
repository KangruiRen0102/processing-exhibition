let particles = [];
let bloomRadius = 50;

function setup() {
  createCanvas(800, 800);
  noCursor();
  background(20, 30, 50); // Dark background for contrast
}

function draw() {
  background(20, 30, 50, 25); // Faint background fade for trails

  // Create particles on mouse movement
  if (mouseIsPressed) {
    for (let i = 0; i < 5; i++) {
      particles.push(new Particle(mouseX, mouseY));
    }
  }

  // Update and display particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    // Remove particles that have fully bloomed
    if (p.size > bloomRadius * 1.5) {
      particles.splice(i, 1);
    }
  }

  // Add a faint "bloom" effect at the mouse position
  noFill();
  stroke(255, 200, 150, 50);
  strokeWeight(2);
  ellipse(mouseX, mouseY, bloomRadius, bloomRadius);
}

class Particle {
  constructor(x, y) {
    this.position = createVector(x, y);
    this.velocity = p5.Vector.random2D().mult(random(1, 3));
    this.size = random(5, 10);
    this.growthRate = random(0.5, 1.5);
    this.colour = color(random(150, 255), random(50, 200), random(100, 255), 150);
  }

  update() {
    this.position.add(this.velocity);
    this.size += this.growthRate;
  }

  display() {
    noStroke();
    fill(this.colour, map(this.size, 5, bloomRadius * 1.5, 255, 50));
    ellipse(this.position.x, this.position.y, this.size, this.size);
  }
}

function keyPressed() {
  if (key === 'r' || key === 'R') {
    particles = []; // Reset the particles
  }
}
