let orbitalX = 0; // Horizontal position of the orbital
let orbitalY;     // Vertical position of the orbital
let orbitalSize;  // Size of the orbital
let auroraStart, auroraEnd;
let transformationMode = 1; // Transformation effect mode

function setup() {
  createCanvas(800, 600);
  orbitalY = height / 2;      // Sets the orbital's initial position
  orbitalSize = 30;           // Set the orbital initial size
  auroraStart = color(10, 50, 150);
  auroraEnd = color(100, 200, 255);
  noStroke();
}

function draw() {
  drawAurora();          // Aurora background
  drawJourney();         // Moving orbital
  applyMetamorphosis();  // Transformation of the orbital/metamorphosis :)
}

function drawAurora() {
  // Create flowing gradient for aurora
  for (let y = 0; y < height; y += 5) {
    let noiseOffset = map(noise(y * 0.01, frameCount * 0.01), 0, 1, -50, 50);
    fill(lerpColor(auroraStart, auroraEnd, map(y, 0, height, 0, 1)));
    rect(0, y + noiseOffset, width, 5);
  }
}

function drawJourney() {
  // Draw the moving orbital as it goes along the gradient
  fill(255, 200, 100);  // Orbital's color
  ellipse(orbitalX, orbitalY, orbitalSize, orbitalSize); // Orbital position and size during its journey
  orbitalX += 2; // Move the orbital horizontally
  if (orbitalX > width) orbitalX = 0; // Loop back to the start when reaching the edge
}

function applyMetamorphosis() {
  // Transformations based on the mode
  if (transformationMode === 1) {
    // Size pulsation
    orbitalSize = 20 + 10 * sin(frameCount * 0.05);
    fill(255, 150, 150 + 100 * sin(frameCount * 0.1));
    ellipse(orbitalX, orbitalY, orbitalSize, orbitalSize);
  } else if (transformationMode === 2) {
    // Rotating trail effect
    for (let i = 0; i < 10; i++) {
      let angle = radians(i * 36 + frameCount);
      let trailX = orbitalX + cos(angle) * 20;
      let trailY = orbitalY + sin(angle) * 20;
      fill(255, 150, 150, 100 - i * 10);
      ellipse(trailX, trailY, 15, 15);
    }
  } else if (transformationMode === 3) {
    // Ripple effect
    for (let i = 0; i < 5; i++) {
      let rippleSize = orbitalSize + i * 10;
      fill(255, 255, 150, 150 - i * 30);
      ellipse(orbitalX, orbitalY, rippleSize, rippleSize);
    }
  }
}

function keyPressed() {
  // Switch transformation modes
  if (key === '1') transformationMode = 1;
  if (key === '2') transformationMode = 2;
  if (key === '3') transformationMode = 3;
}
