// ArrayList to store all the particles (treated as shapes)
ArrayList<Shape> particles = new ArrayList<>();
ArrayList<Star> stars = new ArrayList<>();

// Flags to manage interaction modes
boolean attractMode = true; // Determines whether particles are attracted or repelled by the mouse
boolean mouseInteractionEnabled = true; // Controls if mouse interaction is enabled
float attractionStrength = 0.010;

void setup() {
  size(1000, 750); // Set the canvas size
  noStroke(); // Remove borders from shapes
  for (int j = 0; j < 300; j++) {
    stars.add(new Star(random(width), random(height)));
  }
}

void draw() {
  fill(0, 30); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

  // Draw the moon
  fill(255, 255, 255);
  stroke(255, 255, 255);
  ellipse(200, 100, 75, 75); // White circle for the moon
  fill(0);
  stroke(0);
  ellipse(230, 92, 60, 60); // Black circle for the moon

  // Update and display each star (draw stars after the moon)
  for (Star s : stars) {
    s.update();
    s.display();
  }

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

  // Maintain particle count at a maximum of 500
  while (particles.size() < 500) {
    addParticle(random(width), random(height)); // Add particles at random positions
  }

  // Draw the other shapes for the bridge after updating particles

  fill(189, 191, 210); //changes the fill colors
  rect(195, 490, 10, 180); //draws a rectangle 
  rect(345, 420, 10, 230);
  rect(495, 390, 10, 260);
  rect(645, 420, 10, 230);
  rect(800, 490, 10, 180);
  fill(171, 171, 171);
  rect(75, 675, 50, 150);
  rect(875, 675, 50, 150);
  fill(147, 157, 177); 
  rect(0, 650, 1000, 25); 

 // creating the arc for the bridge
  noFill();
  strokeWeight(20); // Set the thickness of the stroke
  stroke(189, 191, 210); // Set the stroke color to black for the first arc
  arc(500, 825, 950, 850, PI + 0.2, TWO_PI - 0.2); // Draw the first arc

  // Second arc for the lights attached to the bridge
  strokeWeight(7);
  stroke(115, 255, 225); // Set the stroke color to cyan (one of my friend's favorite color) for the second arc 
  arc(500, 765, 885, 710, PI + 0.33, TWO_PI - 0.33); // Draw the second arc with a different size
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
    super(x, y, color(255)); // Set the fill color to white
    velocity = new PVector(0, random(0.5, 2)); // Assign a random downward velocity
    lifespan = random(200, 400);   // Assign a random lifespan
  }

  // Update the particle's position and state
  void update() {
    x += velocity.x; // Update x position based on velocity
    y += velocity.y; // Update y position based on velocity
    lifespan -= 1.5; // Decrease lifespan over time
    // No rotation for downward movement
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

// Star class for twinkling effect
class Star {
  float x, y; // Position of the star
  float brightness; // Brightness of the star
  float size; // Size of the star
  float speed; // Speed of the brightness change

  // Constructor for Star
  Star(float x, float y) {
    this.x = x;
    this.y = y;
    this.brightness = random(25, 255); // Initial random brightness
    this.size = random(2, 5); // Initial random size
    this.speed = random(10, 50); // Speed of brightness change
  }

  // Update the star's brightness
  void update() {
    brightness += speed; // Adjust brightness by speed
    if (brightness > 255 || brightness < 25) {
      speed *= -1; // Reverse the direction when limits are reached
    }
  }

  // Display the star
  void display() {
    noStroke();
    fill(255,235,144, brightness); // Set star color with current brightness
    ellipse(x, y, size, size); // Draw the star
  }
}

// Function to add a new particle to the list
void addParticle(float x, float y) {
  particles.add(new Particle(x, y));
}

// Handle key presses for different interactions
void keyPressed() {
  switch (Character.toLowerCase(key)) {
    case 'o':
      mouseInteractionEnabled = !mouseInteractionEnabled; // Toggle mouse interaction
      break;
  
      
    case 'm':
      // Add 50 new particles
      for (int i = 0; i < 50; i++) {
        addParticle(random(width), random(height)); // Add particles at random x positions at the top
      }
      break;
      
    case 'g':
      particles.clear(); // Clear all particles
      break;
      
    case 'f':
      // Randomly adjust the speed of all particles
      for (Shape shape : particles) {
        if (shape instanceof Particle) {
          ((Particle) shape).velocity.mult(random(0.5, 1.5));
        }
      }
      break;
      
    case 's':
      attractionStrength += 0.005;
      break;
      
    case 'w':
      attractionStrength -= 0.005;
      break;
  }
}
