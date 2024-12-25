// Processing sketch for "Discovery, Infinity, and Flow"
// Represents discovery through dynamic shapes, infinity with looping motion, and flow with seamless transitions.

// Global variables
int numCircles = 50; // Number of circles
float angle = 0; // Angle for rotation
color[] palette = {color(30, 144, 255), color(0, 255, 127), color(255, 69, 0), color(255, 215, 0)}; // Colors for flow

void setup() {
  size(800, 800);
  noStroke();
  frameRate(30);
}

void draw() {
  background(0);

  // Draw flowing background
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(palette[0], palette[1], inter);
    stroke(c);
    line(0, i, width, i);
  }

  // Draw rotating infinite loops
  translate(width / 2, height / 2);
  for (int i = 0; i < numCircles; i++) {
    float radius = map(i, 0, numCircles, 50, 300);
    float x = radius * cos(angle + i * TWO_PI / numCircles);
    float y = radius * sin(angle + i * TWO_PI / numCircles);

    fill(palette[i % palette.length]);
    ellipse(x, y, 20, 20);
  }

  // Dynamic element for discovery
  float discoveryX = width / 2 + 200 * cos(angle * 2);
  float discoveryY = height / 2 + 200 * sin(angle * 2);
  fill(palette[2]);
  ellipse(discoveryX, discoveryY, 50, 50);

  angle += 0.02;
}
