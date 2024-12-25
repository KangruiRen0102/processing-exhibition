// Variables to control the frozen environment and twilight effect
float bgColor = 255;       // Background color for twilight
color topColor = color(0, 0, 0);  // Black color for top of the gradient
color bottomColor = color(0, 0, 255); // Blue color for bottom of the gradient

// Variables to control snowflake behavior
boolean isFrozen = false;  // Flag to track if the snowflakes are frozen
boolean explode = false;   // Flag to trigger explosion effect
boolean geyserActive = false; // Flag to track if geyser is active (spacebar pressed)
ArrayList<Snowflake> snowflakes = new ArrayList<Snowflake>(); // Array to store snowflakes

void setup() {
  size(800, 800); // Size of the canvas
  frameRate(30);  // Set the frame rate for slower animation
  noStroke();     // No outline for the shapes
  background(255); // Start with a white background
  
  // Create initial snowflakes (further increased number for higher density)
  for (int i = 0; i < 400; i++) { // Increased number of snowflakes for even denser snowfall
    snowflakes.add(new Snowflake(random(width), random(height / 2), random(5, 15)));
  }
}

void draw() {
  // Static black to blue gradient background
  createGradientBackground();
  
  // Draw frozen, icy structures (snowflakes)
  for (Snowflake snowflake : snowflakes) {
    snowflake.update(); // Update the snowflakes' behavior (frozen or animated)
    snowflake.display(); // Draw each snowflake
  }

  // If geyser effect is active, add new snowflakes shooting upwards
  if (geyserActive) {
    createGeyser();
  }
}

// Function to handle mouse press (freeze particles)
void mousePressed() {
  isFrozen = true;  // Freeze the snowflakes when the mouse is pressed
}

// Function to handle mouse release (unfreeze particles and trigger explosion)
void mouseReleased() {
  isFrozen = false; // Unfreeze the snowflakes when the mouse is released
  explode = true;   // Trigger the explosion effect
  applyExplosionForce(mouseX, mouseY); // Apply the explosion force to snowflakes near the mouse
}

// Function to handle spacebar press (create geyser of snowflakes)
void keyPressed() {
  if (key == ' ') {
    geyserActive = true; // Activate the geyser when the spacebar is pressed
  }
}

// Function to handle spacebar release (stop the geyser effect)
void keyReleased() {
  if (key == ' ') {
    geyserActive = false; // Deactivate the geyser when the spacebar is released
  }
}

// Function to create the static black to blue gradient background
void createGradientBackground() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0.0, 1.0); // Calculate the interpolation factor
    color c = lerpColor(topColor, bottomColor, inter); // Interpolate between black and blue
    stroke(c); // Set the color
    line(0, y, width, y); // Draw a horizontal line to create gradient effect
  }
}

// Function to apply explosion force to snowflakes near the mouse
void applyExplosionForce(float mouseX, float mouseY) {
  for (Snowflake snowflake : snowflakes) {
    float distance = dist(mouseX, mouseY, snowflake.x, snowflake.y);
    if (distance < 150) { // If snowflake is within 150 pixels of the mouse
      snowflake.applyExplosionForce(mouseX, mouseY); // Apply force to move the snowflake
    }
  }
}

// Function to create the geyser of snowflakes shooting up from the bottom
void createGeyser() {
  float geyserX = width / 2; // Set geyser origin to the center of the bottom edge
  float geyserY = height;    // Fixed y-coordinate at the bottom of the screen
  
  // Create a burst of snowflakes from the geyser origin point
  for (int i = 0; i < 20; i++) { // Create a burst of 20 snowflakes
    float angle = random(TWO_PI); // Random trajectory angle in radians (full circle)
    float speed = random(5, 10);  // Random upward speed for geyser snowflakes
    float forceX = cos(angle) * speed; // X component of the speed
    float forceY = sin(angle) * speed; // Y component of the speed (shooting upwards)
    float size = random(5, 15); // Random size for variety

    // Add a new snowflake at the geyser's origin, shooting in a random direction
    snowflakes.add(new Snowflake(geyserX, geyserY, size, forceX, forceY)); 
  }
}

// Snowflake class to control individual snowflakes
class Snowflake {
  float x, y, size, speedY;
  float forceX, forceY;   // Explosive forces applied to snowflakes
  boolean isBeingPushed = false; // Flag to track if the snowflake is being pushed by the mouse
  int shapeType; // To store the shape type of the snowflake
  
  // Constructor to initialize snowflake's properties
  Snowflake(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speedY = random(2, 6); // Increased falling speed range
    this.forceX = 0; // No initial force
    this.forceY = 0; // No initial force
    this.shapeType = int(random(0, 2)); // Randomly assign a shape type (0 = circle, 1 = star)
  }

  // Constructor for geyser snowflakes (shooting up)
  Snowflake(float x, float y, float size, float forceX, float forceY) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.forceX = forceX;
    this.forceY = forceY;
    this.speedY = 0; // No initial falling speed
    this.shapeType = int(random(0, 2)); // Randomly assign a shape type (0 = circle, 1 = star)
  }

  // Function to update snowflake's position (freeze or animate)
  void update() {
    if (isFrozen) {
      // Snowflakes stay in place when frozen
    } else {
      // Apply force for explosion if triggered
      x += forceX;
      y += forceY;
      
      // Fall down if no explosion force
      if (forceX == 0 && forceY == 0) {
        y += speedY;
      }
      
      if (y > height) {
        y = random(-10, -50); // Reset snowflake to the top once it reaches the bottom
      }
    }
  }
  
  // Function to apply explosion force to the snowflake
  void applyExplosionForce(float mouseX, float mouseY) {
    float angle = atan2(y - mouseY, x - mouseX); // Angle between snowflake and mouse
    float distance = dist(mouseX, mouseY, x, y); // Distance between snowflake and mouse
    float force = map(distance, 0, 150, 5, 25); // Increased explosion force range
    
    forceX = cos(angle) * force; // X component of the force
    forceY = sin(angle) * force; // Y component of the force
    
    // Immediately reapply falling effect after explosion
    if (forceX != 0 || forceY != 0) {
      speedY = random(4, 8); // Immediately speed up falling after explosion
    }
  }

  // Function to display the snowflake
  void display() {
    fill(255, 255, 255, 180); // Semi-transparent white for frozen effect
    if (shapeType == 0) {
      ellipse(x, y, size, size);  // Circle shape
    } else if (shapeType == 1) {
      drawStar(x, y, size, size / 2, 5); // Star shape
    }
  }

  // Function to draw a star shape
  void drawStar(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = -PI/2; a < TWO_PI - PI/2; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius1;
      sy = y + sin(a + halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
