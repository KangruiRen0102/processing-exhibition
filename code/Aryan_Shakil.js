let snowflakes = [];
let windowAlpha = 0;
let fadeDirection = true;
let memoryEffect = false;

function setup() {
  createCanvas(800, 600);
  for (let i = 0; i < 100; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  if (memoryEffect) {
    background(80, 30, 40);
  } else {
    background(30, 40, 80);
  }

  updateWindowAlpha();
  drawCitySilhouette();
  drawGroundLayer();

  for (let s of snowflakes) {
    s.update();
    s.display();
  }
}

function mousePressed() {
  memoryEffect = !memoryEffect;
}

function updateWindowAlpha() {
  if (fadeDirection) {
    windowAlpha += 2;
    if (windowAlpha >= 255) {
      fadeDirection = false;
    }
  } else {
    windowAlpha -= 2;
    if (windowAlpha <= 50) {
      fadeDirection = true;
    }
  }
}

function drawGroundLayer() {
  fill(10, 10, 10);
  noStroke();
  rect(0, height * 0.85, width, height * 0.15);
}

function drawCitySilhouette() {
  noStroke();

  drawBuildingWithWindows(0, height * 0.4, width * 0.1, height * 0.6);
  drawBuildingWithWindows(width * 0.12, height * 0.3, width * 0.12, height * 0.7);
  drawBuildingWithWindows(width * 0.25, height * 0.5, width * 0.1, height * 0.5);
  drawBuildingWithWindows(width * 0.36, height * 0.35, width * 0.18, height * 0.65);
  drawBuildingWithWindows(width * 0.54, height * 0.4, width * 0.1, height * 0.6);
  drawBuildingWithWindows(width * 0.66, height * 0.3, width * 0.15, height * 0.7);
  drawBuildingWithWindows(width * 0.82, height * 0.5, width * 0.1, height * 0.5);
  drawBuildingWithWindows(width * 0.94, height * 0.4, width * 0.06, height * 0.6);
}

function drawBuildingWithWindows(x, y, w, h) {
  fill(20, 20, 20);
  rect(x, y, w, h);

  fill(220, 220, 200, windowAlpha);
  let windowSize = w * 0.15;
  let spacing = w * 0.05;

  for (let i = x + spacing; i < x + w - windowSize; i += windowSize + spacing) {
    for (let j = y + spacing; j < y + h - windowSize; j += windowSize + spacing) {
      rect(i, j, windowSize, windowSize);
    }
  }
}

class Snowflake {
  constructor() {
    this.x = random(width);
    this.y = random(-height, 0);
    this.speed = random(1, 3);
    this.size = random(2, 5);
  }

  update() {
    this.y += this.speed;
    if (this.y > height) {
      this.y = random(-height, 0);
      this.x = random(width);
    }
  }

  display() {
    fill(255);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}
