let clockRadius = 100; // Radius of the clock
let clockPaused = false; // Tracks if the clock is paused
let spaceBarCount = 0; // Space bar press counter
const MAX_PRESSES = 2; // Press limit before reset

// Clock position and movement
let clockX, clockY;
let velocityX = 3, velocityY = 3;

// Saved hand positions when paused
let pausedSecond, pausedMinute, pausedHour;

function setup() {
  createCanvas(800, 800);
  clockX = width / 2;
  clockY = height / 2;
}

function draw() {
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

  push();
  translate(clockX, clockY);
  drawClockFace();
  drawClockHands();
  pop();
}

function drawClockFace() {
  noFill();
  stroke(255);
  strokeWeight(4);
  ellipse(0, 0, clockRadius * 2, clockRadius * 2);

  // Hour markers
  for (let i = 0; i < 12; i++) {
    let angle = map(i, 0, 12, 0, TWO_PI) - HALF_PI;
    let innerX = cos(angle) * (clockRadius - 10);
    let innerY = sin(angle) * (clockRadius - 10);
    let outerX = cos(angle) * clockRadius;
    let outerY = sin(angle) * clockRadius;
    strokeWeight(2);
    line(innerX, innerY, outerX, outerY);
  }
}

function drawClockHands() {
  let currentSecond = second();
  let currentMinute = minute() + currentSecond / 60.0;
  let currentHour = hour() % 12 + currentMinute / 60.0;

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
  let secAngle = map(currentSecond, 0, 60, 0, TWO_PI) - HALF_PI;
  line(0, 0, cos(secAngle) * (clockRadius - 20), sin(secAngle) * (clockRadius - 20));

  // Minute hand
  stroke(0, 200, 200);
  strokeWeight(4);
  let minAngle = map(currentMinute, 0, 60, 0, TWO_PI) - HALF_PI;
  line(0, 0, cos(minAngle) * (clockRadius - 40), sin(minAngle) * (clockRadius - 40));

  // Hour hand
  stroke(255);
  strokeWeight(6);
  let hourAngle = map(currentHour, 0, 12, 0, TWO_PI) - HALF_PI;
  line(0, 0, cos(hourAngle) * (clockRadius - 60), sin(hourAngle) * (clockRadius - 60));
}

function keyPressed() {
  if (key === ' ') {
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
