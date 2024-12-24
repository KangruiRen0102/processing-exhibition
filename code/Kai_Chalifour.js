let angle = 0; // For Time (rotating clock-like hands)
let chaosMode = false; // Toggle chaos mode
let timeRadius = 150; // Radius for Time hand
let starSpeed = 2; // Speed of star movement
let stars = []; // Array to store stars

function setup() {
  createCanvas(1600, 900); // Set canvas size
  frameRate(60); // Set frame rate
  colorMode(HSB, 360, 100, 100); // Use HSB color mode

  // Create 500 stars
  for (let i = 0; i < 500; i++) {
    stars.push(new Star());
  }
}

function draw() {
  background(0); // Black background for space

  translate(width / 2, height / 2); // Center the drawing origin

  // Draw stars
  for (let star of stars) {
    star.update();
    star.show();
  }

  // Draw translucent clock face
  fill(0, 0, 100, 0.2);
  noStroke();
  ellipse(0, 0, timeRadius * 2.5, timeRadius * 2.5);

  // Draw clock markings
  stroke(0);
  strokeWeight(1);
  for (let i = 0; i < 12; i++) {
    let markAngle = (TWO_PI / 12) * i;
    let outerX = cos(markAngle) * (timeRadius * 1.2);
    let outerY = sin(markAngle) * (timeRadius * 1.2);
    let innerX = cos(markAngle) * (timeRadius * 1.1);
    let innerY = sin(markAngle) * (timeRadius * 1.1);
    line(outerX, outerY, innerX, innerY);
  }

  // Draw rotating clock-like hands
  push();
  stroke(0);
  strokeWeight(4);
  line(0, 0, cos(angle) * timeRadius, sin(angle) * timeRadius);
  strokeWeight(2);
  line(0, 0, cos(angle * 12) * (timeRadius * 0.6), sin(angle * 12) * (timeRadius * 0.6));
  pop();

  angle += 0.005; // Update Time
}

function keyPressed() {
  if (key === ' ') {
    chaosMode = !chaosMode; // Toggle chaos mode
    for (let star of stars) {
      if (chaosMode) {
        star.startMovingRandomly();
      } else {
        star.stopMovingRandomly();
      }
    }
  }
}

function mouseDragged() {
  timeRadius = map(mouseX, 0, width, 50, 300); // Adjust Time radius interactively
}

class Star {
  constructor() {
    this.x = random(-width, width);
    this.y = random(-height, height);
    this.z = random(width);
    this.pz = this.z;
    this.velX = 0;
    this.velY = 0;
    this.movingRandomly = false;
    this.starColor = random(1) < 0.5 ? color(0, 100, 100) : color(0, 0, 100);
  }

  update() {
    if (this.movingRandomly) {
      this.x += this.velX;
      this.y += this.velY;
    } else {
      this.z -= starSpeed;
      if (this.z < 1) {
        this.z = width;
        this.x = random(-width, width);
        this.y = random(-height, height);
        this.pz = this.z;
      }
    }
  }

  startMovingRandomly() {
    this.movingRandomly = true;
    this.velX = random(-2, 2);
    this.velY = random(-2, 2);
  }

  stopMovingRandomly() {
    this.movingRandomly = false;
    this.velX = 0;
    this.velY = 0;
  }

  show() {
    let sx = map(this.x / this.z, 0, 1, 0, width / 2);
    let sy = map(this.y / this.z, 0, 1, 0, height / 2);
    let r = map(this.z, 0, width, 8, 0);

    fill(this.starColor);
    noStroke();
    ellipse(sx, sy, r, r);

    if (!this.movingRandomly) {
      let px = map(this.x / this.pz, 0, 1, 0, width / 2);
      let py = map(this.y / this.pz, 0, 1, 0, height / 2);
      this.pz = this.z;

      stroke(255);
      line(px, py, sx, sy);
    }
  }
}
