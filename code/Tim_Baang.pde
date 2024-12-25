int buildingCount = 1;  // Start with 1 building
int peopleCount = 3;    // Start with 3 people
int skyState = 0; // 0 = Day, 1 = Dusk, 2 = Dawn, 3 = Twilight, 4 = Night
int clickCounter = 0; // A counter to track mouse clicks

void setup() {
  size(800, 400); // Set canvas size to 800 pixels wide and 400 pixels high
  noLoop(); // Disable continuous looping; the screen redraws only when requested
}

void draw() {
  // Main function to draw the scene
  drawSky();       // Draw the background sky with gradient and details
  drawBuildings(); // Draw buildings based on the current building count
  drawPeople();    // Draw people on the ground
  drawGround();    // Draw the ground at the bottom of the canvas
}

void drawSky() {
  // Render the sky with a gradient and additional details based on skyState
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1); // Map the y-coordinate to an interpolation value
    color c = color(0); // Default sky color initialization

    // Set the gradient colors based on the current skyState
    if (skyState == 0) {
      c = lerpColor(color(135, 206, 235), color(25, 25, 112), inter); // Day: Light blue to dark blue
    } else if (skyState == 1) {
      c = lerpColor(color(255, 140, 0), color(75, 0, 130), inter); // Dusk: Orange to indigo
    } else if (skyState == 2) {
      c = lerpColor(color(255, 223, 186), color(255, 69, 0), inter); // Dawn: Peach to deep orange
    } else if (skyState == 3) {
      c = lerpColor(color(72, 61, 139), color(25, 25, 112), inter); // Twilight: Purple to dark blue
    } else if (skyState == 4) {
      c = lerpColor(color(0, 0, 0), color(25, 25, 112), inter); // Night: Black to dark blue
    }

    stroke(c); // Set the stroke color for the line
    line(0, y, width, y); // Draw a horizontal line to create the gradient effect
  }

  // Add additional sky details based on the time of day
  if (skyState == 1 || skyState == 3 || skyState == 4) {
    drawStars(); // Draw stars for darker skies
  } else {
    drawClouds(); // Draw clouds for brighter skies
  }
}

void drawStars() {
  // Draw stars for darker sky states
  for (int i = 0; i < 100; i++) { // Randomly generate 100 stars
    float x = random(width); // Random x-coordinate
    float y = random(height); // Random y-coordinate
    float size = random(1, 3); // Random size of stars
    fill(255, 255, 255, 150); // White stars with slight transparency
    noStroke(); // No border for stars
    ellipse(x, y, size, size); // Draw the star as a small circle
  }
}

void drawClouds() {
  // Draw clouds for daytime or brighter sky states
  fill(255, 255, 255, 180); // White clouds with slight transparency
  noStroke(); // No border for clouds
  
  int cloudCount = int(random(7, 15)); // Randomly generate 7 to 15 clouds
  for (int i = 0; i < cloudCount; i++) {
    float cloudX = random(width); // Random horizontal position
    float cloudY = random(height / 2); // Random vertical position in the upper half
    float cloudWidth = random(100, 250); // Random cloud width
    float cloudHeight = random(50, 120); // Random cloud height

    // Create a cloud shape using multiple overlapping ellipses
    for (int j = 0; j < 6; j++) {
      float puffX = cloudX + random(-cloudWidth / 2, cloudWidth / 2); // Offset for cloud puff
      float puffY = cloudY + random(-cloudHeight / 2, cloudHeight / 2); 
      ellipse(puffX, puffY, random(40, 80), random(40, 80)); // Draw the cloud puff
    }
  }
}

void drawBuildings() {
  fill(0); // Set building color to black
  noStroke(); // No border for buildings

  // Loop to draw buildings based on the building count
  for (int i = 0; i < buildingCount; i++) {
    int buildingWidth = int(random(50, 100)); // Random width for each building
    int buildingHeight = int(random(150, 300)); // Random height for each building
    int x = int(random(width / 2, width - buildingWidth)); // Position buildings on the right side
    rect(x, height - buildingHeight, buildingWidth, buildingHeight); // Draw the building as a rectangle
  }
}

void drawPeople() {
  fill(0); // Set people color to black

  // Loop to draw people based on the people count
  for (int i = 0; i < peopleCount; i++) {
    float x = random(50, width / 2 - 50); // Random x-position for people on the left side
    float bodyHeight = 40; // Height of the body
    float bodyWidth = 10; // Width of the body
    float headSize = 15; // Diameter of the head

    float groundY = height - 20; // Fixed ground level for positioning

    rect(x - bodyWidth / 2, groundY - bodyHeight, bodyWidth, bodyHeight); // Draw the body
    ellipse(x, groundY - bodyHeight - headSize / 2, headSize, headSize); // Draw the head
  }
}

void drawGround() {
  strokeWeight(50); // Set thickness of the ground line
  stroke(0); // Set ground color to black
  line(0, height - 20, width, height - 20); // Draw the ground as a thick line
}

void mousePressed() {
  // Respond to mouse clicks to update the scene

  skyState = (skyState + 1) % 5; // Cycle through sky states
  peopleCount = min(peopleCount + 1, 10); // Increment people count, capped at 10

  clickCounter++; // Track number of clicks
  if (clickCounter % 3 == 0) { // Every third click
    buildingCount = min(buildingCount + 1, 20); // Increment building count, capped at 20
  }

  redraw(); // Redraw the scene with updated parameters
}
