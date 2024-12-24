let bubbles = []; // 存储所有气泡的数组
let contaminants = []; // 存储所有污染物的数组

// 环境变量
let liquidDensity = 1.0; // 液体密度影响气泡上升速度
let currentSpeed = 0.2; // 水流的速度影响气泡的水平漂移

let clickPosition; // 存储鼠标点击位置

// 常量
const speedIncreaseFactor = 1.5;
const speedDecreaseFactor = 0.5;

function setup() {
  createCanvas(800, 600);
  clickPosition = createVector(-1, -1); // 初始化鼠标点击位置
  frameRate(60);

  // 初始化100个污染物
  for (let i = 0; i < 100; i++) {
    contaminants.push(new Contaminant(random(width), random(-height, 0)));
  }
}

function draw() {
  background(0);

  updateContaminants();
  updateBubbles();

  // 确保污染物始终保持100个
  while (contaminants.length < 100) {
    contaminants.push(new Contaminant(random(width), 0));
  }
}

function updateContaminants() {
  let contaminantsToRemove = [];

  for (let c of contaminants) {
    c.update();
    c.display();

    for (let b of bubbles) {
      if (dist(c.x, c.y, b.x, b.y) < b.size / 2) {
        contaminantsToRemove.push(c);
        b.grow();
        break;
      }
    }
  }

  contaminants = contaminants.filter((c) => !contaminantsToRemove.includes(c));
}

function updateBubbles() {
  let bubblesToRemove = [];

  for (let b of bubbles) {
    b.update();
    b.display();

    if (clickPosition.dist(createVector(b.x, b.y)) < 100 && !b.isBlooming()) {
      b.bloom();
    }

    if (b.isDead()) {
      bubblesToRemove.push(b);
    }
  }

  bubbles = bubbles.filter((b) => !bubblesToRemove.includes(b));
}

class Bubble {
  constructor(x, y, size, riseSpeed, isClustered) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.riseSpeed = riseSpeed;
    this.driftSpeed = random(-1, 1);
    this.bubbleColor = this.getComplexColor(x, y);
    this.blooming = false;
    this.lifespan = random(200, 600);
    this.isActive = true;
    this.isClustered = isClustered;
    this.clusterFactor = random(0.8, 1.2);
    this.clusterRange = random(5, 15);
  }

  update() {
    if (this.isActive) {
      this.y -= this.riseSpeed / (liquidDensity * this.clusterFactor);
      this.x += this.driftSpeed + currentSpeed;

      if (this.x < 0 || this.x > width) {
        this.driftSpeed *= -1;
      }

      if (this.y < -this.size) {
        this.isActive = false;
      }

      if (this.blooming) {
        this.size = map(this.y, height + 100, 0, 10, 40);
      }

      this.lifespan--;
    }
  }

  display() {
    fill(this.bubbleColor, map(this.lifespan, 0, 255, 0, 255));
    noStroke();
    ellipse(this.x, this.y, this.size);
  }

  isDead() {
    return this.lifespan < 0;
  }

  bloom() {
    this.blooming = true;
  }

  isBlooming() {
    return this.blooming;
  }

  grow() {
    this.size += 2;
    this.riseSpeed *= 1.1;
  }

  getComplexColor(x, y) {
    let distFromCenter = dist(x, y, width / 2, height / 2) / (width / 2);
    let r = sin(TWO_PI * distFromCenter + millis() * 0.001) * 128 + 127;
    let g = sin(TWO_PI * distFromCenter + millis() * 0.002 + HALF_PI) * 128 + 127;
    let b = sin(TWO_PI * distFromCenter + millis() * 0.003 + PI) * 128 + 127;
    return color(r, g, b);
  }
}

class Contaminant {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.contaminantColor = color(250, 250, 250, 250);
  }

  update() {
    this.y += 1 / liquidDensity;
    if (this.y > height) {
      this.y = 0;
      this.x = random(width);
      this.size = random(5, 15);
    }

    if (this.y > height / 2) {
      this.size += 0.05;
    }
  }

  display() {
    fill(this.contaminantColor);
    ellipse(this.x, this.y, this.size);
  }
}

function mousePressed() {
  clickPosition.set(mouseX, mouseY);
  for (let i = 0; i < 100; i++) {
    let isClustered = random(1) < 0.5;
    bubbles.push(new Bubble(mouseX + random(-50, 50), mouseY + random(-50, 50), random(6, 8), random(1, 2), isClustered));
  }
}

function keyPressed() {
  if (key === 'b' || key === 'B') {
    addBubbles(100);
  } else if (key === 'c' || key === 'C') {
    bubbles = [];
  } else if (key === '+') {
    adjustBubbleRiseSpeed(speedIncreaseFactor);
  } else if (key === '-') {
    adjustBubbleRiseSpeed(speedDecreaseFactor);
  } else if (key === 'w' || key === 'W') {
    currentSpeed *= 1.5;
  } else if (key === 's' || key === 'S') {
    currentSpeed *= 0.5;
  } else if (key === 'd' || key === 'D') {
    liquidDensity *= 1.1;
  } else if (key === 'a' || key === 'A') {
    liquidDensity *= 0.9;
  }
}

function addBubbles(count) {
  for (let i = 0; i < count; i++) {
    let isClustered = random(1) < 0.2;
    bubbles.push(new Bubble(random(width), random(height), random(4, 5), random(1, 1.5), isClustered));
  }
}

function adjustBubbleRiseSpeed(factor) {
  for (let b of bubbles) {
    b.riseSpeed *= factor;
  }
}
