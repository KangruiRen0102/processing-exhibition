AuroraParticle[] particles; // Array to store "Aurora" particles
int numParticles = 300; // Number of particles
boolean reverseDirection = false; // Tracks direction of flow
color[] journeyColors; // Store the color transitions for the journey trail
float[] colorLerpSpeed; // Speed for color interpolation

void setup() {
  size(800, 800); // Canvas size
  particles = new AuroraParticle[numParticles];
  journeyColors = new color[width / 20]; // Store journey colors for each line
  colorLerpSpeed = new float[width / 20]; // Speed for color transitions for journey trail
  
  for (int i = 0; i < numParticles; i++) {
    particles[i] = new AuroraParticle(random(width), random(height));
  }

  // Initialize the journey line colors
  for (int i = 0; i < journeyColors.length; i++) {
    journeyColors[i] = getRandomColor(); // Random initial colors
    colorLerpSpeed[i] = random(0.02, 0.05); // Random speed of color transitions
  }

  background(20, 20, 50); // Dark base for persistent trails
  noStroke();
}

void draw() {
  fill(20, 20, 50, 25); // Transparent background for glowing trails
  rect(0, 0, width, height); // Persisting trails effect
  
  for (AuroraParticle p : particles) {
    p.update();
    p.display();
  }
  
  drawJourneyTrail(); // Draw dynamic, pulsating journey trails
}

// Class representing aurora particles
class AuroraParticle {
  float x, y; // Position
  float size; // Size of particle
  float angle; // Movement angle
  color currentColor; // Current color of the particle
  color targetColor; // Target color for smooth transition

  AuroraParticle(float startX, float startY) {
    x = startX;
    y = startY;
    size = random(3, 8);
    currentColor = getRandomColor(); // Initial random color
    targetColor = getRandomColor();  // Set the first target color
    angle = random(TWO_PI);
  }

  void update() {
    // Reverse or normal direction based on interaction
    float direction = reverseDirection ? -1 : 1;
    angle += random(-0.05, 0.05) * direction;
    x += cos(angle) * 2 * direction;
    y += sin(angle) * 2 * direction;

    // Wrap particles to maintain flow
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;

    // Gradually shift to the target color
    currentColor = lerpColor(currentColor, targetColor, 0.02);

    // Change target color periodically
    if (frameCount % 100 == 0) {
      targetColor = getRandomColor();
    }
  }

  void display() {
    fill(currentColor);
    ellipse(x, y, size, size); // Draw particle
  }
}

// Helper function to get a random vibrant color
color getRandomColor() {
  return color(random(100, 255), random(100, 255), random(100, 255), 150);
}

// Creates pulsating paths symbolizing a journey
void drawJourneyTrail() {
  for (int i = 0; i < journeyColors.length; i++) {
    // Interpolate the color for each line in the journey
    journeyColors[i] = lerpColor(journeyColors[i], getRandomColor(), colorLerpSpeed[i]);
    
    float pulse = sin(frameCount * 0.05 + i * 0.1) * 10 + 20; // Pulsating effect
    strokeWeight(2 + pulse * 0.05);
    stroke(journeyColors[i]);
    
    // Draw the vertical lines of the journey
    float y = height / 2 + sin((frameCount * 0.02) + i * 0.1) * 100;
    line(i * 20, height, i * 20, y); // Adjust position for each vertical line
  }
  noStroke();
}

// Mouse click reverses direction
void mousePressed() {
  reverseDirection = !reverseDirection;
}

// Reset animation when 'R' is pressed
void keyPressed() {
  if (key == 'R' || key == 'r') {
    for (AuroraParticle p : particles) {
      p.x = random(width); // Reset positions
      p.y = random(height);
      p.currentColor = getRandomColor(); // Reset colors
      p.targetColor = getRandomColor();
    }
    reverseDirection = false; // Reset direction
  }
}
