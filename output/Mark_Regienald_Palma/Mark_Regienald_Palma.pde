// Declare variables for visual elements
PImage silhouette; // Declare a PImage for the silhouette
int numStars = 150; // Number of stars
float[] starX = new float[numStars]; // X positions of stars
float[] starY = new float[numStars]; // Y positions of stars
float[] starSizes = new float[numStars]; // Sizes of stars
float[] starSpeeds = new float[numStars]; // Speed of brightness oscillation

int numWaves = 8; // Number of aurora waves
float[] offsets; // Y offsets for wave movement
color[] auroraColors; // Colors for aurora waves

Meteor meteor; // Single meteor object
boolean meteorActive = false; // Controls whether the meteor is currently active
ArrayList<Firework> fireworks = new ArrayList<Firework>(); // List of active fireworks

// Initial setup function
void setup() {
  size(1600, 1200, P2D); // Create a high-resolution canvas using P2D renderer
  silhouette = loadImage("silhouette.png"); // Load the silhouette image
  if (silhouette == null) {
    println("Image failed to load. Check the file name and location.");
  }

  // Initialize aurora wave offsets and colors
  offsets = new float[numWaves];
  auroraColors = new color[numWaves];
  meteor = new Meteor(); // Initialize the meteor object

  // Initialize properties for stars
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(width); // Randomize X position within the canvas width
    starY[i] = random(height * 0.7f); // Randomize Y position in the top 70% of the canvas
    starSizes[i] = random(2, 6); // Assign random sizes for stars
    starSpeeds[i] = random(0.01, 0.05); // Set speed of brightness oscillation
  }

  // Initialize colors and offsets for aurora waves
  for (int i = 0; i < numWaves; i++) {
    offsets[i] = random(TWO_PI); // Random starting phase for wave motion
    auroraColors[i] = color(random(50, 255), random(100, 255), random(150, 255), 100); // Semi-transparent wave colors
  }
  noStroke(); // Disable stroke for smooth visuals
}

// Main draw loop
void draw() {
  drawNightGradient(); // Draw the background gradient
  drawStars();         // Render stars

  // Render the meteor if active
  if (meteorActive) {
    meteor.update();
    meteor.display();
  }

  drawAuroraWaves();   // Render aurora waves
  drawFireworks();     // Render fireworks
  drawSilhouette();    // Overlay the silhouette image
}

// Draw a gradient for the night sky
void drawNightGradient() {
  color[] palette = {
    color(1, 22, 46),   // Deep blue shades for a natural gradient
    color(0, 29, 55),
    color(0, 39, 70),
    color(1, 49, 85),
    color(0, 58, 99),
    color(1, 66, 109)
  };

  int numColors = palette.length;
  int sectionHeight = height / (numColors - 1); // Divide canvas into gradient sections

  for (int i = 0; i < numColors - 1; i++) {
    for (int y = i * sectionHeight; y < (i + 1) * sectionHeight; y++) {
      float t = map(y, i * sectionHeight, (i + 1) * sectionHeight, 0, 1); // Interpolation factor
      color interColor = lerpColor(palette[i], palette[i + 1], t); // Interpolate between colors
      stroke(interColor);
      line(0, y, width, y); // Draw gradient line
    }
  }
}

// Draw stars with oscillating brightness
void drawStars() {
  noStroke();
  for (int i = 0; i < numStars; i++) {
    float brightness = 155 + sin(frameCount * starSpeeds[i]) * 100; // Oscillate brightness over time
    fill(brightness); // Set star color based on brightness
    ellipse(starX[i], starY[i], starSizes[i], starSizes[i]); // Draw star at (X, Y)
  }
}

// Render aurora waves with dynamic motion
void drawAuroraWaves() {
  for (int i = 0; i < numWaves; i++) {
    fill(auroraColors[i]); // Set wave color

    // Calculate Y offset for wave motion
    float yOffset = map(sin(offsets[i]), -1, 1, -50, 50) + map(mouseY, 0, height, -30, 30);

    beginShape();
    for (float x = 0; x <= width; x += 10) {
      float yTop = height / 3 + yOffset + sin(offsets[i] + x * 0.05 + map(mouseX, 0, width, -PI, PI)) * 60;
      vertex(x, yTop); // Top wave vertex
    }
    for (float x = width; x >= 0; x -= 10) {
      float yBottom = height / 2 + yOffset + sin(offsets[i] + x * 0.07 + map(mouseX, 0, width, -PI, PI)) * 30;
      vertex(x, yBottom); // Bottom wave vertex
    }
    endShape(CLOSE);

    offsets[i] += 0.02; // Increment wave offset for animation
  }
}

