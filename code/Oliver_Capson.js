let circles = []; // Array to hold all the circles

function setup() {
  createCanvas(800, 600); // Set the size of the canvas
  colorMode(HSB, 360, 100, 100); // Set the color mode to HSB
}

function draw() {
  colorMode(RGB, 255); // Set the color mode to RGB for the background
  background(255); // Set the background to white

  colorMode(HSB, 360, 100, 100); // Return to HSB mode for the circles

  // Loop through all circles and update and display them
  for (let c of circles) {
    c.update(); // Update the circle
    c.display(); // Display the circle
  }
}

// Called when the mouse is pressed to add a new circle
function mousePressed() {
  circles.push(new Circle(mouseX, mouseY)); // Add a new circle at the mouse position
}

// Circle class represents a single circle
class Circle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.radius = 20; // Initial radius of the circle
    this.growing = false; // Whether the circle is growing
    this.hue = -1; // Start with a gray color
    this.transitioning = false; // Whether the circle is transitioning colors
  }

  // Update function to check for overlaps and update properties
  update() {
    // Check for overlaps with other circles
    for (let other of circles) {
      if (other !== this && this.overlaps(other)) {
        this.growing = true;
        other.growing = true;

        // Start color transition on overlap
        this.transitioning = true;
        other.transitioning = true;
      }
    }

    // If the circle is growing, increase its radius
    if (this.growing) {
      this.radius += 0.5;
    }

    // If the circle is transitioning, update its hue for a rainbow effect
    if (this.transitioning) {
      if (this.hue === -1) this.hue = 0; // Initialize hue to red
      this.hue = (this.hue + 1) % 360; // Cycle hue smoothly
    }
  }

  // Display the circle
  display() {
    noStroke();
    if (this.hue === -1) {
      fill(128); // Gray if not transitioning
    } else {
      fill(this.hue, 100, 100); // Rainbow color
    }
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }

  // Check if this circle overlaps with another circle
  overlaps(other) {
    let distance = dist(this.x, this.y, other.x, other.y);
    return distance < this.radius + other.radius;
  }
}
