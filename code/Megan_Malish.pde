ArrayList<Shape> particles; // ArrayList

// Interaction modes
boolean attractMode = true; // States if snowflakes are attracted by the mouse
boolean mouseInteractionEnabled = true; // The mouse interaction is enabled

// Setup function runs once
void setup() {
  size(1000, 700); // Canvas size
  particles = new ArrayList<Shape>(); // Initializing ArrayList
  noStroke(); // Disables shape strokes
  
  // Create snowflakes
  for (int i = 0; i < 300; i++) {
    addParticle(random(width), 1); // Adds snowflakes at random positions along the width
  }
  frameRate(100); // Frame rate to 100 frames per second 
}

// The draw function runs continuously
void draw() {
  fill(color(137, 196, 255), 300); // Semi-transparent light blue fill that creates a slight trailing effect
  rect(0, 0, width, height); // Draws a rectangle over the canvas 
  
  // Snowflakes get upadated and displayed
  for (int i = particles.size() - 1; i >= 0; i--) {
    Shape p = particles.get(i);
    p.update(); // Updates position and state of the snowflakes 
    p.display(); // Displays the snowflakes
    
     // Applys the desired mouse interactions 
    if (mouseInteractionEnabled && p instanceof Particle) {
      Particle particle = (Particle)p;
      if (attractMode) {
        particle.attract(width, 700); // Attract the particle towards the bottom of the canvus
      } else {
      }
        
    // Removes snowflakes that have died
    if (particle.isDead()) {
      particles.remove(i);
      }
    }
  }
  
  // Adds new snowflakes
  if (particles.size() < 2000) {
    addParticle(random(width), 1);
  }
}

// Base class that represents a snowflake
abstract class Shape {
  float x, y; // Position of the snowflakes
  color fillColor; // Fill color of snowflakes

  // Constructor
  Shape(float x, float y, color fillColor) {
    this.x = x; // x-coordinate
    this.y = y; // y-coordinate
    this.fillColor = color(255, 255, 255); // Sets snowflake color to white
  }

  // Subclasses implementing abstract methods
  abstract void update(); 
  abstract void display(); 
}

// Snowflake class extending Shape
class Particle extends Shape {
  PVector velocity; // Snowflakes velocity 
  float lifespan;   // Snowflakes lifespan 

  // Constructor for Snowflake
  Particle(float x, float y) {
    super(x, y, 1);
    velocity = PVector.random2D(); // Randomized 2D velocity
    velocity.mult(random(1.5, 5)); // Velocity
    lifespan = random(400, 600);   // Random lifespan
  }

  // Updateing position, lifespan, and rotation velocity direction
  void update() {
    x += velocity.x; // Updates x 
    y += velocity.y; // Updates y 
    lifespan -= 1.25; // Decreases lifespan 
    velocity.rotate(0.01); // Rotate velocity direction
  }

  // Attracts snowflakes to the mouse
  void attract(float targetX, float targetY) {
    PVector attraction = new PVector(targetX - x, targetY - y);
    attraction.normalize(); // Simplifying to just direction
    attraction.mult(0.05); // Strength 
    velocity.add(attraction); // Applying to the velocity
  }
  
  // Displays the snowflake as a translucent white ellipse that fades with the lifspan
  void display() {
    noStroke();
    fill(color(255,255,255), map(lifespan, 0, 600, 0, 200)); // Adjust transparency based on lifespan
    ellipse(x, y, map(lifespan, 0, 600, 1, 20), map(lifespan, 0, 600, 1, 15)); // Draw the snowflake
  }

  // Checking the lifespan of the snowflake and removes them if they died
  boolean isDead() {
    return lifespan < 0;
  }
}

// Adds new snowflakes
void addParticle(float x, float y) {
  particles.add(new Particle(x, y));
}
