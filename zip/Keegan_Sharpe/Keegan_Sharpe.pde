float rectX, rectY;  // Position of the rectangle
float speedX, speedY; // Speed of the rectangle's movement
float areaX, areaY;   // Top-left corner of the moving rectangular area
float areaWidth, areaHeight; // Dimensions of the rectangular area
color rectColor;      // Variable to store the color of the rectangle
int colorIndex;       // Index to cycle through colors
PFont font;           // Font for the text

void setup() {
  size(800, 600);
  
  // Initialize the position and speed of the rectangle
  rectX = 250;  // Start position inside the area
  rectY = 250;
  speedX = 1.5;  // Horizontal speed (slowed down by 50%)
  speedY = 1.5;  // Vertical speed (slowed down by 50%)

  // Define the size and position of the rectangular area
  areaX = 50;  // X-coordinate of the top-left corner of the area
  areaY = 50;  // Y-coordinate of the top-left corner of the area
  areaWidth = 700; // Width of the area
  areaHeight = 500; // Height of the area
  
  // Initialize the rectangle's color and colorIndex
  colorIndex = 0;  // Start with the first color (Blue)
  rectColor = color(0, 0, 255);  // Blue color initially
  
  // Load a font for the text
  font = createFont("Arial", 32);
  textFont(font);  // Set the font for the text
}

void draw() {
  drawMovingRectangle();
}

// Draw the moving rectangle
void drawMovingRectangle() {
  background(0);  // Set background to black
  
  // Move the rectangle
  rectX += speedX;
  rectY += speedY;
  
  // Check for collisions with the walls of the rectangular area and reverse direction if necessary
  if (rectX < areaX || rectX + 100 > areaX + areaWidth) {
    speedX *= -1;  // Reverse horizontal direction if the rectangle hits the left or right wall
    changeColor();  // Change color on horizontal bounce
  }
  if (rectY < areaY || rectY + 50 > areaY + areaHeight) {
    speedY *= -1;  // Reverse vertical direction if the rectangle hits the top or bottom wall
    changeColor();  // Change color on vertical bounce
  }
  
  // Draw the moving rectangular area (as a visible border)
  stroke(255);  // White border for the area
  noFill();
  rect(areaX, areaY, areaWidth, areaHeight);  // Draw the rectangular boundary

  // Draw the moving rectangle inside the area with the current color
  fill(rectColor);  // Set the current fill color for the rectangle
  rect(rectX, rectY, 100, 50);  // 100x50 rectangle
  
  // Draw the word "DVD" inside the rectangle
  fill(0);  // Black color for the text
  textAlign(CENTER, CENTER);  // Center the text inside the rectangle
  text("DVD", rectX + 50, rectY + 25);  // Position the text in the middle of the rectangle
}

// Function to cycle through Blue, Green, and Red
void changeColor() {
  // Cycle through the colors using an index
  colorIndex = (colorIndex + 1) % 3;  // 0 -> Blue, 1 -> Green, 2 -> Red

  // Change the color based on the index
  if (colorIndex == 0) {
    rectColor = color(0, 0, 255);  // Blue
  } else if (colorIndex == 1) {
    rectColor = color(0, 255, 0);  // Green
  } else if (colorIndex == 2) {
    rectColor = color(255, 0, 0);  // Red
  }
}
