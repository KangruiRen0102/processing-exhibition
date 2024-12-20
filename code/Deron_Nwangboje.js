let stars = []; // Stars in the sky
let trees = []; // Trees
let bushes = []; // Bushes
let particles = []; // Particles on the road
let aurora;

// Road and field dimensions
let roadWidth = 140;
let roadTopWidth = 40;
let fieldHeight = 300;

function setup() {
  createCanvas(800, 600);
  frameRate(30);

  // Initialize stars
  for (let i = 0; i < 300; i++) {
    stars.push(new Star(random(width), random(height)));
  }

  // Initialize trees and bushes with fixed positions
  addTreesAndBushes(width / 4, 50, -60);
  addTreesAndBushes((3 * width) / 4, 50, -60);

  // Initialize particles
  for (let i = 0; i < 50; i++) {
    particles.push(new Particle(width / 2 + random(-roadTopWidth / 2, roadTopWidth / 2), random(height / 2, height)));
  }

  // Initialize aurora
  aurora = new Aurora();
}

function draw() {
  background(20, 30, 50); // Night sky color

  // Draw stars
  for (let s of stars) {
    s.update();
    s.display();
  }

  // Draw aurora borealis
  aurora.display();

  // Draw fields, trees, bushes, road, and particles
  drawFields();
  for (let t of trees) {
    t.display();
  }
  for (let b of bushes) {
    b.display();
  }
  drawRoad();
  for (let p of particles) {
    p.update();
    p.display();
  }
}

function drawFields() {
  fill(34, 139, 34); // Green color for fields
  // Left field
  beginShape();
  vertex(0, height);
  vertex(width / 2 - roadWidth / 2, height);
  vertex(width / 2 - roadTopWidth / 2, height / 2);
  vertex(0, height / 2);
  endShape(CLOSE);

  // Right field
  beginShape();
  vertex(width, height);
  vertex(width / 2 + roadWidth / 2, height);
  vertex(width / 2 + roadTopWidth / 2, height / 2);
  vertex(width, height / 2);
  endShape(CLOSE);
}

function drawRoad() {
  fill(40); // Gray road color
  beginShape();
  vertex(width / 2 - roadWidth / 2, height);
  vertex(width / 2 + roadWidth / 2, height);
  vertex(width / 2 + roadTopWidth / 2, height / 2);
  vertex(width / 2 - roadTopWidth / 2, height / 2);
  endShape(CLOSE);

  // Dashed center stripes
  stroke(255);
  strokeWeight(2);
  for (let y = height; y > height / 2; y -= 20) {
    line(width / 2, y, width / 2, y - 10);
  }
}

function addTreesAndBushes(centerX, startY, offsetY) {
  for (let i = 0; i < 4; i++) {
    trees.push(new Tree(centerX + i * 30, height / 2 + startY + i * 50));
    bushes.push(new Bush(centerX + i * 30 - 30, height / 2 + offsetY + i * 80));
  }
}

class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(1, 3);
    this.brightness = random(150, 255);
    this.speed = random(0.01, 0.1);
  }
  update() {
    this.brightness += sin(frameCount * this.speed) * 30;
    this.size = 1 + sin(frameCount * this.speed) * 0.8;
    this.brightness = constrain(this.brightness, 150, 255);
  }
  display() {
    noStroke();
    fill(this.brightness);
    ellipse(this.x, this.y, this.size);
  }
}

class Tree {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
  display() {
    fill(139, 69, 19); // Trunk
    rect(this.x - 5, this.y - 30, 10, 30);
    fill(0, 100, 0); // Leaves
    triangle(this.x - 15, this.y - 30, this.x + 15, this.y - 30, this.x, this.y - 60);
  }
}

class Bush {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
  display() {
    fill(50, 205, 50);
    ellipse(this.x, this.y, 30, 20);
  }
}

class Aurora {
  constructor() {
    this.numBands = 10;
    this.offsets = [];
    this.colors = [];
    for (let i = 0; i < this.numBands; i++) {
      this.offsets[i] = random(1000);
      this.colors[i] = this.randomColor();
    }
  }
  display() {
    noStroke();
    for (let i = 0; i < this.numBands; i++) {
      fill(this.colors[i]);
      beginShape();
      for (let x = 0; x <= width; x++) {
        let y = map(noise(x * 0.01, this.offsets[i]), 0, 1, height / 8, height / 3);
        vertex(x, y);
      }
      vertex(width, 0);
      vertex(0, 0);
      endShape(CLOSE);
      this.offsets[i] += 0.02;
    }
  }
  randomColor() {
    return color(random(100, 255), random(0, 255), random(100, 255), 150);
  }
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speed = random(0.2, 1.0);
  }
  update() {
    this.y -= this.speed;
    if (this.y < height / 2) {
      this.y = height;
      this.x = width / 2 + random(-roadTopWidth / 2, roadTopWidth / 2);
    }
  }
  display() {
    noStroke();
    fill(255, 150, 0, 150);
    ellipse(this.x, this.y, 5, 5);
  }
}

function mousePressed() {
  aurora = new Aurora(); // Randomize aurora colors on mouse press
}
