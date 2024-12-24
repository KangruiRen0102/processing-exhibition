// Aurora Borealis

let auroraShapes = []; // Array to store the aurora shapes

// Define colors for the aurora shapes with transparency to look more natural
const colors = [
  [80, 255, 120, 100],
  [100, 255, 170, 100],
  [175, 215, 230, 100],
  [255, 150, 180, 100],
  [70, 60, 140, 100]
];

// Frame duration before an aurora shape fades out
const displayDuration = 60;

function setup() {
  createCanvas(800, 600); // Canvas size
  noStroke(); // Disable outlines for the aurora shapes
}

function draw() {
  // Make a semi-transparent background for a fading effect
  background(0, 20);

  // Add new aurora shapes every 10 frames
  if (frameCount % 10 === 0) {
    for (let i = 0; i < 5; i++) {
      // Make a new aurora shape with random x and y positions and a color
      auroraShapes.push(
        new AuroraShape(random(width), random(height / 2), colors[i % colors.length])
      );
    }
  }

  // Draw and remove expired aurora shapes
  // Remove shapes from the list in reverse order to avoid issues
  for (let i = auroraShapes.length - 1; i >= 0; i--) {
    const shape = auroraShapes[i];
    shape.draw(); // Draw the aurora shape
    if (shape.isExpired()) {
      auroraShapes.splice(i, 1); // Remove the shape if its duration is done
    }
  }
}

// Class to define aurora shapes
class AuroraShape {
  constructor(x, y, shapeColor) {
    // Starting point of the aurora shape
    this.x = x;
    this.y = y;

    // Control point offsets for creating the Bezier curve
    this.x2Offset = random(-100, 100);
    this.y2Offset = random(50, 150);
    this.x3Offset = random(-50, 50);
    this.y3Offset = random(50, 150);
    this.x4Offset = random(-30, 30);
    this.y4Offset = random(50, 150);

    // Color of the aurora shape
    this.shapeColor = shapeColor;

    // The frame when this shape was made
    this.createTime = frameCount;
  }

  // Draws the aurora shape on the canvas
  draw() {
    fill(...this.shapeColor); // Color for the shape
    beginShape(); // Start defining the shape
    vertex(this.x, this.y); // Starting point of the shape
    bezierVertex(
      this.x + this.x2Offset,
      this.y + this.y2Offset,
      this.x + this.x2Offset + this.x3Offset,
      this.y + this.y2Offset + this.y3Offset,
      this.x + this.x2Offset + this.x3Offset + this.x4Offset,
      this.y + this.y2Offset + this.y3Offset + this.y4Offset
    );
    vertex(this.x, height); // Close the shape at the starting x position
    endShape(CLOSE); // Complete the shape
  }

  // Checks if the aurora shape's duration has expired
  isExpired() {
    // Return true if the shape has existed longer than the display duration
    return frameCount - this.createTime > displayDuration;
  }
}
