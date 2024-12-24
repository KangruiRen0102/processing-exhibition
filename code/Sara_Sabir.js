let WINDOW_WIDTH = 800;
let WINDOW_HEIGHT = 600;
let DAY_SKY_COLOR, NIGHT_SKY_COLOR;
let GROUND_HEIGHT = 100;
let grassBlades = [];
let flowers = [];
let birds = [];
let trees = [];
let sun;
let dayTime = 0;
let sunlightIntensity = 0;
let treeCount = 4;
let isNight = false;

function setup() {
  createCanvas(WINDOW_WIDTH, WINDOW_HEIGHT);
  colorMode(HSB, 360, 100, 100);

  DAY_SKY_COLOR = color(200, 100, 100);
  NIGHT_SKY_COLOR = color(240, 30, 30);

  for (let i = 0; i < 2000; i++) {
    grassBlades.push(new Grass(random(width), height - GROUND_HEIGHT + random(10)));
  }

  sun = new Sun(100, 100, 40);

  for (let i = 0; i < 5; i++) {
    flowers.push(new Flower(random(width), height - GROUND_HEIGHT));
  }

  let spaceBetweenTrees = width / (treeCount + 1);
  for (let i = 0; i < treeCount; i++) {
    let treeX = (i + 1) * spaceBetweenTrees;
    trees.push(new Tree(treeX, height - GROUND_HEIGHT, 100, 0.2));
  }

  initializeFlowers();
}

function draw() {
  dayTime += 0.01;
  updateWeather();

  background(isNight ? NIGHT_SKY_COLOR : DAY_SKY_COLOR);

  sun.update();
  if (!isNight) {
    sun.display();
  }

  fill(34, 51, 51);
  noStroke();
  rect(0, height - GROUND_HEIGHT, width, GROUND_HEIGHT);

  for (let blade of grassBlades) {
    blade.grow(sunlightIntensity);
    blade.display();
  }

  for (let flower of flowers) {
    flower.grow(sunlightIntensity);
    flower.display();
  }

  for (let bird of birds) {
    bird.update();
    bird.display();
  }

  for (let tree of trees) {
    tree.grow(sunlightIntensity);
    tree.display();
  }
}

function updateWeather() {
  sunlightIntensity = sun.calculateIntensity();
}

function initializeFlowers() {
  let maxFlowers = 15;
  let spaceBetweenFlowers = width / (maxFlowers + 1);
  let sortedFlowers = [];

  for (let i = 0; i < maxFlowers; i++) {
    let flowerX = (i + 1) * spaceBetweenFlowers;
    sortedFlowers.push(new Flower(flowerX, height - GROUND_HEIGHT));
  }

  sortedFlowers.sort((f1, f2) => f1.x - f2.x);
  flowers = sortedFlowers;
}

function keyPressed() {
  if (key === ' ') {
    isNight = !isNight;
    sun.update();
    if (!isNight) {
      sun.display();
    }
  }
}

function mousePressed() {
  birds.push(new Bird(0, height - GROUND_HEIGHT - 20));
}

class Sun {
  constructor(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.angle = 0;
  }

  update() {
    this.angle = (dayTime % TWO_PI);
    this.x = width / 2 + cos(this.angle) * (width / 2 - this.radius);
    this.y = height / 2 + sin(this.angle) * (height / 2 - this.radius);
  }

  display() {
    noStroke();
    fill(50, 80, 100);
    circle(this.x, this.y, this.radius * 2);

    stroke(50, 60, 100, 50);
    for (let a = 0; a < TWO_PI; a += PI / 8) {
      let rayLength = this.radius * 1.5;
      line(this.x, this.y, this.x + cos(a) * rayLength, this.y + sin(a) * rayLength);
    }
  }

  calculateIntensity() {
    return map(sin(this.angle), -1, 1, 0.2, 1.0);
  }
}

