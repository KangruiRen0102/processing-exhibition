/* Although I have a year of Java coding experience, I used AI to aid in
the creation process as Dr. Gaang suggested in class.
I created the functions and ComplexColour function, referencing example 1
and 2 provided during the class. Also, I used Generative Art by Matt Pearson
and Open Source Processing Code files to help me create the bloom, gradient,
and clustering effects. Then, I used Chat GPT to help me improve my object-based
parameterizing methods, reduce line repetitions, and fix errors that I was
encountering (mainly with my blooming function). I also used ChatGPT to help
give me additional feedback on how I could improve my code.
*/

// Create an ArrayList to store all the bubbles   
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();  

// Create an ArrayList to store all the contaminants
ArrayList<Contaminant> contaminants = new ArrayList<Contaminant>();  

// Environmental variables affecting bubbles (wind and water currents)
float liquidDensity = 1.0;  // Liquid density affects how quickly bubbles rise
float currentSpeed = 0.2;  // Speed of the current affects horizontal drift of the bubbles

PVector clickPosition;  // Position of mouse click used to trigger the bloom effect

// Constants for bubble rise speed modification
float speedIncreaseFactor = 1.5;
float speedDecreaseFactor = 0.5;

void setup() {
  size(800, 600);  // Set canvas size
  clickPosition = new PVector(-1, -1);  // Initialize click position (off canvas to prevent error)
  noStroke();  // Disable outlines for shapes
  frameRate(60);  // Set frame rate for smooth animation
  
  // Initialize 100 contaminants at random positions using a loop
  for (int i = 0; i < 100; i++) {
    contaminants.add(new Contaminant(random(width), random(-height, 0)));
  }
}

void draw() {
  background(0);  // Creates a black background for contrast and artistic effect
  
  updateContaminants();  // Update contaminants and check collisions with bubbles
  updateBubbles();  // Update bubble positions, sizes, and interactions
  
  // A loop checking that there is 100 contaminants at any time
  while (contaminants.size() < 100) {
    addContaminant(random(width), 0);  // Adds new contaminant if under max count
  }
}

// Function to update contaminants' positions and remove them if trapped by bubbles
void updateContaminants() {
  // List to store contaminants marked for removal
  ArrayList<Contaminant> contaminantsToRemove = new ArrayList<Contaminant>();

  for (Contaminant c : contaminants) {
    c.update();  // Update the contaminant's position
    c.display();  // Display the contaminant on screen
    
    // Check if the bubble and contaminant intersects
    for (Bubble b : bubbles) {
      if (dist(c.x, c.y, b.x, b.y) < b.size / 2) {
        contaminantsToRemove.add(c);  // Marks the intersecting contaminant for removal
        b.grow();  // Grow bubble as it removes the contaminant
        break;  // Stop checking further contaminants for this bubble
      }
    }
  }

  // Remove contaminants that were marked for removal
  contaminants.removeAll(contaminantsToRemove);
}

// Function to update bubbles' positions and check for interactions with mouse click using a loop
void updateBubbles() {
  // List to store bubbles that need to be removed (e.g., when lifespan ends)
  ArrayList<Bubble> bubblesToRemove = new ArrayList<Bubble>();

  for (int i = bubbles.size() - 1; i >= 0; i--) {
    Bubble b = bubbles.get(i);  // Gets the current bubble
    b.update();  // Update the bubble's position
    b.display(); // Display the bubble

    // Conditional that blooms (creates) a bubble if it is close to point the mouse click
    if (clickPosition.dist(new PVector(b.x, b.y)) < 100 && !b.isBlooming()) {
      b.bloom();  // Trigger bloom effect on the bubble
    }

    // Conditional that removes a bubble if it is "dead" (out of lifespan)
    if (b.isDead()) {
      bubblesToRemove.add(b);
    }
  }

  // Remove dead bubbles
  bubbles.removeAll(bubblesToRemove);
}

// Function to add a contaminant at a given position
void addContaminant(float x, float y) {
  contaminants.add(new Contaminant(x, y));  // Create and add a new contaminant
}

// Bubble class handling the behavior of individual bubbles
class Bubble {
  float x, y, size, riseSpeed, driftSpeed, lifespan, clusterFactor, clusterRange;  //position, size, vertical speed
  //horizontal displacement, distance that creates a cluster and range for a cluster of bubbles to form
  color bubbleColor;  // Color of the bubble
  boolean blooming;  // Flag to check if bubble is blooming
  boolean isActive;  // Flag to check if bubble is still active
  boolean isClustered;  // Flag to check if bubble is part of a cluster
  PVector velocity;  // Movement vector (horizontal + vertical speed)

