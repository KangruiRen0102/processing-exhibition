float time = 0; // Animation timer
int numCircles = 100; // Number of circles to draw
float scaleFactor = 1.0; // Overall zoom
float infinityScale = 1.0; // Size of the infinity symbol
float rotationAngle = 0; // Rotation
float rotationSpeed = 0.01; // Speed of rotation
boolean isPaused = false; // Pause toggle
ArrayList<Particle> particles; // Persistent particle explosions

void setup() {
  size(800, 800);
  frameRate(60);
  noStroke();
  particles = new ArrayList<Particle>();
}

void draw() {
  if (isPaused) return;

  background(20); // Dark background
  translate(width / 2, height / 2); // Center the drawing

  // Adjust scaling and rotation
  scale(scaleFactor);
  rotate(rotationAngle);

  drawInfinitySymbol();
  updateParticles();

  time += 0.01; // Advance animation
  rotationAngle += rotationSpeed; // Continuous rotation
}

void drawInfinitySymbol() {
  for (int i = 0; i < numCircles; i++) {
    float progress = map(i, 0, numCircles, 0, TWO_PI); 
    float t = progress + time; 

    // Parametric equations for the infinity symbol with scaling
    float a = 150 * infinityScale; 
    float b = 300 * infinityScale; 

    float x = (b * cos(t)) / (1 + pow(sin(t), 2));
    float y = (a * cos(t) * sin(t)) / (1 + pow(sin(t), 2));

    float size = map(sin(t + time), -1, 1, 10, 30); // Circle size oscillation
    fill(lerpColor(color(0, 255, 100), color(0, 100, 255), sin(t + time) * 0.5 + 0.5));

    ellipse(x, y, size, size);
  }
}

void updateParticles() {
  for (Particle p : particles) {
    p.show();
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    triggerExplosion();
  }
}

void triggerExplosion() {
  for (int i = 0; i < 50; i++) {
    float angle = random(TWO_PI);
    float speed = random(2, 5);
    particles.add(new Particle(0, 0, cos(angle) * speed, sin(angle) * speed));
  }
}

class Particle {
  float x, y, vx, vy;
  int size;
  int particleColor;

  Particle(float x, float y, float vx, float vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = int(random(4, 8));
    this.particleColor = color(random(50, 255), random(50, 255), 255);
  }

  void show() {
    fill(particleColor, 200);
    ellipse(x, y, size, size);
    x += vx * 0.5; // Move slowly outward
    y += vy * 0.5;
  }
}

void mouseWheel(MouseEvent event) {
  // Increase or decrease the number of circles
  numCircles += event.getCount() * -5;
  numCircles = constrain(numCircles, 10, 200);
}

void keyPressed() {
  if (key == ' ') {
    isPaused = !isPaused; // Toggle pause
  } else if (keyCode == UP) {
    // Increase the speed of rotation
    rotationSpeed += 0.005;
  } else if (keyCode == DOWN) {
    // Decrease the speed of rotation
    rotationSpeed = max(0.001, rotationSpeed - 0.005);
  } else if (keyCode == LEFT) {
    // Decrease overall zoom (scaleFactor)
    scaleFactor = max(0.5, scaleFactor - 0.1);
  } else if (keyCode == RIGHT) {
    // Increase overall zoom (scaleFactor)
    scaleFactor = min(2.0, scaleFactor + 0.1);
  } else if (key == '+') {
    // Increase the number of circles
    numCircles = min(200, numCircles + 10);
  } else if (key == '-') {
    // Decrease the number of circles
    numCircles = max(10, numCircles - 10);
  } else if (key == 'w' || key == 'W') {
    // Increase the size of the infinity symbol
    infinityScale = min(3.0, infinityScale + 0.1);
  } else if (key == 's' || key == 'S') {
    // Decrease the size of the infinity symbol
    infinityScale = max(0.0, infinityScale - 0.1);
  }
}
