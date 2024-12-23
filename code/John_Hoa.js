let elements = []; // Array to hold visual elements
let waveOffset = 0; // Offset for animating waves

function setup() {
  createCanvas(800, 600);

  // Add static elements like the sun and background
  elements.push(new Sun(width - 100, 100, 80, color(255, 223, 0)));

  for (let i = 0; i < 10; i++) {
    let x = random(100, width - 100);
    let y = random(height - 200, height - 50);
    elements.push(new Starfish(x, y, random(20, 40), color(255, 127, 80)));
    elements.push(new Seashell(x + random(-30, 30), y + random(-30, 30), random(15, 30), color(238, 130, 238)));
  }
}

function draw() {
  background(135, 206, 235); // Sky blue
  drawWaves(); // Dynamic sea waves

  // Draw all static elements
  for (let element of elements) {
    element.display();
  }

  drawBoat(); // A simple boat representing discovery and connection
}

// Function to draw animated waves
function drawWaves() {
  noStroke();
  for (let i = height / 2; i < height; i += 20) {
    fill(0, 105 + i / 10, 148);
    beginShape();
    for (let x = 0; x <= width; x++) {
      let y = sin((x + waveOffset) * 0.02) * 10 + i;
      vertex(x, y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  waveOffset += 1; // Increment offset for animation
}

// Function to draw a boat
function drawBoat() {
  fill(139, 69, 19); // Brown boat
  rectMode(CENTER);
  rect(width / 2, height / 2, 120, 20);

  fill(255); // White sail
  triangle(width / 2 - 10, height / 2 - 10, width / 2 + 50, height / 2 - 60, width / 2 + 50, height / 2);
}

// Base Shape class
class Shape {
  constructor(x, y, fillColor) {
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }

  display() {
    fill(this.fillColor);
    noStroke();
  }
}

// Sun class
class Sun extends Shape {
  constructor(x, y, radius, fillColor) {
    super(x, y, fillColor);
    this.radius = radius;
  }

  display() {
    super.display();
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }
}

// Starfish class
class Starfish extends Shape {
  constructor(x, y, size, fillColor) {
    super(x, y, fillColor);
    this.size = size;
  }

  display() {
    super.display();
    push();
    translate(this.x, this.y);
    for (let i = 0; i < 5; i++) {
      ellipse(0, this.size / 2, this.size / 4, this.size);
      rotate(TWO_PI / 5);
    }
    pop();
  }
}

// Seashell class
class Seashell extends Shape {
  constructor(x, y, radius, fillColor) {
    super(x, y, fillColor);
    this.radius = radius;
  }

  display() {
    super.display();
    arc(this.x, this.y, this.radius * 2, this.radius, PI, TWO_PI);
  }
}
