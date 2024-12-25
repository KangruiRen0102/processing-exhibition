// ArrayList to store all the particles (treated as shapes)
ArrayList<Shape> particles;

// Flags to manage interaction modes
boolean attractMode = false; // Determines whether particles are attracted or repelled by the mouse
boolean mouseInteractionEnabled = false; // Controls if mouse interaction is enabled
float attractionStrength = 0.05;

// Timer for transitioning from red circle to particle effect
int startTime;
boolean showParticles = false;

// Timer for delaying the particle effect by 3 seconds after red circle
int delayTime = 3000; // 3 seconds in milliseconds

// Setup function runs once at the beginning
void setup() {
  size(1200, 800); // Set the canvas size
  particles = new ArrayList<Shape>(); // Initialize the ArrayList
  noStroke(); // Disable the stroke for shapes

  // Create initial particles
  for (int i = 0; i < 500; i++) {
    addParticle(random(width), random(height)); // Add particles at random positions
  }

  frameRate(60); // Set frame rate to 60 frames per second 
  startTime = millis(); // Record the start time
}

// The draw function runs continuously to create animation
void draw() {
  if (!showParticles) {
    // Display red circle for 3 seconds
    background(255); // white background
    fill(255, 0, 0); // Red color
    ellipse(width / 2, height / 2, 200, 200); // Red circle in the center

    // Check if 3 seconds have passed since the start time
    if (millis() - startTime > delayTime) {
      showParticles = true; // Transition to particle effect after the delay
    }
  } else {
    // Particle effect
    fill(0, 15); // Set a semi-transparent black fill to create a trailing effect
    rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

    // Update and display each particle
    var iter = particles.iterator();
    while (iter.hasNext()) {
      Particle p = (Particle)iter.next();
      p.update(); // Update particle position and state
      p.display(); // Display the particle

      // Apply mouse interactions if enabled
      if (mouseInteractionEnabled && p instanceof Particle) {
        p.applyForce(mouseX, mouseY, attractionStrength, attractMode); // Unified attraction/repulsion
      }

      // Remove dead particles
      if (p.isDead()) {
        iter.remove();
      }
    }

    println(particles.size());
    if (particles.size() == 0) {
      // Draw the yellow dot in the center of the screen
      fill(255, 255, 0); // Set the fill color to yellow
      ellipse(width / 2, height / 2, 50, 50); // Draw the yellow dot at the center
    }

    // Maintain particle count at a maximum of 1000
    while (particles.size() < 1000 && false) {  // remove the "&& false" to re-enable maintaining particle count
      addParticle(random(width), random(height));
    }
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
    super(x, y, getComplexColor(x, y)); // Call the parent constructor
    velocity = PVector.random2D(); // Assign a random 2D velocity
    velocity.mult(random(0.5, 2)); // Scale the velocity
    lifespan = random(200, 600);   // Assign a random lifespan
  }

  // Update the particle's position and state
  void update() {
    x += velocity.x; // Update x position based on velocity
    y += velocity.y; // Update y position based on velocity
    lifespan -= 1.5; // Decrease lifespan over time
    velocity.rotate(0.02); // Slightly rotate velocity direction
  }

  // Unified method to apply attraction or repulsion
  void applyForce(float targetX, float targetY, float strength, boolean isAttract) {
    PVector force = new PVector(targetX - x, targetY - y);
    force.normalize();
    force.mult(isAttract ? strength : -strength); // Attraction or repulsion based on mode
    velocity.add(force);
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

// Generate a complex color based on position
color getComplexColor(float x, float y) {
  float distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);

  // Calculate RGB values using sine functions for a dynamic effect
  float r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
  float g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
  float b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;

  return color(r, g, b); // Return the calculated color
}

// Handle key presses for different interactions
void keyPressed() {
  switch (Character.toLowerCase(key)) {
    case 'o':
      mouseInteractionEnabled = !mouseInteractionEnabled; // Toggle mouse interaction
      break;
      
    case 'a':
      attractMode = !attractMode; // Toggle attraction/repulsion mode
      break;
      
    case 'n':
      // Add 100 new particles
      for (int i = 0; i < 100; i++) {
        addParticle(random(width), random(height));
      }
      break;
      
    case 'c':
      particles.clear(); // Clear all particles
      break;
      
    case 's':
      // Randomly adjust the speed of all particles
      for (Shape shape : particles) {
        if (shape instanceof Particle) {
          ((Particle) shape).velocity.mult(random(0.5, 1.5));
        }
      }
      break;
      
    case '+':
      attractionStrength += 0.01;
      break;
      
    case '-':
      attractionStrength -= 0.01;
      break;
  }
}
