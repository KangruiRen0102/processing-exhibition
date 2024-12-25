//Chat GPT was used to optimize and restructure some code and functions

// Sea, Flow, and Chaos Visual Simulation in Processing

float waveOffset = 0;
ArrayList<Particle> currents = new ArrayList<Particle>();

void setup() {
  size(800, 600);

  // Initialize particle system to simulate ocean currents
  for (int i = 0; i < 200; i++) {
    currents.add(new Particle(random(width), random(height), random(1, 5)));
  }
}

void draw() {
  background(10, 30, 60); // Dark ocean-like background

  drawSea(); // Draw the dynamic sea waves
  drawCurrents(); // Draw particles simulating chaotic currents
}

// Function to create flowing sea waves
void drawSea() {
  noFill();
  stroke(100, 150, 255, 150); // Light blue wave color
  strokeWeight(2);

  // Create a series of sine-like waves
  for (int y = 0; y <= height; y += 20) {
    beginShape();
    for (int x = 0; x <= width; x += 20) {
      // Use Perlin noise to create organic wave offsets
      float offset = map(noise(x * 0.01, y * 0.01, waveOffset), 0, 1, -50, 50);
      vertex(x, y + offset);
    }
    endShape();
  }

  // Gradually animate wave movement
  waveOffset += 0.01;
}

// Function to draw and animate chaotic currents
void drawCurrents() {
  for (Particle p : currents) {
    p.move(); // Update position based on Perlin noise
    p.display(); // Render particle
  }
}

// Class representing individual particles in the current
class Particle {
  float x, y, speed;
  color col;

  // Constructor to initialize particle attributes
  Particle(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;

    // Assign a semi-random ocean-inspired color
    this.col = color(random(50, 150), random(100, 200), 255, random(100, 200));
  }

  // Function to update particle movement using Perlin noise
  void move() {
    x += cos(noise(x * 0.01, y * 0.01) * TWO_PI) * speed;
    y += sin(noise(x * 0.01, y * 0.01) * TWO_PI) * speed;

    // Wrap-around behavior when particles move offscreen
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
  }

  // Function to draw the particle as a small circle
  void display() {
    noStroke();
    fill(col);
    ellipse(x, y, 8, 8);
  }
}
