let creature;
let smallFishes = [];

// Setup the canvas and initialize the morphing creature and small fish
function setup() {
  createCanvas(800, 600); // Canvas size
  creature = new MorphingCreature(createVector(width / 2, height / 2), 50, color(255, 150, 100));
  
  // Initialize a list of small fish with random positions and sizes
  for (let i = 0; i < 10; i++) {
    smallFishes.push(new SmallFish(random(width), random(height), 15, color(200, 100, 50)));
  }
}

// Main draw loop: update the display
function draw() {
  drawBackground(); // Draw the underwater background
  
  // Display all small fish
  for (let i = smallFishes.length - 1; i >= 0; i--) {
    smallFishes[i].display();
  }
  
  // Update and draw the morphing creature
  creature.updatePosition(); // Smoothly move creature to the target position
  creature.morph();          // Render the current stage of the creature
}

// Handle mouse clicks: interact with fish or move the morphing creature
function mousePressed() {
  // Check if a small fish is clicked
  for (let i = smallFishes.length - 1; i >= 0; i--) {
    if (smallFishes[i].isClicked(mouseX, mouseY)) {
      smallFishes.splice(i, 1); // Remove the clicked fish
    }
  }
  
  // Move the morphing creature to the clicked location and advance its stage
  creature.setTarget(mouseX, mouseY);
  creature.advanceMorphStage();
}

// Draw the underwater background with light rays
function drawBackground() {
  // Gradient effect for the ocean
  for (let y = 0; y < height; y++) {
    let brightness = map(y, 0, height, 50, 150);
    stroke(0, 100, 200, brightness); // Gradient blue
    line(0, y, width, y);
  }
  drawLightRays(); // Add dynamic light rays
}

// Draw dynamic light rays moving across the screen
function drawLightRays() {
  for (let i = 0; i < 5; i++) {
    let x = sin(frameCount * 0.01 + i) * width; // Oscillating x positions
    stroke(255, 50); // Transparent white for light rays
    line(x, 0, x + 100, height);
  }
}

// Class representing the morphing creature
class MorphingCreature {
  constructor(pos, sz, c) {
    this.position = pos;       // Current position
    this.target = pos.copy();  // Target starts at the initial position
    this.size = sz;            // Size of the creature
    this.bodyColor = c;        // Initial color
    this.morphStage = 0;       // Start at the first stage (fish)
  }

  setTarget(x, y) {
    this.target.set(x, y); // Set a new target position
  }

  updatePosition() {
    this.position = p5.Vector.lerp(this.position, this.target, 0.05); // Linear interpolation
  }

  advanceMorphStage() {
    this.morphStage = (this.morphStage + 1) % 3; // Cycle through three stages
  }

  morph() {
    if (this.morphStage === 0) this.drawFish();       // Stage 1: Fish
    else if (this.morphStage === 1) this.drawShark(); // Stage 2: Shark
    else this.drawMegalodon();                       // Stage 3: Megalodon
  }

  drawFish() {
    fill(this.bodyColor);
    noStroke();
    // Fish body using Bézier curves
    beginShape();
    vertex(this.position.x - this.size * 0.6, this.position.y);
    bezierVertex(
      this.position.x - this.size * 0.3,
      this.position.y - this.size * 0.5,
      this.position.x + this.size * 0.3,
      this.position.y - this.size * 0.5,
      this.position.x + this.size * 0.6,
      this.position.y
    );
    bezierVertex(
      this.position.x + this.size * 0.3,
      this.position.y + this.size * 0.5,
      this.position.x - this.size * 0.3,
      this.position.y + this.size * 0.5,
      this.position.x - this.size * 0.6,
      this.position.y
    );
    endShape(CLOSE);
    // Fish tail
    beginShape();
    vertex(this.position.x - this.size * 0.6, this.position.y);
    vertex(this.position.x - this.size * 0.9, this.position.y - this.size * 0.2);
    vertex(this.position.x - this.size * 0.9, this.position.y + this.size * 0.2);
    endShape(CLOSE);
  }

  drawShark() {
    fill(50, 50, 100);
    noStroke();
    beginShape();
    vertex(this.position.x - this.size, this.position.y);
    bezierVertex(
      this.position.x - this.size * 0.5,
      this.position.y - this.size,
      this.position.x + this.size * 0.5,
      this.position.y - this.size,
      this.position.x + this.size,
      this.position.y
    );
    bezierVertex(
      this.position.x + this.size * 0.5,
      this.position.y + this.size,
      this.position.x - this.size * 0.5,
      this.position.y + this.size,
      this.position.x - this.size,
      this.position.y
    );
    endShape(CLOSE);
    // Dorsal fin
    beginShape();
    vertex(this.position.x - this.size * 0.2, this.position.y - this.size * 0.5);
    vertex(this.position.x, this.position.y - this.size * 1.2);
    vertex(this.position.x + this.size * 0.2, this.position.y - this.size * 0.5);
    endShape(CLOSE);
  }

  drawMegalodon() {
    fill(30, 30, 80);
    noStroke();
    beginShape();
    vertex(this.position.x - this.size * 1.5, this.position.y);
    bezierVertex(
      this.position.x - this.size,
      this.position.y - this.size * 1.5,
      this.position.x + this.size,
      this.position.y - this.size * 1.5,
      this.position.x + this.size * 1.5,
      this.position.y
    );
    bezierVertex(
      this.position.x + this.size,
      this.position.y + this.size * 1.5,
      this.position.x - this.size,
      this.position.y + this.size * 1.5,
      this.position.x - this.size * 1.5,
      this.position.y
    );
    endShape(CLOSE);
    // Dorsal fin
    beginShape();
    vertex(this.position.x - this.size * 0.3, this.position.y - this.size * 0.8);
    vertex(this.position.x, this.position.y - this.size * 1.6);
    vertex(this.position.x + this.size * 0.3, this.position.y - this.size * 0.8);
    endShape(CLOSE);
  }
}

// Class representing small stationary fish
class SmallFish {
  constructor(x, y, size, bodyColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.bodyColor = bodyColor;
  }

  display() {
    fill(this.bodyColor);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size * 0.6); // Fish body
    triangle(
      this.x - this.size * 0.5,
      this.y,
      this.x - this.size,
      this.y - this.size * 0.2,
      this.x - this.size,
      this.y + this.size * 0.2
    ); // Fish tail
  }

  isClicked(mouseX, mouseY) {
    return dist(mouseX, mouseY, this.x, this.y) < this.size; // Check if click is within fish bounds
  }
}
