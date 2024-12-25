

ArrayList<Shape> elements; // List to hold visual elements
float waveOffset = 0;      // Offset for animating waves

void setup() {
  size(800, 600);
  elements = new ArrayList<Shape>();

  // Add static elements the sun and background
  elements.add(new Sun(width - 100, 100, 80, color(255, 223, 0)));

  
  for (int i = 0; i < 10; i++) {
    float x = random(100, width - 100);
    float y = random(height - 200, height - 50);
    elements.add(new Starfish(x, y, random(20, 40), color(255, 127, 80)));
    elements.add(new Seashell(x + random(-30, 30), y + random(-30, 30), random(15, 30), color(238, 130, 238)));
  }
}

void draw() {
  background(135, 206, 235); // Sky blue
  drawWaves();               // Dynamic sea waves

  // Draw all static elements
  for (Shape element : elements) {
    element.display();
  }

  drawBoat(); // A simple boat representing discovery and connection
}

// Function to draw animated waves
void drawWaves() {
  noStroke();
  for (int i = height / 2; i < height; i += 20) {
    fill(0, 105 + i / 10, 148);
    beginShape();
    for (int x = 0; x <= width; x++) {
      float y = sin((x + waveOffset) * 0.02) * 10 + i;
      vertex(x, y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  waveOffset += 1; // Increment offset for animation
}

// Function to draw a boat
void drawBoat() {
  fill(139, 69, 19); // Brown boat
  rectMode(CENTER);
  rect(width / 2, height / 2, 120, 20);

  fill(255); // White sail
  triangle(width / 2 - 10, height / 2 - 10, width / 2 + 50, height / 2 - 60, width / 2 + 50, height / 2);
}

// Base Shape class
class Shape {
  float x, y;
  color fillColor;

  Shape(float x, float y, color fillColor) {
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }

  void display() {
    fill(fillColor);
    noStroke();
  }
}

// Sun class
class Sun extends Shape {
  float radius;

  Sun(float x, float y, float radius, color fillColor) {
    super(x, y, fillColor);
    this.radius = radius;
  }

  @Override
  void display() {
    super.display();
    ellipse(x, y, radius * 2, radius * 2);
  }
}

// Starfish class
class Starfish extends Shape {
  float size;

  Starfish(float x, float y, float size, color fillColor) {
    super(x, y, fillColor);
    this.size = size;
  }

  @Override
  void display() {
    super.display();
    pushMatrix();
    translate(x, y);
    for (int i = 0; i < 5; i++) {
      ellipse(0, size / 2, size / 4, size);
      rotate(TWO_PI / 5);
    }
    popMatrix();
  }
}

// Seashell class
class Seashell extends Shape {
  float radius;

  Seashell(float x, float y, float radius, color fillColor) {
    super(x, y, fillColor);
    this.radius = radius;
  }

  @Override
  void display() {
    super.display();
    arc(x, y, radius * 2, radius, PI, TWO_PI);
  }
}
