let sky;
let ship;
let wave;
let stars = [];
const starCount = 100;

function setup() {
  createCanvas(1200, 800);
  noStroke();

  sky = new Sky(color(135, 206, 235), color(25, 25, 112));
  ship = new Ship(-150, height * 0.65, 0.8);
  wave = new Wave(4, 0.02, 0.005);

  for (let i = 0; i < starCount; i++) {
    stars.push(new Star(random(width), random(height / 2), random(1, 3)));
  }
}

function draw() {
  sky.update();
  sky.display();

  if (sky.currentColor !== sky.dayColor) {
    for (let star of stars) {
      star.display();
    }
  }

  wave.update();
  wave.display();

  ship.update();
  ship.display();
}

class Sky {
  constructor(dayColor, nightColor) {
    this.dayColor = dayColor;
    this.nightColor = nightColor;
    this.currentColor = dayColor;
    this.timeOfDay = 0;
  }

  update() {
    this.timeOfDay += 0.0004;
    if (this.timeOfDay > 1) this.timeOfDay = 0;
    this.currentColor = lerpColor(this.nightColor, this.dayColor, abs(sin(TWO_PI * this.timeOfDay)));
  }

  display() {
    background(this.currentColor);
  }
}

class Wave {
  constructor(waveAmplitude, waveFrequency, waveSpeed) {
    this.waveAmplitude = waveAmplitude;
    this.waveFrequency = waveFrequency;
    this.waveSpeed = waveSpeed;
    this.waveOffset = 0;
  }

  update() {
    this.waveOffset += this.waveSpeed;
  }

  display() {
    fill(30, 144, 255);
    rect(0, height * 0.65, width, height * 0.35);

    for (let x = 0; x < width; x += 5) {
      let waveHeight = sin(this.waveFrequency * x + this.waveOffset) * this.waveAmplitude;
      ellipse(x, height * 0.65 + waveHeight, 10, 10);
    }
  }
}

class Star {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  display() {
    fill(255);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

class Ship {
  constructor(shipX, shipY, shipSpeed) {
    this.shipX = shipX;
    this.shipY = shipY;
    this.shipSpeed = shipSpeed;
  }

  update() {
    this.shipX += this.shipSpeed;
    if (this.shipX > width + 150) this.shipX = -150;
  }

  display() {
    fill(80, 80, 80);
    beginShape();
    vertex(this.shipX - 100, this.shipY);
    vertex(this.shipX + 100, this.shipY);
    vertex(this.shipX + 70, this.shipY + 30);
    vertex(this.shipX - 70, this.shipY + 30);
    endShape(CLOSE);

    fill(255);
    rect(this.shipX - 70, this.shipY - 30, 140, 30, 5);

    fill(0, 0, 255);
    for (let i = -60; i <= 60; i += 30) {
      ellipse(this.shipX + i, this.shipY - 15, 10, 10);
    }

    fill(200, 0, 0);
    rect(this.shipX - 20, this.shipY - 60, 40, 30);
  }
}
