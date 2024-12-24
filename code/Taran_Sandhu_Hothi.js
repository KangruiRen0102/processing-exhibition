// Underwater Generative Art: Sea, Animals, and Discovery

let creatures = []; // List of marine creatures
let treasures = [];  // Positions of glowing treasures

function setup() {
  createCanvas(800, 600);

  // Create marine creatures
  for (let i = 0; i < 15; i++) {
    creatures.push(new SeaCreature(random(width), random(height)));
  }

  // Create scattered treasures
  for (let i = 0; i < 10; i++) {
    treasures.push(createVector(random(width), random(height)));
  }
}

function draw() {
  // Draw underwater gradient background
  for (let i = 0; i < height; i++) {
    let c = map(i, 0, height, 20, 100); // Darker at top, lighter below
    stroke(20, 50, c + 20);
    line(0, i, width, i);
  }

  // Draw glowing treasures to symbolize discovery
  for (let t of treasures) {
    let glow = sin(frameCount * 0.05 + t.x) * 50 + 100; // Pulsating effect
    fill(255, 200, 0, glow);
    noStroke();
    ellipse(t.x, t.y, 12, 12); // Draw treasure as glowing dots
  }

  // Draw and update marine creatures
  for (let sc of creatures) {
    sc.update(); // Update position for fluid movement
    sc.display(); // Draw creature
  }

  // Draw flowing currents as subtle moving lines
  stroke(150, 200, 255, 50);
  noFill();
  for (let i = 0; i < 5; i++) {
    beginShape();
    for (let x = 0; x < width; x += 20) {
      let y = height / 2 + sin(frameCount * 0.01 + x * 0.1 + i * 10) * 50;
      vertex(x, y + random(-2, 2));
    }
    endShape();
  }
}

// Class representing sea creatures
class SeaCreature {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(15, 30);
    this.speedX = random(-1, 1);
    this.speedY = random(-0.5, 0.5);
    this.bodyColor = color(random(100, 255), random(100, 255), random(200, 255));
  }

  // Update position for smooth movement
  update() {
    this.x += this.speedX;
    this.y += this.speedY;

    // Wrap around edges for continuous motion
    if (this.x < 0) this.x = width;
    if (this.x > width) this.x = 0;
    if (this.y < 0) this.y = height;
    if (this.y > height) this.y = 0;
  }

  // Draw the sea creature
  display() {
    fill(this.bodyColor, 150);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size / 2); // Body
    ellipse(this.x - this.size / 3, this.y - this.size / 4, this.size / 3, this.size / 4); // Top fin
    ellipse(this.x - this.size / 3, this.y + this.size / 4, this.size / 3, this.size / 4); // Bottom fin
    fill(255);
    ellipse(this.x + this.size / 4, this.y, this.size / 8, this.size / 8); // Eye
  }
}
