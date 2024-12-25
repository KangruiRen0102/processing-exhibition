// Underwater Generative Art: Sea, Animals, and Discovery

ArrayList<SeaCreature> creatures; // List of marine creatures
ArrayList<PVector> treasures;    // Positions of glowing treasures

void setup() {
  size(800, 600);
  creatures = new ArrayList<SeaCreature>();
  treasures = new ArrayList<PVector>();
  
  // Create marine creatures
  for (int i = 0; i < 15; i++) {
    creatures.add(new SeaCreature(random(width), random(height)));
  }

  // Create scattered treasures
  for (int i = 0; i < 10; i++) {
    treasures.add(new PVector(random(width), random(height)));
  }
}

void draw() {
  // Draw underwater gradient background
  for (int i = 0; i < height; i++) {
    float c = map(i, 0, height, 20, 100); // Darker at top, lighter below
    stroke(20, 50, c + 20);
    line(0, i, width, i);
  }
  
  // Draw glowing treasures to symbolize discovery
  for (PVector t : treasures) {
    float glow = sin(frameCount * 0.05 + t.x) * 50 + 100; // Pulsating effect
    fill(255, 200, 0, glow);
    ellipse(t.x, t.y, 12, 12); // Draw treasure as glowing dots
  }

  // Draw and update marine creatures
  for (SeaCreature sc : creatures) {
    sc.update(); // Update position for fluid movement
    sc.display(); // Draw creature
  }

  // Draw flowing currents as subtle moving lines
  stroke(150, 200, 255, 50);
  noFill();
  for (int i = 0; i < 5; i++) {
    beginShape();
    for (float x = 0; x < width; x += 20) {
      float y = height / 2 + sin(frameCount * 0.01 + x * 0.1 + i * 10) * 50;
      vertex(x, y + random(-2, 2));
    }
    endShape();
  }
}

// Class representing sea creatures
class SeaCreature {
  float x, y; // Position
  float size; // Size of the creature
  float speedX, speedY; // Movement speed
  color bodyColor; // Color of the creature

  // Constructor initializes the creature
  SeaCreature(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(15, 30);
    this.speedX = random(-1, 1);
    this.speedY = random(-0.5, 0.5);
    this.bodyColor = color(random(100, 255), random(100, 255), random(200, 255));
  }

  // Update position for smooth movement
  void update() {
    x += speedX;
    y += speedY;
    
    // Wrap around edges for continuous motion
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;
  }

  // Draw the sea creature
  void display() {
    fill(bodyColor, 150);
    noStroke();
    ellipse(x, y, size, size / 2); // Body
    ellipse(x - size / 3, y - size / 4, size / 3, size / 4); // Top fin
    ellipse(x - size / 3, y + size / 4, size / 3, size / 4); // Bottom fin
    fill(255);
    ellipse(x + size / 4, y, size / 8, size / 8); // Eye
  }
}
