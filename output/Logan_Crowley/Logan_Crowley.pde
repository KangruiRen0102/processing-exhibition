float t = 0; // Time variable for animation

void setup() {
  size(800, 800);
  smooth();
}

void draw() {
  background(0); // Black background as shadow

  // Infinity symbol pattern
  translate(width / 2, height / 2);
  noFill();
  
  for (int i = 0; i < 30; i++) {
    stroke(lerpColor(color(50, 50, 100), color(200, 200, 255), sin(t + i * 0.3) * 0.5 + 0.5));
    strokeWeight(2);
    beginShape();
    for (float a = 0; a < TWO_PI; a += 0.1) {
      float r = 200 + 50 * sin(6 * a + t + i * 0.15); // Increased amplitude for dramatic effect
      float x = r * cos(a);
      float y = r * sin(a) * cos(a); // Infinity symbol formula
      vertex(x, y);
    }
    endShape(CLOSE);
  }

  // Hope - pulsing light
  noStroke();
  for (int i = 50; i > 0; i--) {
    float brightness = (float)i / 50;
    fill(lerpColor(color(255, 200, 50), color(255, 50, 50), brightness), 150 - i * 3);
    ellipse(0, 0, i * 10 * abs(sin(t * 1.5)), i * 10 * abs(sin(t * 1.5))); // Faster and larger pulsing
  }

  t += 0.05; // time increment
}
