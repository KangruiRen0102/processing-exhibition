let cols, rows;
let scl = 20; // Scale of each grid
let zoff = 0; // Z-offset for 3D Perlin noise
let particles = []; // Array to store particles
let flowfield = []; // Store flow vectors
let i = 0;

function setup() {
  createCanvas(600, 800); // Size of the canvas
  cols = floor(width / scl); // Calculate number of columns based on canvas width and scale
  rows = floor(height / scl); // Calculate number of rows based on canvas height and scale
  flowfield = new Array(cols * rows); // Initialize the flow array with one vector per cell

  for (let i = 0; i < 2000; i++) {
    particles.push(new Particle()); // Create 2000 particles
  }
  background(243, 234, 226); // Set background color
}

function draw() {
  let yoff = 0; // Initialize
  for (let y = 0; y < rows; y++) { // Loop through rows
    let xoff = 0; // Initialize
    for (let x = 0; x < cols; x++) { // Loop through columns
      let index = x + y * cols; // Index
      let angle = noise(xoff, yoff, zoff) * TWO_PI * 2; // Angle
      let v = p5.Vector.fromAngle(angle); // Create a vector from the angle
      v.setMag(1);
      flowfield[index] = v; // Store vector in flowfield
      xoff += 0.1; // Increment for x
    }
    yoff += 0.1; // Increment for y
  }
  zoff += 0.01; // Increment for z to animate flow vectors over time

  // Update and display particles
  for (let p of particles) {
    p.follow(flowfield);
    p.update();
    p.edges();
    p.show();
  }

  // Draw a radial gradient and an expanding white circle
  radialGradient(width / 2, height / 2, 0, 
                 width / 2, height / 2, 130, 
                 color(232, 123, 116), 
                 color(255));

  noStroke();
  i += 0.1; 
  fill(255); // Set the fill color to white for the circle
  if (i < 80) {
    ellipse(width / 2, height / 2, i, i); // Draw circle
  } else {
    ellipse(width / 2, height / 2, 80, 80); // Circle size maxes out at 80
  }
}

// Particle class to simulate particle flow on the canvas
class Particle {
  constructor() {
    this.pos = createVector(random(width), random(height)); // Random starting position within the canvas
    this.vel = createVector(); // Initial velocity is zero
    this.acc = createVector(); // Initial acceleration is zero
    this.maxspeed = 2; // Maximum speed
    this.col = color(68, 105, 161, 5);
  }

  follow(flowfield) {
    let x = floor(this.pos.x / scl); // Determine the column in the flow field
    let y = floor(this.pos.y / scl); // Determine the row in the flow field
    let index = x + y * cols; // Calculate the index in the flow field array
    if (index >= 0 && index < flowfield.length) { // Ensure the index is within bounds
      let force = flowfield[index]; // Get the corresponding vector from the flow field
      this.applyForce(force); // Apply the force to the particle
    }
  }

  applyForce(force) {
    this.acc.add(force); // Add the force to the acceleration
  }

  update() {
    this.vel.add(this.acc);
    this.vel.limit(this.maxspeed);
    this.pos.add(this.vel); // Update position based on velocity
    this.acc.mult(0); // Reset acceleration after applying it
  }

  edges() {
    if (this.pos.x > width) this.pos.x = 0; // Wrap around right edge
    if (this.pos.x < 0) this.pos.x = width; // Wrap around left edge
    if (this.pos.y > height) this.pos.y = 0; // Wrap around bottom edge
    if (this.pos.y < 0) this.pos.y = height; // Wrap around top edge
  }

  show() {
    let d = dist(this.pos.x, this.pos.y, mouseX, mouseY); // Distance from mouse cursor
    if (d < 50) {
      this.col = color(128, 0, 128, 5); // Change color if within 50 pixels of mouse cursor
    } else {
      this.col = color(68, 105, 161, 5); // Default color
    }

    strokeWeight(2); // Brush/drawing thickness
    if (random(1) < 0.01) {
      stroke(255, 255, 255, 200);
      strokeWeight(1);
    } else {
      stroke(this.col);
    }
    point(this.pos.x, this.pos.y); // Draw particle
  }
}

// Function to create a smooth radial gradient effect by blending colors across concentric circles
function radialGradient(sX, sY, sR, eX, eY, eR, colorS, colorE) {
  for (let r = sR; r < eR; r += 1) { // Loop through radii to create concentric circles
    let inter = map(r, sR, eR, 0, 1); // Calculate interpolation factor
    stroke(lerpColor(colorS, colorE, inter));
    noFill();
    ellipse(sX, sY, r * 2, r * 2); // Draw gradient ellipse
  }
}
