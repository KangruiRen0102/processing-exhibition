int numShapes = 50;
float[] xPos = new float[numShapes];
float[] yPos = new float[numShapes];
float[] sizes = new float[numShapes];
float[] maxSizes = new float[numShapes]; // Array to store each flower's max size
color[] bloomColors = new color[numShapes]; // Initial random colors for each flower
boolean blooming = false; // Track whether blooming is active

// Aurora parameters
float auroraOffset = 0.5;  // Control the horizontal movement of the aurora
color auroraColor;  // Variable to hold the current aurora color

// Ocean wave parameters
boolean addWaves = false;  // Control if waves are active
float waveOffset = 0;  // Offset to animate waves

void setup() {
  size(600, 600);
  noStroke();  // Remove outlines globally
  for (int i = 0; i < numShapes; i++) {
    // Set initial positions randomly within the bottom half of the screen
    xPos[i] = random(width);
    yPos[i] = random(height / 2, height); // Only in the bottom half
    sizes[i] = random(2, 8);  // Initial flower size range
    maxSizes[i] = random(15, 20); // Max flower size range
    
    // Assign random flower colors from the defined set
    bloomColors[i] = randomFlowerColor(); // Set a random color for each flower
  }

  // Set initial aurora color to green
  auroraColor = color(34, 139, 34); // Forest Green for aurora
}

void draw() {
  background(0); // Set the background to black

  // Draw the ocean
  drawOcean();

  // Draw the aurora
  drawAurora();

  // Draw the green hill in the background
  drawHill();

  for (int i = 0; i < numShapes; i++) {
    // If blooming is active, expand the size of shapes gradually, but stop at each shape's unique max size
    if (blooming) {
      sizes[i] += 0.5; // Growth happens as the shapes expand
      if (sizes[i] > maxSizes[i]) {
        sizes[i] = maxSizes[i]; // Limit size to each shape's max size
      }
    }

    // Only draw shapes that are below the hill
    if (yPos[i] >= hillY(xPos[i])) {
      // Draw the blooming flower shape with its respective colors (without color changing)
      drawFlower(xPos[i], yPos[i], sizes[i], bloomColors[i]);
    }
  }
}

// Function to draw the Aurora Borealis
void drawAurora() {
  float alpha = 100; // Transparency for the aurora
  noFill();
  strokeWeight(10); // Increase stroke weight to make the aurora thicker
  stroke(auroraColor, alpha); // Use the current aurora color

  // Draw multiple slightly offset waves to make the aurora thicker
  for (int i = 0; i < 3; i++) {
    float offsetY = i * 20; // Slight vertical offset for each wave to create thickness
    beginShape();
    for (float x = 0; x <= width; x++) {
      // Generate a smooth sine wave for the aurora
      float y = (height * 0.2) + 100 * sin(TWO_PI * (x + auroraOffset) / width) + offsetY; // Smooth sine wave movement with vertical offset
      vertex(x, y);
    }
    endShape();
  }

  auroraOffset += 0.5; // Aurora movement speed
}

// Function to draw a green hill in the background
void drawHill() {
  noStroke();  // Remove the stroke for the hill

  fill(34, 139, 34); // Green color for the hill (forest green)
  beginShape();
  vertex(0, height); // Start at the bottom left corner
  
  // Create a sine wave that spans twice the width of the canvas
  for (float x = 0; x <= width; x++) { // Loop through the entire width of the canvas
    // Stretch the hill
    float y = height - 300 * sin(TWO_PI * x / (2*width)); // Stretch hill
    vertex(x, y);
  }
  
  vertex(width, height); // End at the bottom right corner
  endShape(CLOSE);
}

// Function to get the y-position of the hill at a given x-coordinate
float hillY(float x) {
  // The hill is defined by the sine wave, and we use the same calculation as in the drawing function
  return height - 300 * sin(TWO_PI * x / (2*width));
}

// Function to draw a flower shape at the given position
void drawFlower(float x, float y, float size, color c) {
  int numPetals = 6; // Number of petals for the flower
  float petalAngle = TWO_PI / numPetals; // Angle between each petal
  float petalLength = size; // Length of each petal
  
  noStroke(); // Remove the stroke for the flower
  
  fill(c); // Set the color for the flower
  
  // Draw the flower shape (circle of petals)
  for (int i = 0; i < numPetals; i++) {
    float angle = i * petalAngle;
    float petalX = x + cos(angle) * petalLength;
    float petalY = y + sin(angle) * petalLength;
    
    ellipse(petalX, petalY, size, size); // Draw each petal
  }
  
  // Draw the center of the flower
  fill(255, 255, 0); // Yellow color for the center
  ellipse(x, y, size * 0.4, size * 0.4); // Center circle
}

// Function to draw the ocean to the right of the hill
void drawOcean() {
  fill(0, 0, 255); // Blue color for the ocean (ocean blue)
  noStroke();
  
  // Draw the ocean as a rectangle spanning the right side of the canvas
  if (addWaves) {
    // Add waves to the ocean using a sine wave pattern
    for (float x = 0; x <= width; x++) {
      float waveHeight = 5 * sin(8 * TWO_PI * (x + waveOffset) / width);
      rect(x, height * 0.75 + waveHeight, 1, height * 0.25); // Draw the wave on the ocean
    }
    waveOffset += 2;  // Speed of wave movement
  } else {
    rect(0, height * 0.75, width, height * 0.25); // Ocean without waves, simple rectangle
  }
}

// Function to return a random flower color from the defined palette
color randomFlowerColor() {
  int randomColor = int(random(4)); // Random number between 0 and 3
  switch(randomColor) {
    case 0: return color(186, 85, 211); // Medium Orchid
    case 1: return color(128, 0, 128); // Purple
    case 2: return color(138, 43, 226); // Blue-Violet
    case 3: return color(223, 115, 255); // Heliotrope
    default: return color(186, 85, 211); // Default to Medium Orchid
  }
}

// Detect key press to start blooming, change aurora color, toggle waves
void keyPressed() {
  if (key == 'b' || key == 'B') {  // 'B' key to start blooming
    blooming = true; // Start blooming effect when 'B' key is pressed
  } else if (key == 'r' || key == 'R') {  // 'R' key to reset blooming
    blooming = false; // Stop blooming effect when 'R' key is pressed
    // Optionally reset sizes or stop them from growing
    for (int i = 0; i < numShapes; i++) {
      sizes[i] = random(2, 8); // Reset sizes back to an even smaller random range
    }
  } else if (key == 'n' || key == 'N') {  // 'N' key to change aurora color
    // Randomly change the color of the aurora
    auroraColor = color(random(100, 255), random(100, 255), random(100, 255)); // Random color for aurora
  } else if (key == 'v' || key == 'V') {  // 'V' key to toggle waves visibility
    addWaves = !addWaves; // Toggle waves visibility
  }
}
