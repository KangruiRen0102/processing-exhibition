let numSnowflakes = 100; // Add 100 snowflakes to the animation
let snowflakes = []; // Array for snowflakes
let lightning = false; // Indicator for when the lightning should flash

function setup() {
  createCanvas(800, 600);
  // Initialize each snowflake with a random position and speed
  for (let i = 0; i < numSnowflakes; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  background(0); // Black background for each frame

  // Trigger lightning with 1% likelihood
  if (random(1) < 0.01) {
    lightning = true;
  }

  // If lightning is triggered, display yellow flash covering the entire screen
  if (lightning) {
    fill(255, 255, 0); // Fill color yellow
    rect(0, 0, width, height); // Yellow rectangle covering entire screen
    lightning = false; // Stop lightning flash in the next frame
  }

  // Display each snowflake
  for (let s of snowflakes) {
    s.update(); // Downward motion of snowflake
    s.display(); // Add snowflake to screen
  }
}

class Snowflake {
  constructor() {
    this.x = random(width); // Randomize the horizontal position
    this.y = random(-100, height); // Randomize the vertical position
    this.speed = random(1, 3); // Randomize the speed
  }

  // Update the snowflake's position
  update() {
    this.y += this.speed; // Move downward by its speed
    if (this.y > height) {
      this.y = random(-100, -10); // Reset to position above frame
      this.x = random(width); // Determine new horizontal position
    }
  }

  // Draw snowflake as a white dot/circle
  display() {
    fill(255); // Color (white)
    noStroke(); // No outline
    ellipse(this.x, this.y, 5, 5); // Draw snowflake
  }
}
