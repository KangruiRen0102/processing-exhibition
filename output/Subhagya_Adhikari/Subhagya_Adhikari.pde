
/* 
Project: Aurora Through Infinity
Author: Subhagya Adhikari
Description: An interpretation of the aurora combined with infinity and  a journey.
*/

float t = 0; // Time variable for animation
ArrayList<Star> stars; // For cosmic stars

void setup() {
  size(800, 800);
  noStroke();
  stars = new ArrayList<Star>();
  for (int i = 0; i < 150; i++) {
    stars.add(new Star(random(width), random(height), random(1, 3)));
  }
}

void draw() {
  // Cosmic background gradient
  drawCosmicBackground();

  // Twinkling stars
  for (Star star : stars) {
    star.twinkle();
  }

  // Dynamic aurora ribbons
  for (int i = 0; i < 5; i++) {
    drawAurora(200 + i * 50, i);
  }

  // Rotating infinity symbol
  drawRotatingInfinity(width / 2, height / 2, 200, t);

  t += 0.02; // Increment time for animations
}

// Function to draw cosmic gradient background
void drawCosmicBackground() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    color c = lerpColor(color(10, 10, 50), color(0, 0, 20), inter);
    stroke(c);
    line(0, y, width, y);
  }
}

// Function to draw dynamic aurora ribbons
void drawAurora(float yOffset, int index) {
  fill(lerpColor(color(100, 200, 255, 80), color(150, 50, 255, 80), sin(t + index) * 0.5 + 0.5));
  beginShape();
  for (float x = 0; x <= width; x += 10) {
    float y = yOffset + sin((x * 0.05) + t + index) * 50;
    vertex(x, y);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

// Function to draw rotating infinity symbol
void drawRotatingInfinity(float x, float y, float size, float time) {
  pushMatrix();
  translate(x, y);
  rotate(time * 0.5); // Rotational effect
  noFill();
  stroke(255, 255, 255, 150);
  strokeWeight(3);
  beginShape();
  for (float angle = 0; angle < TWO_PI; angle += 0.01) {
    float r = size * 0.5;
    float x1 = r * cos(angle) * (1 + sin(angle));
    float y1 = r * sin(angle) * cos(angle);
    vertex(x1, y1);
  }
  endShape(CLOSE);

  // Glowing trails
  stroke(255, 255, 255, 50);
  for (int i = 1; i <= 3; i++) {
    float scale = 1.0 - i * 0.1;
    beginShape();
    for (float angle = 0; angle < TWO_PI; angle += 0.01) {
      float r = size * 0.5 * scale;
      float x1 = r * cos(angle) * (1 + sin(angle));
      float y1 = r * sin(angle) * cos(angle);
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }
  popMatrix();
}

// Star class for cosmic background
class Star {
  float x, y, radius;
  color starColor;

  Star(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.starColor = color(255, 255, 255, random(100, 255));
  }

  void twinkle() {
    fill(starColor);
    noStroke();
    ellipse(x, y, radius, radius);
    starColor = color(255, 255, 255, random(100, 255)); // Random brightness
  }
}
