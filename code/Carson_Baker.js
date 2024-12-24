class Shape {
  constructor(x, y, c) {
    this.x = x
    this.y = y
    this.C = c
    this.Op = 1
    this.r1 = 0
    this.r2 = 0
    this.x1 = 0
    this.y1 = 0
    this.x2 = 0
    this.y2 = 0
  }
}

let iceberg, penguinb, tummy, beak, a1, a2, f1, f2

function setup() {
  createCanvas(800, 800)
  background(0, 0, 100)
  iceberg = new Shape(400, 400, color(255))
  penguinb = new Shape(400, 400, color(0))
  tummy = new Shape(400, 400, color(255))
  beak = new Shape(400, 400, color(255))
  a1 = new Shape(400, 400, color(0))
  a2 = new Shape(400, 400, color(0))
  f1 = new Shape(400, 400, color(0))
  f2 = new Shape(400, 400, color(0))
}

function draw() {
  background(0, 0, 125)
  iceberg.Op -= 0.005
  if (iceberg.Op < 0) {
    iceberg.Op = 0
    penguinb.Op = 0
    tummy.Op = 0
    beak.Op = 0
    a1.Op = 0
    a2.Op = 0
    f1.Op = 0
    f2.Op = 0
    if (iceberg.Op > 0) {
      penguinb.Op = 1
      tummy.Op = 1
      beak.Op = 1
      a1.Op = 1
      a2.Op = 1
      f1.Op = 1
      f2.Op = 1
    }
  }
  fill(240, 240, 255, iceberg.Op * 255)
  ellipse(iceberg.x, iceberg.y, iceberg.r1, iceberg.r2)
  noStroke()
  fill(0, 0, 0, penguinb.Op * 255)
  ellipse(penguinb.x, penguinb.y, 30, 30)
  fill(255, 255, 255, tummy.Op * 255)
  ellipse(tummy.x, tummy.y, 20, 10)
  fill(250, 100, 100, beak.Op * 255)
  triangle(beak.x, beak.y, beak.x1, beak.y1, beak.x2, beak.y2)
  fill(0, 0, 0, a1.Op * 255)
  ellipse(a1.x, a1.y, 15, 15)
  fill(0, 0, 0, a2.Op * 255)
  ellipse(a2.x, a2.y, 15, 15)
  fill(0, 0, 0, f1.Op * 255)
  ellipse(f1.x, f1.y, 10, 10)
  fill(0, 0, 0, f2.Op * 255)
  ellipse(f2.x, f2.y, 10, 10)
}

function mousePressed() {
  iceberg.x = mouseX
  iceberg.y = mouseY
  iceberg.C = 255
  iceberg.Op = 1
  iceberg.r1 = random(50, 400)
  iceberg.r2 = random(50, 400)
  penguinb.x = mouseX + random(-1, 1) * (1 / 3) * iceberg.r1
  penguinb.y = mouseY + random(-1, 1) * (1 / 3) * iceberg.r2
  penguinb.C = 0
  penguinb.Op = 1
  f1.x = penguinb.x - 7
  f1.y = penguinb.y + 15
  f1.Op = 1
  f2.x = penguinb.x + 7
  f2.y = penguinb.y + 15
  f2.Op = 1
  tummy.x = penguinb.x
  tummy.y = penguinb.y + 10
  tummy.Op = 1
  beak.x = penguinb.x
  beak.y = penguinb.y + 17
  beak.x1 = penguinb.x - 4
  beak.y1 = penguinb.y + 10
  beak.x2 = penguinb.x + 4
  beak.y2 = penguinb.y + 10
  beak.Op = 1
  a1.x = penguinb.x - 17
  a1.y = penguinb.y
  a1.Op = 1
  a2.x = penguinb.x + 17
  a2.y = penguinb.y
  a2.Op = 1
}
