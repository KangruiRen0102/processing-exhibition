let wave = 6; // Number of waves
let offsets = []; // Array for wave offsets
let waveColours; // Array for wave colors

function setup() {
  createCanvas(800, 600); // Canvas size
  waveColours = [
    color(50, 200, 255, 100),   // Light blue
    color(100, 255, 150, 120),  // Light green
    color(200, 25, 255, 80),    // Purple
    color(255, 100, 200, 120)   // Pink
  ];

  // Randomize initial phase offsets
  for (let j = 0; j < wave; j++) {
    offsets.push(random(TWO_PI));
  }
}

function draw() {
  background(10, 15, 50); // Night sky background

  push(); // Save transformation state
  translate(width / 2, height / 2); // Center origin
  rotate(PI); // Rotate canvas
  translate(-width / 2, -height / 2); // Restore origin to top-left

  // Draw each wave
  for (let j = 0; j < wave; j++) {
    drawWave(j, waveColours[j % waveColours.length]);
    offsets[j] += 0.2; // Increment wave offset
  }

  // Draw stars
  drawStars(100);

  pop(); // Restore transformation state
}

// Draws a single wave
function drawWave(index, waveColour) {
  let waveHeight = height / 4.0; // Max wave height
  let wavePosY = height / 2.0 + index * 30; // Vertical position of wave
  let waveSpeed = 0.5 + index * 0.1; // Animation speed

  noStroke();
  fill(waveColour);

  beginShape();
  for (let x = 0; x <= width; x += 10) {
    let y = wavePosY + sin((x + offsets[index]) * 0.02) * waveHeight * noise(x * 0.01, frameCount * 0.005);
    vertex(x, y); // Add vertex for wave
  }
  vertex(width, height); // Bottom-right corner
  vertex(0, height); // Bottom-left corner
  endShape(CLOSE); // Close and fill wave shape
}

// Draws stars
function drawStars(count) {
  for (let j = 0; j < count; j++) {
    let x = random(width); // Random x-position
    let y = random(height); // Random y-position
    let brightness = random(100, 255); // Random brightness
    noStroke();
    fill(brightness, brightness, brightness, 150); // Star color with transparency
    ellipse(x, y, random(1, 3), random(1, 3)); // Small circle for star
  }
}
