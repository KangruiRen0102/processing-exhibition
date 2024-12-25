int numParticles = 600; // Increased number of particles
Particle[] particles = new Particle[numParticles]; // Array to hold all particles
boolean mouseInteracted = false; // Track mouse interaction
float time = 0; // Time-based variable for color and animation effects

void setup() {
  size(1024, 768, P3D); // Enable 3D rendering for depth effect
  colorMode(HSB, 360, 255, 255, 255); // HSB color mode for smooth gradients
  for (int i = 0; i < numParticles; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  background(0); // Clear the screen with black
  translate(width / 2, height / 2, -600); // Center and adjust the view
  rotateY(frameCount * 0.001); // Subtle rotation for dynamic 3D visualization

  // Draw layered aurora-like structures
  for (int layer = -10; layer <= 10; layer++) { // Increased number of layers for more depth
    float zOffset = layer * 80; // Adjust layer spacing dynamically
    drawAuroraLayer(zOffset);
  }

  // Update and draw particles
  for (Particle p : particles) {
    p.update();
    p.display();
  }

  // Mouse interaction effects
  if (mouseInteracted) {
    drawInteractiveEffect();
  }

  time += 0.01; // Update time for dynamic color changes
}

// Draws a layered aurora with subtle color shifts and noise-based displacement
void drawAuroraLayer(float zOffset) {
  beginShape(TRIANGLE_STRIP);
  for (int x = -width; x <= width; x += 6) { // Increased resolution by reducing step
    float y1 = noise(x * 0.02, frameCount * 0.005) * 400 - 200; // Taller, more dynamic curves
    float y2 = noise(x * 0.02, frameCount * 0.005 + 1000) * 400 - 200;

    float hue = map(x, -width, width, 160, 280) + sin(time * 0.1 + x * 0.02) * 30; // Dynamic hue shifting

    fill(hue, 200, 255, 180); // Top vertex color
    vertex(x, y1, zOffset);

    fill(hue, 150, 200, 120); // Bottom vertex color
    vertex(x, y2, zOffset - 80); // Increased depth between layers for more 3D feel
  }
  endShape();
}

// Mouse interaction toggles particle effect and visual changes
void mousePressed() {
  mouseInteracted = !mouseInteracted;
}

// Adds an interactive circular effect when the mouse is pressed
void drawInteractiveEffect() {
  pushMatrix();
  translate(mouseX - width / 2, mouseY - height / 2, 0);
  for (int i = 0; i < 50; i++) {
    float angle = radians(i * 360 / 50);
    float x = cos(angle) * 80;
    float y = sin(angle) * 80;
    stroke((frameCount + i * 5) % 360, 200, 255);
    line(0, 0, x, y);
  }
  popMatrix();
}

// Particle class with random motion, lifespan, and smooth behavior
class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  float size;
  float speed;

  Particle() {
    reset();
  }

  // Reset the particle with new random properties
  void reset() {
    position = new PVector(random(-width / 2, width / 2), random(-height / 2, height / 2), random(-500, 500)); // Expanded range for depth
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1)); // Increased velocity for more dynamic motion
    lifespan = random(300, 400); // Increased lifespan for prolonged particles
    size = random(4, 8); // Larger particles for greater visibility
    speed = random(0.5, 1.5); // Different speed for each particle
  }

  // Update the particle's position and lifespan
  void update() {
    position.add(velocity.mult(speed)); // Apply speed to movement
    lifespan -= 1.5; // Slightly slower decay for particles
    if (lifespan < 0) {
      reset();
    }
  }

  // Display the particle, with color based on its Z-depth
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    float hue = map(position.z, -500, 500, 200, 360); // Map Z-depth to hue for color variation
    noStroke();
    fill(hue, 255, 255, lifespan);
    sphere(size); // Larger sphere for increased particle visibility
    popMatrix();
  }
}
