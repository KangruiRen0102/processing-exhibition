ArrayList<MemoryCircle> memoryCircles = new ArrayList<MemoryCircle>();
ArrayList<Hexagon> hexagons = new ArrayList<Hexagon>();
ArrayList<Star> stars = new ArrayList<Star>();

void setup() {
  size(800, 800);
  // Frame rate for smooth animation
  frameRate(30);
  setupHexagons();
  setupStars();
}

void draw() {
  // Background
  background(180, 220, 255); 

  // Stars
  for (Star star : stars) {
    star.display();
    star.twinkle();
  }

  // Hexagons
  for (Hexagon hex : hexagons) {
    hex.display();
  }

  // Glowing orb
  noStroke();
  for (int i = 100; i > 0; i -= 10) { 
    fill(255, 200, 0, 255 - i * 2); 
    ellipse(width / 2, height / 2, i * 3, i * 3); 
  }

  // Adding memory circles
  if (frameCount % 10 == 0) { 
    memoryCircles.add(new MemoryCircle(width / 2, height / 2));
  }
  
  for (int i = memoryCircles.size() - 1; i >= 0; i--) {
    MemoryCircle mc = memoryCircles.get(i);
    mc.update();
    mc.display();

    if (mc.isOffScreen()) {
      memoryCircles.remove(i);
    }
  }
}

void setupHexagons() {
  for (int i = 0; i < 50; i++) {
    hexagons.add(new Hexagon(random(width), random(height), random(20, 60)));
  }
}

void setupStars() {
  for (int i = 0; i < 100; i++) {
    stars.add(new Star(random(width), random(height), random(3, 6))); 
  }
}

void mousePressed() {
  // Burst of memory orbs wherever the mouse is clicked
  for (int i = 0; i < 10; i++) {
    memoryCircles.add(new MemoryCircle(mouseX, mouseY));
  }
}

class MemoryCircle {
  float x, y;
  float size;
  float speed;
  float angle;

  MemoryCircle(float startX, float startY) {
    x = startX;
    y = startY;
    size = random(10, 30);
    speed = random(1, 3);
    angle = random(TWO_PI);
  }

  void update() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
  }

  void display() {
    fill(255, 180, 50, 100); 
    noStroke();
    ellipse(x, y, size, size);
  }

  boolean isOffScreen() {
    return x < -size || x > width + size || y < -size || y > height + size;
  }
}

class Hexagon {
  float x, y, size;

  Hexagon(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  void display() {
    stroke(255);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < 6; i++) {
      float angle = TWO_PI / 6 * i;
      float x1 = x + cos(angle) * size;
      float y1 = y + sin(angle) * size;
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }
}

class Star {
  float x, y, size;
  float brightness;
  boolean increasing;

  Star(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.brightness = random(150, 255); 
    this.increasing = random(1) > 0.5;
  }

  void display() {
    fill(brightness);
    noStroke();
    ellipse(x, y, size, size);
  }

  void twinkle() {
    if (increasing) {
      brightness += 2;
      if (brightness > 255) increasing = false;
    } else {
      brightness -= 2;
      if (brightness < 150) increasing = true;
    }
  }
}
