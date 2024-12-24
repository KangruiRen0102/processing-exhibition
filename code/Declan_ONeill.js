let numParts = 100;
let partWidth;
let oceanColors = [];
let currentColors = [];
let changeTime = 300;
let lastChangeTime = 0;
let fishPos;
let fish;
let facing = true;
let waveOffsets;
let waveSpeed = 0.05;
let waveAmplitude = 100;
let waveFrequency = 0.01;
let bubbles = [];
let shapeVisible = false;
let shapeType;
let shapePos;
let shapeSize;
let shapeStartTime;
let seaweeds = [];
let jellyfishMarkers = [];
let jellyfish = [];
let sharks = [];

function setup() {
  createCanvas(800, 600);
  partWidth = width / numParts;
  oceanColors = [color(10, 30, 80), color(15, 45, 100), color(20, 60, 120)];
  currentColors = Array.from({ length: numParts }, () => random(oceanColors));

  waveOffsets = Array.from({ length: numParts }, () => random(TWO_PI));

  fish = createFishImage(true);
  fishPos = createVector(width / 2, height / 2);

  for (let i = 0; i < 10; i++) {
    seaweeds.push(new Seaweed(random(width), height, random(50, 300)));
  }

  for (let i = 0; i < 6; i++) {
    sharks.push(new Shark(0, random(height)));
  }
}

function draw() {
  background(0);

  for (let i = 0; i < numParts; i++) {
    let waveY = sin(waveOffsets[i]) * waveAmplitude;
    fill(currentColors[i]);
    noStroke();
    rect(i * partWidth, waveY, partWidth, height);
    waveOffsets[i] += waveSpeed;
  }

  if (millis() - lastChangeTime > changeTime) {
    currentColors = Array.from({ length: numParts }, () => random(oceanColors));
    lastChangeTime = millis();
  }

  seaweeds.forEach((seaweed) => seaweed.display());

  for (let i = bubbles.length - 1; i >= 0; i--) {
    let b = bubbles[i];
    b.update();
    b.display();
    if (b.isOffScreen()) {
      bubbles.splice(i, 1);
    }
  }

  for (let i = jellyfishMarkers.length - 1; i >= 0; i--) {
    let c = jellyfishMarkers[i];
    c.update();
    c.display();
    if (c.isExpired()) {
      jellyfishMarkers.splice(i, 1);
    }
  }

  jellyfish.forEach((j) => {
    j.update();
    j.display();
  });

  sharks.forEach((s) => {
    s.update();
    s.display();
  });

  push();
  translate(fishPos.x, fishPos.y);
  if (!facing) {
    scale(-1, 1);
  }
  image(fish, -fish.width / 2, -fish.height / 2);
  pop();

  if (mouseIsPressed && mouseButton === LEFT) {
    fishPos.x = lerp(fishPos.x, mouseX, 0.05);
  }

  if (shapeVisible && millis() - shapeStartTime < 5000) {
    drawRandomShape(shapeType, shapePos.x, shapePos.y, shapeSize);
  } else {
    shapeVisible = false;
  }
}

function mousePressed() {
  if (mouseButton === LEFT) {
    facing = mouseX > fishPos.x;
    shapeVisible = true;
    shapeType = int(random(3));
    shapePos = createVector(random(width), random(height));
    shapeSize = int(random(20, 60));
    shapeStartTime = millis();

    for (let i = 0; i < 5; i++) {
      bubbles.push(new Bubble(fishPos.x, fishPos.y));
    }

    jellyfishMarkers.push(new JellyFishMarker(mouseX, mouseY));
    jellyfish.push(new Jellyfish(mouseX, mouseY));

    sharks.forEach((s) => {
      if (dist(mouseX, mouseY, s.pos.x, s.pos.y) < 50) {
        s.startDragging();
      }
    });
  } else if (mouseButton === RIGHT) {
    resetScene();
  }
}

function mouseReleased() {
  sharks.forEach((s) => s.stopDragging());
}

function resetScene() {
  sharks.forEach((s) => {
    s.pos.set(0, random(height));
  });
  bubbles = [];
  seaweeds = [];
  jellyfishMarkers = [];
  jellyfish = [];

  for (let i = 0; i < 10; i++) {
    seaweeds.push(new Seaweed(random(width), height, random(50, 300)));
  }
}

