void setup() {
  size(800, 600);
  noStroke();
}

void draw() {
  // Background: Multicolor gradient for the ocean
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(10, 30, 80), color(0, 50, 100), inter));
    if (y > height / 2) {
      stroke(lerpColor(color(0, 50, 100), color(10, 10, 60), map(y, height / 2, height, 0, 1)));
    }
    line(0, y, width, y);
  }

  // Time: Colorful clock in the center
  pushMatrix();
  translate(width / 2, height / 2);
  fill(255, 220, 100, 150); // Glow for clock face
  ellipse(0, 0, 320, 320);
  fill(100, 200, 255, 180); // Clock face
  ellipse(0, 0, 300, 300);

  // Clock markings with colors
  for (int i = 0; i < 12; i++) {
    float angle = radians(360 / 12 * i);
    float outerX = cos(angle) * 140;
    float outerY = sin(angle) * 140;
    float innerX = cos(angle) * 120;
    float innerY = sin(angle) * 120;
    stroke(lerpColor(color(255, 100, 100), color(100, 100, 255), i / 12.0));
    strokeWeight(3);
    line(innerX, innerY, outerX, outerY);
  }

  // Hour hand
  float hourAngle = radians((hour() % 12) * 30 - 90);
  stroke(255, 80, 80);
  strokeWeight(6);
  line(0, 0, cos(hourAngle) * 80, sin(hourAngle) * 80);

  // Minute hand
  float minuteAngle = radians(minute() * 6 - 90);
  stroke(80, 255, 80);
  strokeWeight(4);
  line(0, 0, cos(minuteAngle) * 100, sin(minuteAngle) * 100);

  // Second hand
  float secondAngle = radians(second() * 6 - 90);
  stroke(80, 80, 255);
  strokeWeight(2);
  line(0, 0, cos(secondAngle) * 110, sin(secondAngle) * 110);

  popMatrix();

  // Sea: Multicolor undulating wave pattern
  float waveHeight = 50;
  float waveFrequency = 0.02;
  for (int x = 0; x < width; x += 10) {
    float y = height * 0.75 + sin(frameCount * 0.02 + x * waveFrequency) * waveHeight;
    fill(lerpColor(color(30, 50, 100), color(100, 200, 255), sin(x * 0.05 + frameCount * 0.02) * 0.5 + 0.5));
    ellipse(x, y, 20, 20);
  }
}
