int cols, rows;
ArrayList<Integer> gradientColors = new ArrayList<Integer>();  // ArrayList of color integers (using Processing's color type)
float speed = 0.0015;                  // Speed of the gradient movement
float offsetX = 0;                     // Offset for horizontal gradient movement
float offsetY = 0;                     // Offset for vertical gradient movement
float directionX = 1;                  // Default X direction multiplier (East)
float directionY = 0;                  // Default Y direction multiplier (East)

// Initial setup
void setup() {
  size(1200, 800);      // Set canvas size
  cols = width / 20;    // Number of columns (each column is 20px wide)
  rows = height / 20;   // Number of rows (each row is 20px tall)
  
  // Initialize with 6 random colors
  for (int i = 0; i < 6; i++) {
    gradientColors.add(color(random(255), random(255), random(255)));
  }
}

// Main drawing loop
void draw() {
  background(0); // Set background to black
  
  // Create the gradient using the color array
  createGradient();
  
  // Update the gradient's movement
  offsetX += speed * directionX; // Move in the X direction
  offsetY += speed * directionY; // Move in the Y direction
}

// Function to create and display the gradient
void createGradient() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      // Calculate the color at each pixel based on Perlin noise for smooth transition
      float noiseValue = noise(x * 0.1 + offsetX, y * 0.1 + offsetY);
      
      // Interpolate between the colors based on noise
      color c = getGradientColor(noiseValue);
      
      // Set the pixel color
      fill(c);
      noStroke();
      rect(x * 20, y * 20, 20, 20);
    }
  }
}

// Function to get a gradient color based on the Perlin noise value
color getGradientColor(float noiseValue) {
  // Use the noise value to blend between the colors
  int index1 = (int)(noiseValue * gradientColors.size()) % gradientColors.size(); // Pick a base color index
  int index2 = (index1 + 1) % gradientColors.size(); // Pick the next color index
  
  // Interpolate between the two colors based on noise value
  return lerpColor(gradientColors.get(index1), gradientColors.get(index2), noiseValue);
}

// Handle key presses for color changes and gradient controls
void keyPressed() {
  if (key == 'c' || key == 'C') {
    // Change all gradient colors randomly
    for (int i = 0; i < gradientColors.size(); i++) {
      gradientColors.set(i, color(random(255), random(255), random(255)));
    }
  }
  
  // Increase or decrease speed with up/down arrow keys
  if (key == CODED) {
    if (keyCode == UP) {
      speed += 0.0005;  // Increase the speed
    } else if (keyCode == DOWN) {
      speed -= 0.0005;  // Decrease the speed, but keep it above 0
      speed = max(0.0005, speed);  // Ensure minimum speed
    }
  }
  
  // Add a new color when 'a' key is pressed, but only if we have fewer than 5 colors
  if (key == 'a' || key == 'A') {
    if (gradientColors.size() < 5) {
      gradientColors.add(color(random(255), random(255), random(255)));
    }
  }
  
  // Remove a color when 'r' key is pressed, but only if we have more than 2 colors
  if (key == 'r' || key == 'R') {
    if (gradientColors.size() > 2) {
      gradientColors.remove(gradientColors.size() - 1); // Remove the last color
    }
  }

  // Change direction based on compass direction keys (1-8 keys)
  if (key == '1') {
    // North
    directionX = 0;
    directionY = -1;
  } else if (key == '2') {
    // North-East
    directionX = 1;
    directionY = -1;
  } else if (key == '3') {
    // East
    directionX = 1;
    directionY = 0;
  } else if (key == '4') {
    // South-East
    directionX = 1;
    directionY = 1;
  } else if (key == '5') {
    // South
    directionX = 0;
    directionY = 1;
  } else if (key == '6') {
    // South-West
    directionX = -1;
    directionY = 1;
  } else if (key == '7') {
    // West
    directionX = -1;
    directionY = 0;
  } else if (key == '8') {
    // North-West
    directionX = -1;
    directionY = -1;
  }
}
