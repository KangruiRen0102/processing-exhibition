// ArrayList to store all the particles (treated as shapes)
ArrayList<Shape> particles;

// Flags to manage interaction modes
boolean attractMode = false; // Determines whether particles are attracted or repelled by the mouse
boolean mouseInteractionEnabled = false; // Controls if mouse interaction is enabled

// Setup function runs once at the beginning
void setup() {
  size(1200, 800); // Set the canvas size
  particles = new ArrayList<Shape>(); // Initialize the ArrayList
  noStroke(); // Disable the stroke for shapes
  
  // Create initial particles
  for (int i = 0; i < 500; i++) {
    addParticle(random(width), random(height)); // Add particles at random positions
  }
  
  frameRate(60); // Set frame rate to 60 frames per second for smoother animation
}

// The draw function runs continuously to create animation
void draw() {
  fill(0, 15); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect
  
  // Update and display each particle
  for (int i = particles.size() - 1; i >= 0; i--) {
    Shape p = particles.get(i);
    p.update(); // Update particle position and state
    p.display(); // Display the particle
    
    // Apply mouse interactions if enabled
    if (mouseInteractionEnabled && p instanceof Particle) {
      Particle particle = (Particle)p;
      if (attractMode) {
        particle.attract(mouseX, mouseY); // Attract the particle towards the mouse
      } else {
        particle.repel(mouseX, mouseY); // Repel the particle away from the mouse
      }
      
      // Remove dead particles
      if (particle.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  // Add new particles if the number is below 1000
  if (particles.size() < 1000) {
    addParticle(random(width), random(height));
  }
}

// Base class representing a generic shape
abstract class Shape {
  float x, y; // Position of the shape
  color fillColor; // Fill color of the shape

  // Constructor
  Shape(float x, float y, color fillColor) {
    this.x = x; // Set x-coordinate
    this.y = y; // Set y-coordinate
    this.fillColor = fillColor; // Set fill color
  }

  // Abstract methods to be implemented by subclasses
  abstract void update(); 
  abstract void display(); 
}

// Particle class extending Shape
class Particle extends Shape {
  PVector velocity; // Velocity of the particle
  float lifespan;   // Lifespan of the particle

  // Constructor for Particle
  Particle(float x, float y) {
    super(x, y, getBlueShade(x, y)); // Call the parent constructor for the blueshade
    velocity = PVector.random2D(); // Assign a random 2D velocity
    velocity.mult(random(0.5, 2)); // Scale the velocity
    lifespan = random(200, 400);   // Assign a random lifespan
  }

  // Update the particle's position and state
  void update() {
    x += velocity.x; // Update x position based on velocity
    y += velocity.y; // Update y position based on velocity
    lifespan -= 1.5; // Decrease lifespan over time
    velocity.rotate(0.02); // Slightly rotate velocity direction
  }

  // Attract the particle towards a target (e.g., mouse position)
  void attract(float targetX, float targetY) {
    PVector attraction = new PVector(targetX - x, targetY - y);
    attraction.normalize(); // Normalize to get direction only
    attraction.mult(0.05); // Control strength of attraction
    velocity.add(attraction); // Apply attraction to velocity
  }
  
  // Repel the particle away from a target
  void repel(float targetX, float targetY) {
    PVector repelForce = new PVector(x - targetX, y - targetY);
    repelForce.normalize();
    repelForce.mult(0.1); // Control strength of repulsion
    velocity.add(repelForce);
  }

  // Display the particle as a fading ellipse
  void display() {
    noStroke();
    fill(fillColor, map(lifespan, 0, 400, 0, 255)); // Adjust transparency based on lifespan
    ellipse(x, y, map(lifespan, 0, 400, 1, 8), map(lifespan, 0, 400, 1, 8)); // Draw the particle
  }

  // Check if the particle is dead
  boolean isDead() {
    return lifespan < 0;
  }
}

// Function to add a new particle to the list
void addParticle(float x, float y) {
  particles.add(new Particle(x, y));
}

// Randomally generate blue shades
color getBlueShade(float x, float y) {
  float blueIntensity = random(50, 225); //generating making random blue intensities 
  return color (0, 0, blueIntensity); //making red and green 0 but blue shades vary 
}



// Handle key presses for different interactions
void keyPressed() {
  if (key == 'o' || key == 'O') {
    mouseInteractionEnabled = !mouseInteractionEnabled; // Toggle mouse interaction
  }
  
  if (key == 'a' || key == 'A') {
    attractMode = !attractMode; // Toggle attraction/repulsion mode
  }
  
  if (key == 'n' || key == 'N') {
    // Add 100 new particles
    for (int i = 0; i < 100; i++) {
      addParticle(random(width), random(height));
    }
  }
  
  if (key == 'c' || key == 'C') {
    particles.clear(); // Clear all particles
  }
  
  if (key == 's' || key == 'S') {
    // Randomly adjust the speed of all particles
    for (Shape shape : particles) {
      if (shape instanceof Particle) {
        ((Particle)shape).velocity.mult(random(0.5, 1.5)); 
      }
    }
  }
}
