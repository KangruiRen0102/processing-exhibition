let time = 0; // Animation timer
let numCircles = 100; // Number of circles to draw
let scaleFactor = 1.0; // Overall zoom
let infinityScale = 1.0; // Size of the infinity symbol
let rotationAngle = 0; // Rotation
let rotationSpeed = 0.01; // Speed of rotation
let isPaused = false; // Pause toggle
let particles = []; // Persistent particle explosions

function setup() {
  createCanvas(800, 800);
  frameRate(60);
  noStroke();
}

function draw() {
  if (isPaused) return;

  background(20); // Dark background
  translate(width / 2, height / 2); // Center the drawing

  // Adjust scaling and rotation
  scale(scaleFactor);
  rotate(rotationAngle);

  drawInfinitySymbol();
  updateParticles();

  time += 0.01; // Advance animation
  rotationAngle += rotationSpeed; // Continuous rotation
}

function drawInfinitySymbol() {
  for (let i = 0; i < numCircles; i++) {
    let progress = map(i, 0, numCircles, 0, TWO_PI);
    let t = progress + time;

    // Parametric equations for the infinity symbol with scaling
    let a = 150 * infinityScale;
    let b = 300 * infinityScale;

    let x = (b * cos(t)) / (1 + pow(sin(t), 2));
    let y = (a * cos(t) * sin(t)) / (1 + pow(sin(t), 2));

    let size = map(sin(t + time), -1, 1, 10, 30); // Circle size oscillation
    fill(lerpColor(color(0, 255, 100), color(0, 100, 255), sin(t + time) * 0.5 + 0.5));

    ellipse(x, y, size, size);
  }
}

function updateParticles() {
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    // Remove dead particles
    if (p.isDead()) {
      particles.splice(i, 1);
    }
  }
}

function mousePressed() {
  if (mouseButton === LEFT) {
    triggerExplosion();
  }
}

function triggerExplosion() {
  for (let i = 0; i < 50; i++) {
    let angle = random(TWO_PI);
    let speed = random(2, 5);
    particles.push(new Particle(0, 0, cos(angle) * speed, sin(angle) * speed));
  }
}

class Particle {
  constructor(x, y, vx, vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = int(random(4, 8));
    this.particleColor = color(random(50, 255), random(50, 255), 255);
    this.life = 255; // Particle life
  }

  update() {
    this.x += this.vx * 0.5; // Move slowly outward
    this.y += this.vy * 0.5;
    this.life -= 2; // Gradually fade out
  }

  display() {
    fill(this.particleColor, this.life);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }

  isDead() {
    return this.life <= 0;
  }
}

function mouseWheel(event) {
  // Increase or decrease the number of circles
  numCircles += event.delta > 0 ? -5 : 5;
  numCircles = constrain(numCircles, 10, 200);
}

function keyPressed() {
  if (key === ' ') {
    isPaused = !isPaused; // Toggle pause
  } else if (keyCode === UP_ARROW) {
    // Increase the speed of rotation
    rotationSpeed += 0.005;
  } else if (keyCode === DOWN_ARROW) {
    // Decrease the speed of rotation
    rotationSpeed = max(0.001, rotationSpeed - 0.005);
  } else if (keyCode === LEFT_ARROW) {
    // Decrease overall zoom (scaleFactor)
    scaleFactor = max(0.5, scaleFactor - 0.1);
  } else if (keyCode === RIGHT_ARROW) {
    // Increase overall zoom (scaleFactor)
    scaleFactor = min(2.0, scaleFactor + 0.1);
  } else if (key === '+') {
    // Increase the number of circles
    numCircles = min(200, numCircles + 10);
  } else if (key === '-') {
    // Decrease the number of circles
    numCircles = max(10, numCircles - 10);
  } else if (key === 'w' || key === 'W') {
    // Increase the size of the infinity symbol
    infinityScale = min(3.0, infinityScale + 0.1);
  } else if (key === 's' || key === 'S') {
    // Decrease the size of the infinity symbol
    infinityScale = max(0.5, infinityScale - 0.1);
  }
}
