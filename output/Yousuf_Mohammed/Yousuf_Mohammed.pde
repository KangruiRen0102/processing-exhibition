// Keywords: Edmonton, Frozen, Chaos
// Thematic Sentence: "A chaotic snowstorm blankets Edmonton's frozen skyline, creating a serene yet dynamic scene."

// VARIABLES

PImage edmonton;           // Variable to store the Edmonton silhouette image
Snowflake[] snowflakes;    // Array to store snowflake objects
int numFlakes = 3000;      // Number of snowflakes

// MAIN CODE

void setup() {
  
  // WINDOW SETUP
  size(800, 500); // Set the window size
  
  // LOAD IMAGE
  edmonton = loadImage("Edmonton.png");
  edmonton.resize(width, height);
  
  // CREATE SNOWFLAKES
  snowflakes = new Snowflake[numFlakes]; // Initialize the snowflakes array
  for (int i = 0; i < numFlakes; i++) {
    snowflakes[i] = new Snowflake();
  }
  
}

void draw() {
  
  // BACKGROUND COLOR
  background(255);
  
  // DISPLAY IMAGE
  image(edmonton, 0, 0);
  
  // UPDATE SNOWFLAKES "FALLING ANIMATION"
  for (Snowflake flake : snowflakes) {
    flake.update();  // Update the snowflake's position
    flake.display(); // Draw the snowflake 
  }
  
}

// CLASSES

class Snowflake {
  
  // VARIABLES
  float x, y, size, speed; // Position (x, y), size, and speed of the snowflake

  // SNOWFLAKE CONSTRUCTOR
  Snowflake() {
    x = random(width);       // Random horizontal position
    y = random(-height, 0);  // Random vertical position, starting above the screen
    size = random(2, 6);     // Random size of the snowflake (2 to 6 pixels)
    speed = random(1, 3);    // Random falling speed (1 to 3 pixels per frame)
  }

  // UPDATE SNOWFLAKE POSITION
  void update() {
    y += speed;           // Snowflake falls downward by its speed
    if (y > height) {     // If the snowflake moves off the bottom of the screen
      y = random(-50, 0); // Reset it to the top, slightly above the canvas
      x = random(width);  // Give it a new random horizontal position
    }
  }

  // DISPLAY SNOWFLAKES
  void display() {
    fill(200, 255, 255);       // Light blue-white color for snowflakes
    noStroke();                // No outline for the snowflakes
    ellipse(x, y, size, size); // Draw the snowflake as a circle
  }
  
}
