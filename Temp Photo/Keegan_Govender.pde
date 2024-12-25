ArrayList<Particle> particles;
float bloomRadius = 50;

void setup() {
  size(800, 800);
  particles = new ArrayList<Particle>();
  noCursor();
}

void draw() {
  background(20, 30, 50); // Dark background for contrast

  // Create particles on mouse movement
  if (mousePressed) {
    for (int i = 0; i < 5; i++) {
      particles.add(new Particle(mouseX, mouseY));
    }
  }

  // Update and display particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();

    // Remove particles that have fully bloomed
    if (p.size > bloomRadius * 1.5) {
      particles.remove(i);
    }
  }

  // Add a faint "bloom" effect at the mouse position
  noFill();
  stroke(255, 200, 150, 50);
  strokeWeight(2);
  ellipse(mouseX, mouseY, bloomRadius, bloomRadius);
}

class Particle {
  PVector position;
  PVector velocity;
  float size;
  float growthRate;
  int colour;

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D().mult(random(1, 3));
    size = random(5, 10);
    growthRate = random(0.5, 1.5);
    colour = color(random(150, 255), random(50, 200), random(100, 255), 150);
  }

  void update() {
    position.add(velocity);
    size += growthRate;
  }

  void display() {
    noStroke();
    fill(colour, map(size, 5, bloomRadius * 1.5, 255, 50));
    ellipse(position.x, position.y, size, size);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    particles.clear(); // Reset the piece
  }
}