class Grass {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.height = random(5, 8);
    this.maxHeight = random(30, 30);
    this.growthRate = random(0.1, 0.4);
    this.col = color(random(85, 95), random(70, 90), random(40, 60));
  }

  grow(sunlight) {
    if (this.height < this.maxHeight) {
      this.height += this.growthRate * sunlight;
    }
  }

  display() {
    stroke(this.col);
    strokeWeight(1);
    let swayAmount = sin(this.x * 0.1 + dayTime) * 2;
    line(this.x, this.y, this.x + swayAmount, this.y - this.height);
  }
}

class Flower {
  constructor(x, baseY) {
    this.x = x;
    this.baseY = baseY;
    this.stemHeight = 0;
    this.size = 0;
    this.growthStage = 0;
    this.petalColor = color(random(360), 80, 90);
  }

  grow(sunlight) {
    if (this.growthStage < 1) {
      this.growthStage += 0.002 * sunlight;
      this.stemHeight = map(this.growthStage, 0, 1, 0, 40);
      this.size = map(this.growthStage, 0.3, 1, 0, 20);
      this.size = max(this.size, 0);
    }
  }

  display() {
    push();
    translate(this.x, this.baseY);

    stroke(120, 80, 40);
    strokeWeight(2);
    line(0, 0, 0, -this.stemHeight);

    if (this.growthStage > 0.3) {
      translate(0, -this.stemHeight);

      noStroke();
      for (let angle = 0; angle < TWO_PI; angle += PI / 6) {
        fill(this.petalColor);
        push();
        rotate(angle);
        ellipse(this.size / 2, 0, this.size, this.size / 2);
        pop();
      }

      fill(50, 90, 90);
      circle(0, 0, this.size / 3);
    }

    pop();
  }
}

class Bird {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.speedX = random(1, 2);
    this.speedY = random(-0.5, 0.5);
    this.birdColor = color(0, 0, 0);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;

    if (this.y < 10) this.y = 10;
    if (this.y > 150) this.y = 150;
  }

  display() {
    fill(this.birdColor);
    noStroke();

    let bodyBaseHeight = 10;
    let bodyTipHeight = 10;

    beginShape();
    vertex(this.x, this.y);
    vertex(this.x - bodyBaseHeight, this.y + bodyTipHeight);
    vertex(this.x + bodyBaseHeight, this.y + bodyTipHeight);
    endShape(CLOSE);

    let bodyCenterX = this.x;
    let bodyCenterY = this.y + (bodyTipHeight / 2);

    let wingOffset = sin(frameCount * 0.2) * 5;

    stroke(this.birdColor);
    strokeWeight(3);
    noFill();

    beginShape();
    vertex(bodyCenterX, bodyCenterY);
    bezierVertex(bodyCenterX - 15, bodyCenterY - 10 + wingOffset, bodyCenterX - 25, bodyCenterY - 20 + wingOffset, bodyCenterX - 30, bodyCenterY - 10);
    endShape();

    beginShape();
    vertex(bodyCenterX, bodyCenterY);
    bezierVertex(bodyCenterX + 15, bodyCenterY - 10 + wingOffset, bodyCenterX + 25, bodyCenterY - 20 + wingOffset, bodyCenterX + 30, bodyCenterY - 10);
    endShape();
  }
}

class Tree {
  constructor(x, baseY, maxHeight, growthRate) {
    this.x = x;
    this.baseY = baseY;
    this.height = 0;
    this.maxHeight = maxHeight;
    this.growthRate = growthRate;
    this.foliageLayers = 3;
  }

  grow(sunlight) {
    if (this.height < this.maxHeight * 0.8) {
      this.height += this.growthRate * sunlight;
    }
  }

  display() {
    fill(139, 69, 19);
    rect(this.x - 10, this.baseY - this.height, 20, this.height);

    fill(34, 139, 34);
    let layerHeight = this.height / this.foliageLayers;
    for (let i = 0; i < this.foliageLayers; i++) {
      let topY = this.baseY - this.height - (layerHeight * i);
      if (i * 5 < 25) {
        triangle(
          this.x - 40 - (i * 3),
          topY,
          this.x + 40 + (i * 3),
          topY,
          this.x,
          topY - 50
        );
      }
    }
  }
}
