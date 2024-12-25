// Time, Space, and Chaos

// Key variables for controlling time, chaos mode, and stars
float angle = 0; // For Time (rotating clock-like hands)
boolean chaosMode = false; // Toggle chaos mode
float timeRadius = 150; // Radius for Time hand
float starSpeed = 2; // Speed of star movement
ArrayList<Star> stars = new ArrayList<Star>(); // List to store stars

void setup() {
  // Set canvas size to 1600x900 (16:9 aspect ratio, 100% larger than original)
  size(1600, 900);
  frameRate(60); // Set the frame rate to 60 FPS
  colorMode(HSB, 360, 100, 100); // Set color mode to HSB (Hue, Saturation, Brightness)
  
  // Create 500 stars
  for (int i = 0; i < 500; i++) {
    stars.add(new Star());
  }
}

void draw() {
  background(0); // Black background for space

  // Draw Space: Moving stars
  translate(width / 2, height / 2); // Center the drawing origin
  for (Star s : stars) {
    s.update(); // Update star position
    s.show(); // Display the star
  }

  // Draw translucent clock face with markings
  fill(0, 0, 100, 50); // White, semi-transparent clock face
  noStroke(); // No outline for the clock face
  ellipse(0, 0, timeRadius * 2.5, timeRadius * 2.5); // Draw clock face
  stroke(0); // Black color for clock markings
  strokeWeight(1); // Thin line for clock markings
  for (int i = 0; i < 12; i++) {
    // Draw clock markings for each hour
    float markAngle = TWO_PI / 12 * i;
    float outerX = cos(markAngle) * (timeRadius * 1.2);
    float outerY = sin(markAngle) * (timeRadius * 1.2);
    float innerX = cos(markAngle) * (timeRadius * 1.1);
    float innerY = sin(markAngle) * (timeRadius * 1.1);
    line(outerX, outerY, innerX, innerY); // Line from the outer to the inner mark
  }

  // Draw Time: Rotating clock-like hands
  pushMatrix(); // Save current transformation matrix
  stroke(0); // Black color for clock hands
  strokeWeight(4); // Thicker line for minute hand
  line(0, 0, cos(angle) * timeRadius, sin(angle) * timeRadius); // Minute hand
  strokeWeight(2); // Thinner line for hour hand
  line(0, 0, cos(angle * 12) * (timeRadius * 0.6), sin(angle * 12) * (timeRadius * 0.6)); // Hour hand
  popMatrix(); // Restore previous transformation matrix

  // Update Time (slowly rotate hands)
  angle += 0.005; // Increment angle for time hand
}

void keyPressed() {
  // Toggle Chaos mode with spacebar
  if (key == ' ') {
    chaosMode = !chaosMode; // Toggle the chaosMode variable
    if (chaosMode) {
      // When chaos mode starts, give each star a random direction
      for (Star s : stars) {
        s.startMovingRandomly(); // Start random movement for each star
      }
    } else {
      // Reset stars to normal movement
      for (Star s : stars) {
        s.stopMovingRandomly(); // Stop random movement for each star
      }
    }
  }
}

void mouseDragged() {
  // Adjust Time radius interactively based on mouse position
  timeRadius = map(mouseX, 0, width, 50, 300); // Scale the time radius based on mouseX position
}

class Star {
  float x, y, z;
  float pz;
  float velX, velY; // Velocity for random movement in X and Y directions
  boolean movingRandomly = false; // Flag to check if the star is moving randomly
  color starColor; // Color of the star (red or white)

  Star() {
    x = random(-width, width); // Random X position
    y = random(-height, height); // Random Y position
    z = random(width); // Random depth (Z position)
    pz = z; // Preserve the previous Z position for trailing effect
    velX = 0; // Initial X velocity (no movement)
    velY = 0; // Initial Y velocity (no movement)

    // Random color (either red or white)
    if (random(1) < 0.5) {
      starColor = color(0, 100, 100); // Red color in HSB (Hue, Saturation, Brightness)
    } else {
      starColor = color(0, 0, 100); // White color in HSB
    }
  }

  void update() {
    // If the star is moving randomly (in chaos mode)
    if (movingRandomly) {
      x += velX; // Move the star in X direction
      y += velY; // Move the star in Y direction
    } else {
      // Normal movement of stars (depth effect)
      z -= starSpeed; // Move stars forward based on speed
      if (z < 1) {
        z = width; // Reset the star's depth if it goes too far
        x = random(-width, width); // Reset X position
        y = random(-height, height); // Reset Y position
        pz = z; // Preserve the new depth
      }
    }
  }

  void startMovingRandomly() {
    if (!movingRandomly) {
      movingRandomly = true; // Start random movement
      velX = random(-2, 2); // Set random speed in X direction
      velY = random(-2, 2); // Set random speed in Y direction
    }
  }

  void stopMovingRandomly() {
    movingRandomly = false; // Stop random movement
    velX = 0; // Reset X velocity
    velY = 0; // Reset Y velocity
  }

  void show() {
    float sx = map(x / z, 0, 1, 0, width / 2); // Map X position based on Z (depth)
    float sy = map(y / z, 0, 1, 0, height / 2); // Map Y position based on Z (depth)
    float r = map(z, 0, width, 8, 0); // Map radius based on Z (depth)
    fill(starColor); // Set the color of the star (red or white)
    noStroke(); // No outline for the star
    ellipse(sx, sy, r, r); // Draw the star

    if (!movingRandomly) {
      // Draw a trailing effect if the star is not moving randomly
      float px = map(x / pz, 0, 1, 0, width / 2); // Map previous X position
      float py = map(y / pz, 0, 1, 0, height / 2); // Map previous Y position
      pz = z; // Update the previous Z position
      stroke(255); // White stroke for the line
      line(px, py, sx, sy); // Draw the line from previous to current position
    }
  }
}
