float clockRadius = 100; // Radius of the clock
boolean clockPaused = false; // Tracks if the clock is paused
int spaceBarCount = 0; // Space bar press counter
final int MAX_PRESSES = 2; // Press limit before reset

// Clock position and movement
float clockX, clockY;
float velocityX = 3, velocityY = 3;

// Saved hand positions when paused
float pausedSecond, pausedMinute, pausedHour;

void setup() {
  size(800, 800); 
  clockX = width / 2;
  clockY = height / 2;
}

void draw() {
  background(20);

  if (!clockPaused) {
    // Update clock position
    clockX += velocityX;
    clockY += velocityY;

    // Bounce off edges
    if (clockX - clockRadius < 0 || clockX + clockRadius > width) {
      velocityX *= -1;
    }
    if (clockY - clockRadius < 0 || clockY + clockRadius > height) {
      velocityY *= -1;
    }
  }

  translate(clockX, clockY);
  drawClockFace();
  drawClockHands();
}

void drawClockFace() {
  noFill();
  stroke(255);
  strokeWeight(4);
  ellipse(0, 0, clockRadius * 2, clockRadius * 2);

  // Hour markers
  for (int i = 0; i < 12; i++) {
    float angle = map(i, 0, 12, 0, TWO_PI) - HALF_PI;
    float innerX = cos(angle) * (clockRadius - 10);
    float innerY = sin(angle) * (clockRadius - 10);
    float outerX = cos(angle) * clockRadius;
    float outerY = sin(angle) * clockRadius;
    strokeWeight(2);
    line(innerX, innerY, outerX, outerY);
  }
}

void drawClockHands() {
  float currentSecond = second();
  float currentMinute = minute() + currentSecond / 60.0;
  float currentHour = hour() % 12 + currentMinute / 60.0;

  if (clockPaused) {
    currentSecond = pausedSecond;
    currentMinute = pausedMinute;
    currentHour = pausedHour;
  } else {
    pausedSecond = currentSecond;
    pausedMinute = currentMinute;
    pausedHour = currentHour;
  }

  // Second hand
  stroke(200, 0, 0);
  strokeWeight(2);
  float secAngle = map(currentSecond, 0, 60, 0, TWO_PI) - HALF_PI;
  line(0, 0, cos(secAngle) * (clockRadius - 20), sin(secAngle) * (clockRadius - 20));

  // Minute hand
  stroke(0, 200, 200);
  strokeWeight(4);
  float minAngle = map(currentMinute, 0, 60, 0, TWO_PI) - HALF_PI;
  line(0, 0, cos(minAngle) * (clockRadius - 40), sin(minAngle) * (clockRadius - 40));

  // Hour hand
  stroke(255);
  strokeWeight(6);
  float hourAngle = map(currentHour, 0, 12, 0, TWO_PI) - HALF_PI;
  line(0, 0, cos(hourAngle) * (clockRadius - 60), sin(hourAngle) * (clockRadius - 60));
}

void keyPressed() {
  if (key == ' ') {
    clockPaused = !clockPaused;

    if (!clockPaused) {
      spaceBarCount++;
      if (spaceBarCount >= MAX_PRESSES) {
        clockRadius = 100; // Reset radius
        spaceBarCount = 0; // Reset counter
      } else {
        clockRadius *= 2; // Increase radius
      }
    }
  }
}
