// Aurora Journey
// By: DeroN Nwangboje

// Objects for the scene
ArrayList<Star> stars;       // Stars in the sky
ArrayList<Tree> trees;       // Trees
ArrayList<Bush> bushes;      // Bushes
ArrayList<Particle> particles; // Particles on the road
Aurora aurora;

// Road and field dimensions
float roadWidth = 140;
float roadTopWidth = 40;
float fieldHeight = 300;

void setup() {
  size(800, 600);
  smooth();
  frameRate(30);

  // Initialize stars
  stars = new ArrayList<Star>();
  for (int i = 0; i < 300; i++) {
    stars.add(new Star(random(width), random(height)));
  }

  // Initialize trees and bushes with fixed non-overlapping placement (4 on each side)
  trees = new ArrayList<Tree>();
  bushes = new ArrayList<Bush>();
  
  // Left side trees and bushes
  trees.add(new Tree(width / 4 - 30, height / 2 + 50));
  trees.add(new Tree(width / 4, height / 2 + 100));
  trees.add(new Tree(width / 4 + 30, height / 2 + 150));
  trees.add(new Tree(width / 4 + 60, height / 2 + 200));
  
  bushes.add(new Bush(width / 4 - 60, height / 2 + 70));
  bushes.add(new Bush(width / 4 - 30, height / 2 + 150));
  bushes.add(new Bush(width / 4 + 30, height / 2 + 210));
  bushes.add(new Bush(width / 4 + 60, height / 2 + 250));

  // Right side trees and bushes
  trees.add(new Tree(3 * width / 4 - 30, height / 2 + 50));
  trees.add(new Tree(3 * width / 4, height / 2 + 100));
  trees.add(new Tree(3 * width / 4 + 30, height / 2 + 150));
  trees.add(new Tree(3 * width / 4 + 60, height / 2 + 200));

  bushes.add(new Bush(3 * width / 4 - 60, height / 2 + 70));
  bushes.add(new Bush(3 * width / 4 - 30, height / 2 + 150));
  bushes.add(new Bush(3 * width / 4 + 30, height / 2 + 210));
  bushes.add(new Bush(3 * width / 4 + 60, height / 2 + 250));

  // Initialize particles (one-time creation)
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 50; i++) {
    particles.add(new Particle(width / 2 + random(-roadTopWidth / 2, roadTopWidth / 2), random(height / 2, height)));
  }

  // Initialize aurora
  aurora = new Aurora();
}

void draw() {
  background(20, 30, 50); // Night sky color

  // Draw stars
  for (Star s : stars) {
    s.update();
    s.display();
  }

  // Draw aurora borealis
  aurora.display();

  // Draw fields, trees, bushes, road, and particles
  drawFields();
  for (Tree t : trees) {
    t.display();
  }
  for (Bush b : bushes) {
    b.display();
  }
  drawRoad();
  for (Particle p : particles) {
    p.update();  // Update particle position
    p.display(); // Draw particle
  }
}

// Function to draw green fields
void drawFields() {
  fill(34, 139, 34); // Green color for fields

  // Left field
  beginShape();
  vertex(0, height);
  vertex(width / 2 - roadWidth / 2, height);
  vertex(width / 2 - roadTopWidth / 2, height / 2);
  vertex(0, height / 2);
  endShape(CLOSE);

  // Right field
  beginShape();
  vertex(width, height);
  vertex(width / 2 + roadWidth / 2, height);
  vertex(width / 2 + roadTopWidth / 2, height / 2);
  vertex(width, height / 2);
  endShape(CLOSE);
}

// Function to draw a road with white dashed stripes
void drawRoad() {
  fill(40); // Gray road color
  beginShape();
  vertex(width / 2 - roadWidth / 2, height); // Base of road (left)
  vertex(width / 2 + roadWidth / 2, height); // Base of road (right)
  vertex(width / 2 + roadTopWidth / 2, height / 2); // Top of road (right)
  vertex(width / 2 - roadTopWidth / 2, height / 2); // Top of road (left)
  endShape(CLOSE);

  // Draw dashed center stripes
  stroke(255);
  strokeWeight(2);
  for (float y = height; y > height / 2; y -= 20) {
    line(width / 2, y, width / 2, y - 10); // Dashes
  }
}

// Star class (with intense sparkling effect)
class Star {
  float x, y, size, brightness;
  float speed;

  Star(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(1, 3); // Star size
    this.brightness = random(150, 255);
    this.speed = random(0.01, 0.1); // Faster sparkle speed
  }

  void update() {
    brightness += sin(frameCount * speed) * 30; // Brighter sparkle
    size = 1 + sin(frameCount * speed) * 0.8;  // More dynamic size changes
    brightness = constrain(brightness, 150, 255);
  }

  void display() {
    fill(brightness);
    noStroke();
    ellipse(x, y, size, size); // Draw sparkling star
  }
}

// Tree class (with textured trunk and darker green leaves)
class Tree {
  float x, y;

  Tree(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(139, 69, 19); // Brown trunk
    rect(x - 5, y - 30, 10, 30); // Tree trunk

    fill(0, 100, 0); // Dark green leaves
    triangle(x - 15, y - 30, x + 15, y - 30, x, y - 60); // Tree foliage
  }
}

// Bush class
class Bush {
  float x, y;

  Bush(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(50, 205, 50); // Lighter green for bushes
    ellipse(x, y, 30, 20); // Bush
  }
}

// Aurora class (interactive color-changing aurora)
class Aurora {
  int numBands = 10;
  float[] offsets = new float[numBands];
  color[] colors = new color[numBands];

  Aurora() {
    randomizeColors(); // Set initial aurora colors
    for (int i = 0; i < numBands; i++) {
      offsets[i] = random(1000);
    }
  }

  void display() {
    noStroke();
    for (int i = 0; i < numBands; i++) {
      fill(colors[i]);
      beginShape();
      for (int x = 0; x <= width; x++) {
        float y = map(noise(x * 0.01, offsets[i]), 0, 1, height / 8, height / 3);
        vertex(x, y);
      }
      vertex(width, 0);
      vertex(0, 0);
      endShape(CLOSE);
      offsets[i] += 0.02; // Animate aurora motion
    }
  }

  void randomizeColors() {
    for (int i = 0; i < numBands; i++) {
      colors[i] = color(
        random(100, 255), // R (red/purple)
        random(0, 255),   // G (blue/green tones)
        random(100, 255), // B (blue/purple tones)
        150               // Transparency
      );
    }
  }
}

// Particle class (flowing upwards and resetting)
class Particle {
  float x, y, speed;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = random(0.2, 1.0); // Speed for upward flow
  }

  void update() {
    y -= speed; // Move particle upwards
    if (y < height / 2) { // Reset particle position when it reaches the road's top
      y = height;
      x = width / 2 + random(-roadTopWidth / 2, roadTopWidth / 2);
    }
  }

  void display() {
    noStroke();
    fill(255, 150, 0, 150); // Glowing orange particles
    ellipse(x, y, 5, 5); // Particle shape
  }
}

// Handle mouse interaction to change aurora colors
void mousePressed() {
  aurora.randomizeColors(); // Change aurora colors on click
}
