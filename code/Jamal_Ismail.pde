// Blooming Infinity: Interactive Parametric Art
ArrayList<Particle> particles;
int maxParticles = 100;

void setup() {
  size(800, 800);
  particles = new ArrayList<Particle>();
  for (int i = 0; i < maxParticles; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}

void draw() {
  background(20, 30, 50); // Night-like background
  for (Particle p : particles) {
    p.update();
    p.display();
  }
}

class Particle {
  float x, y;
  float size;
  float speedX, speedY;
  color col;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.speedX = random(-2, 2);
    this.speedY = random(-2, 2);
    this.col = color(random(100, 255), random(100, 200), random(200, 255));
  }

  void update() {
    x += speedX;
    y += speedY;

    // "What-if" scenario: Bounce off edges
    if (x < 0 || x > width) speedX *= -1;
    if (y < 0 || y > height) speedY *= -1;

    // Parametric-based behavior: Size changes over time
    size = map(sin(frameCount * 0.05), -1, 1, 5, 15);
  }

  void display() {
    noStroke();
    fill(col);
    ellipse(x, y, size, size);
  }
}

// Interaction to modify particle speed
void mouseMoved() {
  for (Particle p : particles) {
    p.speedX = map(mouseX, 0, width, -3, 3);
    p.speedY = map(mouseY, 0, height, -3, 3);
  }
}
