let waveOffset = 0;
let currents = [];

function setup() {
  createCanvas(800, 600);

  for (let i = 0; i < 200; i++) {
    currents.push(new Particle(random(width), random(height), random(1, 5)));
  }
}

function draw() {
  background(10, 30, 60);

  drawSea();
  drawCurrents();
}

function drawSea() {
  noFill();
  stroke(100, 150, 255, 150);
  strokeWeight(2);

  for (let y = 0; y <= height; y += 20) {
    beginShape();
    for (let x = 0; x <= width; x += 20) {
      let offset = map(noise(x * 0.01, y * 0.01, waveOffset), 0, 1, -50, 50);
      vertex(x, y + offset);
    }
    endShape();
  }

  waveOffset += 0.01;
}

function drawCurrents() {
  for (let p of currents) {
    p.move();
    p.display();
  }
}

class Particle {
  constructor(x, y, speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.col = color(random(50, 150), random(100, 200), 255, random(100, 200));
  }

  move() {
    this.x += cos(noise(this.x * 0.01, this.y * 0.01) * TWO_PI) * this.speed;
    this.y += sin(noise(this.x * 0.01, this.y * 0.01) * TWO_PI) * this.speed;

    if (this.x > width) this.x = 0;
    if (this.x < 0) this.x = width;
    if (this.y > height) this.y = 0;
    if (this.y < 0) this.y = height;
  }

  display() {
    noStroke();
    fill(this.col);
    ellipse(this.x, this.y, 8, 8);
  }
}
