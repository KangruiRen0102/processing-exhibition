// List to store shapes
let shapes = []; // This list keeps track of all the shapes currently on the canvas.

function setup() {
  createCanvas(800, 800); // Sets up the canvas size to 800x800 pixels.
  noStroke(); // Removes outlines for all shapes.
  background(255); // Sets the background to white.

  // Draw large dark grey circle (outer circle)
  fill(50); // Sets the fill color to dark grey.
  ellipse(width / 2, height / 2, 600, 600); // Draws a centered circle with a diameter of 600 pixels.

  // Draw smaller pink circle (inner circle)
  fill(255, 105, 180); // Sets the fill color to pink.
  ellipse(width / 2, height / 2, 500, 500); // Draws a centered circle with a diameter of 500 pixels.
}

function draw() {
  // Redraw the background each frame to reset the canvas
  background(255);

  // Redraw the large dark grey circle
  fill(50);
  ellipse(width / 2, height / 2, 600, 600);

  // Redraw the smaller pink circle
  fill(255, 105, 180);
  ellipse(width / 2, height / 2, 500, 500);

  // Iterate through the list of shapes in reverse order to safely remove faded shapes
  for (let i = shapes.length - 1; i >= 0; i--) {
    let s = shapes[i]; // Retrieve each shape instance.
    s.update(); // Update the shape's properties (e.g., fading effect).
    s.display(); // Draw the shape to the canvas.
    if (s.isFaded()) { // Check if the shape is fully faded.
      shapes.splice(i, 1); // Remove the shape from the list if it has disappeared.
    }
  }
}

function mousePressed() {
  // Calculate distance from the center of the pink circle to the mouse click
  let distance = dist(mouseX, mouseY, width / 2, height / 2);

  // Only allow new shapes if the mouse click is inside the pink circle (radius 250)
  if (distance <= 250) {
    // Calculate the size of the shape based on its distance from the center
    let size = map(distance, 0, 250, 30, 5); // Closer clicks produce larger shapes.
    shapes.push(new Shape(mouseX, mouseY, size)); // Add a new shape with calculated size at the mouse position.
  }
}

// Class to represent shapes (star, circle, or square)
class Shape {
  constructor(x, y, size) {
    this.x = x; // Set x-coordinate of the shape.
    this.y = y; // Set y-coordinate of the shape.
    this.size = size; // Set the size of the shape.
    this.type = int(random(3)); // Randomly determines the type of the shape: 0 = star, 1 = circle, 2 = square.
    this.alpha = 255; // Initial transparency (fully opaque).
    this.fadeRate = this.type === 0 ? 255.0 / (10 * 60) : this.type === 1 ? 255.0 / (2 * 60) : 255.0 / (5 * 60); // Determine fade rate based on shape type.
  }

  update() {
    // Decrease the alpha (transparency) value over time
    this.alpha -= this.fadeRate; // Fades the shape at the rate defined earlier.
    if (this.alpha < 0) this.alpha = 0; // Ensure alpha doesn't go below 0.
  }

  display() {
    fill(255, 223, 0, this.alpha); // Set the color to yellow with the current transparency.
    if (this.type === 0) {
      this.drawStar(this.x, this.y, this.size, this.size / 2, 5); // Draw a star.
    } else if (this.type === 1) {
      ellipse(this.x, this.y, this.size, this.size); // Draw a circle.
    } else if (this.type === 2) {
      rectMode(CENTER); // Center the square around its position.
      rect(this.x, this.y, this.size, this.size); // Draw a square.
    }
  }

  isFaded() {
    return this.alpha <= 0; // Returns true if the shape is fully faded (alpha is 0 or less).
  }

  drawStar(x, y, radius1, radius2, npoints) {
    let angle = TWO_PI / npoints; // Calculate the angle between points.
    let halfAngle = angle / 2.0; // Calculate the angle for the inner points.
    beginShape();
    for (let a = 0; a < TWO_PI; a += angle) {
      // Outer vertex
      let sx = x + cos(a) * radius2;
      let sy = y + sin(a) * radius2;
      vertex(sx, sy);

      // Inner vertex
      sx = x + cos(a + halfAngle) * radius1;
      sy = y + sin(a + halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE); // Close the shape to complete the star.
  }
}
