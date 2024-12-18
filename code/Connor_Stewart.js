class Flower {
  constructor() {
    this.hue = random(0, 360); // Random hue
    this.petalCount = int(random(2, 8)) * 4; // Ensure symmetry by multiplying by 4
    this.len = random(100, 200); // Petal length
    this.wid = random(0.2, 0.5); // Petal width
    this.rowCount = int(random(4, 10)); // Number of layers
    this.rotate = random(0.5, 2.0); // Rotation between petals
  }

  display() {
    stroke(0);
    strokeWeight(1);
    let deltaA = (2 * PI) / this.petalCount;
    let petalLen = this.len;

    push();
    for (let r = 0; r < this.rowCount; r++) {
      for (let angle = 0; angle < 2 * PI; angle += deltaA) {
        rotate(deltaA);
        this.petal(petalLen * 0.75, 0, petalLen, petalLen * this.wid, (this.hue - r * 20) % 360);
      }
      rotate(this.rotate);
      petalLen = petalLen * (1 - 3.0 / this.rowCount);
    }
    pop();
  }

  petal(x, y, lenP, widP, hueP) {
    stroke(0);
    for (let i = 20; i > 0; i--) {
      fill((hueP + i * 2) % 360, 100, 5 * i);
      ellipse(x, y, (lenP * i) / 20.0, (widP * i) / 20.0);
      noStroke();
    }
  }
}

let f1;
let grassWidth = 5, grassHeight = 5;
let rows, cols, value = 0;

function setup() {
  createCanvas(1000, 1000);
  smooth();
  colorMode(HSB, 360, 100, 100);
  background(200, 20, 100);

  rows = height / grassHeight;
  cols = width / grassWidth;

  drawGrassField();
  fill(60, 100, 100);
  noStroke();
  circle(850, 150, 100);
  fill(30, 255, 30);
  rect(-5, 930, width + 10, 70);

  strokeWeight(12);
  translate(width / 2, 898);
  tree(0);

  f1 = new Flower();
  frameRate(0.5);
}

function draw() {
  push();
  if (value % 2 == 0) {
    let randomposition = floor(random(width / 10)) * 10;
    translate(randomposition, 898);
    scale(0.1);
    f1.display();
    pop();
    f1 = new Flower();
  }
}

function drawGrassField() {
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let x = i * grassWidth;
      let y = 930;
      let angle = random(-PI / 4, PI / 4);
      let length = random(10, 30);
      drawGrassBlade(x, y, angle, length);
    }
  }
}

function drawGrassBlade(x, y, angle, length) {
  push();
  translate(x, y);
  rotate(angle);
  stroke(value % 2 == 0 ? color(120, 100, 30) : color(0, 0, 100));
  strokeWeight(2);
  line(0, 0, 0, -length);
  pop();
}

function tree(x) {
  if (x < 14) {
    stroke(20, 32, 37);
    line(0, 0, 0, -height / 10);
    translate(0, -height / 10);
    rotate(random(-0.1, 0.1));
    if (random(1.0) < 0.6) {
      rotate(0.3);
      scale(0.75);
      push();
      tree(x + 1);
      pop();
      rotate(-0.7);
      push();
      tree(x + 1);
      pop();
    } else if (x > 9) {
      stroke(120, 100, 100);
      line(0, 0, 0, -height / 10);
      translate(0, -height / 10);
      rotate(random(-0.1, 0.1));
      if (random(1.0) < 0.6) {
        rotate(0.3);
        scale(0.75);
        push();
        tree(x + 1);
        pop();
        rotate(-0.7);
        push();
        tree(x + 1);
        pop();
      }
    } else {
      tree(x);
    }
  }
}

function mousePressed() {
  value++;
  if (value % 2 != 0) {
    smooth();
    background(0, 0, 70);
    rows = height / grassHeight;
    cols = width / grassWidth;
    drawGrassField();
    fill(0, 0, 100);
    noStroke();
    circle(850, 150, 100);
    fill(192, 2, 94);
    rect(-5, 930, width + 10, 70);
    strokeWeight(12);
    translate(width / 2, 898);
    wintertree(0);
  } else {
    background(200, 20, 100);
    rows = height / grassHeight;
    cols = width / grassWidth;
    drawGrassField();
    fill(60, 100, 100);
    noStroke();
    circle(850, 150, 100);
    fill(30, 255, 30);
    rect(-5, 930, width + 10, 70);
    strokeWeight(12);
    translate(width / 2, 898);
    tree(0);
  }
}

function wintertree(x) {
  if (x < 14) {
    stroke(20, 32, 37);
    line(0, 0, 0, -height / 10);
    translate(0, -height / 10);
    rotate(random(-0.1, 0.1));
    if (random(1.0) < 0.6) {
      rotate(0.3);
      scale(0.75);
      push();
      wintertree(x + 1);
      pop();
      rotate(-0.7);
      push();
      wintertree(x + 1);
      pop();
    } else {
      wintertree(x);
    }
  }
}
