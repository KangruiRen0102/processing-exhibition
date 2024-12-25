boolean isFrozen = false;

void setup() {
  size(1000, 1000);
  background(20);
  frameRate(60);
  noCursor();
}

void draw() {
  if (!isFrozen) {
    // Chaos
    for (int i = 0; i < 10; i++) {
      float x = random(width);
      float y = random(height);
      float size = random(30, 100);
      noStroke();
      fill(random(255), random(255), random(255), 150);
      ellipse(x, y, size, size);
    }

    // Growing trails formed by mouse pointer to signify memory and growth 
    stroke(255, 200);
    strokeWeight(frameCount % 10 + 1); // Trail grows over time
    line(pmouseX, pmouseY, mouseX, mouseY);

    // Center ring that expands with time to signify growth
    float growthSpeed = millis() * 0.01;
    stroke(random(255), 200);
    noFill();
    ellipse(width / 2, height / 2, growthSpeed % width, growthSpeed % height);

    // Fading
    fill(100, 10);
    rect(0, 0, width, height);
  }
}

void mousePressed() {
  isFrozen = !isFrozen; // Toggle freeze by mouse click for memory
}
