let snowflakes = [];
let isFrozen = false;
let explode = false;
let geyserActive = false;
let bgColor;
let topColor;
let bottomColor;

function setup() {
  createCanvas(800, 800);
  frameRate(30);
  noStroke();
  topColor = color(0, 0, 0);
  bottomColor = color(0, 0, 255);
  
  for (let i = 0; i < 400; i++) {
    snowflakes.push(new Snowflake(random(width), random(height / 2), random(5, 15)));
  }
}

function draw() {
  createGradientBackground();

  for (let snowflake of snowflakes) {
    snowflake.update();
    snowflake.display();
  }

  if (geyserActive) {
    createGeyser();
  }
}

function mousePressed() {
  isFrozen = true;
}

function mouseReleased() {
  isFrozen = false;
  explode = true;
  applyExplosionForce(mouseX, mouseY);
}

function keyPressed() {
  if (key === ' ') {
    geyserActive = true;
  }
}

function keyReleased() {
  if (key === ' ') {
    geyserActive = false;
  }
}

function createGradientBackground() {
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0.0, 1.0);
    let c = lerpColor(topColor, bottomColor, inter);
    stroke(c);
    line(0, y, width, y);
  }
}

function applyExplosionForce(mouseX, mouseY) {
  for (let snowflake of snowflakes) {
    let distance = dist(mouseX, mouseY, snowflake.x, snowflake.y);
    if (distance < 150) {
      snowflake.applyExplosionForce(mouseX, mouseY);
    }
  }
}

function createGeyser() {
  let geyserX = width / 2;
  let geyserY = height;

  for (let i = 0; i < 20; i++) {
    let angle = random(TWO_PI);
    let speed = random(5, 10);
    let forceX = cos(angle) * speed;
    let forceY = sin(angle) * speed;
    let size = random(5, 15);

    snowflakes.push(new Snowflake(geyserX, geyserY, size, forceX, forceY));
  }
}

class Snowflake {
  constructor(x, y, size, forceX = 0, forceY = 0) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speedY = random(2, 6);
    this.forceX = forceX;
    this.forceY = forceY;
    this.shapeType = int(random(0, 2));
  }

  update() {
    if (isFrozen) return;

    this.x += this.forceX;
    this.y += this.forceY;

    if (this.forceX === 0 && this.forceY === 0) {
      this.y += this.speedY;
    }

    if (this.y > height) {
      this.y = random(-10, -50);
    }
  }

  applyExplosionForce(mouseX, mouseY) {
    let angle = atan2(this.y - mouseY, this.x - mouseX);
    let distance = dist(mouseX, mouseY, this.x, this.y);
    let force = map(distance, 0, 150, 5, 25);

    this.forceX = cos(angle) * force;
    this.forceY = sin(angle) * force;

    if (this.forceX !== 0 || this.forceY !== 0) {
      this.speedY = random(4, 8);
    }
  }

  display() {
    fill(255, 255, 255, 180);
    if (this.shapeType === 0) {
      ellipse(this.x, this.y, this.size, this.size);
    } else {
      this.drawStar(this.x, this.y, this.size, this.size / 2, 5);
    }
  }

  drawStar(x, y, radius1, radius2, npoints) {
    let angle = TWO_PI / npoints;
    let halfAngle = angle / 2.0;
    beginShape();
    for (let a = -PI / 2; a < TWO_PI - PI / 2; a += angle) {
      let sx = x + cos(a) * radius2;
      let sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius1;
      sy = y + sin(a + halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}

