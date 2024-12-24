// Define the class for the Aurora
class Aurora {
  constructor(x, y, w, h, c1, c2, speed) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    this.c1 = c1;
    this.c2 = c2;
    this.speed = speed;
  }

  display() {
    // Aurora moves horizontally, creating a flowing effect
    fill(lerpColor(this.c1, this.c2, sin(radians(frameCount * this.speed))));
    noStroke();
    ellipse(this.x, this.y, this.width, this.height);
  }

  move() {
    // The aurora moves in a horizontal sine wave motion
    this.x = width / 2 + sin(radians(frameCount * this.speed)) * 300;
  }
}

// Define the class for the Journey Dot
class JourneyDot {
  constructor(x, y, diameter, col, speed) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.col = col;
    this.speed = speed;
  }

  display() {
    fill(this.col);
    ellipse(this.x, this.y, this.diameter, this.diameter);
  }

  move() {
    // Dot moves back and forth along the X axis, representing the journey
    this.x = map(sin(radians(frameCount * this.speed)), -1, 1, 0, width);
  }
}

let aurora;
let journeyDot;

function setup() {
  createCanvas(800, 600);
  // Initialize Aurora and JourneyDot objects
  aurora = new Aurora(width / 2, height / 2, 500, 100, color(0, 255, 255), color(255, 105, 180), 0.1);
  journeyDot = new JourneyDot(0, height - 50, 20, color(255), 0.5);
}

function draw() {
  background(0); // Set the background to black

  // Call the methods of Aurora and JourneyDot objects to display and animate
  aurora.move();
  aurora.display();

  journeyDot.move();
  journeyDot.display();
}
