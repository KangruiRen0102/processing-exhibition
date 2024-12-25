ArrayList<Wave> waves;
ArrayList<Particle> particles;
ArrayList<Star> stars;
float sunRadius = 50;
float timeCounter = 0;
PVector sunPos;
color sunsetTop = color(255, 94, 77);  // Vibrant orange-red
color sunsetBottom = color(50, 20, 100);  // Deep purple-blue

void setup() {
  size(800, 800);
  waves = new ArrayList<>();
  particles = new ArrayList<>();
  stars = new ArrayList<>();
  sunPos = new PVector(width / 2, height / 4);
  
  // Create initial waves
  for (int i = 0; i < 5; i++) {
    waves.add(new Wave(height - 150 + i * 30)); // Waves closer to the bottom
  }
  
  // Create stars
  for (int i = 0; i < 100; i++) {
    stars.add(new Star());
  }
}

void draw() {
  // Constant sunset background
  setGradient(0, 0, width, height, sunsetTop, sunsetBottom, Y_AXIS);
  
  // Draw twinkling stars
  for (Star star : stars) {
    star.twinkle();
    star.display();
  }
  
  // Pulsating "hope" sun
  float pulse = sin(timeCounter * 0.05) * 20;
  fill(255, 204, 0, 180);
  noStroke();
  ellipse(sunPos.x, sunPos.y, sunRadius + pulse, sunRadius + pulse);
  
  // Update and draw waves
  for (Wave wave : waves) {
    wave.update();
    wave.display();
  }
  
  // Add flowing particles
  if (frameCount % 3 == 0) {
    particles.add(new Particle(random(width), height - 150, color(random(100, 200), random(100, 200), 255)));
  }
  
  // Update and display particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isOffScreen()) {
      particles.remove(i);
    }
  }
  
  // Increment time
  timeCounter++;
}

// Particle class
class Particle {
  PVector position;
  PVector velocity;
  color col;
  
  Particle(float x, float y, color c) {
    position = new PVector(x, y);
    velocity = new PVector(random(-1, 1), random(-2, -1));
    col = c;
  }
  
  void update() {
    position.add(velocity);
    velocity.x += random(-0.05, 0.05);
  }
  
  void display() {
    fill(col, 150);
    noStroke();
    ellipse(position.x, position.y, 5, 5);
  }
  
  boolean isOffScreen() {
    return position.y < height - 200 || position.x < 0 || position.x > width;
  }
}

// Wave class for faster left-to-right ocean flow
class Wave {
  float offsetX;
  float offsetY;
  float waveSpeed = 0.05; // Increased speed for faster motion
  float waveAmplitude = 20;
  float noiseOffset; // For randomness in shape
  
  Wave(float offsetY) {
    this.offsetY = offsetY;
    this.offsetX = random(0, TWO_PI); // Random phase offset
    this.noiseOffset = random(0, 100); // Start with random noise
  }
  
  void update() {
    offsetX += waveSpeed; // Faster horizontal shift
    noiseOffset += 0.01; // Increment noise for organic effect
  }
  
  void display() {
    noFill();
    stroke(100, 150, 255, 180);
    strokeWeight(2);
    beginShape();
    for (float x = 0; x < width; x += 5) {
      float waveNoise = noise(noiseOffset + x * 0.01) * 2; // Subtle variation
      float y = sin((x + offsetX) * 0.05) * (waveAmplitude + waveNoise) + offsetY;
      vertex(x, y);
    }
    endShape();
  }
}

// Star class for dynamic twinkling stars
class Star {
  float x, y;
  float size;
  int twinkleSpeed;
  color starColor;
  
  Star() {
    x = random(width);
    y = random(height / 2); // Stars only in the top half
    size = random(1, 3);
    twinkleSpeed = int(random(5, 30)); // Faster twinkling
    starColor = color(255, 255, 200, random(100, 255));
  }
  
  void twinkle() {
    if (frameCount % twinkleSpeed == 0) {
      starColor = color(255, 255, 200, random(100, 255));
    }
  }
  
  void display() {
    fill(starColor);
    noStroke();
    ellipse(x, y, size, size);
  }
}

// Gradient function
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis) {
  noFill();
  for (int i = 0; i <= h; i++) {
    float inter = map(i, 0, h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    if (axis == Y_AXIS) {
      stroke(c);
      line(x, y + i, x + w, y + i);
    }
  }
}

final int Y_AXIS = 1;
