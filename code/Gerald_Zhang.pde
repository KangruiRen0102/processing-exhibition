ArrayList<Shape> memories;

// Define the canvas dimensions and setup initial properties
void setup() {
  size(800, 600); // Set canvas size to 800x600 pixels
  memories=new ArrayList<Shape>(); // Initialize the ArrayList
  frameRate(45); // Set frame rate for smooth animation at 45 frames per second
}

// ArrayList to store memory objects (fleeting and lasting)


// Main draw loop: runs continuously to animate the memories
void draw() {
  ` fill(0, 15);
  rect(0, 0, width, height); //Draws a rectangle centered at (0,0) over the canvas for the effects to take place upon

  // Add new memory particles at specific intervals
  if (frameCount % 2 == 0) { // Add a new FleetingMemory every 2 frames thru modulus operator (frequent)
    memories.add(new FleetingMemory(random(width), random(height))); // Create a new fleeting, quick-fading memory particle at random positions
  }
  if (frameCount % 500 == 0) { // Add a new LastingMemory every 500 frames thru modulus operator (infrequent)
    memories.add(new LastingMemory(random(width), random(height))); // Create a large, slow-fading "significant memory" particle at  random positioon
  }

  // Update and display each memory in the list
  for (int i = memories.size() - 1; i >= 0; i--) {
    Shape memory = memories.get(i); // Retrieve each memory particle from the list
    memory.update(); // Update the memory's position, fading (alpha)
    memory.display(); // Display the memory with its current attributes (position, alpha)

    // Remove memory if it has faded out or moved off the canvas (in other words, "dead")
    if (memory.isDead()) {
      memories.remove(i); // Remove the memory from the list if it’s "dead"
    }
  }
}

// Abstract Shape class serves as a base class for all memory shapes
abstract class Shape {
  float x, y; // Position coordinates for each memory shape
  color fillColor; // Fill color of the shape
  float alpha; // Transparency level to control fading

  // Constructor initializes position, color, and transparency
  Shape(float x, float y, color fillColor) {
    this.x = x; // Assign the spawn x-coordinate
    this.y = y; // Assign the spawn y-coordinate
    this.fillColor = fillColor; // Initialize color with given fill color
    this.alpha = 255; // Start with full opacity for new memories
  }

  // Abstract methods to be implemented by subclasses
  abstract void update(); // Update properties like position, size, and fading
  abstract void display(); // Display the shape with current properties
  abstract boolean isDead(); // Determine if the shape should be removed from the screen
}

// FleetingMemory class for small, quick-moving particles that fade rapidly
class FleetingMemory extends Shape {
  PVector velocity; // Velocity vector controls movement direction and speed
  float size; // Size of the FleetingMemory particle

  // Constructor initializes position, color, and movement properties
  FleetingMemory(float x, float y) {
    super(x, y, getComplexColor(x, y)); // Set initial position and color utilizing the shape abstract class
    velocity = PVector.random2D(); // Random initial direction of motion
    velocity.x *= random(4, 5); // Set x-component of velocity
    velocity.y *= random(4, 5); // Set y-component of velocity
    size = random(3, 5); // Set size to a small value for small memories
  }

  // Update position and fade for FleetingMemory
  void update() {
    x += velocity.x; // Update x-position from x-velocity
    y += velocity.y; // Update y-position from y-velocity
    alpha -= random(1, 8); // Alpha drops fast so the particles fade fast
  }

  // Display the FleetingMemory particle
  void display() {
    noStroke(); // Disable stroke
    fill(fillColor, alpha); // Apply fading effect with current alpha
    ellipse(x, y, size, size); // Draw a small circle to represent the memory
  }

  // Check if particle has faded out or moved off screen bounds
  boolean isDead() {
    return alpha < 0 || x > width + 100 || y > height + 100 || y < -100; // Return true if alpha is below 0 or particle is out of canvas bounds
  }
}

// LastingMemory class for larger, oval-shaped memories that drift slowly and fade slow
class LastingMemory extends Shape {
  PVector drift; // Vector for slow drifting 
  float size; // Size of the memory shape (large for significant memories)
  float rotation; // Rotation angle
  color ovalColor; // Color specific to auroras for significant memories

  // Constructor initializes position, color, size, and drift properties
  LastingMemory(float x, float y) {
    super(x, y, getComplexColor(x, y)); // Set initial position and color
    drift = new PVector(random(-0.5, 0.5), random(-0.5, 0.5)); // Small random drift so it don't zoom around like the small memories
    size = random(80, 250); // Large size to represent a significant memory
    rotation = random(TWO_PI); // Random initial rotation angle caus it looks cooler
    ovalColor = color(random(0, 255), random(0, 200), random(0, 255), alpha); 
  }

  // Update position, fading, and rotation for LastingMemory
  void update() {
    x += drift.x; // Apply horizontal movement 
    y += drift.y; // Apply vertical movement
    rotation += 0.001; // Slow rotation so it don't look as janky
    alpha -= 0.3; // Slow fade-out since alpha goes down slowly
  }

  // Display the big elliptic/oval memory with transparency and rotation
  void display() {
    pushMatrix(); // Save current transformation state
    translate(x, y); // Move to the memory's current position
    rotate(rotation); // Apply rotation
    fill(ovalColor, alpha); // Set fill color with current transparency level
    noStroke(); // Disable stroke
    ellipse(0, 0, size, size * 0.5); // To draw the actual oval/ellipse
    popMatrix(); // Restore previous transformation state
  }

  // Check if LastingMemory has faded out or drifted off screen
  boolean isDead() {
    return alpha < 0 || x > width + 100 || y > height + 100 || y < -100; // Returns 'True' boolean if alpha is <0 or out of canvas bounds
  }
}

// Generate colors based on object position; this is the exact same code used in the examples
color getComplexColor(float x, float y) {
  float distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2); // Normalize distance from the canvas center

  // Calculate R, G, B values with sine functions
  float r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
  float g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
  float b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;

  return color(r, g, b); // Return color with calculated RGB values
}

// Key controls to add bursts of small/large or clear all memories
void keyPressed() {
  switch (Character.toLowerCase(key)) {
  case 'c': // Clears all memories when 'c' key is pressed
    memories.clear();
    break;

  case 'n': // Adds a burst of memories when 'n' key is pressed
    for (int i = 0; i < 20; i++) { // Add 20 FleetingMemory particles
      memories.add(new FleetingMemory(random(width), random(height)));
    }
    for (int i = 0; i < 5; i++) { // Add 5 LastingMemory particles 
      memories.add(new LastingMemory(random(width), random(height)));
    }
    break;
  }
}
