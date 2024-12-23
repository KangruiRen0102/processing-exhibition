let animals = []; // List to hold all the animals
let footprints = []; // List to hold footprints
let flameX, flameY; // Position of the flame
const numAnimals = 10; // Number of animals

class Animal {
  constructor(x, y, speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.direction = random(TWO_PI); // Random starting direction
    this.targetAngle = random(TWO_PI); // Initial target angle
    this.angleOffset = random(-1.0, 1.0); // Random offset for zigzag movement
    this.c = color(139, 69, 19); // Brown color
    this.headSize = 15; // Size of the animal's head
  }

  moveTowards(targetX, targetY) {
    // Calculate the angle to the target
    const angleToTarget = atan2(targetY - this.y, targetX - this.x);
    // Introduce randomness for wavy movement
    this.targetAngle = angleToTarget + sin(this.angleOffset) * 0.5;
    // Update position
    this.x += cos(this.targetAngle) * this.speed;
    this.y += sin(this.targetAngle) * this.speed;
    // Update angle offset
    this.angleOffset += random(-0.1, 0.1);
    // Leave a footprint
    this.leaveFootprint();
  }

  display() {
    push();
    // Rotate based on movement direction
    const movementAngle = atan2(sin(this.targetAngle), cos(this.targetAngle));
    translate(this.x, this.y);
    rotate(movementAngle);

    // Draw body
    fill(this.c);
    ellipse(0, 0, 40, 20); // Body

    // Draw head
    fill(139, 69, 19);
    ellipse(20, 0, this.headSize, this.headSize); // Head

    pop();
  }

  leaveFootprint() {
    footprints.push(new Footprint(this.x - 10, this.y + 5, millis()));
    footprints.push(new Footprint(this.x + 10, this.y + 5, millis()));
  }
}

class Footprint {
  constructor(x, y, timestamp) {
    this.x = x;
    this.y = y;
    this.timestamp = timestamp;
  }

  display() {
    const age = millis() - this.timestamp;
    if (age > 2000) return; // Ignore footprints older than 2 seconds

    const alpha = map(age, 0, 2000, 255, 0);
    fill(211, 211, 211, alpha);
    noStroke();
    ellipse(this.x, this.y, 10, 10); // Footprint shape
  }
}

function setup() {
  createCanvas(800, 600);

  // Create animals
  for (let i = 0; i < numAnimals; i++) {
    const x = random(width);
    const y = random(height);
    const speed = random(1.5, 3);
    animals.push(new Animal(x, y, speed));
  }

  // Initialize flame position
  flameX = width / 2;
  flameY = height / 2;
}

function draw() {
  background(255); // Frozen tundra background

  // Draw hope flame
  fill(0, 255, 0, 150);
  noStroke();
  ellipse(flameX, flameY, 100, 100); // Green circle

  // Draw bonfire-like flame
  drawFlame(flameX, flameY);

  // Display footprints
  for (const footprint of footprints) {
    footprint.display();
  }

  // Move and display animals
  for (const animal of animals) {
    animal.moveTowards(flameX, flameY);
    animal.display();
  }
}

function drawFlame(x, y) {
  noStroke();

  // Inner yellow flame
  fill(255, 204, 0, 180);
  ellipse(x, y, 20, 20);

  // Orange outer flame
  fill(255, 102, 0, 150);
  ellipse(x, y - 5, 35, 35);

  // Red largest flame
  fill(255, 0, 0, 120);
  ellipse(x, y + 5, 50, 50);
}

function mouseMoved() {
  // Update flame position
  flameX = mouseX;
  flameY = mouseY;
}
