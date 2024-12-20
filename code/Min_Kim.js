let numShapes = 100;
let shapes = []; // Array to store shapes

function setup() {
  createCanvas(600, 600); // Set canvas size
  for (let i = 0; i < numShapes; i++) {
    shapes.push(new Shape(random(width), random(height))); // Initialize shapes
  }
}

function draw() {
  background(20); // Dark background for contrast
  for (let i = 0; i < numShapes; i++) {
    shapes[i].move();
    shapes[i].display();
  }
}

class Shape {
  constructor(xPos, yPos) {
    this.x = xPos;
    this.y = yPos;
    this.xSpeed = random(-2, 2);
    this.ySpeed = random(-2, 2);
    this.size = random(10, 20);
  }

  move() {
    // Shapes move randomly, symbolizing chaos
    this.x += this.xSpeed;
    this.y += this.ySpeed;

    // Reverse direction if hitting edges
    if (this.x < 0 || this.x > width) this.xSpeed *= -1;
    if (this.y < 0 || this.y > height) this.ySpeed *= -1;

    // Gradually pull shapes toward the center, representing focus over time
    this.x += (width / 2 - this.x) * 0.005;
    this.y += (height / 2 - this.y) * 0.005;
  }

  display() {
    noStroke();
    fill(255, 150, 0, 150); // Bright color for energy
    ellipse(this.x, this.y, this.size, this.size);
  }
}