function drawRandomShape(type, x, y, size) {
  switch (type) {
    case 0:
      fill(200, 100, 200, 150);
      ellipse(x, y, size, size);
      break;
    case 1:
      fill(255, 200, 0, 150);
      drawStar(x, y, size / 2, size, 5);
      break;
    case 2:
      fill(255, 182, 193, 150);
      arc(x, y, size, size, PI, TWO_PI);
      break;
  }
}

function drawStar(x, y, radius1, radius2, npoints) {
  let angle = TWO_PI / npoints;
  let halfAngle = angle / 2.0;
  beginShape();
  for (let a = 0; a < TWO_PI; a += angle) {
    let sx = x + cos(a) * radius2;
    let sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a + halfAngle) * radius1;
    sy = y + sin(a + halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

function createFishImage(facing) {
  let fishWidth = 60;
  let fishHeight = 30;
  let fish = createGraphics(fishWidth, fishHeight);
  fish.clear();
  fish.noStroke();
  fish.fill(255, 140, 0);
  fish.ellipse(facing ? 20 : fishWidth - 20, fishHeight / 2, 30, 30);
  return fish;
}

class Bubble {
  constructor(x, y) {
    this.pos = createVector(x, y);
    this.radius = random(5, 15);
    this.speed = random(1, 3);
  }

  update() {
    this.pos.y -= this.speed;
  }

  display() {
    noStroke();
    fill(200, 200, 255, 150);
    ellipse(this.pos.x, this.pos.y, this.radius, this.radius);
  }

  isOffScreen() {
    return this.pos.y + this.radius < 0;
  }
}

class Seaweed {
  constructor(x, baseY, height) {
    this.x = x;
    this.baseY = baseY;
    this.height = height;
    this.swayOffset = random(TWO_PI);
  }

  display() {
    stroke(0, 200, 0);
    strokeWeight(4);
    noFill();
    let sway = sin(this.swayOffset) * 10;
    beginShape();
    for (let i = 0; i < 10; i++) {
      let y = lerp(this.baseY, this.baseY - this.height, i / 10.0);
      let xOffset = sway * (i / 10.0);
      vertex(this.x + xOffset, y);
    }
    endShape();
    this.swayOffset += 0.02;
  }
}

class JellyFishMarker {
  constructor(x, y) {
    this.pos = createVector(x, y);
    this.size = random(30, 70);
    this.creationTime = millis();
  }

  update() {}

  display() {
    fill(255, 0, 0);
    noStroke();
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
  }

  isExpired() {
    return millis() - this.creationTime > 5000;
  }
}

class Jellyfish {
  constructor(x, y) {
    this.pos = createVector(x, y);
    this.size = random(30, 60);
    this.floatSpeed = random(0.1, 0.3);
    this.bodyColor = color(random(0, 255), random(0, 255), random(0, 255), 150);
    this.pulseTimer = random(100);
  }

  update() {
    this.pos.y += this.floatSpeed;
    this.pulseTimer += 0.1;
    this.bodyColor = color(
      sin(this.pulseTimer) * 100 + 100,
      sin(this.pulseTimer + PI / 3) * 100 + 100,
      sin(this.pulseTimer + PI / 2) * 100 + 100,
      150
    );
  }

  display() {
    noStroke();
    fill(this.bodyColor);
    ellipse(this.pos.x, this.pos.y, this.size, this.size * 1.5);
  }
}

class Shark {
  constructor(x, y) {
    this.pos = createVector(x, y);
    this.size = random(60, 120);
    this.dragging = false;
    this.dragOffset = createVector();
  }

  update() {
    if (this.dragging) {
      this.pos.x = lerp(this.pos.x, mouseX - this.dragOffset.x, 0.1);
      this.pos.y = lerp(this.pos.y, mouseY - this.dragOffset.y, 0.1);
    } else {
      this.pos.x += 2;
      if (this.pos.x > width) {
        this.pos.x = 0;
      }
    }
  }

  display() {
    fill(100, 100, 255);
    noStroke();
    ellipse(this.pos.x, this.pos.y, this.size, this.size / 2);
    fill(200, 200, 255);
    triangle(
      this.pos.x - this.size / 2,
      this.pos.y,
      this.pos.x - this.size / 2 - 20,
      this.pos.y - 20,
      this.pos.x - this.size / 2 - 20,
      this.pos.y + 20
    );
  }

  startDragging() {
    this.dragging = true;
    this.dragOffset.set(mouseX - this.pos.x, mouseY - this.pos.y);
  }

  stopDragging() {
    this.dragging = false;
  }
}
