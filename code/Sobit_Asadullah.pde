// Mandelbrot fractal generator in Processing
float minX = -2.5; // Left boundary of the view window
float maxX = 1.5;  // Right boundary
float minY = -1.5; // Bottom boundary
float maxY = 1.5;  // Top boundary
int maxIterations = 100; // Maximum iterations to determine if a point is in the set
float zoomFactor = 1.02; // Slower zoom factor (2% per zoom)
float zoomLevel = 1.0; // Current zoom level
float offsetX = 0.0; // Offset for panning along X axis
float offsetY = 0.0; // Offset for panning along Y axis

// Zoom threshold to display text
float zoomThreshold = 70; // Zoom threshold to trigger the message

// Timing variables for intro message
long startTime;  // Time when the intro message starts
boolean showIntro = true; // Flag to show the intro message

void setup() {
  size(800, 800);  // Set window size
  noLoop();        // Draw only once initially
  frameRate(30);   // Frame rate for smooth updates
  textSize(32);    // Set font size for the message
  textAlign(CENTER, CENTER); // Center the text on the screen
  
  startTime = millis(); // Store the current time to track intro duration
}

void draw() {
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
    float zoomMinX = minX / zoomLevel + offsetX;
    float zoomMaxX = maxX / zoomLevel + offsetX;
    float zoomMinY = minY / zoomLevel + offsetY;
    float zoomMaxY = maxY / zoomLevel + offsetY;

    loadPixels(); // Prepare for pixel manipulation
    
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        // Map pixel coordinates to complex plane coordinates
        float cRe = map(x, 0, width, zoomMinX, zoomMaxX);
        float cIm = map(y, 0, height, zoomMinY, zoomMaxY);
        float a = cRe;
        float b = cIm;
        int n;

        // Iterate to check if the point escapes the set
        for (n = 0; n < maxIterations; n++) {
          float aa = a * a - b * b;
          float bb = 2 * a * b;
          a = aa + cRe;
          b = bb + cIm;

          // If the point escapes (magnitude greater than 2), stop iterating
          if (a * a + b * b > 16) {
            break;
          }
        }
        
        // Map the number of iterations to a color (grayscale)
        int pixelColor = int(map(n, 0, maxIterations, 0, 255)); // Explicitly cast to int
        pixelColor = (n == maxIterations) ? 0 : pixelColor;  // Points inside the set are black

        // Set pixel color based on the number of iterations
        pixels[x + y * width] = color(pixelColor);
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
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0) {
    zoomLevel *= zoomFactor; // Zoom in (slower zoom)
  } else {
    zoomLevel /= zoomFactor; // Zoom out (slower zoom)
  }
  redraw();  // Redraw the fractal with new zoom level
}

// Pan with arrow keys
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      offsetX -= 0.1;  // Pan left
    } else if (keyCode == RIGHT) {
      offsetX += 0.1;  // Pan right
    } else if (keyCode == UP) {
      offsetY -= 0.1;  // Pan up
    } else if (keyCode == DOWN) {
      offsetY += 0.1;  // Pan down
    }
    redraw();  // Redraw the fractal after panning
  }
}
