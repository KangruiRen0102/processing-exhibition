// Number of snowflakes
let snowflakeCount = 200;
let snowflakes = [];

// Clock variables
let clockX, clockY, clockSize;

// Tree variables
let treeHeight = 50;
let growthRate = 0.2;
let snowpileHeight = 0;
let treeFullyGrown = false;

// Snowman transformation variables
let transformingToSnowman = false;
let transitioningToSpring = false;
let transformationProgress = 0;
let springTransitionProgress = 0;
let snowmanFormedTime = -1;
let typedInput = "";

// Flowers
let flowers = [];

function setup() {
  createCanvas(800, 600);
  clockX = width - 80;
  clockY = 80;
  clockSize = 100;

  for (let i = 0; i < snowflakeCount; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  if (!transitioningToSpring) {
    drawWinterBackground();
  } else {
    drawSpringBackground();
  }

  drawGround();

  if (!transitioningToSpring) {
    snowflakes.forEach((snowflake) => {
      snowflake.fall();
      snowflake.display();
    });
  }

  drawFrozenClock();
  drawFrozenTree();
  growTree();

  if (treeFullyGrown && !transformingToSnowman && !transitioningToSpring) {
    formFlatSnowpile();
  }

  if (transformingToSnowman) {
    transformPileToSnowman();
  }

  if (transitioningToSpring) {
    transitionToSpring();
  }

  flowers.forEach((flower) => {
    flower.display();
  });
}

function drawWinterBackground() {
  for (let y = 0; y < height; y++) {
    let t = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(30, 50, 80), color(200, 220, 255), t));
    line(0, y, width, y);
  }
}

function drawSpringBackground() {
  for (let y = 0; y < height; y++) {
    let t = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(200, 220, 255), color(135, 206, 235), springTransitionProgress * t));
    line(0, y, width, y);
  }

  drawSun();
}

function drawSun() {
  let sunX = 100;
  let sunY = 100;
  let sunRadius = 50;

  fill(255, 223, 0);
  noStroke();
  ellipse(sunX, sunY, sunRadius * 2);

  stroke(255, 223, 0, 150);
  strokeWeight(3);
  for (let i = 0; i < 12; i++) {
    let angle = map(i, 0, 12, 0, TWO_PI);
    let rayLength = sunRadius * 2;
    let x1 = sunX + cos(angle) * sunRadius;
    let y1 = sunY + sin(angle) * sunRadius;
    let x2 = sunX + cos(angle) * (sunRadius + rayLength);
    let y2 = sunY + sin(angle) * (sunRadius + rayLength);
    line(x1, y1, x2, y2);
  }
}

function drawGround() {
  noStroke();
  if (transitioningToSpring) {
    fill(lerpColor(color(240, 240, 255), color(34, 139, 34), springTransitionProgress));
  } else {
    fill(240, 240, 255);
  }
  rect(0, height - 100, width, 100);
}

function drawFrozenClock() {
  let seconds = (millis() / 1000) % 60;
  let minutes = (millis() / 60000) % 60;
  let hours = (millis() / 3600000) % 12;

  let secondAngle = map(seconds, 0, 60, -HALF_PI, TWO_PI - HALF_PI);
  let minuteAngle = map(minutes, 0, 60, -HALF_PI, TWO_PI - HALF_PI);
  let hourAngle = map(hours + minutes / 60.0, 0, 12, -HALF_PI, TWO_PI - HALF_PI);

  fill(200, 220, 255);
  noStroke();
  ellipse(clockX, clockY, clockSize);

  stroke(180, 220, 255);
  strokeWeight(5);
  line(clockX, clockY, clockX + cos(hourAngle) * clockSize / 4, clockY + sin(hourAngle) * clockSize / 4);
  strokeWeight(3);
  line(clockX, clockY, clockX + cos(minuteAngle) * clockSize / 2, clockY + sin(minuteAngle) * clockSize / 2);
  stroke(255, 0, 0);
  strokeWeight(2);
  line(clockX, clockY, clockX + cos(secondAngle) * clockSize / 2, clockY + sin(secondAngle) * clockSize / 2);
}

