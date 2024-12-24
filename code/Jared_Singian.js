let cols, rows;
let gradientColors = []; // Array to hold color values
let speed = 0.0015; // Speed of gradient movement
let offsetX = 0; // Offset for horizontal gradient movement
let offsetY = 0; // Offset for vertical gradient movement
let directionX = 1; // Default X direction multiplier (East)
let directionY = 0; // Default Y direction multiplier (East)

function setup() {
  createCanvas(1200, 800); // Set canvas size
  cols = Math.ceil(width / 20); // Number of columns (each column is 20px wide)
  rows = Math.ceil(height / 20); // Number of rows (each row is 20px tall)

  // Initialize with 6 random colors
  for (let i = 0; i < 6; i++) {
    gradientColors.push(color(random(255), random(255), random(255)));
  }
}

function draw() {
  background(0); // Set background to black

  // Create the gradient using the color array
  createGradient();

  // Update the gradient's movement
  offsetX += speed * directionX; // Move in the X direction
  offsetY += speed * directionY; // Move in the Y direction
}

// Function to create and display the gradient
function createGradient() {
  for (let y = 0; y < rows; y++) {
    for (let x = 0; x < cols; x++) {
      // Calculate the color at each pixel based on Perlin noise for smooth transition
      let noiseValue = noise(x * 0.1 + offsetX, y * 0.1 + offsetY);

      // Interpolate between the colors based on noise
      let c = getGradientColor(noiseValue);

      // Set the pixel color
      fill(c);
      noStroke();
      rect(x * 20, y * 20, 20, 20);
    }
  }
}

// Function to get a gradient color based on the Perlin noise value
function getGradientColor(noiseValue) {
  // Use the noise value to blend between the colors
  let index1 = Math.floor(noiseValue * gradientColors.length) % gradientColors.length; // Pick a base color index
  let index2 = (index1 + 1) % gradientColors.length; // Pick the next color index

  // Interpolate between the two colors based on noise value
  return lerpColor(gradientColors[index1], gradientColors[index2], noiseValue);
}

// Handle key presses for color changes and gradient controls
function keyPressed() {
  if (key === 'c' || key === 'C') {
    // Change all gradient colors randomly
    for (let i = 0; i < gradientColors.length; i++) {
      gradientColors[i] = color(random(255), random(255), random(255));
    }
  }

  // Increase or decrease speed with up/down arrow keys
  if (keyCode === UP_ARROW) {
    speed += 0.0005; // Increase the speed
  } else if (keyCode === DOWN_ARROW) {
    speed = max(0.0005, speed - 0.0005); // Decrease the speed, but keep it above 0
  }

  // Add a new color when 'a' key is pressed, but only if we have fewer than 10 colors
  if (key === 'a' || key === 'A') {
    if (gradientColors.length < 10) {
      gradientColors.push(color(random(255), random(255), random(255)));
    }
  }

  // Remove a color when 'r' key is pressed, but only if we have more than 2 colors
  if (key === 'r' || key === 'R') {
    if (gradientColors.length > 2) {
      gradientColors.pop(); // Remove the last color
    }
  }

  // Change direction based on compass direction keys (1-8 keys)
  switch (key) {
    case '1': // North
      directionX = 0;
      directionY = -1;
      break;
    case '2': // North-East
      directionX = 1;
      directionY = -1;
      break;
    case '3': // East
      directionX = 1;
      directionY = 0;
      break;
    case '4': // South-East
      directionX = 1;
      directionY = 1;
      break;
    case '5': // South
      directionX = 0;
      directionY = 1;
      break;
    case '6': // South-West
      directionX = -1;
      directionY = 1;
      break;
    case '7': // West
      directionX = -1;
      directionY = 0;
      break;
    case '8': // North-West
      directionX = -1;
      directionY = -1;
      break;
  }
}
