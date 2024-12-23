let memories = []; // Array to store memory objects (fleeting and lasting)

function setup() {
  createCanvas(800, 600); // Set canvas size to 800x600 pixels
  frameRate(45); // Set frame rate for smooth animation at 45 frames per second
}

function draw() {
  fill(0, 15);
  rect(0, 0, width, height); // Draws a rectangle to create a fading effect on the canvas

  // Add new memory particles at specific intervals
  if (frameCount % 2 === 0) {
    // Add a new FleetingMemory every 2 frames (frequent)
    memories.push(new FleetingMemory(random(width), random(height)));
  }
  if (frameCount % 500 === 0) {
    // Add a new LastingMemory every 500 frames (infrequent)
    memories.push(new LastingMemory(random(width), random(height)));
  }

  // Update and display each memory in the list
  for (let i = memories.length - 1; i >= 0; i--) {
    let memory = memories[i];
    memory.update(); // Update the memory's position and fading
    memory.display(); // Display the memory with its current attributes

    // Remove memory if it has faded out or moved off the canvas
    if (memory.isDead()) {
      memories.splice(i, 1);
    }
  }
}

// Abstract class for memory shapes
class Shape {
  constructor(x, y, fillColor) {
    this.x = x; // Position coordinates
    this.y = y;
    this.fillColor = fillColor; // Fill color of the shape
    this.alpha = 255; // Start with full opacity for new memories
  }

  // Abstract methods to be implemented by subclasses
  update() {}
  display() {}
  isDead() {
    return this.alpha < 0;
  }
}

// FleetingMemory class for small, quick-moving particles that fade rapidly
class FleetingMemory extends Shape {
  constructor(x, y) {
    super(x, y, getComplexColor(x, y));
    this.velocity = p5.Vector.random2D().mult(random(4, 5)); // Random initial direction and speed
    this.size = random(3, 5); // Small size for fleeting memories
  }

  update() {
    this.x += this.velocity.x; // Update position
    this.y += this.velocity.y;
    this.alpha -= random(1, 8); // Fade rapidly
  }

  display() {
    noStroke();
    fill(this.fillColor, this.alpha);
    ellipse(this.x, this.y, this.size, this.size); // Draw a small circle
  }

  isDead() {
    return this.alpha < 0 || this.x > width + 100 || this.y > height + 100 || this.y < -100;
  }
}

// LastingMemory class for larger, slow-fading oval shapes
class LastingMemory extends Shape {
  constructor(x, y) {
    super(x, y, getComplexColor(x, y));
    this.drift = createVector(random(-0.5, 0.5), random(-0.5, 0.5)); // Small random drift
    this.size = random(80, 250); // Large size for significant memories
    this.rotation = random(TWO_PI); // Random initial rotation
  }

  update() {
    this.x += this.drift.x; // Update position
    this.y += this.drift.y;
    this.rotation += 0.001; // Slow rotation
    this.alpha -= 0.3; // Slow fade-out
  }

  display() {
    push();
    translate(this.x, this.y);
    rotate(this.rotation);
    fill(this.fillColor, this.alpha);
    noStroke();
    ellipse(0, 0, this.size, this.size * 0.5); // Draw an ellipse
    pop();
  }

  isDead() {
    return this.alpha < 0 || this.x > width + 100 || this.y > height + 100 || this.y < -100;
  }
}

// Generate colors based on object position
function getComplexColor(x, y) {
  let distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);

  // Calculate R, G, B values with sine functions
  let r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
  let g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
  let b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;

  return color(r, g, b);
}

// Key controls to add bursts of small/large or clear all memories
function keyPressed() {
  switch (key.toLowerCase()) {
    case 'c':
      memories = []; // Clear all memories
      break;
    case 'n':
      // Add bursts of memories
      for (let i = 0; i < 20; i++) {
        memories.push(new FleetingMemory(random(width), random(height)));
      }
      for (let i = 0; i < 5; i++) {
        memories.push(new LastingMemory(random(width), random(height)));
      }
      break;
  }
}
