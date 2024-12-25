int snowflakesCount = 500;
Snowflake[] snowflakes = new Snowflake[snowflakesCount];

int starCount = 100;
Star[] stars = new Star[starCount];

int buildingCount = 4; // Now 4 buildings in total
Building[] buildings = new Building[buildingCount];
boolean clicked = false; // Track whether the screen has been clicked

void setup() {
  size(800, 600);
  noStroke();
  
  // Initialize snowflakes
  for (int i = 0; i < snowflakesCount; i++) {
    snowflakes[i] = new Snowflake();
  }
  
  // Initialize stars
  for (int i = 0; i < starCount; i++) {
    stars[i] = new Star();
  }
  
  // Initialize buildings with specific heights
  for (int i = 0; i < buildingCount; i++) {
    buildings[i] = new Building(i);
  }
}

void draw() {
  // Set background for a winter's night
  background(20, 24, 54); // Dark blue sky
  
  // Draw buildings
  drawBuildings();
  
  // Draw moon
  drawMoon();
  
  // Draw street
  drawStreet();
  
  // Draw stars
  for (int i = 0; i < starCount; i++) {
    stars[i].update();
    stars[i].display();
  }
  
  // Draw streetlights
  drawStreetLights();
  
  // Draw snowflakes
  for (int i = 0; i < snowflakesCount; i++) {
    snowflakes[i].update();
    snowflakes[i].display();
  }
  
  // If the screen has been clicked, animate building height change
  if (clicked) {
    animateBuildingHeightChange();
  }
}

// Snowflake class
class Snowflake {
  float x, y, speed, size;
  
  Snowflake() {
    x = random(width);
    y = random(-100, height);
    speed = random(0.5, 2);
    size = random(2, 6);
  }
  
  void update() {
    y += speed;
    // Reset snowflake when it goes off the screen
    if (y > height) {
      y = random(-100, -10);
      x = random(width);
    }
  }
  
  void display() {
    fill(255, 255, 255, 150); // White color with slight transparency
    ellipse(x, y, size, size);
  }
}

// Star class
class Star {
  float x, y, size, alpha;
  
  Star() {
    x = random(width);
    y = random(height / 2); // Stars above the horizon
    size = random(1, 3);
    alpha = random(100, 255); // Random initial opacity
  }
  
  void update() {
    // Slow down the twinkling effect by gradually changing alpha
    alpha += random(-1, 1);
    alpha = constrain(alpha, 100, 255);
  }
  
  void display() {
    fill(255, 255, 255, alpha); // White color with dynamic opacity
    ellipse(x, y, size, size);
  }
}

// Building class for specific buildings in the background
class Building {
  float x, y, w, h;
  
  Building(int index) {
    // Predefined positions and heights for specific buildings
    y = height - 50; // All buildings will connect to the street
    
    if (index == 0) {
      // Building 1 (short)
      x = random(0, width - 100);
      w = 150;
      h = 150;
    } else if (index == 1) {
      // Building 2 (medium height)
      x = random(0, width - 100);
      w = 200;
      h = 250;
    } else if (index == 2) {
      // Building 3 (tall)
      x = random(0, width - 100);
      w = 175;
      h = 350;
    } else {
      // Final Building on the left side
      x = 0; // Positioned at the far left
      w = 100;
      h = 200; // Height is medium size for variety
    }
  }
  
  void display() {
    fill(0); // Black color for buildings
    rect(x, y - h, w, h); // Adjust y so the building connects with the street
  }
  
  // Method to randomly change the height of the building
  void randomizeHeight() {
    h = (int) random(150, 400); // Randomize height between 150 and 400 pixels
  }
}

// Draw moon in the top right
void drawMoon() {
  fill(255, 255, 255, 200); // White color with slight transparency
  ellipse(width - 100, 100, 80, 80); // Moon positioned at top right corner
}

// Draw street (horizontal street along the base)
void drawStreet() {
  fill(100, 100, 100); // Dark gray for the street
  rect(0, height - 50, width, 50); // Street is a rectangle at the bottom
}

// Draw streetlights
void drawStreetLights() {
  float streetlightSpacing = width / 7; // 6 streetlights spaced evenly across the street
  
  for (int i = 0; i < 6; i++) {
    float lightX = streetlightSpacing * (i + 1);
    float lightY = height - 50;
    
    // Light pole
    fill(100, 100, 100); // Dark gray for the pole
    rect(lightX - 5, lightY - 45, 10, 50);
    
    // Streetlight bulb
    fill(255, 255, 100); // Yellowish light
    ellipse(lightX, lightY - 60, 30, 30);
    
    // Glow effect around the light
    fill(255, 255, 150, 100);
    ellipse(lightX, lightY - 60, 70, 70);
  }
}

// Draw buildings in the background
void drawBuildings() {
  for (int i = 0; i < buildingCount; i++) {
    buildings[i].display();
  }
}

// Animate building height change
void animateBuildingHeightChange() {
  // Randomly change the height of the buildings
  for (int i = 0; i < buildingCount; i++) {
    buildings[i].randomizeHeight();
  }
  clicked = false; // Reset clicked state to avoid constant change
}

// Handle mouse click event
void mousePressed() {
  clicked = true; // Set the clicked flag to true when the mouse is pressed
}
