void setup() {
  size(800, 800);
  noLoop();
}

void draw() {
  background(20); // Dark background to symbolize the unknown chaos of life
  
  // Create chaotic shapes and colors
  for (int i = 0; i < 150; i++) {
    float x = random(width);
    float y = random(height);
    float size = random(10, 50);
    int r = (int)random(100, 255);
    int g = (int)random(100, 255);
    int b = (int)random(100, 255);
    
    fill(r, g, b, 150);
    noStroke();
    ellipse(x, y, size, size);
  }
  
  // Add a "frozen moment" at the center
  pushMatrix();
  translate(width / 2, height / 2);
  for (int i = 0; i < 50; i++) {
    float angle = TWO_PI / 50 * i;
    float x = cos(angle) * 150;
    float y = sin(angle) * 150;
    
    stroke(255);
    strokeWeight(2);
    line(0, 0, x, y);
  }
  popMatrix();
  
  // Add flowing lines to symbolize the journey ahead
  noFill();
  stroke(255, 200, 0);
  strokeWeight(2);
  for (int i = 0; i < 10; i++) {
    float offset = i * 15;
    beginShape();
    for (float x = 0; x < width; x += 5) {
      float y = height / 2 + sin(x * 0.01 + offset) * 100;
      vertex(x, y);
    }
    endShape();
  }
}
