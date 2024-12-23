let waves = [];
let particles = [];
let stars = [];
let sunRadius = 50;
let timeCounter = 0;
let sunPos;
let sunsetTop, sunsetBottom;

const Y_AXIS = 1; // Gradient axis

function setup() {
  createCanvas(800, 800);
  waves = [];
  particles = [];
  stars = [];
  sunsetTop = color(255, 94, 77); // Vibrant orange-red
  sunsetBottom = color(50, 20, 100); // Deep purple-blue
  sunPos = createVector(width / 2, height / 4);

  // Create initial waves
  for (let i = 0; i < 5; i++) {
    waves.push(new Wave(height - 150 + i * 30));
  }

  // Create stars
  for (let i = 0; i < 100; i++) {
    stars.push(new Star());
  }
}

function draw() {
  // Constant sunset background
  setGradient(0, 0, width, height, sunsetTop, sunsetBottom, Y_AXIS);

  // Draw twinkling stars
  for (let star of stars) {
    star.twinkle();
    star.display();
  }

  // Pulsating "hope" sun
  let pulse = sin(timeCounter * 0.05) * 20;
  fill(255, 204, 0, 180);
  noStroke();
  ellipse(sunPos.x, sunPos.y, sunRadius + pulse, sunRadius + pulse);

  // Update and draw waves
  for (let wave of waves) {
    wave.update();
    wave.display();
  }

  // Add flowing particles
  if (frameCount % 3 === 0) {
    particles.push(new Particle(random(width), height - 150, color(random(100, 200), random(100, 200), 255)));
  }

  // Update and display particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
    if (p.isOffScreen()) {
      particles.splice(i, 1);
    }
  }

  // Increment time
  timeCounter++;
}

class Particle {
  constructor(x, y, col) {
    this.position = createVector(x, y);
    this.velocity = createVector(random(-1, 1), random(-2, -1));
    this.col = col;
  }

  update() {
    this.position.add(this.velocity);
    this.velocity.x += random(-0.05, 0.05);
  }

  display() {
    fill(this.col, 150);
    noStroke();
    ellipse(this.position.x, this.position.y, 5, 5);
  }

  isOffScreen() {
    return this.position.y < height - 200 || this.position.x < 0 || this.position.x > width;
  }
}

class Wave {
  constructor(offsetY) {
    this.offsetY = offsetY;
    this.offsetX = random(0, TWO_PI); // Random phase offset
    this.noiseOffset = random(0, 100); // Start with random noise
    this.waveSpeed = 0.05; // Increased speed for faster motion
    this.waveAmplitude = 20;
  }

  update() {
    this.offsetX += this.waveSpeed; // Faster horizontal shift
    this.noiseOffset += 0.01; // Increment noise for organic effect
  }

  display() {
    noFill();
    stroke(100, 150, 255, 180);
    strokeWeight(2);
    beginShape();
    for (let x = 0; x < width; x += 5) {
      let waveNoise = noise(this.noiseOffset + x * 0.01) * 2; // Subtle variation
      let y = sin((x + this.offsetX) * 0.05) * (this.waveAmplitude + waveNoise) + this.offsetY;
      vertex(x, y);
    }
    endShape();
  }
}

class Star {
  constructor() {
    this.x = random(width);
    this.y = random(height / 2); // Stars only in the top half
    this.size = random(1, 3);
    this.twinkleSpeed = int(random(5, 30)); // Faster twinkling
    this.starColor = color(255, 255, 200, random(100, 255));
  }

  twinkle() {
    if (frameCount % this.twinkleSpeed === 0) {
      this.starColor = color(255, 255, 200, random(100, 255));
    }
  }

  display() {
    fill(this.starColor);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}

function setGradient(x, y, w, h, c1, c2, axis) {
  noFill();
  for (let i = 0; i <= h; i++) {
    let inter = map(i, 0, h, 0, 1);
    let c = lerpColor(c1, c2, inter);
    if (axis === Y_AXIS) {
      stroke(c);
      line(x, y + i, x + w, y + i);
    }
  }
}
