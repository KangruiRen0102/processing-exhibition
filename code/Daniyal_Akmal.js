let explorers = [];
const totalExplorers = 200; // Number of explorers displayed during the animation
let auroraWave = 0.0;

function setup() {
  createCanvas(800, 800);
  background(10, 15, 50);
  for (let i = 0; i < totalExplorers; i++) {
    explorers.push(new Explorer(random(width), random(height)));
  }
}

function draw() {
  background(10, 15, 50, 50);

  drawAurora();

  for (let e of explorers) {
    e.move();
    e.display();
  }
}

function drawAurora() {
  noStroke();
  for (let i = 0; i < height; i += 10) {
    let colorShift = map(sin(auroraWave + i * 0.05), -1, 1, 100, 255);
    fill(50, colorShift, 255, 100);
    rect(0, i, width, 10);
  }
  auroraWave += 0.1;
}

class Explorer {
  constructor(x, y) {
    this.position = createVector(x, y);
    this.velocity = p5.Vector.random2D().mult(random(1, 3));
    this.trailColor = color(random(200, 255), random(100, 200), random(150, 255), 150);
  }

  move() {
    this.position.add(this.velocity);

    if (this.position.x > width) this.position.x = 0;
    if (this.position.x < 0) this.position.x = width;
    if (this.position.y > height) this.position.y = 0;
    if (this.position.y < 0) this.position.y = height;
  }

  display() {
    noStroke();
    fill(this.trailColor);
    ellipse(this.position.x, this.position.y, 6, 6);
  }
}
