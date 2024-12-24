let numParticles = 600; // Number of particles
let particles = []; // Array to hold all particles
let mouseInteracted = false; // Track mouse interaction
let time = 0; // Time-based variable for animation effects

function setup() {
  createCanvas(1024, 768, WEBGL); // Enable 3D rendering
  colorMode(HSB, 360, 255, 255, 255); // HSB color mode for gradients
  for (let i = 0; i < numParticles; i++) {
    particles.push(new Particle());
  }
}

function draw() {
  background(0); // Clear screen with black
  translate(0, 0, -600); // Center and adjust the view
  rotateY(frameCount * 0.001); // Subtle rotation for dynamic 3D visualization

  // Draw layered aurora
  for (let layer = -10; layer <= 10; layer++) {
    let zOffset = layer * 80; // Spacing between layers
    drawAuroraLayer(zOffset);
  }

  // Update and draw particles
  for (let p of particles) {
    p.update();
    p.display();
  }

  // Mouse interaction effect
  if (mouseInteracted) {
    drawInteractiveEffect();
  }

  time += 0.01; // Increment time for dynamic color changes
}

// Function to draw aurora layers
function drawAuroraLayer(zOffset) {
  beginShape(TRIANGLE_STRIP);
  for (let x = -width; x <= width; x += 6) {
    let y1 = noise(x * 0.02, frameCount * 0.005) * 400 - 200;
    let y2 = noise(x * 0.02, frameCount * 0.005 + 1000) * 400 - 200;

    let hue = map(x, -width, width, 160, 280) + sin(time * 0.1 + x * 0.02) * 30;

    fill(hue, 200, 255, 180); // Top vertex color
    vertex(x, y1, zOffset);

    fill(hue, 150, 200, 120); // Bottom vertex color
    vertex(x, y2, zOffset - 80);
  }
  endShape();
}

// Mouse interaction toggles particle effect
function mousePressed() {
  mouseInteracted = !mouseInteracted;
}

// Function to draw interactive circular effect
function drawInteractiveEffect() {
  push();
  translate(mouseX - width / 2, mouseY - height / 2, 0);
  for (let i = 0; i < 50; i++) {
    let angle = radians((i * 360) / 50);
    let x = cos(angle) * 80;
    let y = sin(angle) * 80;
    stroke((frameCount + i * 5) % 360, 200, 255);
    line(0, 0, x, y);
  }
  pop();
}

// Particle class
class Particle {
  constructor() {
    this.reset();
  }

  // Reset particle properties
  reset() {
    this.position = createVector(
      random(-width / 2, width / 2),
      random(-height / 2, height / 2),
      random(-500, 500)
    );
    this.velocity = createVector(random(-1, 1), random(-1, 1), random(-1, 1));
    this.lifespan = random(300, 400);
    this.size = random(4, 8);
    this.speed = random(0.5, 1.5);
  }

  // Update particle position and lifespan
  update() {
    this.position.add(p5.Vector.mult(this.velocity, this.speed));
    this.lifespan -= 1.5;
    if (this.lifespan < 0) {
      this.reset();
    }
  }

  // Display the particle
  display() {
    push();
    translate(this.position.x, this.position.y, this.position.z);
    let hue = map(this.position.z, -500, 500, 200, 360);
    noStroke();
    fill(hue, 255, 255, this.lifespan);
    sphere(this.size);
    pop();
  }
}
