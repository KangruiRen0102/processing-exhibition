let particles = []; // Array to store particles (whispers)
let gradientColors = [
  [5, 5, 15],
  [15, 15, 50],
  [30, 30, 100],
  [50, 40, 120],
  [90, 50, 140],
  [120, 60, 160],
  [200, 80, 180],
  [250, 100, 150],
  [255, 120, 140]
];
let stars = []; // Array to hold stars
let mountainShapes = []; // Array to hold mountain shapes

function setup() {
  createCanvas(800, 800);
  noStroke();

  // Initialize particles
  for (let i = 0; i < 50; i++) {
    addParticle(random(width), random(height * 2 / 3, height));
  }

  // Initialize stars
  for (let i = 0; i < 125; i++) {
    stars.push(new Star(random(width), random(height / 1.65), random(2, 4)));
  }

  // Generate mountain layers
  for (let i = 0; i < 4; i++) {
    mountainShapes.push(createMountainLayer(0.45, color(70 - i * 10, 70 - i * 10, 70 - i * 10)));
  }
}

function draw() {
  // Draw gradient background
  for (let y = 0; y < height; y++) {
    let t = map(y, 0, height, 0, gradientColors.length - 1);
    let index1 = floor(t);
    let index2 = min(index1 + 1, gradientColors.length - 1);
    let blend = t - index1;
    let col = lerpColor(color(...gradientColors[index1]), color(...gradientColors[index2]), blend);
    stroke(col);
    line(0, y, width, y);
  }

  // Draw mountains
  for (let shape of mountainShapes) {
    shape.display();
  }

  // Draw moon
  drawMoon();

  // Draw stars
  for (let star of stars) {
    star.display();
  }

  // Draw particles (whispers)
  fill(0, 15);
  rect(0, 0, width, height);
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
    if (p.isDead()) {
      particles.splice(i, 1);
    }
  }

  // Maintain particle count
  while (particles.length < 50) {
    addParticle(random(width), random(height * 2 / 3, height));
  }

  // Draw sine waves
  drawSineWaves();
}

function mousePressed() {
  let newStars = 25;
  for (let i = 0; i < newStars; i++) {
    stars.push(new Star(random(width), random(height / 1.65), random(2, 4)));
  }
}

function drawSineWaves() {
  noFill();
  stroke(0);
  strokeWeight(5);

  let waveHeight = 20;
  let waveSpacing = 30;
  let frequency = 0.004;

  for (let j = height - 150; j < height; j += waveSpacing) {
    beginShape();
    for (let x = 0; x <= width; x++) {
      let noiseFactor = noise(x * 0.01, frameCount * 0.01);
      let yOffset = waveHeight * sin(TWO_PI * frequency * x + frameCount * 0.03);
      let y = j + yOffset + noiseFactor * 5;
      let alpha = map(abs(x - width / 2), 0, width / 2, 255, 50);
      stroke(0, alpha);
      vertex(x, y);
    }
    endShape();
  }
}

function createMountainLayer(heightFactor, mountainColor) {
  let shape = new MountainLayer(heightFactor, mountainColor);
  return shape;
}

function drawMoon() {
  let moonX = width - 150;
  let moonY = 150;
  let moonRadius = 80;
  fill(255, 255, 200);
  noStroke();
  ellipse(moonX, moonY, moonRadius * 2, moonRadius * 2);
}

class Star {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  display() {
    fill(255, 255, 255);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = p5.Vector.random2D().mult(random(0.5, 1.5));
    this.lifespan = random(200, 400);
    this.fillColor = random() < 0.5 ? color(255, 204, 0) : color(255, 255, 255);
    this.trail = [];
  }

  update() {
    this.x += this.velocity.x;
    this.y += this.velocity.y;
    this.lifespan -= 1.5;
    this.velocity.rotate(0.02);
    this.trail.push(createVector(this.x, this.y));
    if (this.trail.length > 25) {
      this.trail.shift();
    }
    if (this.x > width) this.x = 0;
    if (this.x < 0) this.x = width;
    if (this.y > height) this.y = height;
    if (this.y < height / 3) this.y = height / 3;
  }

  display() {
    fill(this.fillColor, map(this.lifespan, 0, 255, 0, 255));
    noStroke();
    ellipse(this.x, this.y, 4, 4);
    for (let i = 0; i < this.trail.length; i++) {
      let p = this.trail[i];
      let alpha = map(i, 0, this.trail.length - 1, 0, 255);
      fill(this.fillColor, alpha);
      ellipse(p.x, p.y, 3, 3);
    }
  }

  isDead() {
    return this.lifespan <= 0;
  }
}

function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

class MountainLayer {
  constructor(heightFactor, mountainColor) {
    this.heightFactor = heightFactor;
    this.mountainColor = mountainColor;
    this.vertices = [];

    let verticalOffset = 275;
    for (let x = 0; x <= width; x += 160) {
      let peakHeight = random(height * heightFactor * 0.6, height * heightFactor * 1.0);
      this.vertices.push({ x: x, y: peakHeight + verticalOffset });
    }
  }

  display() {
    fill(this.mountainColor);
    noStroke();
    beginShape();
    for (let v of this.vertices) {
      vertex(v.x, v.y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}
