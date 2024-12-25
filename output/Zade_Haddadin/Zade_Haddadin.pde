// Define the class for the Aurora
class Aurora {
  float x, y;  // Position of the aurora
  float width, height;  // Dimensions of the aurora
  color c1, c2;  // Colors for the aurora effect
  float speed;  // Speed for the horizontal movement
  
  Aurora(float x, float y, float w, float h, color c1, color c2, float speed) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    this.c1 = c1;
    this.c2 = c2;
    this.speed = speed;
  }
  
  void display() {
    // Aurora moves horizontally, creating a flowing effect
    fill(lerpColor(c1, c2, sin(radians(frameCount * speed))));
    noStroke();
    ellipse(x, y, width, height);
  }
  
  void move() {
    // The aurora moves in a horizontal sine wave motion
    x = width / 2 + sin(radians(frameCount * speed)) * 300;
  }
}

// Define the class for the Journey Dot
class JourneyDot {
  float x, y;  // Position of the journey dot
  float diameter;  // Diameter of the dot
  color col;  // Color of the dot
  float speed;  // Speed for the movement
  
  JourneyDot(float x, float y, float diameter, color col, float speed) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.col = col;
    this.speed = speed;
  }
  
  void display() {
    fill(col);
    ellipse(x, y, diameter, diameter);
  }
  
  void move() {
    // Dot moves back and forth along the X axis, representing the journey
    x = map(sin(radians(frameCount * speed)), -1, 1, 0, width);
  }
}

Aurora aurora;
JourneyDot journeyDot;

void setup() {
  size(800, 600);
  // Initialize Aurora and JourneyDot objects
  aurora = new Aurora(width / 2, height / 2, 500, 100, color(0, 255, 255), color(255, 105, 180), 0.1);
  journeyDot = new JourneyDot(0, height - 50, 20, color(255), 0.5);
}

void draw() {
  background(0);  // Set the background to black
  
  // Call the methods of Aurora and JourneyDot objects to display and animate
  aurora.move();
  aurora.display();
  
  journeyDot.move();
  journeyDot.display();
}
