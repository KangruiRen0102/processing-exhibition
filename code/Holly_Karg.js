let ripples = [];
let circles = [];

let waveHeight = 20;
let waveFrequency = 0.05;

let circleX = 1;
let circleY = 1;
let circleRadius = 5;

function setup() {
  createCanvas(800, 600);
  background(130, 213, 232);
}

function mousePressed() {
  circleX = mouseX;
  circleY = mouseY;
  circleRadius = random(5, 100);

  circles.push(new Circle(circleX, circleY, circleRadius));
  ripples.push(new Ripple(mouseX, mouseY));
}

function draw() {
  drawWaves();

  for (let c of circles) {
    fill(255);
    ellipse(c.x, c.y, c.radius * 2, c.radius * 2);
  }

  for (let i = ripples.length - 1; i >= 0; i--) {
    let ripple = ripples[i];
    ripple.update();
    ripple.display();

    if (ripple.alpha <= 0) {
      ripples.splice(i, 1);
    }
  }
}

function drawWaves() {
  noFill();
  stroke(0, 0, 139);
  strokeWeight(2);

  let offset = 0;

  for (let y = 100; y < height; y += 30) {
    beginShape();
    for (let x = 0; x <= width; x++) {
      let wave = sin(x * waveFrequency + offset) * waveHeight;
      let clampedWave = constrain(wave, -waveHeight, waveHeight);
      vertex(x, y + clampedWave);
    }
    endShape();
  }
}

class Circle {
  constructor(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }
}

class Ripple {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.radius = circleRadius;
    this.alpha = 600;
  }

  update() {
    this.radius += 2;
    this.alpha -= 5;
  }

  display() {
    noFill();
    stroke(255, this.alpha);
    strokeWeight(0.5);
    ellipse(this.x, this.y, this.radius, this.radius);
  }
}
