let maxRadius = 600;  // Maximum radius of ripples
let speed = 3;        // Speed of ripple expansion
let ripples = []; // List to store multiple ripples
let flowers = []; // List to store multiple flowers
let chaosShapes = []; // List for chaotic shapes
let numFlowers = 5;        // Number of flowers to draw
let angleOffset = 0;     // Petal rotation offset for animation
let minFlowerDistance = 200; // Minimum distance between flowers
let rippleInterval = 50; // Interval between spawning new ripples (milliseconds)
let lastRippleTime = 0;  // Time of the last ripple spawn
let colorStage = 0;        // Stage for color (0 = Blue, 1 = Red, 2 = Green)
let startTime;           // Time when the program starts
let redStartTime;        // Time when the red ripples start
let textAppearTime = 30000; // Time after which the text will start to appear (30 seconds)
let textAlpha = 0;       // Alpha value for the text (starts as invisible)
let textVisible = false; // Flag to indicate if the text should be visible
let chaosMode = false;  // Flag for chaos mode
let chaosStartTime;       // Time when chaos mode starts

function setup() {
  createCanvas(800, 800);  // Canvas size
  noFill();
  resetProgram(); // Initialize the program variables
}

function draw() {
  background(255);  // Clear the screen to white

  if (chaosMode) {
    // Chaos mode: Display chaotic shapes
    for (let shape of chaosShapes) {
      shape.update();
      shape.display();
    }
    return; // Stop drawing anything else
  }

  // Draw all flowers
  for (let flower of flowers) {
    flower.display();
  }

  // Create ripples continuously from each flower's center
  if (millis() - lastRippleTime > rippleInterval) {
    for (let flower of flowers) {
      ripples.push(new Ripple(flower.x, flower.y, speed, colorStage));
    }
    lastRippleTime = millis();
  }

  // Update and draw each ripple
  for (let i = ripples.length - 1; i >= 0; i--) {
    let r = ripples[i];
    r.update();
    r.display();
    if (r.isOffScreen()) {
      ripples.splice(i, 1);
    }
  }

  // Handle color transitions for ripples
  if (millis() - startTime > 5000 && colorStage == 0) {
    colorStage = 1;
    redStartTime = millis();
  }

  if (millis() - redStartTime > 5000 && colorStage == 1) {
    colorStage = 2;
  }

  // Gradually reveal the text after 30 seconds
  if (millis() - startTime > textAppearTime && !chaosMode) {
    textVisible = true;
    if (textAlpha < 255) {
      textAlpha += 1;
    }
  }

  // Display the text after it starts appearing
  if (textVisible) {
    fill(0, 0, 0, textAlpha);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("click to discover something cool", width / 2, height / 2);
  }
}

// Reset the program to its initial state
function resetProgram() {
  ripples = [];  // Clear all ripples
  flowers = []; // Clear all flowers
  chaosShapes = []; // Clear chaotic shapes
  startTime = millis();              // Reset the start time
  textAlpha = 0;
  textVisible = false;
  chaosMode = false;
  colorStage = 0;

  // Create new flowers at random positions ensuring no overlap
  for (let i = 0; i < numFlowers; i++) {
    let flowerX, flowerY;
    let overlaps;
    do {
      flowerX = random(width);
      flowerY = random(height);
      overlaps = false;
      for (let f of flowers) {
        let d = dist(flowerX, flowerY, f.x, f.y);
        if (d < minFlowerDistance) {
          overlaps = true;
          break;
        }
      }
    } while (overlaps);

    let flowerPetals = int(random(5, 12)); // Random number of petals for each flower
    flowers.push(new Flower(flowerX, flowerY, flowerPetals));
  }
}

// Track mouse click
function mousePressed() {
  if (!chaosMode && millis() - startTime >= 31000) {
    chaosMode = true;
    chaosStartTime = millis(); // Record chaos start time
    textVisible = false; // Hide text immediately
    generateChaos(); // Generate initial chaos shapes
  }
}

// Function to generate chaotic shapes
function generateChaos() {
  for (let i = 0; i < 100; i++) { // Generate 100 shapes
    chaosShapes.push(new ChaosShape(random(width), random(height), random(20, 100), random(20, 100)));
  }
}

// Flower class
class Flower {
  constructor(x, y, petals) {
    this.x = x;
    this.y = y;
    this.petals = petals;
  }

  display() {
    drawFlower(this.x, this.y, 100, this.petals, angleOffset);
  }
}

function drawFlower(x, y, radius, petals, angleOffset) {
  push();
  translate(x, y);

  for (let i = 0; i < petals; i++) {
    let angle = TWO_PI / petals * i + angleOffset;
    let petalX = cos(angle) * radius;
    let petalY = sin(angle) * radius;
    drawPetal(petalX, petalY, 100, 40);
  }

  pop();
}

function drawPetal(x, y, w, h) {
  push();
  translate(x, y);
  rotate(atan2(y, x));
  noStroke();
  fill(255, 100, 100, 150);
  ellipse(0, 0, w, h);
  pop();
}

// Ripple class
class Ripple {
  constructor(x, y, speed, colorStage) {
    this.x = x;
    this.y = y;
    this.radius = 0;
    this.speed = speed;
    this.colorStage = colorStage;
  }

  update() {
    this.radius += this.speed;
  }

  display() {
    noFill();
    if (this.colorStage === 0) {
      stroke(0, 100, 255, 150);
    } else if (this.colorStage === 1) {
      stroke(255, 0, 0, 150);
    } else if (this.colorStage === 2) {
      stroke(0, 255, 0, 150);
    }
    strokeWeight(2);
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }

  isOffScreen() {
    return this.radius > max(width, height) * 1.2;
  }
}

// ChaosShape class
class ChaosShape {
  constructor(x, y, w, h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.dx = random(-5, 5); // Random x-speed
    this.dy = random(-5, 5); // Random y-speed
    this.col = color(random(255), random(255), random(255), random(150, 255));
  }

  update() {
    this.x += this.dx;
    this.y += this.dy;

    // Bounce off edges
    if (this.x < 0 || this.x > width) this.dx *= -1;
    if (this.y < 0 || this.y > height) this.dy *= -1;
  }

  display() {
    fill(this.col);
    noStroke();
    let shapeType = int(random(4)); // Random shape type
    switch (shapeType) {
      case 0: ellipse(this.x, this.y, this.w, this.h); break; // Circle
      case 1: rect(this.x, this.y, this.w, this.h); break; // Rectangle
      case 2: triangle(this.x, this.y, this.x + this.w / 2, this.y - this.h, this.x + this.w, this.y); break; // Triangle
      case 3: line(this.x, this.y, this.x + this.w, this.y + this.h); break; // Line
    }
  }
}
