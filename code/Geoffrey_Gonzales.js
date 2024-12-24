// Sky Generation
let sky1 = [237, 165, 80]; // Lower sky color
let sky2 = [0, 92, 159]; // Upper sky color
let currentSkyColor = sky2;

// Wave Generation
let waves = [];

// Cloud Generation
let clouds = [];
let currentCloudColor;

// Rain Generation
let rain = [];
let rainActive = false;

function setup() {
  createCanvas(1000, 800);
  frameRate(45);
  currentCloudColor = color(255, 240, 210);

  // Initialize waves
  for (let i = 0; i < 5; i++) {
    let wave = new Wave(2, random(20, 30), random(350, 430), 150 + i * 50, width, color(random(40, 80), random(80, 120), random(100, 190)));
    waves.push(wave);
  }

  // Initialize clouds
  for (let i = 0; i < 8; i++) {
    let x = random(width);
    let y = random(50, 300);
    clouds.push(new Cloud(x, y, int(random(15, 25)), 90, currentCloudColor));
  }

  // Initialize rain
  for (let i = 0; i < 80; i++) {
    rain.push(new RainDrop(random(width), random(-height, 0), random(4, 6)));
  }
}

function draw() {
  background(255);
  drawSky();
  drawSun();

  // Draw waves
  for (let wave of waves) {
    wave.update();
  }

  // Draw clouds
  for (let cloud of clouds) {
    cloud.setColor(currentCloudColor);
    cloud.display();
  }

  // Draw rain if active
  if (rainActive) {
    for (let drop of rain) {
      drop.fall();
      drop.display();
    }
  }
}

function drawSky() {
  for (let y = 0; y < height / 2; y++) {
    let inter = map(y, 0, height / 2, 0, 1);
    let c = lerpColor(color(sky1), color(sky2), inter);
    stroke(c);
    line(0, y, width, y);
  }
}

function drawSun() {
  noStroke();
  for (let i = 0; i < 150; i += 2) {
    let opacity = map(i, 0, 150, 50, 0);
    fill(237, 165 + i / 2, 80 + i, opacity);
    ellipse(500, 600, 300 - i * 2, 300 - i * 2);
  }
}

class Wave {
  constructor(wavespace, amplitude, period, ywave, width, waveColor) {
    this.wavespace = wavespace;
    this.amplitude = amplitude;
    this.period = period;
    this.ywave = ywave;
    this.waveColor = waveColor;
    this.theta = random(TWO_PI);
    this.dx = (TWO_PI / this.period) * this.wavespace;
    this.waveheights = Array.from({ length: width / this.wavespace }, () => 0);
  }

  update() {
    this.theta += 0.01;
    let x = this.theta;
    for (let i = 0; i < this.waveheights.length; i++) {
      this.waveheights[i] = sin(x) * this.amplitude + this.ywave;
      x += this.dx;
    }
    this.display();
  }

  display() {
    fill(this.waveColor);
    noStroke();
    for (let i = 0; i < this.waveheights.length; i++) {
      ellipse(i * this.wavespace, this.waveheights[i], 16, 16);
    }
  }
}

class Cloud {
  constructor(x, y, numEllipses, sizeRange, cloudColor) {
    this.position = createVector(x, y);
    this.numEllipses = numEllipses;
    this.sizeRange = sizeRange;
    this.cloudColor = cloudColor;
    this.ellipses = Array.from({ length: numEllipses }, () => ({
      x: random(-sizeRange, sizeRange),
      y: random(-sizeRange / 3, sizeRange / 3),
      size: random(sizeRange / 2, sizeRange),
    }));
  }

  setColor(newColor) {
    this.cloudColor = newColor;
  }

  display() {
    fill(this.cloudColor);
    noStroke();
    for (let e of this.ellipses) {
      ellipse(this.position.x + e.x, this.position.y + e.y, e.size, e.size / 2);
    }
  }
}

class RainDrop {
  constructor(x, y, speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

  fall() {
    this.y += this.speed;
    if (this.y > height) {
      this.y = random(-height * 0.5, 0);
      this.x = random(width);
    }
  }

  display() {
    stroke(21, 76, 121);
    line(this.x, this.y, this.x, this.y + 10);
  }
}

function mousePressed() {
  if (mouseY > 350) {
    return;
  } else {
    clouds.push(new Cloud(mouseX, mouseY, int(random(15, 20)), 90, currentCloudColor));
  }
}

function keyPressed() {
  if (key === '1') {
    sky1 = [0, 92, 159];
    sky2 = [237, 165, 80];
    currentCloudColor = color(255, 240, 210);
    rainActive = false;
  } else if (key === '2') {
    sky1 = [124, 58, 85];
    sky2 = [196, 164, 167];
    currentCloudColor = color(196, 164, 167);
    rainActive = false;
  } else if (key === '3') {
    sky1 = [13, 23, 29];
    sky2 = [59, 64, 64];
    currentCloudColor = color(59, 64, 64);
    rainActive = true;
  }
}
