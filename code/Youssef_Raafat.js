// Variables
let pg;
let r = 20;
let t;
let theta;

// Class-level constant
const num1 = 500;

// Instance of the Particle class
let myParticle;

class Particle {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.t = 0; // Initial time
  }

  // Update the position of the particle in a figure-8 motion
  move() {
    this.t += 0.03; // Increment time to move the particle
    // Parametric equations for figure-8 motion
    this.x = 230 * cos(this.t);
    this.y = 230 * sin(2 * this.t) / 2;

    if (mouseIsPressed) {
      this.t += 0.04;
    }
  }

  // Display the particle on the screen
  display() {
    // Change background color based on key
    if (keyIsPressed) {
      if (key === 'r' || key === 'R') {
        fill('#CA0718'); // Red
      } else if (key === 'g' || key === 'G') {
        fill('#43E034'); // Green
      } else if (key === 'b' || key === 'B') {
        fill('#2596BE'); // Blue
      } else if (key === 'w' || key === 'W') {
        fill('#FFFFFF'); // White
      } else if (key === 'y' || key === 'Y') {
        fill('#EBEB36'); // Yellow
      } else if (key === ' ') {
        fill(random(255), random(255), random(255)); // Random color
      }
    }

    ellipse(this.x + width / 2, this.y + height / 2, 3, 3); // Center the particle
  }
}

function setup() {
  createCanvas(600, 500);
  // Initialize PGraphics
  pg = createGraphics(400, 200);
  myParticle = new Particle(0, 0);
}

function draw() {
  myParticle.move();
  myParticle.display();

  fill(0, 12);
  rect(0, 0, width, height);
  noStroke();
  translate(width / 2, height / 2);
  fill(100);

  for (let i = 0; i < num1; i++) {
    stroke(40);
    let x1Value = x1(theta + i);
    let y1Value = y1(theta + i);
    // Points positions dependent on t and i
    point(x1Value, y1Value);
  }

  // Motion of particles/points in figure-8 trajectory
  theta += 10;
}

// Parametric equations mapping infinity/figure-8 motion
function x1(t) {
  return 230 * cos(t);
}

function y1(t) {
  return 230 * sin(2 * t) / 2;
}
