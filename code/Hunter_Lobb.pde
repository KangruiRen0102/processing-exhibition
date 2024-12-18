// ArrayList to store all the particles (treated as shapes)
ArrayList<Shape> particles;

// Setup function runs once at the beginning
void setup() {
  size(1200, 800); // Set the canvas size
  particles = new ArrayList<Shape>(); // Initialize the ArrayList
  noStroke(); // Disable the stroke for shapes
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

float spin = 0; // This variable that will be used to spin the path of the particles
int size = 250; // This variable that will be used to change the size of the firework explosions
int freeze = 1; // This variable that will be used to pause some features when time is frozen

// Particle class extending Shape
class Particle extends Shape {
  PVector velocity; // Velocity of the particle
  float lifespan;   // Lifespan of the particle

  // Constructor for Particle
  Particle(float x, float y) {
    super(x, y, getComplexColor(x, y)); // Call the parent constructor
    velocity = PVector.random2D(); // Assign a random 2D velocity
    velocity.mult(random(0.5, 6)); // Scale the velocity to produce the spread
    lifespan = random(250, 350);   // Assign a random lifespan in the given range
  }

  // Update the particle's position and state
  void update() {
    x += velocity.x * freeze; // Update x position based on velocity and frozenness 
    y += velocity.y * freeze; // Update y position based on velocity and frozenness
    lifespan -= 1.5 * freeze; // Decrease lifespan over time unless frozen
    velocity.rotate(freeze * spin); // Slightly rotate velocity direction based on spin unless frozen
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
} //<>//

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
    
    case 'p':
      // Adds a new group of particles as a firework explosion
      for (int i = 0; i < size * freeze; i++) {
        addParticle(mouseX, mouseY);
      }
      break;
      
     case 'n':
      // Increases the size of the firework explosion
      size += 100;
      break;
      
     case 'm':
      // Decreases the size of the firework explosion
      size -= 100;
      break;
      
     case 'k':
      // Increases the explosion's twist clockwise
      spin += 0.01 * freeze;
      break;
      
     case 'l':
      // Increases the explosions's twist counterclockwise 
      spin -= 0.01 * freeze;
      break;
    
    case 'd':
      // Freezes time by stopping particle transilation, spin, and aging
      for (Shape shape : particles) {
        if (shape instanceof Particle) {
          freeze = 0;
        }
      }
      break;
     
     case 's':
      // Unfreezes time by resuming particle transilation, spin, and aging
      for (Shape shape : particles) {
        if (shape instanceof Particle) {
          freeze = 1;
        }
      }
      break;
      
     case 'r':
      // Resets the canvas to the original conditions
      particles.clear(); // Clears all particles
      spin = 0; // Resets spin
      size = 250; // Resets size
      freeze = 1; // Unfreezes time
      break;
   }    
  }