function drawFrozenTree() {
  let treeX = width / 4;
  let treeY = height - 100;
  let trunkWidth = 10;
  let trunkHeight = treeHeight / 4;

  fill(100, 50, 0);
  rect(treeX - trunkWidth / 2, treeY - trunkHeight, trunkWidth, trunkHeight);

  let layerCount = 5;
  let layerHeight = (treeHeight - trunkHeight) / layerCount;
  for (let i = 0; i < layerCount; i++) {
    let layerBaseWidth = treeHeight * 0.8 - i * 20;
    let layerX1 = treeX - layerBaseWidth / 2;
    let layerX2 = treeX + layerBaseWidth / 2;
    let layerY = treeY - trunkHeight - i * layerHeight;

    fill(30, 100, 30);
    triangle(layerX1, layerY, layerX2, layerY, treeX, layerY - layerHeight);

    if (!transitioningToSpring) {
      fill(255, 255, 255, 200);
      ellipse(treeX, layerY - layerHeight / 2, layerBaseWidth * 0.6, 10);
    }
  }
}

function growTree() {
  if (treeHeight < 150) {
    treeHeight += growthRate;
  } else {
    treeFullyGrown = true;
  }
}

function formFlatSnowpile() {
  let snowpileX = width - 200;
  let snowpileY = height - 100;

  fill(255, 255, 255, 200);
  noStroke();

  for (let i = 0; i < snowpileHeight; i += 5) {
    let ellipseWidth = 100 - i * 0.5;
    ellipse(snowpileX, snowpileY - i, ellipseWidth, 10);
  }

  if (snowpileHeight < 150) {
    snowpileHeight += 0.2;
  }
}

function transformPileToSnowman() {
  let snowmanBaseX = width - 200;
  let snowmanBaseY = height - 100;

  if (transformationProgress < 1) {
    transformationProgress += 0.01;
    if (transformationProgress >= 1) {
      snowmanFormedTime = frameCount;
    }
  }

  let scale = transitioningToSpring ? 1 - springTransitionProgress : transformationProgress;

  fill(255);
  ellipse(snowmanBaseX, snowmanBaseY, 60 * scale);
  ellipse(snowmanBaseX, snowmanBaseY - 50 * scale, 45 * scale);
  ellipse(snowmanBaseX, snowmanBaseY - 90 * scale, 30 * scale);

  if (scale > 0) {
    fill(0);
    rect(snowmanBaseX - 15 * scale, snowmanBaseY - 120 * scale, 30 * scale, 10 * scale);
    rect(snowmanBaseX - 10 * scale, snowmanBaseY - 140 * scale, 20 * scale, 20 * scale);

    ellipse(snowmanBaseX - 5 * scale, snowmanBaseY - 95 * scale, 5 * scale);
    ellipse(snowmanBaseX + 5 * scale, snowmanBaseY - 95 * scale, 5 * scale);
    fill(255, 165, 0);
    triangle(snowmanBaseX, snowmanBaseY - 90 * scale, snowmanBaseX, snowmanBaseY - 85 * scale, snowmanBaseX + 10 * scale, snowmanBaseY - 87 * scale);
    fill(0);
    for (let i = -8; i <= 8; i += 4) {
      ellipse(snowmanBaseX + i * scale, snowmanBaseY - 80 * scale + abs(i) * 0.2, 3 * scale);
    }
  }

  if (snowmanFormedTime > 0 && frameCount > snowmanFormedTime + 300) {
    transitioningToSpring = true;
  }
}

function transitionToSpring() {
  springTransitionProgress += 0.01;
  if (springTransitionProgress >= 1) {
    springTransitionProgress = 1;
  }
}

function keyTyped() {
  if (treeFullyGrown) {
    typedInput += key;
    if (typedInput.toLowerCase() === "snowman") {
      transformingToSnowman = true;
      typedInput = "";
    }
  }
}

class Flower {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.flowerColor = color(random(255), random(255), random(255));
  }

  display() {
    fill(this.flowerColor);
    noStroke();
    ellipse(this.x, this.y, 20);
    fill(255, 255, 0);
    ellipse(this.x, this.y, 10);
  }
}

function mousePressed() {
  if (transitioningToSpring && mouseY > height - 100) {
    flowers.push(new Flower(mouseX, mouseY));
  }
}

class Snowflake {
  constructor() {
    this.x = random(width);
    this.y = random(-height, 0);
    this.speed = random(1, 3);
    this.size = random(2, 5);
  }

  fall() {
    this.y += this.speed;
    if (this.y > height - 100) {
      this.y = random(-height, 0);
      this.x = random(width);
    }
  }

  display() {
    fill(255);
    noStroke();
    ellipse(this.x, this.y, this.size);
  }
}
