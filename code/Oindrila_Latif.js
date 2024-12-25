let numParticles = 600; // Number of particles
let particles = []; // Array to hold all particles
let mouseInteracted = false; // Track mouse interaction
let timeVar = 0; // Time-based variable for animation effects

function setup() {
  createCanvas(1024, 768, WEBGL); // Enable 3D rendering
  colorMode(HSB, 360, 255, 255, 255); // HSB color mode for gradients
  noStroke(); // Disable stroke globally
  for (let i = 0; i < numParticles; i++) {
    particles.push(new Particle());
  }
}

function draw() {
  background(0); // Clear screen with black
  
  // Set up the 3D view
  push();
  translate(0, 0, -600); // Center and adjust the view
  rotateY(frameCount * 0.002); // Increased rotation speed for better visibility
  
  // Set blend mode for aurora
  blendMode(ADD);
  
  // Draw aurora layers
  for (let layer = -10; layer <= 10; layer++) {
    let zOffset = layer * 80; // Spacing between layers
    drawAuroraLayer(zOffset);
  }
  
  // Reset blend mode to normal
  blendMode(BLEND);
  
  pop();
  
  // Update and draw particles
  for (let p of particles) {
    p.update();
    p.display();
  }

  // Mouse interaction effect
  if (mouseInteracted) {
    drawInteractiveEffect();
  }

  timeVar += 0.01; // Increment time for dynamic color changes
}

// Function to draw aurora layers
function drawAuroraLayer(zOffset) {
  beginShape(TRIANGLE_STRIP);
  for (let x = -width / 2; x <= width / 2; x += 6) { // Adjusted x range for WEBGL
    // Generate dynamic y positions using noise
    let y1 = noise(x * 0.02, timeVar * 0.005) * 400 - 200;
    let y2 = noise(x * 0.02, timeVar * 0.005 + 1000) * 400 - 200;

    // Dynamic hue shifting based on position and time
    let hueVal = map(x, -width / 2, width / 2, 160, 280) + sin(timeVar * 0.1 + x * 0.02) * 30;
    hueVal = (hueVal + 360) % 360; // Ensure hue is within 0-360

    // Top vertex color
    fill(hueVal, 200, 255, 180);
    vertex(x, y1, zOffset);
    
    // Bottom vertex color with slight transparency and depth adjustment
    fill(hueVal, 150, 200, 120);
    vertex(x, y2, zOffset - 80);
  }
  endShape();
}

// Mouse interaction toggles interactive effect
function mousePressed() {
  mouseInteracted = !mouseInteracted;
}

// Function to draw interactive circular effect
function drawInteractiveEffect() {
  push();
  // In WEBGL, mouseX and mouseY are centered
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

  // Display the particle with color based on z-depth and lifespan
  display() {
    push();
    translate(this.position.x, this.position.y, this.position.z);
    let hue = map(this.position.z, -500, 500, 200, 360); // Map z-depth to hue
    noStroke();
    let alpha = map(this.lifespan, 0, 400, 0, 255); // Map lifespan to alpha
    alpha = constrain(alpha, 0, 255); // Ensure alpha is within bounds
    fill(hue, 255, 255, alpha);
    sphere(this.size); // Display particle as a sphere
    pop();
  }
}
