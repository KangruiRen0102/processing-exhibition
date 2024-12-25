// ArrayList to store all the particles (treated as shapes)
ArrayList<Shape> particles;

// Timing variables for color transitions
float startTime;
boolean isGrayscale = false; // Flag to track if we should use grayscale
float particleSize = 12; // Initial particle size
float waveAmplitude = 100; // Initial wave amplitude for vertical movement
float waveSpeed = 0.02; // Initial wave speed for vertical movement
float xSpeed = 1; // Initial horizontal movement speed

// Setup function runs once at the beginning
void setup() {
  size(1200, 800); // Set the canvas size
  particles = new ArrayList<Shape>(); // Initialize the ArrayList
  noStroke(); // Disable the stroke for shapes
  startTime = millis(); // Record the starting time for color transition
  
  // Create initial particles
  for (int i = 0; i < 200; i++) { // Reduced particle count from 500 to 200
    addParticle(random(width), random(height)); // Add particles at random positions
  }

  frameRate(60); // Set frame rate to 60 frames per second for smoother animation
}

// The draw function runs continuously to create animation
void draw() {
  // Create a chaotic, dynamic background with shifting colors
  fill(0, 15); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

  // Handle the color change every 5 seconds
  float elapsedTime = (millis() - startTime) / 1000.0; // Time elapsed in seconds
  if (elapsedTime >= 5.0) {
    isGrayscale = !isGrayscale; // Toggle between grayscale and rainbow colors every 5 seconds
    startTime = millis(); // Reset the timer
  }

  // Update and display each particle (representing the engineering student's journey)
  for (int i = particles.size() - 1; i >= 0; i--) {
    Shape p = particles.get(i);
    p.update(); // Update particle position and state
    p.display(); // Display the particle
  }

  // Maintain particle count at a maximum of 1000 (can add more particles if needed)
  while (particles.size() < 200) { // Reduced the particle count again here
    addParticle(random(width), random(height)); // Add new particles as students keep coming in
  }
}

// Base class representing a generic shape
abstract class Shape {
  float x, y; // Position of the shape
  color fillColor; // Fill color of the shape
  float timeOffsetY; // Time offset for sine wave movement (vertical)

  // Constructor
  Shape(float x, float y) {
    this.x = x; // Set x-coordinate
    this.y = y; // Set y-coordinate
    this.fillColor = getColor(); // Set initial color based on current mode
    timeOffsetY = random(TWO_PI); // Random offset for sine wave vertical movement
  }

  // Abstract methods to be implemented by subclasses
  abstract void update();
  abstract void display();
}

// Particle class extending Shape
class Particle extends Shape {
  
  // Constructor for Particle (representing an engineering student)
  Particle(float x, float y) {
    super(x, y); // Call the parent constructor with dynamic color
  }

  // Update the particle's position and state, making it move like a moving wave
  void update() {
    // All particles move left to right along the x-axis (wave-like propagation)
    x += xSpeed; // Horizontal speed (controlled by "H" key)

    // Apply a sine wave for vertical movement, where the sine wave moves horizontally (wave propagation)
    float waveMovement = sin((x + millis() * waveSpeed) * 0.05 + timeOffsetY);
    y = height / 2 + waveMovement * waveAmplitude; // Adjust vertical movement based on waveAmplitude

    // Keep particles within bounds of the canvas (if they move past the screen, reset their x-coordinate)
    if (x > width) {
      x = 0; // Reset x to the left side of the screen, creating an infinite wave
    }

    fillColor = getColor(); // Update color based on mode (rainbow or grayscale)
  }

  // Display the particle as a random shape or a random number
  void display() {
    noStroke();
    fill(fillColor); // Use the color dynamically transitioning from vibrant to grayscale

    // Randomly choose between drawing a shape or a number
    int shapeChoice = (int) random(3); // Randomly choose between 0, 1, or 2
    switch (shapeChoice) {
      case 0: // Draw a circle
        ellipse(x, y, particleSize, particleSize);
        break;
      case 1: // Draw a rectangle
        rect(x, y, particleSize, particleSize);
        break;
      case 2: // Draw a random number
        textSize(16);
        textAlign(CENTER, CENTER);
        text((int) random(0, 100), x, y); // Display a random number at the particle's position
        break;
    }
  }
}

// Function to add a new particle to the list
void addParticle(float x, float y) {
  particles.add(new Particle(x, y));
}

// Generate a color based on whether we are in grayscale or rainbow mode
color getColor() {
  if (isGrayscale) {
    // Grayscale colors: Transition the particles to grayscale
    return getGrayscaleColor();
  } else {
    // Rainbow color: Transition the particles through a rainbow spectrum
    return getRainbowColor();
  }
}

// Rainbow color generation (spectrum of visible colors)
color getRainbowColor() {
  float angle = map(millis() % 5000, 0, 5000, 0, TWO_PI); // Map time to an angle over 5000ms (5 seconds)
  float r = (sin(angle) + 1) * 127; // Red color component based on sine wave
  float g = (sin(angle + TWO_PI / 3) + 1) * 127; // Green component offset for rainbow effect
  float b = (sin(angle + 2 * TWO_PI / 3) + 1) * 127; // Blue component offset for rainbow effect
  return color(r, g, b); // Return the rainbow color
}

// Grayscale color generation
color getGrayscaleColor() {
  // Grayscale colors (calculated based on average RGB value)
  float grayValue = random(100, 200); // A middle-range gray value
  return color(grayValue, grayValue, grayValue); // Return the grayscale color
}

// Handle key presses for interaction
void keyPressed() {
  // If the "C" key is pressed, increase particle size and decrease wave amplitude
  if (key == 'C' || key == 'c') {
    particleSize += 2; // Increase particle size
    waveAmplitude *= 0.8; // Reduce wave amplitude (less wavy movement)
    waveSpeed *= 0.9; // Slightly reduce wave speed (so movement becomes more uniform)
  }

  // If the "R" key is pressed, reset all settings to default
  if (key == 'R' || key == 'r') {
    resetParticles(); // Reset particles to default state
  }

  // If the "H" key is pressed, increase speed of particles
  if (key == 'H' || key == 'h') {
    xSpeed += 0.5; // Increase horizontal movement speed
    waveSpeed *= 1.1; // Increase wave speed (vertical movement)
  }
}

// Function to reset all particle behavior to default
void resetParticles() {
  // Reset particle size, wave amplitude, and wave speed to their original values
  particleSize = 12;
  waveAmplitude = 100;
  waveSpeed = 0.02;
  xSpeed = 1; // Reset horizontal speed to default
  // Reset color mode to rainbow
  isGrayscale = false;

  // Clear existing particles and recreate initial particles
  particles.clear();
  for (int i = 0; i < 200; i++) {
    addParticle(random(width), random(height)); // Add particles at random positions
  }
}
