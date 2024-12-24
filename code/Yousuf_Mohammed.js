// Keywords: Edmonton, Frozen, Chaos
// Thematic Sentence: "A chaotic snowstorm blankets Edmonton's frozen skyline, creating a serene yet dynamic scene."

// VARIABLES

let edmonton;           // Variable to store the Edmonton silhouette image
let snowflakes = [];    // Array to store snowflake objects
let numFlakes = 3000;   // Number of snowflakes

// MAIN CODE

function preload() {
  // LOAD IMAGE
  edmonton = loadImage('uploads/Edmonton.png'); // Replace with your Edmonton image path
}

function setup() {
  // WINDOW SETUP
  createCanvas(800, 500); // Set the window size

  // RESIZE IMAGE
  edmonton.resize(width, height);

  // CREATE SNOWFLAKES
  for (let i = 0; i < numFlakes; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  // BACKGROUND COLOR
  background(255);

  // DISPLAY IMAGE
  image(edmonton, 0, 0);

  // UPDATE SNOWFLAKES "FALLING ANIMATION"
  for (let flake of snowflakes) {
    flake.update();  // Update the snowflake's position
    flake.display(); // Draw the snowflake 
  }
}

// CLASSES

class Snowflake {
  constructor() {
    // VARIABLES
    this.x = random(width);       // Random horizontal position
    this.y = random(-height, 0);  // Random vertical position, starting above the screen
    this.size = random(2, 6);     // Random size of the snowflake (2 to 6 pixels)
    this.speed = random(1, 3);    // Random falling speed (1 to 3 pixels per frame)
  }

  // UPDATE SNOWFLAKE POSITION
  update() {
    this.y += this.speed;           // Snowflake falls downward by its speed
    if (this.y > height) {          // If the snowflake moves off the bottom of the screen
      this.y = random(-50, 0);      // Reset it to the top, slightly above the canvas
      this.x = random(width);       // Give it a new random horizontal position
    }
  }

  // DISPLAY SNOWFLAKES
  display() {
    fill(200, 255, 255);       // Light blue-white color for snowflakes
    noStroke();                // No outline for the snowflakes
    ellipse(this.x, this.y, this.size, this.size); // Draw the snowflake as a circle
  }
}
