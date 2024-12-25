// Processing Code Making a clock obscured in Shadow, representing the themes of time, shadow, and twilight

// Variables for clock center and size
float centerX, centerY; // Center of the clock
float clockRadius; // Radius of the clock

void setup() {
  size(1000, 1000); // Canvas size
  centerX = width / 2;
  centerY = height / 2;
  clockRadius = min(width, height) / 2 - 50; // Set radius with padding
}

void draw() {
  background(10, 10, 30); // Dark background resembling shadow

  // Draw clock face
  fill(35, 35, 75); // Dark color for clock face
  noStroke();
  ellipse(centerX, centerY, clockRadius * 1.5, clockRadius * 1.5);

  // Draw hour markers
  for (int i = 0; i < 12; i++) {
    float angle = map(i, 0, 12, 0, TWO_PI) - HALF_PI;
    float x = centerX + cos(angle) * clockRadius * 0.6;
    float y = centerY + sin(angle) * clockRadius * 0.6;
    fill(200, 200, 100);
    ellipse(x, y, 12, 12); // Hour marker dots
  }

  // Get current time
  int h = hour() % 12;
  int m = minute();
  int s = second();

  // Calculate angles for clock hands
  float hourAngle = map(h + m / 60.0, 0, 12, 0, TWO_PI) - HALF_PI;
  float minuteAngle = map(m + s / 60.0, 0, 60, 0, TWO_PI) - HALF_PI;
  float secondAngle = map(s, 0, 60, 0, TWO_PI) - HALF_PI;

  // Draw clock hands
  strokeCap(ROUND);

  // Hour hand
  stroke(200, 200, 255, 150);
  strokeWeight(8);
  line(centerX, centerY,
       centerX + cos(hourAngle) * clockRadius * 0.4,
       centerY + sin(hourAngle) * clockRadius * 0.4);

  // Minute hand
  stroke(150, 150, 200, 200);
  strokeWeight(6);
  line(centerX, centerY,
       centerX + cos(minuteAngle) * clockRadius * 0.6,
       centerY + sin(minuteAngle) * clockRadius * 0.6);

  // Second hand
  stroke(100, 100, 150, 200);
  strokeWeight(3);
  line(centerX, centerY,
       centerX + cos(secondAngle) * clockRadius * 0.7,
       centerY + sin(secondAngle) * clockRadius * 0.7);

  // Overlay shadow obscuring parts of the clock
  drawClockShadow();

  // Draw window
  drawWindow();

  // Draw moon
  drawMoon();
}

// Function to draw a moving shadow obscuring parts of the clock
void drawClockShadow() {
  float shadowX = centerX + cos(frameCount * 0.01) * clockRadius * 0.6;
  float shadowY = centerY + sin(frameCount * 0.01) * clockRadius * 0.6;

  fill(0, 0, 0, 160); // Dark shadow
  noStroke();
  ellipse(shadowX, shadowY, clockRadius * 1.5, clockRadius * 1.5);
}

// Function to draw the window
void drawWindow() {
  stroke(0);
  strokeWeight(10);
  fill(245, 12); // Semi-transparent window pane
  rectMode(CENTER);
  square(centerX, centerY, 900); // Window frame
  line(centerX - 450, centerY, centerX + 450, centerY); // Horizontal pane
  line(centerX, centerY - 450, centerX, centerY + 450); // Vertical pane
}

// Function to draw the moon
void drawMoon() {
  blendMode(ADD); // Apply blend mode for glowing effect

  // Base moon
  fill(200, 200, 120, 200);
  circle(centerX + 300, centerY - 300, 70);

  // Glow effect layers
  for (int i = 1; i <= 5; i++) {
    float glowRadius = 70 + i * 15;
    float glowAlpha = 150 / i; // Reduce opacity for outer layers
    fill(200, 200, 120, glowAlpha);
    circle(centerX + 300, centerY - 300, glowRadius);
  }

  blendMode(BLEND); // Reset blending mode
}
