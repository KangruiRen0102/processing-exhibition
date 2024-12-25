float orbitalX = 0; // Horizontal position of the orbital
float orbitalY;     // Vertical position of the orbital
float orbitalSize;  // Size of the orbital
color auroraStart = color(10, 50, 150);
color auroraEnd = color(100, 200, 255);
int transformationMode = 1; // Transformation effect mode
void setup() {
  size(800, 600);
  orbitalY = height / 2;      // Sets the orbital's initial position
  orbitalSize = 30;           // Set the orbital initial size
  noStroke();
}

void draw() {
  drawAurora();          // Aurora background
  drawJourney();         // Moving orbitall
  applyMetamorphosis();  // Transformation of the orbital/metamophosis :)
}

void drawAurora() {
  // Create flowing grad for aurora
  for (int y = 0; y < height; y += 5) {
    float noiseOffset = map(noise(y * 0.01, frameCount * 0.01), 0, 1, -50, 50);
    fill(lerpColor(color(10, 50, 150), color(100, 200, 255), map(y, 0, height, 0, 1)));
    rect(0, y + noiseOffset, width, 5);
  }
}
void drawJourney() {
  // Yhis draws the moving orbital as it goes alonng the grad
  fill(255, 200, 100);  // orbital's color
  ellipse(orbitalX, orbitalY, orbitalSize, orbitalSize); // orbital position and size during it journey
  orbitalX += 2; // Move the orbital horizontally
  if (orbitalX > width) orbitalX = 0; // Loop back to the start when reaching the edge
}
void applyMetamorphosis() {
  // Transformations based on the mode
  if (transformationMode == 1) {
    // Size pulsation
    orbitalSize = 20 + 10 * sin(frameCount * 0.05);
    fill(255, 150, 150 + 100 * sin(frameCount * 0.1));
    ellipse(orbitalX, orbitalY, orbitalSize, orbitalSize);
  } else if (transformationMode == 2) {
    // Rotating trail effect
    for (int i = 0; i < 10; i++) {
      float angle = radians(i * 36 + frameCount);
      float trailX = orbitalX + cos(angle) * 20;
      float trailY = orbitalY + sin(angle) * 20;
      fill(255, 150, 150, 100 - i * 10);
      ellipse(trailX, trailY, 15, 15);
    }
  } else if (transformationMode == 3) {
    // Ripple effect
    for (int i = 0; i < 5; i++) {
      float rippleSize = orbitalSize + i * 10;
      fill(255, 255, 150, 150 - i * 30);
      ellipse(orbitalX, orbitalY, rippleSize, rippleSize);
    }
  }
}
void keyPressed() {
  // Switch transformation modes
  if (key == '1') transformationMode = 1;
  if (key == '2') transformationMode = 2;
  if (key == '3') transformationMode = 3;
}
