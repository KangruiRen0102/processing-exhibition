let x = 450; // Initial x-position of the lines
let y = 420;
let angle = 0; // Stores the current angle of rotation
let dia = 22; // Initial diameter of the shape
let changeSpeed = 0.7; // Controls how fast the diameter changes based on mouse position
let isRed = true; // Tracks if the line color is red or blue
let reverseRotation = false; // Determines if rotation is reversed
let bgColor; // Background color
let lastClickTime = 0; // Differentiate between a single and double click
let doubleClickThreshold = 500; // Limit for double click

function setup() {
  createCanvas(960, 1080); // Canvas size
  bgColor = color(255); // Initial background color set to white
}

function draw() {
  background(bgColor); // Sets up the background color
  
  let distFromCenter = dist(mouseX, mouseY, width / 2, height / 2);

  // Adjust the speed based on the distance from the center
  if (distFromCenter < 120) {
    changeSpeed = 0.015; // Slower change when close to the center
  } else {
    changeSpeed = 0.12; // Faster change when further from the center
  }

  mouseX = constrain(mouseX, 30, width); // Changed lower limit of mouseX
  dia = lerp(dia, mouseX, changeSpeed); // Lerp syntax allows for smoother change

  translate(width / 2, height / 2); // Origin moves to center of canvas
  if (reverseRotation) {
    rotate(radians(angle / 2)); // When statement is true, direction reverses
  } else {
    rotate(-radians(angle / 2)); // Direction of rotation stays the same
  }

  // Drawing the ellipses and rotating lines
  for (let a = 0; a < 360; a += dia / 3) {
    push();
    rotate(radians(a)); // Each shape rotates by an increment

    // Setting up the line color based on `isRed` from previous steps
    stroke(isRed ? color(255, 0, 0) : color(0, 0, 255)); // Toggles the line between red and blue
    strokeWeight(dia / 4); // Stroke weight is set based on the diameter
    line(0, y * sin(radians(a + angle)), x - dia / 3, 0); // Draws the line for the center
    line(width, y * sin(radians(a + angle)), x + dia / 3, 0); // Draws line to the right side

    noStroke(); // Disables the stroke
    fill(0); // Fill color to black
    ellipse(0, y * sin(radians(a + angle)), dia / 2, dia / 2); // Small ellipses at endpoint of each line

    stroke(0); // Stroke color back to black
    if (y <= y * sin(radians(a + angle)) + dia / 4) fill(0); // Condition slightly adjusted
    else noFill(); // If condition is not met, then no fill
    ellipse(0, y, dia, dia); // Ellipses at the center
    pop(); // Restores the previous transformation
  }
  angle++; // Increases the angle for rotation animation
}

function mousePressed() {
  let currentTime = millis(); // Current time in milliseconds

  if (currentTime - lastClickTime < doubleClickThreshold) {
    // If time between clicks is less than the threshold, it's a double click
    reverseRotation = !reverseRotation; // Toggle rotation direction
    bgColor = (bgColor === color(255)) ? color(255, 255, 0) : color(255); // Background color between white and yellow
  } else {
    // Single click detection
    isRed = !isRed; // Toggle between red and blue for line color
  }

  lastClickTime = currentTime; // Updates the time of the last click
}
