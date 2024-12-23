let mugCenterX = 400, mugCenterY = 400; // Mug center
let liquidLevel = 330; // height for steam and marshmallow float reference
let steamParticles = []; // Steam particles
let marshmallows = []; // Array for marshmallows
let selectedMarshmallow = null; // Currently dragged marshmallow
const marshmallowSize = 50;

function setup() {
  createCanvas(800, 800); // Canvas size
  frameRate(60); // Set a higher frame rate for smoother animation

  for (let i = 0; i < 5; i++) {
    let startX = mugCenterX + random(-17, 17) * 9; // Random horizontal position
    let startY = random(0, 400); // Random vertical position
    marshmallows.push(new Marshmallow(startX, startY, marshmallowSize));
  }
}

function draw() {
  background(135, 206, 235); // Light gray background
  drawTable();
  drawCup(); // Draw the cup and saucer

  // Display and interact with marshmallows
  for (let m of marshmallows) {
    m.update();
    m.display();
  }

  drawSteam(); // Draw animated steam
}

function drawTable() {
  stroke(0);
  strokeWeight(2);
  fill(255);
  rect(0, 550, 800, 800);
}

function drawCup() {
  // Saucer
  stroke(0);
  strokeWeight(2);
  fill(255);
  ellipse(400, 700, 600, 290);
  noStroke();
  fill(0, 0, 0, 50);
  ellipse(400, 700, 440, 190);

  // Cup body
  stroke(0);
  strokeWeight(2);
  fill(255);
  rect(175, 350, 450, 250, 30);
  ellipse(400, 600, 450, 300);
  fill(255);
  ellipse(400.5, 585, 448, 300);
  stroke(0);
  strokeWeight(2);
  fill(255);
  ellipse(400, 350, 450, 180);

  // Liquid
  noStroke();
  fill(150, 75, 0);
  ellipse(400, 355, 410, 165);
  fill(80, 40, 0);
  ellipse(400, 355, 400, 155);
}

function drawSteam() {
  if (frameCount % 10 === 0) {
    steamParticles.push(new SteamParticle(mugCenterX, liquidLevel - 30));
  }

  for (let i = steamParticles.length - 1; i >= 0; i--) {
    let p = steamParticles[i];
    p.update();
    p.display();

    if (p.lifespan <= 0) {
      steamParticles.splice(i, 1);
    }
  }
}

class SteamParticle {
  constructor(startX, startY) {
    this.x = startX + random(-100, 100);
    this.y = startY + random(-50, 50);
    this.vx = random(-0.5, 0.5);
    this.vy = random(-1, -5);
    this.lifespan = 150;
    this.noiseOffset = random(1000);
  }

  update() {
    this.x += this.vx;
    this.y += this.vy;
    this.lifespan -= 1;
    this.vx = map(noise(this.noiseOffset), 0, 1, -1, 1);
    this.vy = map(noise(this.noiseOffset + 100), 0, 1, -1, -2);
    this.noiseOffset += 0.01;
  }

  display() {
    noStroke();
    fill(255, this.lifespan);
    ellipse(this.x, this.y, 12, 24);
  }
}

class Marshmallow {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.isFloating = true;
    this.randomFloatOffset = random(-5, 35) * 2;
    this.floatingSpeed = random(0.05, 0.1);
    this.targetY = liquidLevel + this.randomFloatOffset;
    this.hasSettled = false;
    this.vy = 0;
  }

  update() {
    if (this.isFloating) {
      if (this.y < liquidLevel - this.size / 2 && !this.hasSettled) {
        this.vy += 0.5;
      } else {
        if (!this.hasSettled) {
          this.y = this.targetY;
          this.vy = 0;
          this.hasSettled = true;
        }
        this.y = this.targetY + sin(frameCount * 0.05) * 5;
      }
      this.y += this.vy;
    }
  }

  display() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    ellipse(this.x, this.y, this.size, this.size * 0.6);
  }

  isHovered(mx, my) {
    return dist(mx, my, this.x, this.y) < this.size / 2;
  }
}

function mousePressed() {
  for (let m of marshmallows) {
    if (m.isHovered(mouseX, mouseY)) {
      selectedMarshmallow = m;
      selectedMarshmallow.isFloating = false;
      break;
    }
  }
}

function mouseDragged() {
  if (selectedMarshmallow) {
    selectedMarshmallow.x = mouseX;
    selectedMarshmallow.y = mouseY;
  }
}

function mouseReleased() {
  if (selectedMarshmallow) {
    selectedMarshmallow.x = constrain(selectedMarshmallow.x, mugCenterX - 130, mugCenterX + 130);
    selectedMarshmallow.isFloating = true;
    selectedMarshmallow = null;
  }
}
