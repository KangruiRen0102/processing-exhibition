float waveOffset = 0;
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
int numBlooms = 15;

void setup() {
  size(800, 800);
  noStroke();
  for (int i = 0; i < 50; i++) {
    bubbles.add(new Bubble(random(width), random(height, height * 1.5)));
  }
}

void draw() {
  background(10, 30, 60); // Deep sea background
  
  drawWaves();
  drawRock();
  drawBubbles();
  drawDecorativeShapes(); // Draw the new shapes once
  drawFishAndHeart(); // Draw fish and heart shapes
}

// Draw flowing waves
void drawWaves() {
  for (int y = 0; y < height; y += 30) {
    fill(10, 50 + y / 10, 120 + y / 5, 100); // Gradient blue for depth
    beginShape();
    for (int x = 0; x <= width; x += 20) {
      float waveHeight = 10 * sin((x + waveOffset) * 0.02 + y * 0.1);
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  waveOffset += 2;
}

// Draw rising bubbles
void drawBubbles() {
  for (Bubble b : bubbles) {
    b.move();
    b.display();
  }
}

// Bubble class
class Bubble {
  float x, y;
  float size;
  float speed;

  Bubble(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(10, 20);
    this.speed = random(1, 3);
  }

  void move() {
    y -= speed;
    if (y < -size) {
      y = height + size;
      x = random(width);
    }
  }

  void display() {
    fill(255, 100);
    ellipse(x, y, size, size);
  }
}

// Draw a rock-like structure
void drawRock() {
  fill(50, 30, 20); // Dark brown/gray for the rock
  beginShape();
  vertex(width * 0, height * 0.8); // Base left
  vertex(width * 0, height * 0.2); // Peak left
  vertex(width * 0.6, height * 0.65); // Peak right
  vertex(width * 0.8, height * 0.85); // Base right
  vertex(width, height); // Bottom right corner
  vertex(0, height); // Bottom left corner
  endShape(CLOSE);
}

// Draw 3 pink semi-circles and 3 orange diamond shapes at the bottom right
void drawDecorativeShapes() {
  // Draw 3 pink semi-circles
  for (int i = 0; i < 3; i++) {
    float x = width - 80 + i * 25; // Position near the very right edge
    float y = height - 50; // Position near the very bottom edge

  }

  // Draw 3 orange diamond shapes
  for (int i = 0; i < 3; i++) {
    float x = width - 80 + i * 25; // Position near the very right edge
    float y = height - 100; // Position near the bottom, slightly above the semi-circles

  }
}



// Draw two fish shapes and a heart shape at the bottom right
void drawFishAndHeart() {
  // Draw Fish 1
  drawFish(width - 200, height - 100, 50, color(255, 0, 0)); // Red Fish
  
  // Draw Fish 2
  drawFish(width - 250, height - 150, 40, color(0, 255, 0)); // Green Fish
  
  // Draw Heart
  drawHeart(width - 300, height - 150, 40); // Heart shape
}

void drawFish(float x, float y, float size, color bodyColor) {
  fill(bodyColor);
  ellipse(x, y, size, size / 2); // Fish body
  triangle(x + size / 2, y, x + size, y - size / 4, x + size, y + size / 4); // Fish tail
}

void drawHeart(float x, float y, float size) {
  fill(255, 0, 0); // Red color
  beginShape();
  vertex(x, y); 
  bezierVertex(x - size / 2, y - size / 2, x - size, y + size / 4, x, y + size);
  bezierVertex(x + size, y + size / 4, x + size / 2, y - size / 2, x, y);
  endShape(CLOSE);
}
