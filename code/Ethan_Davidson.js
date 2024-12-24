let a = 5;                // Amplitude of the petals
let k = 10;               // Controls the number of petals in parametric function
let petalLength = 0;      // Length of the petals starts from 0
let maxPetalLength = 150; // Defines maximum petal length to cap growth
let growthRate = 0.2;     // Defines rate of growth to be 20% original speed

let numRaindrops = 100;             // Number of raindrops
let raindrops = [];                 // Array for raindrops

function setup() {
  createCanvas(600, 600); // Set size of art piece

  // Initialize raindrops
  for (let i = 0; i < numRaindrops; i++) {
    raindrops.push(new Raindrop());
  }
}

function draw() {
  background(90); // Gray background to represent the theme

  // Draw and animate raindrops
  for (let i = 0; i < numRaindrops; i++) {
    raindrops[i].fallAndShow();
  }

  drawFlower(); // Draw the flower

  // Increase size of petals
  if (petalLength < maxPetalLength) {
    petalLength += growthRate;
    a = petalLength; // Adjust amplitude to simulate growing petals
  }

  drawStem(); // Draw the stem
}

// Function to draw the flower petals
function drawFlower() {
  noStroke();
  fill(255, 100, 200); // Pink petals

  beginShape();
  for (let theta = 0; theta <= TWO_PI * k; theta += 0.01) {
    let r = a * cos(k * theta);      // Parametric function for flower petals
    let x = r * cos(theta) + 405;   // Offset to position the flower
    let y = r * sin(theta) + 400;
    vertex(x, y);
  }
  endShape(CLOSE);
}

// Function to draw the stem
function drawStem() {
  fill(0, 255, 0);         // Bright green for the stem
  rect(400, 400, 10, 200); // Create stem rectangle
}

// Class for raindrops
class Raindrop {
  constructor() {
    this.x = random(0, 600);      // Random spawn position across the domain
    this.y = random(-600, -50);   // Spawn above the screen before falling
    this.speed = random(2, 5);    // Random speed for raindrops
  }

  fallAndShow() {
    this.y += this.speed;         // Move drop at the specified speed

    // Reset raindrop position when it falls below the screen
    if (this.y > height) {
      this.y = random(-50, -10); // Reset above the screen
      this.x = random(0, 600);   // Randomize horizontal position
    }

    stroke(0, 0, 255);           // Blue raindrop color
    line(this.x, this.y, this.x, this.y + 20); // Draw raindrop as a vertical line
  }
}
