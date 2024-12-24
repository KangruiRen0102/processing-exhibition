let numSnowflakes = 500;
let snowflakes = [];
let mountain;
let boat;
let snowSpeed = 1;
let clickCount = 0;

function setup() {
  createCanvas(800, 600);
  mountain = new Mountain(height / 2, 100, width);

  for (let i = 0; i < numSnowflakes; i++) {
    snowflakes.push(new Snowflake(random(width), random(-height, height), random(2, 5), random(1, 3)));
  }

  boat = new Boat(width / 2, height / 2 + 100, 100, 20);
  noStroke();
}

function draw() {
  if (clickCount === 0) {
    drawChaoticSnowstorm();
    for (let flake of snowflakes) {
      flake.update(snowSpeed);
      flake.display();
    }
  } else if (clickCount === 1) {
    snowSpeed = 5;
    drawChaoticSnowstorm();
    for (let flake of snowflakes) {
      flake.update(snowSpeed);
      flake.display();
    }
  } else {
    drawSunsetSunriseScene();
    boat.display();
  }
}

function drawChaoticSnowstorm() {
  background(50, 60, 70);
  fill(40, 40, 50);
  for (let i = 0; i < 6; i++) {
    let cloudX = i * width / 6 + random(-30, 30);
    let cloudY = random(50, 150);
    ellipse(cloudX, cloudY, 200, 60);
    ellipse(cloudX - 50, cloudY + 20, 150, 50);
    ellipse(cloudX + 50, cloudY + 20, 150, 50);
  }
  mountain.display();
  fill(30, 60, 120);
  rect(0, height / 2 + 50, width, height / 2);
}

function drawSunsetSunriseScene() {
  for (let i = 0; i < height; i++) {
    let inter = map(i, 0, height, 0, 1);
    let r = lerp(255, 255, inter);
    let g = lerp(94, 60, inter);
    let b = lerp(77, 120, inter);
    stroke(r, g, b);
    line(0, i, width, i);
  }

  fill(255, 204, 0);
  ellipse(100, height / 2 + 50, 150, 150);
  mountain.displaySilhouette();

  fill(255, 94, 77, 150);
  rect(0, height / 2 + 50, width, height / 2);
}

function mousePressed() {
  clickCount++;
  if (clickCount > 2) {
    clickCount = 2;
  }
}

class Snowflake {
  constructor(x, y, size, speed) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
  }

  update(multiplier) {
    this.y += this.speed * multiplier;
    if (this.y > height) {
      this.y = random(-50, -10);
      this.x = random(width);
    }
  }

  display() {
    fill(255);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

class Mountain {
  constructor(baseHeight, noiseScale, width) {
    this.baseHeight = baseHeight;
    this.noiseScale = noiseScale;
    this.width = width;
    this.heights = [];

    for (let i = 0; i < width; i++) {
      this.heights[i] = baseHeight + noise(i * 0.01) * noiseScale - 50;
    }
  }

  display() {
    fill(100, 100, 120);
    beginShape();
    for (let i = 0; i < this.width; i++) {
      vertex(i, this.heights[i]);
    }
    vertex(this.width, height);
    vertex(0, height);
    endShape(CLOSE);

    fill(255);
    beginShape();
    for (let i = 0; i < this.width; i++) {
      vertex(i, this.heights[i] - 20);
    }
    vertex(this.width, height);
    vertex(0, height);
    endShape(CLOSE);
  }

  displaySilhouette() {
    fill(50, 50, 70);
    beginShape();
    for (let i = 0; i < this.width; i++) {
      vertex(i, this.heights[i]);
    }
    vertex(this.width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

class Boat {
  constructor(x, y, width, height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  display() {
    fill(139, 69, 19);
    rect(this.x - this.width / 2, this.y, this.width, this.height);
    triangle(this.x - this.width / 2 - 10, this.y, this.x - this.width / 2, this.y + this.height, this.x - this.width / 2, this.y);
    triangle(this.x + this.width / 2 + 10, this.y, this.x + this.width / 2, this.y + this.height, this.x + this.width / 2, this.y);
    fill(0);
    ellipse(this.x, this.y - 10, 15, 15);
    rect(this.x - 5, this.y, 10, 20);
  }
}
