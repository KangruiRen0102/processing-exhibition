let numSnowflakes = 100;
let snowflakes = [];
let treeX = 150;
let treeY = 450;
let snowmanX = 600;
let snowmanY = 500;
let windDirection = 0;
let isWaving = false;
let isWinter = true;

let iceCreamTruckX = -200;
let iceCreamTruckSpeed = 3;
let isTruckMoving = true;
let sunX = 700;
let sunY = 100;
let sunSize = 80;
let kidAppeared = false;
let kidX = -200;
let kidY = 400;

function setup() {
  createCanvas(800, 600);
  for (let i = 0; i < numSnowflakes; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  if (isWinter) {
    drawWinterScene();
  } else {
    drawSummerScene();
  }
}

function drawWinterScene() {
  background(173, 216, 230);

  windDirection = (mouseX - width / 2) / (width / 2);

  fill(255);
  noStroke();
  rect(0, height - 100, width, 100);

  for (let s of snowflakes) {
    s.update();
    s.display();
  }

  drawTree(treeX, treeY);
  drawSnowman(snowmanX, snowmanY);

  if (mouseIsPressed) {
    isWaving = true;
  } else {
    isWaving = false;
  }
}

function drawSummerScene() {
  background(135, 206, 250);

  fill(34, 139, 34);
  noStroke();
  rect(0, height - 100, width, 100);

  drawSun(sunX, sunY, sunSize);

  if (isTruckMoving) {
    iceCreamTruckX += iceCreamTruckSpeed;
    if (iceCreamTruckX > width) {
      iceCreamTruckX = -200;
    }
  }
  drawIceCreamTruck(iceCreamTruckX, height - 150);

  if (kidAppeared) {
    kidY = height - 100;
    drawKid(kidX, kidY);
  }
}

function drawTree(x, y) {
  fill(139, 69, 19);
  rect(x - 15, y, 30, 90);

  fill(34, 139, 34);
  triangle(x - 70, y - 0, x + 70, y - 0, x, y - 150);
  triangle(x - 60, y - 50, x + 60, y - 50, x, y - 180);
  triangle(x - 50, y - 100, x + 50, y - 100, x, y - 210);
}

function drawSnowman(x, y) {
  fill(255);
  ellipse(x, y, 120, 120);
  ellipse(x, y - 80, 100, 100);
  ellipse(x, y - 140, 80, 80);

  fill(0);
  ellipse(x - 20, y - 150, 10, 10);
  ellipse(x + 20, y - 150, 10, 10);
  ellipse(x, y - 80, 10, 10);
  ellipse(x, y - 60, 10, 10);
  ellipse(x, y - 40, 10, 10);

  fill(255, 69, 0);
  triangle(x, y - 145, x + 15, y - 140, x, y - 135);

  stroke(139, 69, 19);
  strokeWeight(8);
  if (isWaving) {
    line(x + 40, y - 100, x + 100, y - 120);
  } else {
    line(x + 40, y - 100, x + 80, y - 60);
  }
  line(x - 40, y - 100, x - 80, y - 60);

  fill(0);
  rect(x - 30, y - 180, 60, 10);
  rect(x - 20, y - 210, 40, 30);
}

class Snowflake {
  constructor() {
    this.x = random(width);
    this.y = random(-500, -50);
    this.speed = random(1, 3);
    this.size = random(5, 10);
    this.windSpeed = random(0.1, 0.5);
  }

  update() {
    this.y += this.speed;
    this.x += windDirection * this.windSpeed;

    if (this.y > height) {
      this.y = random(-500, -50);
      this.x = random(width);
    }

    if (this.x < 0) {
      this.x = width;
    } else if (this.x > width) {
      this.x = 0;
    }
  }

  display() {
    noStroke();
    fill(255);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

function drawSun(x, y, size) {
  fill(255, 223, 0);
  noStroke();
  ellipse(x, y, size, size);

  stroke(255, 223, 0);
  strokeWeight(4);
  for (let i = 0; i < 12; i++) {
    let angle = TWO_PI / 12 * i;
    let rayX = x + cos(angle) * (size / 2 + 20);
    let rayY = y + sin(angle) * (size / 2 + 20);
    line(x, y, rayX, rayY);
  }
}

function drawIceCreamTruck(x, y) {
  fill(250, 0, 0);
  noStroke();
  rect(x, y, 200, -100);
  rect(x, y, 200, 60);
  rect(x + 200, y - 20, 30, 80);

  fill(211, 211, 211);
  rect(x + 20, y - 60, 100, 80);
  rect(x + 140, y - 60, 40, 40);

  fill(255);
  rect(x + 60, y - 120, 80, 20);

  fill(0);
  ellipse(x + 30, y + 60, 40, 40);
  ellipse(x + 170, y + 60, 40, 40);

  fill(255, 165, 0);
  triangle(x + 70, y - 110, x + 120, y - 110, x + 95, y - 170);
  fill(255, 105, 180);
  ellipse(x + 95, y - 110, 45, 45);
}

function drawKid(x, y) {
  fill(255, 228, 196);
  ellipse(x, y - 80, 40, 40);

  fill(0, 0, 255);
  rect(x - 15, y - 20, 10, 40);
  rect(x + 5, y - 20, 10, 40);

  fill(255, 0, 0);
  rect(x - 15, y - 60, 30, 40);

  fill(255, 228, 196);
  rect(x - 25, y - 60, 10, 30);
  rect(x + 15, y - 60, 10, 30);

  fill(255, 165, 0);
  triangle(x + 20, y - 80, x + 50, y - 80, x + 35, y - 40);
  fill(255, 105, 180);
  ellipse(x + 35, y - 85, 30, 30);
}

function keyPressed() {
  if (key === ' ') {
    isWinter = !isWinter;
    if (!isWinter) {
      iceCreamTruckX = 300;
      kidAppeared = false;
    }
  }
}

function mousePressed() {
  if (!isWinter && !kidAppeared) {
    isTruckMoving = false;
    kidAppeared = true;
    kidX = iceCreamTruckX + 300;
  }
}
