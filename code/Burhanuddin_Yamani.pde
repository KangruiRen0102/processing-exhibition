int numStars = 200;  // Number of stars
Star[] stars = new Star[numStars];  // Array of star objects
ShootingStar shootingStar;  // Shooting star object
PGraphics skyline;  // PGraphics to store the city skyline

void setup() {
  size(800, 600);  // Set the size of the canvas

  // Initialize the PGraphics object for the skyline
  skyline = createGraphics(width, height);
  
  // Draw the skyline once in the PGraphics object
  drawCitySkyline();
  
  // Initialize the stars array
  for (int i = 0; i < numStars; i++) {
    stars[i] = new Star();
  }
  
  // Initialize the shooting star
  shootingStar = new ShootingStar();
}

void draw() {
  // Draw the pre-rendered skyline from PGraphics
  image(skyline, 0, 0);  // Display the saved skyline image
  
  // Draw the stars on top of the skyline
  for (int i = 0; i < numStars; i++) {
    stars[i].display();
  }

  // Randomly trigger shooting stars
  if (random(1) < 0.01) {
    shootingStar.reset();  // Reset shooting star for new animation
  }
  shootingStar.display();  // Display the shooting star
  shootingStar.move();  // Move the shooting star across the screen
}

// Function to draw the city skyline with manually specified buildings
void drawCitySkyline() {
  skyline.beginDraw();  // Begin drawing into the PGraphics object
  skyline.background(0);  // Black background for night sky

  // Draw each building individually with pre-defined positions, heights, and colors
  
  // Building 1
  skyline.fill(150, 100, 200);  // Color: purple
  skyline.rect(50, height - 300, 50, 300);  // Position and height
  drawWindows(skyline, 50, 300, 50, 300);  // Add windows to Building 1
  
  // Building 2
  skyline.fill(100, 150, 255);  // Color: blue
  skyline.rect(130, height - 250, 60, 250);  // Position and height
  drawWindows(skyline, 130, 250, 60, 250);  // Add windows to Building 2
  
  // Building 3
  skyline.fill(255, 100, 100);  // Color: red
  skyline.rect(220, height - 350, 50, 350);  // Position and height
  drawWindows(skyline, 220, 350, 50, 350);  // Add windows to Building 3
  
  // Building 4
  skyline.fill(200, 200, 100);  // Color: yellow
  skyline.rect(300, height - 200, 40, 200);  // Position and height
  drawWindows(skyline, 300, 200, 40, 200);  // Add windows to Building 4
  
  // Building 5
  skyline.fill(100, 255, 100);  // Color: green
  skyline.rect(380, height - 400, 70, 400);  // Position and height
  drawWindows(skyline, 380, 400, 70, 400);  // Add windows to Building 5
  
  // Building 6
  skyline.fill(255, 200, 150);  // Color: orange
  skyline.rect(470, height - 300, 60, 300);  // Position and height
  drawWindows(skyline, 470, 300, 60, 300);  // Add windows to Building 6
  
  // Building 7
  skyline.fill(100, 200, 255);  // Color: light blue
  skyline.rect(550, height - 220, 50, 220);  // Position and height
  drawWindows(skyline, 550, 220, 50, 220);  // Add windows to Building 7
  
  // Building 8
  skyline.fill(255, 150, 200);  // Color: pink
  skyline.rect(630, height - 370, 60, 370);  // Position and height
  drawWindows(skyline, 630, 370, 60, 370);  // Add windows to Building 8

  skyline.endDraw();  // Finish drawing the skyline
}

// Function to draw windows on a building
void drawWindows(PGraphics pg, float x, float baseHeight, float buildingWidth, float buildingHeight) {
  for (int y = (int)(height - buildingHeight + 10); y < height; y += 20) {
    for (int w = (int)(x + 5); w < x + buildingWidth - 5; w += 10) {
      pg.fill(255, 255, 0, 200);  // Yellow windows
      pg.rect(w, y, 5, 10);  // Draw window rectangles
    }
  }
}

// Class to represent individual stars
class Star {
  float x, y, brightness;  // Position and brightness of the star

  // Constructor for Star, initializes its position and brightness
  Star() {
    x = random(width);  // Random x-position within canvas width
    y = random(height);  // Random y-position (entire height of the canvas)
    brightness = random(150, 255);  // Random brightness level
  }

  // Method to display each star
  void display() {
    fill(brightness);  // Set the fill color to the star's brightness
    noStroke();  // No outline for the star
    ellipse(x, y, 2, 2);  // Draw the star as a small ellipse
  }
}

// Class to represent shooting stars
class ShootingStar {
  float x, y, speedX, speedY;  // Position and speed of the shooting star
  boolean active;  // Whether the shooting star is active

  // Constructor for ShootingStar, initializes the shooting star
  ShootingStar() {
    reset();  // Initialize the shooting star
  }

  // Reset the shooting star's position and speed
  void reset() {
    x = random(width);  // Random starting x-position
    y = random(height /8);  // Random starting y-position (upper eighth of the screen, prevent clasing with buildings)
    speedX = random(-10, -20);  // Horizontal speed (moving left)
    speedY = random(2, 5);  // Vertical speed (moving down)
    active = true;  // Activate the shooting star
  }

  // Method to move the shooting star
  void move() {
    if (active) {  // Move only if the shooting star is active
      x += speedX;  // Update x-position based on horizontal speed
      y += speedY;  // Update y-position based on vertical speed
      if (x < 0 || y > height) {  // Deactivate when the star goes off-screen
        active = false;
      }
    }
  }

  // Method to display the shooting star
  void display() {
    if (active) {  // Only display if the shooting star is active
      stroke(255);  // Set the stroke color to white (bright star)
      strokeWeight(2);  // Set stroke thickness
      // Draw the shooting star as a short line
      line(x, y, x + speedX * 2, y + speedY * 2);
    }
  }
}

//The assistance of ChatGPT was used to create this code.