  // Constructor to initialize bubble properties
  Bubble(float x, float y, float size, float riseSpeed, boolean isClustered) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.riseSpeed = riseSpeed;
    this.driftSpeed = random(-1, 1);  // Random horizontal drift speed
    this.bubbleColor = getComplexColor(x, y);  // Color based on position
    this.blooming = false;  // Initially, no bloom effect
    this.lifespan = random(200, 600);  // Random lifespan
    this.isActive = true;  // Bubble is active at the start
    this.isClustered = isClustered;  // Whether it's part of a cluster
    this.clusterFactor = random(0.8, 1.2);  // Cluster factor for speed adjustments
    this.clusterRange = random(5, 15);  // Range to form clusters with nearby bubbles
    this.velocity = new PVector(random(-1, 1), random(1, 2));  // Initial velocity
  }

  // Update the bubble's position each frame
  void update() {
    if (isActive) {
      // Apply environmental effects: rise speed and horizontal drift
      this.y -= riseSpeed / (liquidDensity * clusterFactor);   
      this.x += driftSpeed + currentSpeed;  

      // Reverse horizontal drift if the bubble goes off screen
      if (this.x < 0 || this.x > width) {
        driftSpeed *= -1;
      }

      // Mark the bubble as inactive if it goes off the top of the screen (making it disappear)
      if (this.y < -size) {
        isActive = false;
      }

      // Increase size when the bubble blooms as seen in aqueous systems
      if (blooming) {
        size = map(y, height + 100, 0, 10, 40);  // Size increases as it rises
      }

      // Conditional that mimics clustering behavior (merging of nearby bubbles) by iterating through a loop
      // and checking if it is within a predefined cluster range
      if (isClustered) {
        for (Bubble other : bubbles) {
          if (dist(this.x, this.y, other.x, other.y) < clusterRange && other != this && !other.isClustered) {
            other.isClustered = true;  // Mark as part of the cluster
            other.clusterFactor = this.clusterFactor;  // Synchronize speed
          }
        }
      }

      // Un-cluster if the bubbles drift too far apart by iterating through a loop to compare distance to cluster range
      if (isClustered) {
        for (Bubble other : bubbles) {
          if (dist(this.x, this.y, other.x, other.y) > clusterRange * 2) {
            other.isClustered = false;  // Uncluster if too far apart
          }
        }
      }

      lifespan--;  // Decrease lifespan over time
    }
  }

  // Display the bubble on the screen
  //technique from Processing reference page https://processing.org/reference/map_.html
  void display() {
    fill(bubbleColor, map(lifespan, 0, 255, 0, 255));  // Fade the bubble over time by decreasing transparency as the lifespan decreases
    noStroke();  // Removes the border for the bubble
    ellipse(x, y, size, size);  // Draw bubble as a circle
  }

  // Check if the bubble is "dead" (out of lifespan)
  boolean isDead() {
    return lifespan < 0;
  }

  // Trigger the bloom effect for the bubble
  void bloom() {
    blooming = true;
  }

  // Check if the bubble is blooming
  boolean isBlooming() {
    return blooming;
  }

  // Grow the bubble when it removes contaminants
  void grow() {
    size += 2;  // Increase size
    riseSpeed *= 1.1;  // Increase rise speed
  }

  // Generate a complex color based on position
  // This block comes directly from Example 2 discussed in class
  color getComplexColor(float x, float y) {
    float distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);

    // Dynamic RGB values based on position and time
    float r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
    float g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
    float b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;

    return color(r, g, b);
  }
}

// Contaminant class for simulating pollutants in the water
class Contaminant {
  float x, y, size; // position and size of the contaminant
  color contaminantColor; // fill colour of the contaminant

  // Initialize contaminant properties
  Contaminant(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);  // Random size
    this.contaminantColor = color(250, 250, 250, 250);  // Dark gray color
  }

  // Update the contaminant's position
  void update() {
    this.y += 1 / (liquidDensity);  // Move downwards as affected by water density
    if (this.y > height) {  // Reset if it goes off the screen
      this.y = 0; // to the top of the screen
      this.x = random(width); // places it randomly along the top
      this.size = random(5, 15); // with a random size
    }

    // Conditional that shows how contaminants grow (floc) if not removed
    if (this.y > height / 2) {
      size += 0.05;
    }
  }

  // Display the contaminant
  void display() {
    fill(contaminantColor);
    ellipse(x, y, size, size);
  }
}

// Detect mouse press to trigger bubble creation
void mousePressed() {
  clickPosition.set(mouseX, mouseY);  // Store mouse position
  // Add 100 new bubbles at mouse position, trigger blooming
  for (int i = 0; i < 100; i++) {
    boolean isClustered = random(1) < 0.5;  // Randomly decide clustering
    bubbles.add(new Bubble(mouseX + random(-50, 50), mouseY + random(-50, 50), random(6, 8), random(1, 2), isClustered));
  }
}

// Handle keyboard inputs to modify bubble behavior
// Technique is based off of Example 2 discussed in class
void keyPressed() {
  switch (Character.toLowerCase(key)) {
    case 'b':  // Add 100 random bubbles to represent the dissolved gases in a solution that is there but typically ignored
      addBubbles(100);
      break;
    case 'c':  // Clear all bubbles
      bubbles.clear();
      break;
    case '+':  // Increase rise speed of all bubbles
      adjustBubbleRiseSpeed(speedIncreaseFactor);
      break;
    case '-':  // Decrease rise speed of all bubbles
      adjustBubbleRiseSpeed(speedDecreaseFactor);
      break;
    case 'w':  // Adjust current speed (horizontal drift)
      currentSpeed *= 1.5;
      break;
    case 's':  // Decrease current speed
      currentSpeed *= 0.5;
      break;
    case 'd':  // Increase liquid density
      liquidDensity *= 1.1;
      break;
    case 'a':  // Decrease liquid density
      liquidDensity *= 0.9;
      break;

  }
}

// Helper function to add a specified number of random bubbles to the Arraylist
void addBubbles(int count) {
  for (int i = 0; i < count; i++) {
    boolean isClustered = random(1) < 0.2;  // Randomly decides clustering
    bubbles.add(new Bubble(random(width), random(height), random(4,5), random(1, 1.5), isClustered));
  }
}

// Adjust rise speed of all bubbles by a given factor using a loop
void adjustBubbleRiseSpeed(float factor) {
  for (Bubble b : bubbles) {
    b.riseSpeed *= factor;
  }
}
