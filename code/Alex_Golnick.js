let bridgeSegments = []
let isBridgeComplete = false
let riverBands = []
let trees = []
let rightHouses = []
let car

function setup() {
  createCanvas(800, 600)
  frameRate(30)
  initializeRiverBands()
  initializeTrees()
  car = new Car(50, height / 2 - 12)
}

function draw() {
  drawRiver()
  drawBanks()
  drawBridge()
  drawRoads()
  drawHouses()
  drawRightHouses()
  drawTrees()
  car.display()
}

function mousePressed() {
  if (!isBridgeComplete) {
    addBridgeSegment()
  } else {
    addRightHouse()
  }
}

function initializeRiverBands() {
  for (let i = 0; i < 20; i++) {
    riverBands.push(
      new RiverBand(width / 4, height - i * 30, width / 2, 30, color(0, 0, 150 + i * 5))
    )
  }
}

function initializeTrees() {
  for (let i = 0; i < 5; i++) {
    trees.push(new Tree(random((3 * width) / 4 + 20, width - 20), random(height - 200, height - 50)))
  }
}

function addBridgeSegment() {
  let segmentWidth = 60
  let nextX = bridgeSegments.length * segmentWidth
  if (width / 4 + nextX < (3 * width) / 4) {
    bridgeSegments.push(new BridgeSegment(width / 4 + nextX, height / 2 - 10))
  } else {
    isBridgeComplete = true
  }
}

function addRightHouse() {
  if (rightHouses.length < 3) {
    let newX = random((3 * width) / 4 + 20, width - 70)
    let newY = random(height / 4, height / 2 - 50)
    if (!isOverlapping(newX, newY)) {
      rightHouses.push(new House(newX, newY))
    }
  }
}

function isOverlapping(newX, newY) {
  for (let house of rightHouses) {
    if (dist(newX + 25, newY + 25, house.x + 25, house.y + 25) < 55) {
      return true
    }
  }
  return false
}

function drawRiver() {
  for (let band of riverBands) {
    band.update()
    band.display()
  }
}

function drawBanks() {
  fill(124, 252, 0)
  rect(0, 0, width / 4, height)
  rect((3 * width) / 4, 0, width / 4, height)
}

function drawBridge() {
  for (let segment of bridgeSegments) {
    segment.display()
  }
}

function drawRoads() {
  fill(50, 50, 50)
  rect(0, height / 2 - 10, width / 4, 20)
  rect((3 * width) / 4, height / 2 - 10, width / 4, 20)
}

function drawHouses() {
  fill(139, 69, 19)
  rect(50, height / 3, 50, 50)
  rect(150, height / 3 + 30, 50, 50)
  fill(178, 34, 34)
  triangle(50, height / 3, 75, height / 3 - 30, 100, height / 3)
  triangle(150, height / 3 + 30, 175, height / 3, 200, height / 3 + 30)
}

function drawRightHouses() {
  for (let house of rightHouses) {
    house.display()
  }
}

function drawTrees() {
  for (let tree of trees) {
    tree.display()
  }
}

class BridgeSegment {
  constructor(x, y) {
    this.x = x
    this.y = y
    this.width = 60
    this.height = 20
  }

  display() {
    fill(105, 105, 105)
    rect(this.x, this.y, this.width, this.height)
    fill(70, 70, 70)
    rect(this.x + this.width / 4, this.y + this.height, this.width / 2, 20)
  }
}

class RiverBand {
  constructor(x, y, w, h, c) {
    this.x = x
    this.y = y
    this.width = w
    this.height = h
    this.color = c
    this.speed = 2
  }

  update() {
    this.y -= this.speed
    if (this.y + this.height < 0) {
      this.y = height
    }
  }

  display() {
    fill(this.color)
    rect(this.x, this.y, this.width, this.height)
  }
}

class Tree {
  constructor(x, y) {
    this.x = x
    this.y = y
  }

  display() {
    fill(139, 69, 19)
    rect(this.x - 5, this.y, 10, 20)
    fill(34, 139, 34)
    ellipse(this.x, this.y - 10, 30, 30)
  }
}

class House {
  constructor(x, y) {
    this.x = x
    this.y = y
  }

  display() {
    fill(139, 69, 19)
    rect(this.x, this.y, 50, 50)
    fill(178, 34, 34)
    triangle(this.x, this.y, this.x + 25, this.y - 30, this.x + 50, this.y)
  }
}

class Car {
  constructor(x, y) {
    this.x = x
    this.y = y
  }

  display() {
    fill(255, 0, 0)
    rect(this.x, this.y, 40, 20)
    fill(0)
    ellipse(this.x + 10, this.y + 20, 10, 10)
    ellipse(this.x + 30, this.y + 20, 10, 10)
  }
}
