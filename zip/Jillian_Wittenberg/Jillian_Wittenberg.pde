// Aurora Borealis

// Array to store the aurora shapes
ArrayList<AuroraShape> auroraShapes;

// Define colours for the aurora shapes with transparency to look more natural
color[] colors = {
  color(80, 255, 120, 100),
  color(100, 255, 170, 100),
  color(175, 215, 230, 100),
  color(255, 150, 180, 100), 
  color(70, 60, 140, 100)
};

// Frame duration before an aurora shape fades out
int displayDuration = 60;

void setup() {
  size(800, 600);  // Canvas size
  noStroke();      // Disable outlines for the aurora shapes
  auroraShapes = new ArrayList<AuroraShape>(); // Make the list for the aurora shapes
}

void draw() {
  // Make a semi-transparent background for a fading effect
  background(0, 20); 

  // Add new aurora shapes every 10 frames
  if (frameCount % 10 == 0) {
    for (int i = 0; i < 5; i++) { 
      // Make a new aurora shape with random x and y positions and a colour
      auroraShapes.add(new AuroraShape(random(width), random(height / 2), colors[i % colors.length]));
    }
  }

  // Draw and remove expired aurora shapes
  // Remove shapes from the list in reverse order to avoid issues
  for (int i = auroraShapes.size() - 1; i >= 0; i--) {
    AuroraShape shape = auroraShapes.get(i);
    shape.draw(); // Draw the aurora shape
    if (shape.isExpired()) {
      auroraShapes.remove(i); // Remove the shape if its duration is done
    }
  }
}

// Class to define aurora shapes
class AuroraShape {
  // Starting point of the aurora shape
  float x, y;

  // Control point offsets for creating the Bezier curve
  float x2Offset, y2Offset, x3Offset, y3Offset, x4Offset, y4Offset;

  // Colour of the aurora shape
  color shapeColor;

  // The frame when this shape was made
  int createTime;

  // Make an aurora shape with position, colour, and offsets
  AuroraShape(float x, float y, color shapeColor) {
    this.x = x; // X position
    this.y = y; // Y position
    this.shapeColor = shapeColor; // Colour of the shape
    this.createTime = frameCount; // Frame when the shape was made

    // Generate random offsets for the Bezier curve's control points and determine their curvature
    x2Offset = random(-100, 100);
    y2Offset = random(50, 150);
    x3Offset = random(-50, 50);
    y3Offset = random(50, 150);
    x4Offset = random(-30, 30);
    y4Offset = random(50, 150);
  }

  // Draws the aurora shape on the canvas
  void draw() {
    fill(shapeColor); // Colour for the shape
    beginShape(); // Start defining the shape
    vertex(x, y); // Starting point of the shape
    bezierVertex(
      x + x2Offset, y + y2Offset, // First point
      x + x2Offset + x3Offset, y + y2Offset + y3Offset, // Second point
      x + x2Offset + x3Offset + x4Offset, y + y2Offset + y3Offset + y4Offset // End point
    );
    vertex(x, height); // Close the shape at the starting x position
    endShape(CLOSE); // Complete the shape
  }

  // Checks if the aurora shape's duration has expired
  boolean isExpired() {
    // Return true if the shape has existed longer than the display duration
    return frameCount - createTime > displayDuration;
  }
}
