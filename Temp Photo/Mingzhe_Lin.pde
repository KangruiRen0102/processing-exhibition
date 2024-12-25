// List to store shapes
ArrayList<Shape> shapes = new ArrayList<Shape>();
// This list keeps track of all the shapes currently on the canvas, allowing them to be updated and drawn each frame.

void setup() {
  size(800, 800); // Sets up the canvas size to 800x800 pixels.
  noStroke(); // Removes outlines for all shapes.
  background(255); // Sets the background to white.
  
  // Draw large dark grey circle (outer circle)
  fill(50); // Sets the fill color to dark grey.
  ellipse(width / 2, height / 2, 600, 600); // Draws a centered circle with a diameter of 600 pixels.
  
  // Draw smaller pink circle (inner circle)
  fill(255, 105, 180); // Sets the fill color to pink.
  ellipse(width / 2, height / 2, 500, 500); // Draws a centered circle with a diameter of 500 pixels.
}

void draw() {
  // Redraw the background each frame to reset the canvas
  background(255);
  
  // Redraw the large dark grey circle
  fill(50);
  ellipse(width / 2, height / 2, 600, 600);
  
  // Redraw the smaller pink circle
  fill(255, 105, 180);
  ellipse(width / 2, height / 2, 500, 500);

  // Iterate through the list of shapes in reverse order to safely remove faded shapes
  for (int i = shapes.size() - 1; i >= 0; i--) {
    Shape s = shapes.get(i); // Retrieve each shape instance.
    s.update(); // Update the shape's properties (e.g., fading effect).
    s.display(); // Draw the shape to the canvas.
    if (s.isFaded()) { // Check if the shape is fully faded.
      shapes.remove(i); // Remove the shape from the list if it has disappeared.
    }
  }
}

void mousePressed() {
  // Calculate distance from the center of the pink circle to the mouse click
  float distance = dist(mouseX, mouseY, width / 2, height / 2);
  
  // Only allow new shapes if the mouse click is inside the pink circle (radius 250)
  if (distance <= 250) {
    // Calculate the size of the shape based on its distance from the center
    float size = map(distance, 0, 250, 30, 5); // Closer clicks produce larger shapes.
    shapes.add(new Shape(mouseX, mouseY, size)); // Add a new shape with calculated size at the mouse position.
  }
}

// Class to represent shapes (star, circle, or square)
class Shape {
  float x, y; // Position of the shape.
  float size; // Size of the shape.
  int type = int(random(3)); // Randomly determines the type of the shape: 0 = star, 1 = circle, 2 = square.
  float alpha = 255; // Initial transparency (fully opaque).
  float fadeRate; // Determines how quickly the shape fades based on its type.
  
  Shape(float x, float y, float size) {
    this.x = x; // Set x-coordinate of the shape.
    this.y = y; // Set y-coordinate of the shape.
    this.size = size; // Set the size of the shape.
    
    // Determine fade rate based on shape type
    if (type == 0) { // Star
      fadeRate = 255.0 / (10 * 60); // Fades over 10 seconds.
    } else if (type == 1) { // Circle
      fadeRate = 255.0 / (2 * 60); // Fades over 2 seconds.
    } else if (type == 2) { // Square
      fadeRate = 255.0 / (5 * 60); // Fades over 5 seconds.
    }
  }
  
  void update() {
    // Decrease the alpha (transparency) value over time
    alpha -= fadeRate; // Fades the shape at the rate defined earlier.
    if (alpha < 0) alpha = 0; // Ensure alpha doesn't go below 0.
  }
  
  void display() {
    fill(255, 223, 0, alpha); // Set the color to yellow with the current transparency.
    if (type == 0) {
      drawStar(x, y, size, size / 2, 5); // Draw a star.
    } else if (type == 1) {
      ellipse(x, y, size, size); // Draw a circle.
    } else if (type == 2) {
      rectMode(CENTER); // Center the square around its position.
      rect(x, y, size, size); // Draw a square.
    }
  }
  
  boolean isFaded() {
    return alpha <= 0; // Returns true if the shape is fully faded (alpha is 0 or less).
  }
}

// Function to draw a star
void drawStar(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints; // Calculate the angle between points.
  float halfAngle = angle / 2.0; // Calculate the angle for the inner points.
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    // Outer vertex
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    
    // Inner vertex
    sx = x + cos(a + halfAngle) * radius1;
    sy = y + sin(a + halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE); // Close the shape to complete the star.
}
