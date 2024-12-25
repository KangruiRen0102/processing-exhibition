int[] buildingHeights;  // Array to store building heights
int numBuildings;  // Number of buildings

void setup() {
  size(800, 400);  // Set the size of the canvas
  noStroke();  // No outline for the filled shapes by default
  
  // Initialize the array to store building heights
  numBuildings = width / 100;  // Number of buildings based on width and space
  buildingHeights = new int[numBuildings];
  
  // Set random heights for buildings, but only once, with taller heights
  for (int i = 0; i < numBuildings; i++) {
    buildingHeights[i] = int(random(0.6 * height, 0.9 * height));  // Randomize height between 60% and 90% of canvas height
  }
}

void draw() {
  background(220, 240, 255);  // Set background color to light blue
  
  // Draw the city skyline (this will be drawn every frame)
  drawSkyline();
  
  // Draw the red bridge (between the skyline and the waves)
  drawBridge();
  
  // Draw the waves on top of the bridge and buildings
  drawWaves();
}

// Function to draw the city skyline
void drawSkyline() {
  int buildingWidth = 80;  // Width of each building
  int spaceBetweenBuildings = 100;  // Space between buildings
  
  // Draw buildings in a loop across the canvas
  for (int i = 0; i < numBuildings; i++) {
    // Get the pre-set height for the current building
    int buildingHeight = buildingHeights[i];
    
    // Set building color to a random shade of gray
    fill(50, 20, 100);  // Random gray for buildings
    rect(i * spaceBetweenBuildings, height - buildingHeight, buildingWidth, buildingHeight);  // Draw the building
    
    // Draw windows without outline
    fill(255, 255, 0);  // Yellow for windows
    for (int j = height - buildingHeight + 10; j < height - 10; j += 30) {
      for (int k = i * spaceBetweenBuildings + 10; k < i * spaceBetweenBuildings + buildingWidth - 10; k += 20) {
        rect(k, j, 10, 10);  // Draw a window
      }
    }
  }
}

// Function to draw a red bridge
void drawBridge() {
  fill(255, 0, 0);  // Set the color to red for the bridge
  int bridgeHeight = 50;  // Height of the bridge
  int supportHeight = 250; // Height of the supports
  
  // Set stroke color to red for the bridge outline
  stroke(255, 0, 0);      // Set stroke color to red
  strokeWeight(5);         // Set line thickness for the bridge outline
  
  // Draw the supports (vertical rectangles)
  rect(0, 250, 800, 20);
  rect(275, 80, 5, 170); // Left support
  rect(525, 80, 5, 170); // Right support
  rect(25, 80, 5, 170);  // Left outer support
  rect(775, 80, 5, 170); // Right outer support
  rect(25, 80, 750, 2);  // Top support
  
  // Draw the lines of the bridge with red outline
  line(30, 80, 0, 120);
  line(150, 250, 25, 80);  
  line(275, 80, 150, 250); 
  line(400, 250, 275, 80);
  line(525, 80, 400, 250);
  line(650, 250, 525, 80); 
  line(775, 80, 650, 250); 
  line(800, 120, 775, 80);
  
  // Turn off stroke after drawing the bridge outline
  noStroke();
}

// Function to draw waves
void drawWaves() {
  // First wave - Navy Blue
  fill(0, 0, 128);  // Navy blue color
  beginShape();
  
  // Start from the left edge of the canvas
  vertex(0, height);  // Bottom left corner
  
  // Draw the first wave (navy blue)
  for (float x = 0; x < width; x += 1) {  // Reduced step size for smoother waves
    float waveOffset = mouseX * 0.05;  // Control the wave movement with mouseX
    float y = height / 2 + 75  + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // Add points to the shape based on the sine wave
  }
  
  // End at the right edge of the canvas
  vertex(width, height);  // Bottom right corner
  
  endShape(CLOSE);  // Close the shape and fill it

  // Second wave - Light Blue (opposite direction)
  fill(170, 210, 230);  // Light blue color
  beginShape();
  
  // Start from the left edge of the canvas
  vertex(0, height);  // Bottom left corner
  
  // Draw the second wave (light blue)
  for (float x = 0; x < width; x += 1) {  // Reduced step size for smoother waves
    float waveOffset = mouseX * -0.05;  // Inverse direction for the second wave
    float y = height / 2 + 75 + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // Add points to the shape based on the sine wave
  }
  
  // End at the right edge of the canvas
  vertex(width, height);  // Bottom right corner
  
  endShape(CLOSE);  // Close the shape and fill it
  
  // Third wave - Navy Blue
  fill(0, 0, 130);  // Navy blue color
  beginShape();
  
  // Start from the left edge of the canvas
  vertex(0, height);  // Bottom left corner
  
  // Draw the first wave (navy blue)
  for (float x = 0; x < width; x += 1) {  // Reduced step size for smoother waves
    float waveOffset = mouseX * 0.1;  // Control the wave movement with mouseX
    float y = height / 2 + 100 + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // Add points to the shape based on the sine wave
  }
  
  // End at the right edge of the canvas
  vertex(width, height);  // Bottom right corner
  
  endShape(CLOSE);  // Close the shape and fill it

  // Fourth wave - Light Blue (opposite direction)
  fill(100, 130, 240);  // Light blue color
  beginShape();
  
  // Start from the left edge of the canvas
  vertex(0, height);  // Bottom left corner
  
  // Draw the second wave (light blue)
  for (float x = 0; x < width; x += 1) {  // Reduced step size for smoother waves
    float waveOffset = mouseX * -0.1;  // Inverse direction for the second wave
    float y = height / 2 + 100 + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // Add points to the shape based on the sine wave
  }
  
  // End at the right edge of the canvas
  vertex(width, height);  // Bottom right corner
  
  endShape(CLOSE);  // Close the shape and fill it
}
