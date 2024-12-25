float waveOffset = 0;
ArrayList<Particle> particles = new ArrayList<>();

void setup() {
  size(800, 800); // Canvas size
  background(10, 30, 60); // Dark ocean-like background
  noStroke();
}

void draw() {
  background(10, 30, 60, 50); // Dark background with slight fade effect

  // Draw the "sea" - Moving wave patterns
  drawSea();

  // Draw "infinity" - Spiraling shapes
  drawInfinity();

  // Handle "journey" particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isOffScreen()) {
      particles.remove(i);
    }
  }
}

void mousePressed() {
  // Add particles for "journey" when the mouse is pressed
  for (int i = 0; i < 10; i++) {
    particles.add(new Particle(mouseX, mouseY));
  }
}

// Draw "sea" with flowing waves
void drawSea() {
  waveOffset += 0.05; // Shift waves over time
  for (int y = height / 2; y < height; y += 20) {
    fill(20, 80 + y / 10, 150 + y / 5, 150); // Gradient blues
    beginShape();
    for (int x = 0; x < width; x++) {
      float waveHeight = sin((x * 0.02) + waveOffset + (y * 0.05)) * 20;
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// Draw "infinity" as spiraling shapes
void drawInfinity() {
  pushMatrix();
  translate(width / 2, height / 3); // Center of the canvas
  for (int i = 0; i < 200; i++) {
    float angle = i * 0.1;
    float radius = 100 + i * 0.5;
    float x = radius * cos(angle);
    float y = radius * sin(angle);
    fill(200, 150, 255, map(i, 0, 200, 255, 50)); // Gradient color
    ellipse(x, y, 5, 5);
  }
  popMatrix();
}

// Particle class for "journey"
class Particle {
  float x, y;
  float speedX, speedY;
  float size;
  color col;

  Particle(float startX, float startY) {
    x = startX;
    y = startY;
    speedX = random(-1, 1);
    speedY = random(-2, -1);
    size = random(5, 10);
    col = color(random(100, 200), random(150, 255), random(200, 255)); // Bright blue and green tones
  }

  void update() {
    x += speedX;
    y += speedY;
    size *= 0.98; // Gradual shrink
  }

  void display() {
    fill(col, 150);
    ellipse(x, y, size, size);
  }

  boolean isOffScreen() {
    return y < 0 || size < 1; // Particle disappears when off-screen or too small
  }
}
