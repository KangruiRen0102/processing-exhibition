// This Processing sketch visualizes an aurora-themed journey with infinite depth.
// The code creates animated auroras, a moving path, and stars to symbolize the infinite journey.

int starCount = 200; // Number of stars in the background
Star[] stars = new Star[starCount]; // Array to hold the stars
float[] waveOffsets = new float[5]; // Offsets for aurora waves
ShootingStar shootingStar; // For the shooting star effect

void setup() {
  size(800, 600);
  // Initialize stars for the background
  for (int i = 0; i < starCount; i++) {
    stars[i] = new Star();
  }
  // Initialize offsets for aurora waves
  for (int i = 0; i < waveOffsets.length; i++) {
    waveOffsets[i] = random(1000);
  }
  shootingStar = null; // Start with no shooting star
}

void draw() {
  background(0); // Black background for the night sky
  
  drawStars(); // Drawing infinite stars in the sky
  drawAurora(); // Draw aurora waves
  
  drawPath(); // Draw a journey path which leads into the horizon
  
  // Draw and update shooting star if it exists
  if (shootingStar != null) {
    shootingStar.update();
    shootingStar.display();
    if (shootingStar.isOffScreen()) {
      shootingStar = null; // Remove shooting star if it leaves the screen
    }
  }
}

// Class to represent a single star
class Star {
  float x, y, brightness;
  
  Star() {
    x = random(width);
    y = random(height);
    brightness = random(50, 255); // Random brightness for each star
  }
  
  void display() {
    fill(brightness);
    noStroke();
    ellipse(x, y, 2, 2); // Stars as tiny circles
  }
}

void drawStars() {
  for (Star s : stars) {
    s.display();
  }
}

void drawAurora() {
  noFill();
  for (int i = 0; i < waveOffsets.length; i++) {
    // Change aurora color based on mouse position
    float t = map(mouseX, 0, width, 0, 1); 
    stroke(lerpColor(color(0, 150, 255, 150), color(150, 50, 255, 150), t));
    strokeWeight(10 - i * 2); // Waves get thinner
    beginShape();
    for (int x = 0; x < width; x += 10) {
      float y = map(noise(x * 0.01, waveOffsets[i]), 0, 1, height / 4, height / 2);
      vertex(x, y);
    }
    endShape();
    waveOffsets[i] += 0.01; // Create animation by shifting offsets
  }
}

void drawPath() {
  noStroke();
  for (int i = 0; i < 10; i++) {
    fill(50, 50, 50, 150 - i * 15); // Gradual fading of the path
    beginShape();
    vertex(width / 2 - i * 20, height);
    vertex(width / 2 + i * 20, height);
    vertex(width / 2 + i * 10, height / 2 + i * 50);
    vertex(width / 2 - i * 10, height / 2 + i * 50);
    endShape(CLOSE);
  }
}

// Class for shooting star
class ShootingStar {
  float x, y, speedX, speedY;
  
  ShootingStar(float startX, float startY) {
    x = startX;
    y = startY;
    speedX = random(-5, -3); // Shooting left
    speedY = random(-2, -1); // Slightly upward
  }
  
  void update() {
    x += speedX;
    y += speedY;
  }
  
  void display() {
    stroke(255, 255, 100);
    strokeWeight(3);
    line(x, y, x - 10 * speedX, y - 10 * speedY); // Draw the streak
  }
  
  boolean isOffScreen() {
    return x < 0 || y < 0;
  }
}

// Handle mouse and keyboard interaction
void mousePressed() {
  // Click changes aurora colors dynamically (trigger redraw).
  redraw();
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    // Press 'S' to spawn a shooting star
    shootingStar = new ShootingStar(width, height - random(50, 150));
  }
}
