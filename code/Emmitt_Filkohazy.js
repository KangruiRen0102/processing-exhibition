let angle = 0; // Angle for rotation (used for orbiting animations)
let noiseOffset = 0; // Offset value for Perlin noise to create smooth animations for the northern lights

function setup() {
  createCanvas(800, 800); // Set the size of the canvas (width=800 pixels, height=800 pixels)
  noStroke(); // Disable stroke outlines for shapes
}

function draw() {
  background(0); // Set the background color to black (0 = black)

  // Generate a smooth gradient using Perlin noise for the northern lights effect
  for (let i = 0; i < width; i += 10) { // Iterate through the canvas in a grid of 10x10 pixels
    for (let j = 0; j < height; j += 10) {
      let distance = dist(mouseX, mouseY, i, j); // Calculate the distance between the mouse and the current grid point
      let noiseValue = noise(i * 0.01, j * 0.01, noiseOffset); // Generate Perlin noise value for smooth gradients

      // Map noise values to RGB color components for aurora colors
      let r = map(noiseValue, 0, 1, 50, 100); // Subtle pinks and purples
      let g = map(noiseValue, 0, 1, 100, 255); // Vibrant greens
      let b = map(noiseValue, 0, 1, 150, 255); // Cool blues and purples

      // Adjust the brightness of the aurora colors based on distance from the mouse position
      let brightness = map(distance, 0, width / 2, 255, 50);
      fill(r * brightness / 255, g * brightness / 255, b * brightness / 255);

      rect(i, j, 10, 10); // Draw a small rectangle at the current grid position
    }
  }

  // Increment the noise offset for smooth animation
  noiseOffset += 0.01;

  // Draw twinkling stars randomly across the background
  for (let i = 0; i < 100; i++) {
    fill(255, random(100, 255)); // Randomize the brightness of the stars
    ellipse(random(width), random(height), random(1, 3), random(1, 3)); // Draw stars with random positions and sizes
  }

  translate(width / 2, height / 2); // Move the origin to the center of the canvas

  // Draw the sun orbiting with a realistic gradient
  let sunX = 150 * cos(angle); // Calculate the X position of the sun based on the angle
  let sunY = 150 * sin(angle); // Calculate the Y position of the sun based on the angle
  drawSun(sunX, sunY); // Call the method to draw the sun

  // Draw the moon orbiting with realistic shading
  let moonX = -150 * cos(angle); // Calculate the X position of the moon (opposite direction of the sun)
  let moonY = -150 * sin(angle); // Calculate the Y position of the moon (opposite direction of the sun)
  drawMoon(moonX, moonY); // Call the method to draw the moon

  // Increment the angle for continuous rotation
  angle += 0.02; // Adjust this value to change the rotation speed
}

// Function to create the sun with a radial gradient
function drawSun(x, y) {
  for (let r = 100; r > 0; r -= 5) { // Create concentric circles for the gradient
    let alpha = map(r, 100, 0, 50, 255); // Gradually fade the outer layers
    fill(255, 200, 50, alpha); // Set the fill color for each layer of the sun
    ellipse(x, y, r * 2, r * 2); // Draw each layer as a circle
  }
}

// Function to create the moon with a radial gradient and craters
function drawMoon(x, y) {
  for (let r = 35; r > 0; r--) { // Create concentric circles for the moon's gradient
    let brightness = map(r, 35, 0, 150, 255); // Gradually brighten the inner layers
    fill(brightness); // Set the fill color for each layer of the moon
    ellipse(x, y, r * 2, r * 2); // Draw each layer as a circle
  }

  // Add craters to the moon with subtle shadows
  fill(120); // Set the color for the craters
  ellipse(x + 10, y + 8, 8, 8); // Draw a small crater
  ellipse(x - 12, y - 10, 15, 15); // Draw a medium crater
  ellipse(x - 4, y + 15, 5, 5); // Draw a tiny crater
}
