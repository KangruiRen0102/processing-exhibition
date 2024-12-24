let memoryCircles = [];
let hexagons = [];
let stars = [];

function setup() {
  createCanvas(800, 800);
  frameRate(30);
  setupHexagons();
  setupStars();
}

function draw() {
  // Background
  background(180, 220, 255);

  // Stars
  for (let star of stars) {
    star.display();
    star.twinkle();
  }

  // Hexagons
  for (let hex of hexagons) {
    hex.display();
  }

  // Glowing orb
  noStroke();
  for (let i = 100; i > 0; i -= 10) {
    fill(255, 200, 0, 255 - i * 2);
    ellipse(width / 2, height / 2, i * 3, i * 3);
  }

  // Adding memory circles
  if (frameCount % 10 === 0) {
    memoryCircles.push(new MemoryCircle(width / 2, height / 2));
  }

  for (let i = memoryCircles.length - 1; i >= 0; i--) {
    let mc = memoryCircles[i];
    mc.update();
    mc.display();

    if (mc.isOffScreen()) {
      memoryCircles.splice(i, 1);
    }
  }
}

function setupHexagons() {
  for (let i = 0; i < 50; i++) {
    hexagons.push(new Hexagon(random(width), random(height), random(20, 60)));
  }
}

function setupStars() {
  for (let i = 0; i < 100; i++) {
    stars.push(new Star(random(width), random(height), random(3, 6)));
  }
}

function mousePressed() {
  // Burst of memory orbs wherever the mouse is clicked
  for (let i = 0; i < 10; i++) {
    memoryCircles.push(new MemoryCircle(mouseX, mouseY));
  }
}

class MemoryCircle {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.size = random(10, 30);
    this.speed = random(1, 3);
    this.angle = random(TWO_PI);
  }

  update() {
    this.x += cos(this.angle) * this.speed;
    this.y += sin(this.angle) * this.speed;
  }

  display() {
    fill(255, 180, 50, 100);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }

  isOffScreen() {
    return (
      this.x < -this.size ||
      this.x > width + this.size ||
      this.y < -this.size ||
      this.y > height + this.size
    );
  }
}

class Hexagon {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  display() {
    stroke(255);
    strokeWeight(2);
    noFill();
    beginShape();
    for (let i = 0; i < 6; i++) {
      let angle = TWO_PI / 6 * i;
      let x1 = this.x + cos(angle) * this.size;
      let y1 = this.y + sin(angle) * this.size;
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }
}

class Star {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.brightness = random(150, 255);
    this.increasing = random(1) > 0.5;
  }

  display() {
    noStroke();
    fill(255, 235, 144, this.brightness);
    ellipse(this.x, this.y, this.size, this.size);
  }

  twinkle() {
    if (this.increasing) {
      this.brightness += 2;
      if (this.brightness > 255) this.increasing = false;
    } else {
      this.brightness -= 2;
      if (this.brightness < 150) this.increasing = true;
    }
  }
}
