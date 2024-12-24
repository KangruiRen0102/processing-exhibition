let clockRadius = 100;
let angle = 0;
let rotationSpeed = 0.01;
let numSpirals = 3; // Initial number of spirals
let spiralRotation = 0; // Rotation of the spirals

function setup() {
  createCanvas(800, 800);
  smooth();
}

function draw() {
  background(0);

  // Control clock rotation speed with mouse X position
  rotationSpeed = map(mouseX, 0, width, 0.001, 0.05);

  // Control number of spirals with mouse Y position
  numSpirals = int(map(mouseY, 0, height, 1, 10)); // 1 to 10 spirals

  // Draw the clock at the center of the canvas
  drawClock(width / 2, height / 2, clockRadius, angle);

  // Draw the rotating and expanding color-changing spirals around the clock
  drawRotatingSpirals(width / 2, height / 2, clockRadius);

  // Update the angle to simulate time passing
  angle += rotationSpeed;
  spiralRotation += 0.005; // Slowly rotate the spirals
}

// Function to draw the clock at the specified position
function drawClock(x, y, r, angle) {
  noFill();
  stroke(255);
  strokeWeight(2);

  // Outer circle for clock face
  ellipse(x, y, r * 2, r * 2);

  // Draw the center point
  fill(255);
  noStroke();
  ellipse(x, y, 10, 10); // Clock center

  // Draw the clock hands
  drawClockHands(x, y, r, angle);
}

// Function to draw the moving hands (symbolizing time passing) for the clock
function drawClockHands(x, y, r, angle) {
  let hourAngle = angle * 0.5; // Slow down the rotation for hour hand
  let minuteAngle = angle; // Minute hand rotates faster

  // Hour hand
  stroke(255, 0, 0);
  strokeWeight(4);
  line(x, y, x + cos(hourAngle) * r * 0.5, y + sin(hourAngle) * r * 0.5);

  // Minute hand
  stroke(0, 255, 0);
  strokeWeight(2);
  line(x, y, x + cos(minuteAngle) * r * 0.8, y + sin(minuteAngle) * r * 0.8);

  // Draw the second hand (fastest moving)
  stroke(0, 0, 255);
  strokeWeight(1);
  line(x, y, x + cos(minuteAngle * 1.5) * r * 0.9, y + sin(minuteAngle * 1.5) * r * 0.9);
}

// Function to draw the rotating, expanding, color-changing spirals (symbolizing the infinite journey)
function drawRotatingSpirals(x, y, r) {
  noFill();

  // Loop to draw multiple spirals
  for (let i = 0; i < numSpirals; i++) {
    beginShape();
    for (let t = 0; t < 5 * PI; t += 0.1) {
      // Calculate the spiral's radius and position
      let spiralX = x + cos(t + spiralRotation * i) * (r + t * 5);
      let spiralY = y + sin(t + spiralRotation * i) * (r + t * 5);

      // Calculate the cycling color based on the spiral's position
      let colorCycle = map(t, 0, 5 * PI, 0, 1); // Create a cycle from 0 to 1
      let red = int(sin(colorCycle * TWO_PI) * 127 + 128); // Red channel (cycle)
      let green = int(sin(colorCycle * TWO_PI + PI / 3) * 127 + 128); // Green channel (shifted phase)
      let blue = int(sin(colorCycle * TWO_PI + 2 * PI / 3) * 127 + 128); // Blue channel (shifted phase)

      // Set the color for the spiral
      stroke(red, green, blue, 150); // Smooth color cycling

      vertex(spiralX, spiralY);
    }
    endShape();
  }

  // Optionally, add new spirals over time to show the journey unfolding
  if (frameCount % 60 === 0) {
    numSpirals++; // Add a new spiral every second (60 frames)
  }
}
