let numStars = 200;
let stars = [];
let shootingStar;
let skyline;

function setup() {
  createCanvas(800, 600);

  // Create graphics for the city skyline
  skyline = createGraphics(width, height);
  drawCitySkyline();

  // Initialize stars
  for (let i = 0; i < numStars; i++) {
    stars.push(new Star());
  }

  // Initialize shooting star
  shootingStar = new ShootingStar();
}

function draw() {
  // Draw the skyline
  image(skyline, 0, 0);

  // Display stars
  for (let star of stars) {
    star.display();
  }

  // Trigger shooting stars randomly
  if (random(1) < 0.01) {
    shootingStar.reset();
  }
  shootingStar.move();
  shootingStar.display();
}

function drawCitySkyline() {
  skyline.background(0);

  // Building data (position, width, height, color)
  let buildings = [
    { x: 50, h: 300, w: 50, c: color(150, 100, 200) },
    { x: 130, h: 250, w: 60, c: color(100, 150, 255) },
    { x: 220, h: 350, w: 50, c: color(255, 100, 100) },
    { x: 300, h: 200, w: 40, c: color(200, 200, 100) },
    { x: 380, h: 400, w: 70, c: color(100, 255, 100) },
    { x: 470, h: 300, w: 60, c: color(255, 200, 150) },
    { x: 550, h: 220, w: 50, c: color(100, 200, 255) },
    { x: 630, h: 370, w: 60, c: color(255, 150, 200) },
  ];

  for (let building of buildings) {
    skyline.fill(building.c);
    skyline.rect(building.x, height - building.h, building.w, building.h);
    drawWindows(skyline, building.x, height - building.h, building.w, building.h);
  }
}

function drawWindows(pg, x, y, w, h) {
  pg.fill(255, 255, 0, 200);
  for (let j = y + 10; j < height; j += 20) {
    for (let i = x + 5; i < x + w - 5; i += 10) {
      pg.rect(i, j, 5, 10);
    }
  }
}

class Star {
  constructor() {
    this.x = random(width);
    this.y = random(height);
    this.brightness = random(150, 255);
  }

  display() {
    fill(this.brightness);
    noStroke();
    ellipse(this.x, this.y, 2, 2);
  }
}

class ShootingStar {
  constructor() {
    this.reset();
  }

  reset() {
    this.x = random(width);
    this.y = random(height / 8);
    this.speedX = random(-10, -20);
    this.speedY = random(2, 5);
    this.active = true;
  }

  move() {
    if (this.active) {
      this.x += this.speedX;
      this.y += this.speedY;
      if (this.x < 0 || this.y > height) {
        this.active = false;
      }
    }
  }

  display() {
    if (this.active) {
      stroke(255);
      strokeWeight(2);
      line(this.x, this.y, this.x + this.speedX * 2, this.y + this.speedY * 2);
    }
  }
}
