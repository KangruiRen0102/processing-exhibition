int numSegments = 10; // Number of segments in the kaleidoscope
float growth = 1; // Growth factor for shapes

void setup() {
  size(800, 800);
  background(0);
  frameRate(60);
}

void draw() {
  translate(width / 2, height / 2); // Center the kaleidescope
  float t = millis() * 0.001; // Time for growth
  
  // Interactive element for growth and memory creation over time
  if (mousePressed) {
    growth += 0.2; // Growth increases with interaction
    float x = mouseX - width / 2;
    float y = mouseY - height / 2;
    drawKaleidoscope(x, y, growth);
  } else {
    growth *= 0.99; 
  }
  
  fill(0, 20);
  rect(-width / 2, -height / 2, width, height); // Fades for memory blending
}

void drawKaleidoscope(float x, float y, float size) {
  for (int i = 0; i < numSegments; i++) {
    pushMatrix();
    float angle = TWO_PI / numSegments * i;
    rotate(angle);
    mirrorSymmetry(x, y, size);
    popMatrix();
  }
}

// Draw and mirror the memory shapes
void mirrorSymmetry(float x, float y, float size) {
  fill(colorMap(size), 100, 200, 150);
  noStroke();
  ellipse(x, y, size * 0.5, size * 0.5); // Primary shape
  
  fill(colorMap(size + 50), 150, 250, 100);
   triangle(x - size * 0.1, y - size * 0.1, x + size * 0.1, y - size * 0.1, x, y + size * 0.2); // Supporting shapes
  
  // Mirroring effect for reflection
  pushMatrix();
  scale(-1, 1); // Flip horizontally
  ellipse(x, y, size * 0.5, size * 0.5);
  triangle(x - size * 0.1, y - size * 0.1, x + size * 0.1, y - size * 0.1, x, y + size * 0.2);
  popMatrix();
}

// Map colors based on the growth size
int colorMap(float size) {
  return int(map(size % 255, 0, 255, 100, 255));
}
