class Shape {
  constructor(x, y, fillColor) {
    this.x = x
    this.y = y
    this.fillColor = fillColor
  }
  display() {}
  isInside(mx, my) { return false }
}

class EllipseShape extends Shape {
  constructor(x, y, w, h, fillColor) {
    super(x, y, fillColor)
    noStroke()
    this.w = w
    this.h = h
  }
  display() {
    fill(this.fillColor)
    ellipse(this.x, this.y, this.w, this.h)
  }
  isInside(mx, my) {
    return dist(mx, my, this.x, this.y) < this.w / 2
  }
}

class ShapeManager {
  constructor() {
    this.shapes = []
  }
  addShape(shape) {
    this.shapes.push(shape)
  }
  displayShapes() {
    for (let s of this.shapes) {
      s.display()
    }
  }
  getShapeAt(mx, my) {
    for (let s of this.shapes) {
      if (s.isInside(mx, my)) return s
    }
    return null
  }
  clearShapes() {
    this.shapes = []
  }
}

class InteractionController {
  constructor(shapeManager) {
    this.shapeManager = shapeManager
    this.selectedShape = null
    this.offsetX = 0
    this.offsetY = 0
  }
  handleMousePressed(mx, my) {
    this.selectedShape = this.shapeManager.getShapeAt(mx, my)
    if (this.selectedShape) {
      this.offsetX = mx - this.selectedShape.x
      this.offsetY = my - this.selectedShape.y
    }
  }
  handleMouseDragged(mx, my) {
    if (this.selectedShape) {
      this.selectedShape.x = mx - this.offsetX
      this.selectedShape.y = my - this.offsetY
    }
  }
  handleMouseReleased() {
    this.selectedShape = null
  }
}

let shapeManager
let interactionController

function setup() {
  createCanvas(800, 600)
  shapeManager = new ShapeManager()
  interactionController = new InteractionController(shapeManager)
  createGradientBackground()
  let centerX = width / 2
  let centerY = height / 2
  let loopWidth = 150
  let loopHeight = 100
  let numEllipses = 20
  let ellipseWidth = 50
  let ellipseHeight = 30
  let numEllipsesInLoop = numEllipses / 2
  for (let i = 0; i < numEllipsesInLoop; i++) {
    let angleLeft = map(i, 0, numEllipsesInLoop, -PI, PI)
    let angleRight = map(i, 0, numEllipsesInLoop, -PI, PI)
    let xLeft = centerX - loopWidth + loopWidth * cos(angleLeft)
    let yLeft = centerY + loopHeight * sin(angleLeft)
    shapeManager.addShape(
      new EllipseShape(
        xLeft,
        yLeft,
        ellipseWidth,
        ellipseHeight,
        color(random(255), random(255), random(255))
      )
    )
    let xRight = centerX + loopWidth + loopWidth * cos(angleRight)
    let yRight = centerY + loopHeight * sin(angleRight)
    shapeManager.addShape(
      new EllipseShape(
        xRight,
        yRight,
        ellipseWidth,
        ellipseHeight,
        color(random(255), random(255), random(255))
      )
    )
  }
}

function draw() {
  shapeManager.displayShapes()
}

function mousePressed() {
  interactionController.handleMousePressed(mouseX, mouseY)
}

function mouseDragged() {
  interactionController.handleMouseDragged(mouseX, mouseY)
}

function mouseReleased() {
  interactionController.handleMouseReleased()
}

function createGradientBackground() {
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1)
    let c = lerpColor(color(60, 0, 200), color(65, 145, 100), inter)
    stroke(c)
    line(0, y, width, y)
  }
}
