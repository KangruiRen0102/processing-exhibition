let hourAngle = 0;
let minuteAngle = 0;
let secondAngle = 0;
let dayNightAngle = 0;
let angleVelocity = 0.5; // Changing this value will change the velocity of the hands

function setup() {
  createCanvas(500, 500);
  smooth();
  noStroke();
}

function draw() {
  let dayNightIntensity = (cos(dayNightAngle) + 1) / 2; // Day-night intensity based on hour hand angle
  let backgroundColor = lerpColor(color(0, 2, 61), color(220, 220, 255), dayNightIntensity); // Background color transitions
  background(backgroundColor);

  translate(width / 2, height / 2); // Move origin to center

  // Clock
  fill(50); // Gray
  ellipse(0, 0, 300, 300);

  // Hour ticks
  fill(255); // White
  for (let i = 0; i < 12; i++) { // Create 12 ticks
    push();
    rotate((TWO_PI / 12) * i);
    rect(140, -2, 10, 4);
    pop();
  }

  // Draw clock hands
  // Second hand
  stroke(255, 0, 0); // Red
  strokeWeight(1); // Line thickness
  line(0, 0, 100 * cos(secondAngle - HALF_PI), 100 * sin(secondAngle - HALF_PI));

  // Minute hand
  stroke(255); // White
  strokeWeight(3); // Line thickness
  line(0, 0, 80 * cos(minuteAngle - HALF_PI), 80 * sin(minuteAngle - HALF_PI));

  // Hour hand
  stroke(255); // White
  strokeWeight(5); // Line thickness
  line(0, 0, 60 * cos(hourAngle - HALF_PI), 60 * sin(hourAngle - HALF_PI));

  // Center point
  noStroke();
  fill(255); // White
  ellipse(0, 0, 10, 10);
}

function mouseWheel(event) {
  let scroll = event.delta; // Get scroll value (negative or positive)
  hourAngle += scroll * (angleVelocity / 12); // Update hour angle
  minuteAngle += scroll * angleVelocity; // Update minute angle
  secondAngle += scroll * (angleVelocity * 60); // Update second angle
  dayNightAngle = hourAngle / 2; // Adjust day-night angle
}
