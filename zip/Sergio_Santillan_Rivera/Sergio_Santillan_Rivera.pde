// Gradient colors
color start_color = color(10, 10, 60); // Twilight top color
color end_color = color(200, 150, 80); // Twilight bottom color
color day_start_color = color(135, 206, 250); // Morning top color
color day_end_color = color(255, 255, 255); // Morning bottom color
float twilightFactor = 0; // Transition between day and night (a day will be 1 a night will be 0)

ArrayList<Shape> shapes;
float sunX, sunY;
float sunRadius = 100;
float lightIntensity = 150;
boolean canCreateShapes = true; // Determines if shapes can be created
boolean isDraggingSun = false; // Tracks if the sun is being dragged

void setup() {
  size(1200, 800);
  shapes = new ArrayList<>();
  sunX = width / 2;
  sunY = height / 2;

  // Create initial snowflakes
  for (int i = 0; i < 100; i++) {
    shapes.add(new Snowflake(random(width), random(height), random(2, 5), color(255)));
  }
  frameRate(60);
}

void draw() {
  updateTwilightFactor(); // Update twilight factor based on sun position

  // Interpolate background colors
  color interpolated_start = lerpColor(start_color, day_start_color, twilightFactor);
  color interpolated_end = lerpColor(end_color, day_end_color, twilightFactor);

  // Draw gradient background
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(interpolated_start, interpolated_end, inter);
    stroke(c);
    line(0, i, width, i);
  }

  // Draw the sun
  drawSun();

   // Update and draw all shapes stored in the shapes list
  for (Shape shape : shapes) {
    // Check if the current shape is a Snowflake.
    if (shape instanceof Snowflake) {
      ((Snowflake) shape).update(); // Update snowflake-specific properties like position
    }
    shape.display();
  }
}

void drawSun() {
  // Adjust light intensity based on twilightFactor
  float scaledLightIntensity = map(twilightFactor, 0, 1, 300, 50); // Night = more brightness, Day = less brightness

  // Draw pulsating light around the sun
  for (float r = sunRadius; r < sunRadius + scaledLightIntensity; r += 10) {
    float alpha = map(r, sunRadius, sunRadius + scaledLightIntensity, 150, 0);
    fill(255, 200, 0, alpha);
    ellipse(sunX, sunY, r * 2, r * 2);
  }

  // Draw the constant sun
  fill(255, 255, 0);
  ellipse(sunX, sunY, sunRadius * 2, sunRadius * 2);
}

void updateTwilightFactor() {
  // Update twilightFactor based on sunY
  twilightFactor = map(sunY, height, 0, 0, 1); // 0 = night, 1 = day
  twilightFactor = constrain(twilightFactor, 0, 1);
}

void mouseDragged() {
  if (!canCreateShapes && isDraggingSun) {
    // Move the sun with the mouse
    sunX = mouseX;
    sunY = mouseY;
  }
}

void mousePressed() {
  if (!canCreateShapes) {
    // Check if the mouse is over the sun to start dragging
    float d = dist(mouseX, mouseY, sunX, sunY);
    if (d < sunRadius) {
      isDraggingSun = true;
    }
  }
}

void mouseReleased() {
  isDraggingSun = false; // Stop dragging the sun
}

void keyPressed() {
  switch (Character.toLowerCase(key)) {
    case 'f': // Toggle sun interaction mode with mouse
      canCreateShapes = !canCreateShapes;
      break;

    case 'n': // Add 20 new snowflakes
      if (canCreateShapes) {
        for (int i = 0; i < 20; i++) {
          shapes.add(new Snowflake(random(width), random(height), random(2, 5), color(255)));
        }
      }
      break;

    case 'c': // Clear all snowflakes
      if (canCreateShapes) {
        shapes.removeIf(shape -> shape instanceof Snowflake);
      }
      break;

    case 'w': // Adjust snowflake speeds
      if (canCreateShapes) {
        for (Shape shape : shapes) {
          if (shape instanceof Snowflake) {
            Snowflake snowflake = (Snowflake) shape;
            snowflake.vx *= random(0.5, 1.5);
            snowflake.vy *= random(0.5, 1.5);
          }
        }
      }
      break;

    case 'l': // Lower the sun
      sunY = min(height, sunY + 10); 
      break;

    case 'r': // Raise the sun
      sunY = max(0, sunY - 10);
      break;
  }
}

// Shape base class
class Shape {
  float x, y;
  color fillColor;
 // Constructor to initialize position and fill color of the shape
  Shape(float x, float y, color fillColor) {
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }
// Method to set up the basic appearance of the shape
  void display() {
    fill(fillColor);
    noStroke();// Disable stroke (outline) for the shape
  }
}

// Snowflake class extending Shape
class Snowflake extends Shape {
  float size;
  float vx, vy;
// Constructor to initialize the snowflake's position, size, and fill color
  Snowflake(float x, float y, float size, color fillColor) {
    super(x, y, fillColor); // Use Shape's constructor
    this.size = size;
    this.vx = random(-1, 1);
    this.vy = random(1, 3);
  }
 // Override the display method to draw the snowflake as a circle
  @Override
  void display() {
    super.display();
    ellipse(x, y, size, size);
  }
// Update the snowflake's position based on its velocity
  void update() {
    x += vx;
    y += vy;
    if (y > height) {
      y = 0;
      x = random(width);
    }
  }
}
