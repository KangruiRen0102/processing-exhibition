//This project was made and coded using ChatGPT

// Theme Sentence: "The infinite frozen expanse of the North Pole illuminated by the aurora borealis."

// Processing Sketch

// Constants for snowflakes
int snowflakeCount = 300; // Total number of snowflakes
float[] snowX = new float[snowflakeCount]; // X-coordinates of snowflakes
float[] snowY = new float[snowflakeCount]; // Y-coordinates of snowflakes
float[] snowXSpeed = new float[snowflakeCount]; // Horizontal speed for each snowflake
float[] snowYSpeed = new float[snowflakeCount]; // Vertical speed for each snowflake

void setup() {
  size(800, 800); // Set the canvas size to 800x800 pixels
  background(10, 10, 40); // Deep blue background to simulate the night sky
  frameRate(2); // Slow frame rate for a calming visual effect

  // Initialize snowflake positions and speeds
  for (int i = 0; i < snowflakeCount; i++) {
    snowX[i] = random(width); // Random starting X position
    snowY[i] = random(height); // Random starting Y position
    snowXSpeed[i] = random(-2, 2); // Small horizontal movement for wind effect
    snowYSpeed[i] = random(2, 5); // Vertical speed for falling snow
  }
}

void draw() {
  background(10, 10, 40, 10); // Soft fade effect to maintain smooth transitions

  // Draw the elements of the scene in layers
  drawMountains(); // Draw the stationary mountain range
  drawFrozen();   // Draw the frozen foreground landscape
  drawAurora();   // Draw the dynamic aurora borealis
  drawMoon();     // Draw the moon in the corner
  drawSnow();     // Animate the snowflakes
}

// Function to draw a stationary mountain range in the background
void drawMountains() {
  noStroke(); // Remove outlines from shapes

  // Farther mountain range (darker color)
  fill(60, 100, 140, 200); // Dark blue-gray color
  triangle(100, height - 150, 300, height - 400, 500, height - 150);
  triangle(400, height - 150, 600, height - 350, 750, height - 150);

  // Closer mountain range (lighter color)
  fill(100, 140, 180, 220); // Slightly lighter blue-gray
  triangle(50, height - 150, 200, height - 300, 350, height - 150);
  triangle(500, height - 150, 700, height - 300, 850, height - 150);
}

// Function to draw the frozen ground in the foreground
void drawFrozen() {
  noStroke();
  fill(200, 240, 255, 200); // Icy white-blue color for the ground
  rect(0, height - 150, width, 150); // Rectangle covering the bottom 150 pixels
}

// Function to draw the aurora borealis with dynamic green waves
void drawAurora() {
  noStroke(); // Remove outlines for smoother shapes
  for (int i = 0; i < 5; i++) { // Create multiple layers for depth
    float y = random(height / 3); // Random vertical position in the upper third
    float widthAurora = random(200, 400); // Variable width for each layer
    fill(random(0, 100), random(150, 255), random(0, 100), 120); // Shades of green with transparency
    ellipse(random(width), y, widthAurora, 60); // Draw an elliptical wave
  }
}

// Function to draw a soft yellow moon in the top-right corner
void drawMoon() {
  noStroke(); // Remove outlines
  fill(255, 255, 200, 200); // Soft yellow color for the moon
  ellipse(width - 100, 100, 80, 80); // Position the moon near the top-right corner
}

// Function to animate snowflakes falling with a slight wind effect
void drawSnow() {
  noStroke(); // Remove outlines for smoother snowflakes
  fill(255, 255, 255, 150); // Semi-transparent white color

  for (int i = 0; i < snowflakeCount; i++) {
    ellipse(snowX[i], snowY[i], 5, 5); // Draw each snowflake as a small circle

    // Update the position of the snowflake
    snowY[i] += snowYSpeed[i]; // Move snowflake downward
    snowX[i] += snowXSpeed[i]; // Add horizontal movement for wind effect

    // Reset snowflake position if it moves off the screen vertically
    if (snowY[i] > height) {
      snowY[i] = 0; // Reset to the top
      snowX[i] = random(width); // Randomize horizontal position
      snowXSpeed[i] = random(-2, 2); // Randomize horizontal speed
      snowYSpeed[i] = random(2, 5); // Randomize vertical speed
    }

    // Wrap snowflake horizontally if it moves off the screen
    if (snowX[i] < 0) {
      snowX[i] = width; // Wrap to the right side
    } else if (snowX[i] > width) {
      snowX[i] = 0; // Wrap to the left side
    }
  }
}