// Draw silhouette overlay
void drawSilhouette() {
  if (silhouette != null) {
    image(silhouette, 0, 0, width, height); // Draw silhouette to match canvas dimensions
  } else {
    println("Silhouette image not found!");
  }
}

// Render fireworks effects
void drawFireworks() {
  for (int i = fireworks.size() - 1; i >= 0; i--) {
    Firework fw = fireworks.get(i);
    fw.update();
    fw.display();
    if (fw.particles.isEmpty()) {
      fireworks.remove(i); // Remove finished fireworks
    }
  }
}

// Meteor class implementation
class Meteor {
  float x, y, speedX, speedY, size;
  color coreColor, glowColor;

  Meteor() {
    reset();
  }

  void reset() {
    x = random(width);
    y = random(height / 2);
    speedX = random(5, 8);
    speedY = random(5, 8);
    size = random(5, 20);
    coreColor = color(255);
    glowColor = color(255, 255, 255, 100);
  }

  void update() {
    x += speedX;
    y += speedY;
    if (x > width || y > height) {
      meteorActive = false;
    }
  }

  void display() {
    for (int i = 1; i <= 5; i++) {
      float glowSize = size + i * 10;
      fill(glowColor, 100 - i * 20);
      ellipse(x, y, glowSize, glowSize);
    }
    fill(coreColor);
    noStroke();
    ellipse(x, y, size, size);

    for (int i = 0; i < 10; i++) {
      float tailX = x - speedX * i * 0.5;
      float tailY = y - speedY * i * 0.5;
      float tailSize = size - i;
      fill(glowColor, 150 - i * 15);
      ellipse(tailX, tailY, tailSize, tailSize);
    }
  }
}

// Firework class
// Represents a single firework made up of multiple particles
class Firework {
  ArrayList<Particle> particles; // List of particles composing the firework

  // Constructor initializes the firework at a given position with 100 particles
  Firework(float x, float y) {
    particles = new ArrayList<Particle>();
    int numParticles = 100; // Number of particles in the firework
    for (int i = 0; i < numParticles; i++) {
      // Assign each particle a random color from the aurora palette
      color col = auroraColors[(int)random(auroraColors.length)];
      particles.add(new Particle(x, y, col));
    }
  }

  // Updates all particles and removes those that are finished
  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update(); // Update particle position and state
      if (p.isFinished()) {
        particles.remove(i); // Remove particle if its life is over
      }
    }
  }

  // Draws all active particles on the screen
  void display() {
    for (Particle p : particles) {
      p.display(); // Render each particle
    }
  }
}

// Particle class
// Represents an individual particle in a firework
class Particle {
  float x, y; // Current position of the particle
  float speedX, speedY; // Speed components for motion
  float life; // Remaining lifespan of the particle
  color col; // Color of the particle
  float size; // Size of the particle

  // Constructor initializes particle properties
  Particle(float startX, float startY, color c) {
    x = startX; // Starting X position
    y = startY; // Starting Y position
    speedX = random(-5, 5); // Random horizontal speed
    speedY = random(-5, 5); // Random vertical speed
    life = 255; // Initial lifespan (fully visible)
    col = c; // Assigned color
    size = random(5, 15); // Random size between 5 and 15
  }

  // Updates particle position and decreases its lifespan
  void update() {
    x += speedX; // Update X position
    y += speedY; // Update Y position
    life -= 5; // Decrease lifespan
  }

  // Draws the particle as a fading circle
  void display() {
    fill(col, life); // Set color with transparency based on life
    noStroke(); // No outline
    ellipse(x, y, size, size); // Draw the particle as a circle
  }

  // Checks if the particle's life is over
  boolean isFinished() {
    return life <= 0; // Particle is finished when life reaches 0
  }
}

// Mouse pressed actions
// Handles user interaction for creating meteors and fireworks
void mousePressed() {
  if (keyPressed && key == CODED && keyCode == SHIFT) {
    // Create a firework at mouse position if Shift is pressed
    fireworks.add(new Firework(mouseX, mouseY));
  } else {
    // Create a meteor at random position if Shift is not pressed
    meteor.reset();
    meteorActive = true; // Activate the meteor
  }
}
