float waterLevel = 0; // Initial water level
float cupHeight = 200; // The height of the mug
float cupWidth = 120; // Width of the mug
float mugX = 500; // X position of the mug (center of the canvas)
float mugY = 700; // Y position of the mug
int rainDropCount = 100; // Number of raindrops
Raindrop[] rainDrops = new Raindrop[rainDropCount]; // Array for raindrops
boolean rainActive = true; // Flag for rain
boolean grassGrowing = false; // Flag to check if the grass is growing
ArrayList<Grass> grassList = new ArrayList<Grass>(); // List to hold the growing grass
boolean waterFilling = true; // Flag to control water filling (true means filling, false means stopped)

// To store the elapsed time in milliseconds
int startTime;
boolean timerStarted = false;

// Position and size for the sun
float sunX = 800;
float sunY = 200;
float sunRadius = 80;

// Cloud position
float cloudX = 500;
float cloudY = 200;
float cloudWidth = 400;
float cloudHeight = 150;

void setup() {
  size(1000, 1000); // Set the size of the window
  // Initialize raindrops
  for (int i = 0; i < rainDropCount; i++) {
    rainDrops[i] = new Raindrop(random(cloudX - cloudWidth / 2, cloudX + cloudWidth / 2), random(cloudY - cloudHeight / 2, cloudY - cloudHeight / 4)); // Rain starts from the cloud area
  }
  startTime = millis(); // Record the starting time when the program begins
}

void draw() {
  // Stormy background with dark skies and rain if rain is active
  if (rainActive) {
    drawStormySky();
    drawCloud(cloudX, cloudY, cloudWidth, cloudHeight);
    drawRain();
  } else {
    // Once space is pressed, clear clouds and show sun and grass
    drawSunnySky();
    drawGround();
    drawSun();
  }

  // Draw the mug
  drawMug(mugX, mugY);

  // Fill the mug with rainwater at a slow, uniform rate (only if water is still filling)
  if (waterFilling) {
    fillWater();
  }

  // If the grass is growing, animate the growth process
  if (grassGrowing) {
    growGrass();
  }

  // Display instructions (only visible until space is pressed)
  if (rainActive) {
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Press 'space' before the cup fills up", width / 2, 50);
  }

  // Display the digital clock in the top left corner
  displayDigitalClock();
}

// Function to draw the stormy sky with dark clouds and rain if rain is active
void drawStormySky() {
  background(50, 50, 50); // Dark grey background (stormy sky)
}

// Function to draw the cloud
void drawCloud(float x, float y, float w, float h) {
  fill(80, 80, 80); // Darker clouds
  noStroke();
  ellipse(x, y, w, h); // Main cloud body
  ellipse(x - w / 4, y + h / 4, w * 0.7, h * 0.6); // Left cloud puff
  ellipse(x + w / 4, y + h / 4, w * 0.7, h * 0.6); // Right cloud puff
}

// Function to draw the sunny sky after space is pressed
void drawSunnySky() {
  background(135, 206, 235); // Light blue sky
}

// Function to draw the ground beneath the cup (grey ground)
void drawGround() {
  fill(169, 169, 169); // Gray color for the ground
  noStroke();
  rect(0, height * 2 / 3, width, height / 3); // Draw a grey ground below the cup
}

// Function to draw the sun in the sky
void drawSun() {
  fill(255, 204, 0); // Yellow color for the sun
  noStroke();
  ellipse(sunX, sunY, sunRadius * 2, sunRadius * 2); // Draw the sun
}

// Function to draw the mug (with a more realistic design)
void drawMug(float x, float y) {
  // Draw the cup body with gradient for realism
  for (int i = 0; i < cupHeight; i++) {
    int c = lerpColor(color(255, 255, 255), color(150, 150, 150), map(i, 0, cupHeight, 0, 1));
    stroke(c);
    line(x - cupWidth / 2, y - cupHeight + i, x + cupWidth / 2, y - cupHeight + i); // Draw vertical lines for gradient effect
  }
  
  // Draw the bottom of the cup (slightly darker for 3D effect)
  fill(150, 150, 150);
  noStroke();
  ellipse(x, y - cupHeight + 5, cupWidth, 20); // Bottom ellipse for the cup
}

