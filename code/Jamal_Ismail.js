let particles = [];
let maxParticles = 100;

function setup() {
  createCanvas(800, 800);
  for (let i = 0; i < maxParticles; i++) {
    particles.push(new Particle(random(width), random(height)));
  }
}

function draw() {
  background(20, 30, 50);
  for (let p of particles) {
    p.update();
    p.display();
  }
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.speedX = random(-2, 2);
    this.speedY = random(-2, 2);
    this.col = color(random(100, 255), random(100, 200), random(200, 255));
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;

    if (this.x < 0 || this.x > width) this.speedX *= -1;
    if (this.y < 0 || this.y > height) this.speedY *= -1;

    this.size = map(sin(frameCount * 0.05), -1, 1, 5, 15);
  }

  display() {
    noStroke();
    fill(this.col);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

function mouseMoved() {
  for (let p of particles) {
    p.speedX = map(mouseX, 0, width, -3, 3);
    p.speedY = map(mouseY, 0, height, -3, 3);
  }
}
