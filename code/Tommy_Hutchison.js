let currentState = 1; // Tracks which scene to display
let numRaindrops = 200; // Number of raindrops
let raindrops = []; // Array to store raindrops
let clouds = []; // Array to store clouds
let grassBlades = []; // Array to store grass blades

function setup() {
  createCanvas(800, 800);
  frameRate(30);

  // Create raindrops
  for (let i = 0; i < numRaindrops; i++) {
    raindrops.push(new Raindrop());
  }

  // Create clouds
  clouds.push(new Cloud(200, 150, 100));
  clouds.push(new Cloud(400, 100, 120));
  clouds.push(new Cloud(600, 200, 100));

  // Create grass blades
  for (let x = 0; x < width; x += 10) {
    grassBlades.push(new GrassBlade(x, height, 40));
  }
}

function draw() {
  if (currentState === 1) {
    // Rainy scene
    background(169, 169, 169); // Gray and gloomy
    for (let blade of grassBlades) {
      blade.display();
    }
    for (let drop of raindrops) {
      drop.update();
      drop.display();
    }
    drawSprout(width / 2, height - 100);
  } else if (currentState === 2) {
    // Sunny scene
    background(135, 206, 250); // Bright blue sky
    drawSun();
    for (let cloud of clouds) {
      cloud.display();
    }
    for (let blade of grassBlades) {
      blade.display();
    }
    drawDaisy(width / 2, height / 2, 300);
    drawLeaves(width / 2, height / 2 + 300, 300);
  }
}

function mousePressed() {
  // Switch scenes
  currentState = currentState === 1 ? 2 : 1;
}

// Raindrop class
class Raindrop {
  constructor() {
    this.x = random(width);
    this.y = random(-500, -50);
    this.speed = random(4, 10);
  }

  update() {
    this.y += this.speed;
    if (this.y > height) {
      this.y = random(-500, -50);
      this.x = random(width);
    }
  }

  display() {
    stroke(0, 0, 255);
    line(this.x, this.y, this.x, this.y + 10);
  }
}

// Cloud class
class Cloud {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  display() {
    fill(255);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size * 0.6);
    ellipse(this.x + this.size * 0.3, this.y - this.size * 0.1, this.size * 0.8, this.size * 0.5);
    ellipse(this.x - this.size * 0.3, this.y + this.size * 0.1, this.size * 0.9, this.size * 0.5);
  }
}

// Grass blade class
class GrassBlade {
  constructor(x, baseY, height) {
    this.x = x;
    this.baseY = baseY;
    this.height = height;
  }

  display() {
    fill(34, 139, 34);
    triangle(this.x, this.baseY, this.x + 5, this.baseY - this.height, this.x + 10, this.baseY);
  }
}

// Draw sprout
function drawSprout(x, y) {
  fill(34, 139, 34);
  noStroke();
  rect(x - 5, y, 10, 100);
}

// Draw daisy
function drawDaisy(centerX, centerY, size) {
  let petalLength = size / 2;
  let petalWidth = size / 6;
  let petalCount = 20;

  fill(34, 139, 34);
  rect(centerX - size / 20, centerY + size / 2.9, size / 10, size);

  fill(255);
  noStroke();
  for (let i = 0; i < petalCount; i++) {
    let angle = TWO_PI / petalCount * i;
    let x = centerX + cos(angle) * size / 4;
    let y = centerY + sin(angle) * size / 4;
    push();
    translate(x, y);
    rotate(angle);
    ellipse(0, 0, petalWidth, petalLength);
    pop();
  }

  fill(255, 215, 0);
  ellipse(centerX, centerY, size / 3, size / 3);
}

// Draw leaves
function drawLeaves(centerX, baseY, size) {
  fill(34, 139, 34);
  noStroke();
  let leafSize = size / 6;

  push();
  translate(centerX - size / 6, baseY - size / 4);
  rotate(-PI / 4);
  ellipse(0, 0, leafSize, leafSize * 2);
  pop();

  push();
  translate(centerX + size / 6, baseY - size / 4);
  rotate(PI / 4);
  ellipse(0, 0, leafSize, leafSize * 2);
  pop();
}

// Draw sun
function drawSun() {
  fill(255, 223, 0);
  ellipse(700, 100, 100, 100);
  stroke(255, 223, 0, 150);
  strokeWeight(3);
  for (let i = 0; i < 360; i += 15) {
    let angle = radians(i);
    let x1 = 700 + cos(angle) * 60;
    let y1 = 100 + sin(angle) * 60;
    let x2 = 700 + cos(angle) * 80;
    let y2 = 100 + sin(angle) * 80;
    line(x1, y1, x2, y2);
  }
  noStroke();
}