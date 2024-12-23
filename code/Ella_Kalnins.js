let font;
let waveCount = 8;
let offsets = [];
let clouds = [];

function setup() {
  createCanvas(800, 600);
  font = textFont("Georgia", 24);

  // Assigning movement of waves
  for (let i = 0; i < waveCount; i++) {
    offsets.push(random(TWO_PI));
  }
}

function draw() {
  drawGradientBackground();
  drawMoon();
  drawSea();
  drawClouds();
}

function drawGradientBackground() {
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1);
    let c = lerpColor(color(70, 130, 180), color(255, 105, 97), inter);
    c = lerpColor(c, color(255, 165, 0), inter * inter);
    stroke(c);
    line(0, y, width, y);
  }
}

function drawMoon() {
  noStroke();
  fill(255, 255, 200, 100);
  ellipse(width * 0.8, height * 0.2, 50, 50);
  fill(70, 130, 180, 150);
  ellipse(width * 0.8 + 10, height * 0.2, 40, 50);
}

function drawSea() {
  noStroke();
  for (let i = 0; i < waveCount; i++) {
    fill(10, 20 + i * 10, 50 + i * 15, 120);
    beginShape();
    let y = height * 0.7 - i * 20;
    vertex(0, height);
    for (let x = 0; x <= width; x += 10) {
      let yOffset = sin(TWO_PI * (x / width) + millis() * 0.0002 + offsets[i]) * 20;
      vertex(x, y + yOffset);
    }
    vertex(width, height);
    endShape(CLOSE);
  }
}

function drawClouds() {
  for (let i = clouds.length - 1; i >= 0; i--) {
    let cloud = clouds[i];
    cloud.display();
    cloud.update();
    if (cloud.isFaded()) {
      clouds.splice(i, 1);
    }
  }
}

function mouseMoved() {
  clouds.push(new Cloud(mouseX, mouseY));
}

class Cloud {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.opacity = 50;
    this.size = random(50, 100);
  }

  display() {
    noStroke();
    fill(255, 255, 255, this.opacity);
    ellipse(this.x, this.y, this.size, this.size * 0.6);
    ellipse(this.x - this.size * 0.4, this.y + this.size * 0.2, this.size * 0.6, this.size * 0.4);
    ellipse(this.x + this.size * 0.4, this.y + this.size * 0.2, this.size * 0.6, this.size * 0.4);
  }

  update() {
    this.opacity -= 0.5;
  }

  isFaded() {
    return this.opacity <= 0;
  }
}
