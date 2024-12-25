int num = 60;
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(640, 360);
  noStroke();

  // Create multiple shapes
  for (int i = 0; i < 5; i++) { // Add 5 shapes
    shapes.add(new Shape(num));
  }
}

void draw() {
  background(4,26,64); //Night Sky color
  
  // Display all shapes
  for (Shape s : shapes) {
    s.update(mouseX, mouseY);
    s.display();
  }
  // Display particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isFaded()) {
      particles.remove(i); // Remove faded particles
    }
  }
}

void keyPressed() {
  // Change shape type for all shapes
  for (Shape s : shapes) {
    s.nextShapeType();
  }
}

void mousePressed() {
  // Spawn particles when mouse is pressed
  for (int i = 0; i < 10; i++) { // Release 10 particles
    particles.add(new Particle(mouseX, mouseY, color(178, 243, 142)));
  }
}

// Shape Class
class Shape {
  int num;             // Number of trail points
  float[] x, y;        // Arrays for trail positions
  int shapeType;       // Current shape type (0 = ellipse, 1 = rect, etc.)
  int frameIndex;      // Tracks current frame for trail cycling
  
  Shape(int numPoints) {
    num = numPoints;
    x = new float[num];
    y = new float[num];
    shapeType = 0;     // Start with ellipse
    frameIndex = 0;
  }

  void update(float mx, float my) {
    frameIndex = frameCount % num;
    x[frameIndex] = mx;
    y[frameIndex] = my;
  }

  void display() {
    for (int i = 0; i < num; i++) {
      int index = (frameIndex + 1 + i) % num;
      float size = i; // Shape size increases with trail age
      float alpha = map(i, 0, num, 80, 180); // Older segments are more transparent
      fill(178, 243, alpha);
      
      switch (shapeType) {
        case 0: ellipse(x[index], y[index], size, size); break;
        case 1: rect(x[index] - size / 2, y[index] - size / 2, size, size); break;
        case 2: drawPolygon(x[index], y[index], size, 3); break;
        case 3: drawPolygon(x[index], y[index], size, 5); break;
        case 4: drawPolygon(x[index], y[index], size, 6); break;
      }
    }
  }

  void nextShapeType() {
    shapeType = (shapeType + 1) % 5; // Cycle through 5 shapes
  }

  void drawPolygon(float cx, float cy, float radius, int sides) {
    float angle = TWO_PI / sides;
    beginShape();
    for (int i = 0; i < sides; i++) {
      float px = cx + cos(angle * i) * radius / 2;
      float py = cy + sin(angle * i) * radius / 2;
      vertex(px, py);
    }
    endShape(CLOSE);
  }
}
// Particle Class
class Particle {
  float x, y;         // Position
  float vx, vy;       // Velocity
  float alpha;        // Opacity
  int col;            // Particle color

  Particle(float startX, float startY, int c) {
    x = startX;
    y = startY;
    col = c;
    alpha = 255; // Start fully opaque

    // Random velocity
    vx = random(-2, 2);
    vy = random(-2, 2);
  }

  void update() {
    x += vx;
    y += vy;
    alpha -= 5; // Gradually fade
  }

  void display() {
    fill(col, alpha);
    ellipse(x, y, 10, 10); // Particle size
  }

  boolean isFaded() {
    return alpha <= 0; // Check if particle is fully faded
  }
}
