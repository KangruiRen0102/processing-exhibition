// Line 2 and 3 are the variables for movement and colors
float xOffset = 0;
float yOffset = 0;
// Lines 5,6,7 makes sure the window size is 800x800 pixels and ensures that shapes drawn in the sketch will not have outlines
void setup() {
  size(800, 800);
  noStroke();
}
// This code creates the dark background
void draw() {
  background(10, 20, 40); 

  // This section of code creates the slow-moving blue ice-like polygons in the circles
  for (int i = 0; i < 50; i++) {
    pushMatrix();
    fill(100, 150, 255, 180); // Ice-like blue color
    translate((width / 2) + noise(i, frameCount * 0.001) * width - width / 2 + xOffset,
              (height / 2) + noise(i + 100, frameCount * 0.001) * height - height / 2 + yOffset);
    drawIceShape(random(20, 40));
    popMatrix();
  }

  // This section of code creates the blue gradient circles
  for (int i = 0; i < 10; i++) {
    fill(50, 100, 255, 100 - i * 10);
    ellipse(width / 2 + xOffset, height / 2 + yOffset, width - i * 80, height - i * 80);
  }

  // This section of code creates the moving balls in the wave like pattern
  for (int i = 0; i < width; i += 20) {
    fill(0, 50, 200, 200);
    ellipse(i + xOffset, height / 2 + sin((i + frameCount) * 0.05) * 50 + yOffset, 15, 15);
  }
}

// This section of code uses the draw function to create the ice-like polygons
void drawIceShape(float size) {
  beginShape();
  for (int i = 0; i < 6; i++) { // Hexagonal shape for ice
    float angle = TWO_PI / 6 * i;
    float x = cos(angle) * size;
    float y = sin(angle) * size;
    vertex(x, y);
  }
  endShape(CLOSE);
}
