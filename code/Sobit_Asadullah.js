let minX = -2.5; // Left boundary of the view window
let maxX = 1.5;  // Right boundary
let minY = -1.5; // Bottom boundary
let maxY = 1.5;  // Top boundary
let maxIterations = 100; // Maximum iterations to determine if a point is in the set
let zoomFactor = 1.02; // Slower zoom factor (2% per zoom)
let zoomLevel = 1.0; // Current zoom level
let offsetX = 0.0; // Offset for panning along X axis
let offsetY = 0.0; // Offset for panning along Y axis

// Zoom threshold to display text
let zoomThreshold = 70; // Zoom threshold to trigger the message

// Timing variables for intro message
let startTime;  // Time when the intro message starts
let showIntro = true; // Flag to show the intro message

function setup() {
  createCanvas(800, 800); // Set canvas size
  noLoop();        // Draw only once initially
  frameRate(30);   // Frame rate for smooth updates
  textSize(32);    // Set font size for the message
  textAlign(CENTER, CENTER); // Center the text on the screen

  startTime = millis(); // Store the current time to track intro duration
}

function draw() {
  background(0);  // Set background to black

  // If the intro message is being shown (for the first 4 seconds)
  if (showIntro) {
    fill(255); // Set text color to white
    text("Eye to eye with the infinite", width / 2, height / 2); // Display the intro message

    // Check if 4 seconds have passed
    if (millis() - startTime > 3000) {
      showIntro = false;  // Hide the intro message after 4 seconds
    }
  } else {
    // Adjust the complex plane view for the current zoom level and offsets
    let zoomMinX = minX / zoomLevel + offsetX;
    let zoomMaxX = maxX / zoomLevel + offsetX;
    let zoomMinY = minY / zoomLevel + offsetY;
    let zoomMaxY = maxY / zoomLevel + offsetY;

    loadPixels(); // Prepare for pixel manipulation

    for (let x = 0; x < width; x++) {
      for (let y = 0; y < height; y++) {
        // Map pixel coordinates to complex plane coordinates
        let cRe = map(x, 0, width, zoomMinX, zoomMaxX);
        let cIm = map(y, 0, height, zoomMinY, zoomMaxY);
        let a = cRe;
        let b = cIm;
        let n;

        // Iterate to check if the point escapes the set
        for (n = 0; n < maxIterations; n++) {
          let aa = a * a - b * b;
          let bb = 2 * a * b;
          a = aa + cRe;
          b = bb + cIm;

          // If the point escapes (magnitude greater than 2), stop iterating
          if (a * a + b * b > 16) {
            break;
          }
        }

        // Map the number of iterations to a color (grayscale)
        let pixelColor = map(n, 0, maxIterations, 0, 255); 
        pixelColor = (n === maxIterations) ? 0 : pixelColor;  // Points inside the set are black

        // Set pixel color based on the number of iterations
        let index = (x + y * width) * 4;
        pixels[index] = pixelColor; // Red channel
        pixels[index + 1] = pixelColor; // Green channel
        pixels[index + 2] = pixelColor; // Blue channel
        pixels[index + 3] = 255; // Alpha channel
      }
    }

    updatePixels();  // Apply the pixel changes to the screen

    // If the zoom level is beyond the threshold, display the message
    if (zoomLevel > zoomThreshold) {
      fill(255); // Set text color to white
      text("The only way out is through", width / 2, height / 2); // Display the message
    }
  }
}

// Zoom in/out with mouse wheel
function mouseWheel(event) {
  if (event.delta < 0) {
    zoomLevel *= zoomFactor; // Zoom in (slower zoom)
  } else {
    zoomLevel /= zoomFactor; // Zoom out (slower zoom)
  }
  redraw();  // Redraw the fractal with new zoom level
}

// Pan with arrow keys
function keyPressed() {
  if (keyCode === LEFT_ARROW) {
    offsetX -= 0.1;  // Pan left
  } else if (keyCode === RIGHT_ARROW) {
    offsetX += 0.1;  // Pan right
  } else if (keyCode === UP_ARROW) {
    offsetY -= 0.1;  // Pan up
  } else if (keyCode === DOWN_ARROW) {
    offsetY += 0.1;  // Pan down
  }
  redraw();  // Redraw the fractal after panning
}