int numShapes = 100;
Shape[] shapes = new Shape[numShapes];

void setup() {
  size(600, 600);
  for (int i = 0; i < numShapes; i++) {
    shapes[i] = new Shape(random(width), random(height));
  }
}

void draw() {
  background(20); // Dark background for contrast
  for (int i = 0; i < numShapes; i++) {
    shapes[i].move();
    shapes[i].display();
  }
}

class Shape {
  float x, y, xSpeed, ySpeed;
  float size = random(10, 20);

  Shape(float xPos, float yPos) {
    x = xPos;
    y = yPos;
    xSpeed = random(-2, 2);
    ySpeed = random(-2, 2);
  }

  void move() {
    // Shapes move randomly, symbolizing chaos
    x += xSpeed;
    y += ySpeed;

    // Reverse direction if hitting edges
    if (x < 0 || x > width) xSpeed *= -1;
    if (y < 0 || y > height) ySpeed *= -1;

    // Gradually pull shapes toward the center, representing focus over time
    x += (width/2 - x) * 0.005;
    y += (height/2 - y) * 0.005;
  }

  void display() {
    noStroke();
    fill(255, 150, 0, 150); // Bright color for energy
    ellipse(x, y, size, size);
  }
}
