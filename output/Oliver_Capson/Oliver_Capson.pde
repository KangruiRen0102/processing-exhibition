// List to hold all the circles
ArrayList<Circle> circles = new ArrayList<>();

// Setup function to initialize the environment
void setup() {
  size(800, 600); // Set the size of the canvas
  colorMode(HSB, 360, 100, 100); // Set the color mode to HSB (Hue, Saturation, Brightness)
}

// Main drawing loop
void draw() {
  // Set the background to white in RGB mode (not using HSB here)
  colorMode(RGB, 255); 
  background(255); // Set the background to white

  // Return to HSB mode for the circles
  colorMode(HSB, 360, 100, 100); 

  // Loop through all circles and update and display them
  for (Circle c : circles) {
    c.update(); // Update the circle (check for overlaps, growing, color change)
    c.display(); // Display the circle on the canvas
  }
}

// Called when the mouse is pressed to add a new circle at the mouse position
void mousePressed() {
  circles.add(new Circle(mouseX, mouseY)); // Create and add a new circle at the mouse location
}

// Circle class represents a single circle on the canvas
class Circle {
  float x, y, radius; // Position (x, y) and radius of the circle
  boolean growing; // Flag indicating if the circle is growing due to an intersection
  float hue; // Current hue for the rainbow color
  boolean transitioning; // Flag indicating if the circle is transitioning color

  // Constructor to initialize the circle at a given position
  Circle(float x, float y) {
    this.x = x;
    this.y = y;
    this.radius = 20; // Initial radius of the circle (doubled size from original)
    this.growing = false; // Initially, the circle is not growing
    this.transitioning = false; // Initially, the circle is not transitioning colors
    this.hue = -1; // Start with a gray color (indicated by hue = -1)
  }

  // Update function to check for overlaps and update properties accordingly
  void update() {
    // Loop through all circles to check for overlaps
    for (Circle other : circles) {
      if (other != this && overlaps(other)) { // Check if this circle overlaps with 'other'
        this.growing = true; // Mark this circle as growing
        other.growing = true; // Mark the other circle as growing

        // Start color transition on overlap
        this.transitioning = true;
        other.transitioning = true;
      }
    }

    // If the circle is growing, increase its size
    if (growing) {
      radius += 0.5; // Increment radius to make the circle grow
    }

    // If the circle is transitioning, update its hue for color cycling
    if (transitioning) {
      if (hue == -1) hue = 0; // If hue is not set, initialize it to red (hue = 0)
      hue = (hue + 1) % 360; // Cycle the hue (0 to 360) for smooth rainbow transition
    }
  }

  // Display the circle on the canvas
  void display() {
    noStroke(); // Disable stroke (outline) for the circle
    if (hue == -1) {
      fill(128); // Fill with gray color if the circle is not transitioning
    } else {
      fill(hue, 100, 100); // Use the current hue for the rainbow color
    }
    ellipse(x, y, radius * 2, radius * 2); // Draw the circle
  }

  // Check if this circle overlaps with another circle
  boolean overlaps(Circle other) {
    float distance = dist(this.x, this.y, other.x, other.y); // Calculate the distance between circle centers
    return distance < this.radius + other.radius; // Check if the distance is smaller than the sum of radii (overlap)
  }
}