// Function to fill the mug with rainwater at a slow, uniform rate
void fillWater() {
  if (waterLevel < cupHeight) {
    // Set a more realistic water color (light blue, semi-transparent)
    fill(173, 216, 230, 200); // Light blue color for the water with transparency
    noStroke();
    
    // Slow down the water filling into the cup at a uniform rate
    waterLevel += 0.1; // Increase the water level at a slow, uniform rate
    
    // Draw the water inside the mug
    rect(mugX - cupWidth / 2, mugY - cupHeight + cupHeight - waterLevel, cupWidth, waterLevel); // Water inside the mug
  }
}

// Function to draw rain falling from the cloud
void drawRain() {
  fill(0, 0, 255); // Blue color for raindrops
  noStroke();
  
  // Loop through the raindrops
  for (int i = 0; i < rainDropCount; i++) {
    rainDrops[i].fall(); // Make the raindrop fall
    rainDrops[i].display(); // Draw the raindrop
  }
}

// Raindrop class
class Raindrop {
  float x, y; // Position of the raindrop
  float speed = random(1, 3); // Speed of the raindrop
  
  // Constructor to initialize raindrop's position
  Raindrop(float startX, float startY) {
    x = startX;
    y = startY;
  }
  
  // Function to make the raindrop fall
  void fall() {
    y += speed; // Raindrop falls at its speed
    if (y > mugY - cupHeight) { // If raindrop reaches the mug
      waterLevel += 0.1; // Increase the water level in the mug at a slow rate
      if (waterLevel >= cupHeight) {
        waterLevel = cupHeight; // Cap the water at the top of the mug
      }
    }
    if (y > height) { // If the raindrop goes off the screen
      y = random(cloudY - cloudHeight / 2, cloudY - cloudHeight / 4); // Reset the raindrop's position from the cloud area
    }
  }
  
  // Function to display the raindrop
  void display() {
    ellipse(x, y, 5, 10); // Draw the raindrop
  }
}

// Handle the spacebar press to stop rain and start growing grass
void keyPressed() {
  if (key == ' ') { // Check if the space bar is pressed
    rainActive = false; // Stop the rain
    waterFilling = false; // Stop the water from filling the cup
    grassGrowing = true; // Start growing grass
    // Create several grass blades around the cup
    for (int i = 0; i < 20; i++) {
      grassList.add(new Grass(mugX + random(-50, 50), mugY - cupHeight + 5)); // Add grass around the cup
    }
  }
}

// Function to animate the growing of grass
void growGrass() {
  for (Grass g : grassList) {
    g.grow(); // Animate each grass blade growing
  }
}

// Grass class to handle the grass growing animation
class Grass {
  float x, y; // Position of the grass blade
  int height = 0; // Initial height of the grass blade
  int maxHeight = (int) random(40, 80); // Random maximum height for each grass blade
  int width = 3; // Width of the grass blade
  color grassColor = color(34, 139, 34); // Green color for grass

  // Constructor to initialize the grass's position
  Grass(float startX, float startY) {
    x = startX;
    y = startY;
  }

  // Function to animate the growing process of the grass
  void grow() {
    if (height < maxHeight) {
      height++; // Increase the height of the grass
    }
    
    // Draw the grass blade
    fill(grassColor);
    noStroke();
    rect(x - width / 2, y - height, width, height); // Draw the grass as a vertical line
  }
}

// Function to display the digital clock in the top left corner
void displayDigitalClock() {
  int elapsedTime = millis() - startTime; // Calculate elapsed time in milliseconds
  int seconds = (elapsedTime / 1000) % 60; // Get seconds
  int minutes = (elapsedTime / 60000) % 60; // Get minutes
  
  // Format the time as a string (HH:MM:SS)
  String timeString = nf(minutes, 2) + ":" + nf(seconds, 2);
  
  fill(255); // White color for the text
  textSize(32);
  textAlign(LEFT, TOP);
  text(timeString, 20, 20); // Display the time in the top left corner
}
