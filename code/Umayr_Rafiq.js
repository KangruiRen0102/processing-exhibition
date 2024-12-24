let stars = []; // Array to hold the stars
let starCount = 200; // Number of stars
let waveOffsets = []; // Offsets for aurora waves
let shootingStar = null; // For the shooting star effect

function setup() {
  createCanvas(800, 600);

  // Initialize stars for the background
  for (let i = 0; i < starCount; i++) {
    stars.push(new Star());
  }

  // Initialize offsets for aurora waves
  for (let i = 0; i < 5; i++) {
    waveOffsets.push(random(1000));
  }
}

function draw() {
  background(0); // Black background for the night sky

  drawStars(); // Drawing infinite stars in the sky
  drawAurora(); // Draw aurora waves
  drawPath(); // Draw a journey path which leads into the horizon

  // Draw and update shooting star if it exists
  if (shootingStar !== null) {
    shootingStar.update();
    shootingStar.display();
    if (shootingStar.isOffScreen()) {
      shootingStar = null; // Remove shooting star if it leaves the screen
    }
  }
}

// Class to represent a single star
class Star {
  constructor() {
    this.x = random(width);
    this.y = random(height);
    this.brightness = random(50, 255); // Random brightness for each star
  }

  display() {
    fill(this.brightness);
    noStroke();
    ellipse(this.x, this.y, 2, 2); // Stars as tiny circles
  }
}

function drawStars() {
  for (let s of stars) {
    s.display();
  }
}

function drawAurora() {
  noFill();
  for (let i = 0; i < waveOffsets.length; i++) {
    // Change aurora color based on mouse position
    let t = map(mouseX, 0, width, 0, 1);
    stroke(lerpColor(color(0, 150, 255, 150), color(150, 50, 255, 150), t));
    strokeWeight(10 - i * 2); // Waves get thinner
    beginShape();
    for (let x = 0; x < width; x += 10) {
      let y = map(noise(x * 0.01, waveOffsets[i]), 0, 1, height / 4, height / 2);
      vertex(x, y);
    }
    endShape();
    waveOffsets[i] += 0.01; // Create animation by shifting offsets
  }
}

function drawPath() {
  noStroke();
  for (let i = 0; i < 10; i++) {
    fill(50, 50, 50, 150 - i * 15); // Gradual fading of the path
    beginShape();
    vertex(width / 2 - i * 20, height);
    vertex(width / 2 + i * 20, height);
    vertex(width / 2 + i * 10, height / 2 + i * 50);
    vertex(width / 2 - i * 10, height / 2 + i * 50);
    endShape(CLOSE);
  }
}

// Class for shooting star
class ShootingStar {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.speedX = random(-5, -3); // Shooting left
    this.speedY = random(-2, -1); // Slightly upward
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
  }

  display() {
    stroke(255, 255, 100);
    strokeWeight(3);
    line(this.x, this.y, this.x - 10 * this.speedX, this.y - 10 * this.speedY); // Draw the streak
  }

  isOffScreen() {
    return this.x < 0 || this.y > height / 2;
  }
}

function mousePressed() {
  // Click changes aurora colors dynamically (trigger redraw)
  redraw();
}

function keyPressed() {
  if (key === 's' || key === 'S') {
    // Press 'S' to spawn a shooting star
    shootingStar = new ShootingStar(width, height - random(50, 150));
  }
}
