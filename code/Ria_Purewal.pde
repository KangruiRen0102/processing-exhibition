// Twilight, Bloom  & Chaos - Ria Purewal

// Array for bloom object
Bloom[] blooms;
int numBlooms = 50;

// Variables for chaotic background
float chaosPhase = 0;
color twilightColor;

void setup() {
  size(800, 600); // size of the canvas
  blooms = new Bloom[numBlooms];
  
  // Initialize bloom objects
  for (int i = 0; i < numBlooms; i++) {
    blooms[i] = new Bloom(random(width), random(height));
  }
}

void draw() {
  //  Moving twilight background
  twilightColor = color(50 + 50 * sin(chaosPhase), 20 + 20 * sin(chaosPhase + PI / 2), 80 + 80 * sin(chaosPhase + PI));
  background(twilightColor);
  
  // Render chaotic circles 
  drawChaos();
  
  // Display blooming patterns
  for (Bloom bloom : blooms) {
    bloom.display();
    bloom.grow();
  }
  
  // Update chaos phase
  chaosPhase += 0.02;
}

void drawChaos() {
  noStroke();
  for (int i = 0; i < 100; i++) {
    fill(100 + 50 * sin(chaosPhase + i * 0.1), 30, 100, 50);
    float x = width / 2 + 150 * cos(chaosPhase + i * 0.2);
    float y = height / 2 + 150 * sin(chaosPhase + i * 0.2);
    ellipse(x, y, random(10, 30), random(10, 30));
  }
}

// Class for Bloom patterns
class Bloom {
  float x, y, size;
  color bloomColor;

  Bloom(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.bloomColor = color(random(200, 255), random(100, 200), random(150, 250));
  }
  
  void display() {
    noStroke();
    fill(bloomColor, 150);
    ellipse(x, y, size, size);
  }
  
  void grow() {
    size += random(0.1, 0.5);
    if (size > 50) { // Regenerate bloom
      size = random(5, 15);
      x = random(width);
      y = random(height);
    }
  }
}
