class Flower {
  constructor(x, y, fillColor) {
    this.x = x
    this.y = y
    this.fillColor = fillColor
    this.lifespan = 60
    this.age = 0
  }
  display() {
    if (this.lifespan > 0) {
      fill(this.fillColor, this.lifespan * 2.125)
    }
  }
  update() {
    let d = dist(this.x, this.y, mouseX, mouseY)
    if (d > 140) {
      this.lifespan--
    } else if (this.lifespan < 60) {
      this.lifespan++
    }
    this.age++
  }
  isDead() {
    return this.lifespan <= 0
  }
}

class Simple extends Flower {
  constructor(x, y, petals, size, fillColor) {
    super(x, y, fillColor)
    this.petals = petals
    this.size = size
    this.petalColors = []
    for (let i = 0; i < petals; i++) {
      this.petalColors[i] = color(random(255), random(255), random(255))
    }
  }
  display() {
    if (this.lifespan > 0) {
      super.display()
      push()
      translate(this.x, this.y)
      let scaleFactor = min(1.0, this.age / 15.0)
      scale(scaleFactor)
      let alpha = map(this.lifespan, 0, 60, 0, 255)
      fill(this.petalColors[2], alpha)
      for (let i = 0; i < this.petals; i++) {
        strokeWeight(1)
        stroke(0, alpha)
        rotate((2 * PI) / this.petals)
        ellipse(0, this.size, this.size / (this.petals / 5.0), this.size * 2)
        line(0, 0, 0, this.size)
      }
      fill(255, 255, 0, alpha)
      ellipse(0, 0, this.size, this.size)
      pop()
    }
  }
}

class Pointy extends Flower {
  constructor(x, y, petals, size, fillColor) {
    super(x, y, fillColor)
    this.petals = petals
    this.size = size
    this.petalColors = []
    for (let i = 0; i < petals; i++) {
      this.petalColors[i] = color(random(255), random(255), random(255))
    }
  }
  display() {
    if (this.lifespan > 0) {
      super.display()
      push()
      translate(this.x, this.y)
      let scaleFactor = min(1.0, this.age / 15.0)
      scale(scaleFactor)
      let alpha = map(this.lifespan, 0, 60, 0, 255)
      fill(this.petalColors[2], alpha)
      for (let i = 0; i < this.petals; i++) {
        strokeWeight(1)
        stroke(0, alpha)
        rotate((2 * PI) / this.petals)
        quad(
          0, 0,
          this.size / (this.petals / 2), this.size,
          0, this.size * 2,
          -this.size / (this.petals / 2), this.size
        )
        line(0, 0, 0, this.size)
      }
      fill(255, 255, 0, alpha)
      ellipse(0, 0, this.size, this.size)
      pop()
    }
  }
}

let flowers
let flowerType = 0
let lastFlowerTime = 0
let flowerInterval = 150

function setup() {
  createCanvas(1000, 800)
  imageMode(CENTER)
  flowers = []
  flowers.push(new Simple(200, 200, 8, 20, 40))
  flowers.push(new Pointy(300, 300, 8, 20, 40))
}

function mousePressed() {
  flowerType = random(10)
  if (flowerType < 5) {
    flowers.push(new Simple(
      mouseX + random(-100, 100),
      mouseY + random(-100, 100),
      int(random(4, 10)),
      20,
      color(200)
    ))
  } else {
    flowers.push(new Pointy(
      mouseX + random(-100, 100),
      mouseY + random(-100, 100),
      int(random(4, 10)),
      20,
      color(200)
    ))
  }
}

function mouseMoved() {
  if (millis() - lastFlowerTime > flowerInterval) {
    flowerType = random(10)
    if (flowerType < 5) {
      flowers.push(new Simple(
        mouseX + random(-100, 100),
        mouseY + random(-100, 100),
        int(random(4, 10)),
        20,
        color(200)
      ))
    } else {
      flowers.push(new Pointy(
        mouseX + random(-100, 100),
        mouseY + random(-100, 100),
        int(random(4, 10)),
        20,
        color(200)
      ))
    }
    lastFlowerTime = millis()
  }
}

function keyPressed() {
  if (key === 's') {
    flowerInterval = max(flowerInterval - 100, 25)
  } else if (key === 'f') {
    flowerInterval += 100
  }
}

function drawFilledGradient(x, y, radius) {
  for (let r = radius; r > 0; r--) {
    if (r < radius / 1.5) {
      fill(65, 120, 70)
    } else {
      let c1 = map(r, radius, radius / 1.5, 0, 65)
      let c2 = map(r, radius, radius / 1.5, 0, 120)
      let c3 = map(r, radius, radius / 1.5, 0, 70)
      fill(c1, c2, c3)
    }
    noStroke()
    ellipse(x, y, r * 2, r * 2)
  }
}

function draw() {
  background(0)
  fill(200)
  ellipse(mouseX, mouseY, 400, 400)
  drawFilledGradient(mouseX, mouseY, 200)
  for (let i = flowers.length - 1; i >= 0; i--) {
    let flower = flowers[i]
    flower.update()
    flower.display()
    if (flower.isDead()) {
      flowers.splice(i, 1)
    }
  }
  noFill()
  stroke(0)
  strokeWeight(120)
  ellipse(mouseX, mouseY, 500, 500)
}
