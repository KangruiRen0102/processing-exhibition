let yvalues; // Stores height values for the wave
let xspacing = 16; // Horizontal spacing
let w; // Wave width
let theta = 0.0; // Starting angle
let amplitude = 25.0; // Wave height
let dx; // Value for incrementing X
let period = 300; // Pixels before the wave repeats

// Circle storage
let circlesToDraw = [];

// Color parameters
let waveColor;
let backgndColor;
let circleColor;

class MyCircle {
  constructor(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.myCircleColor = circleColor;
  }

  displayCircle() {
    fill(this.myCircleColor);
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }

  shrink() {
    this.radius--;
  }

  isGone() {
    return this.radius <= 0;
  }
}

function setup() {
  createCanvas(640, 360); // Set display window size

  // Set up wave params
  w = width + 100;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new Array(floor(w / xspacing));

  // Initialize colors
  waveColor = color(184, 22, 41); // Red
  backgndColor = color(104, 12, 23); // Dark red
  circleColor = color(255); // White
}

function draw() {
  background(backgndColor); // Dark red background
  calcWave();
  renderWave();
  calcCircles();

  for (let circle of circlesToDraw) {
    circle.displayCircle();
  }
}

function calcWave() {
  theta += 0.02;
  let x = theta;
  for (let i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x) * amplitude;
    x += dx;
  }
}

function calcCircles() {
  for (let i = circlesToDraw.length - 1; i >= 0; i--) {
    let c = circlesToDraw[i];
    c.shrink();
    if (c.isGone()) {
      circlesToDraw.splice(i, 1);
    }
  }
}

function renderWave() {
  noStroke();
  fill(waveColor);
  beginShape(); // Make the wave solid
  for (let x = 0; x < yvalues.length; x++) {
    vertex(x * xspacing, height / 2 + yvalues[x]);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

function mousePressed() {
  circlesToDraw.push(new MyCircle(mouseX, mouseY, 50));
}
