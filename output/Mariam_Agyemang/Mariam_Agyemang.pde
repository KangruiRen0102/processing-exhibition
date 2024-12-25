// ArrayList to store all the particles (treated as shapes)
ArrayList<Shape> particles;

// Flags to manage interaction modes
boolean attractMode = true; // Determines whether particles are attracted or repelled by the mouse
boolean mouseInteractionEnabled = true; // Controls if mouse interaction is enabled
float attractionStrength = 0.01;

// Setup function runs once at the beginning
void setup() {
  size(800, 800); // Set the canvas size
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
  
  float c = cos(PI/4); //rotate the rectangle by 90 degrees to make a diamond
    translate(width/2, height/2);
    rotate(c);
    
    //To scale the diamonds to be bigger or smaller when the mouse is moved
    float scaleFactor = map(mouseX, 0, width, 0.25, 1.5);
    scaleFactor = constrain(scaleFactor, 0.25, 1.5);
    scale(scaleFactor);
    
    fill (200, 255, 255);   //To make the diamonds light blue
    
    // To position the diamonds to make a larger diamond or crystal
    rect(100, 10, 15, 15);
    rect(100, 30, 15, 15);
    rect(120, 10, 15, 15);
    rect(120, 30, 15, 15);
    
    //To make two more large diamonds on the screen
    rect(-50, 400, 15, 15);
    rect(-50, 420, 15, 15);
    rect(-70, 400, 15, 15);
    rect(-70, 420, 15, 15);
    
    rect(300, -360, 15, 15);
    rect(300, -380, 15, 15);
    rect(320, -360, 15, 15);
    rect(320, -380, 15, 15);
    
 
  // Update and display each particle
  for (int i = particles.size() - 1; i >= 0; i--) {
    Shape p = particles.get(i);
    p.update(); // Update particle position and state
    p.display(); // Display the particle
   
    // Apply mouse interactions if enabled
    if (mouseInteractionEnabled && p instanceof Particle) {
      Particle particle = (Particle) p;
      particle.applyForce(mouseX, mouseY, attractionStrength, attractMode); // Unified attraction/repulsion

      // Remove dead particles
      if (particle.isDead()) {
        particles.remove(i);
      }
    }
  }

  // Maintain particle count at a maximum of 1000
  while (particles.size() < 1000) {
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
    super(x, y, getComplexColor(x, y)); // Call the parent constructor
    velocity = PVector.random2D(); // Assign a random 2D velocity
    velocity.mult(random(0.5, 4)); // Scale the velocity
    lifespan = random(100, 100);   // Assign a random lifespan
  }

  // Update the particle's position and state
  void update() {
    x += velocity.x; // Update x position based on velocity
    y += velocity.y; // Update y position based on velocity
    lifespan -= 1.5; // Decrease lifespan over time
    velocity.rotate(0.05); // Slightly rotate velocity direction
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
