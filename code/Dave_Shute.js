let numShapes = 50
let xPos = []
let yPos = []
let sizes = []
let maxSizes = []
let bloomColors = []
let blooming = false
let auroraOffset = 0.5
let auroraColor
let addWaves = false
let waveOffset = 0

function setup() {
  createCanvas(600, 600)
  noStroke()
  for (let i = 0; i < numShapes; i++) {
    xPos[i] = random(width)
    yPos[i] = random(height / 2, height)
    sizes[i] = random(2, 8)
    maxSizes[i] = random(15, 20)
    bloomColors[i] = randomFlowerColor()
  }
  auroraColor = color(34, 139, 34)
}

function draw() {
  background(0)
  drawOcean()
  drawAurora()
  drawHill()
  for (let i = 0; i < numShapes; i++) {
    if (blooming) {
      sizes[i] += 0.5
      if (sizes[i] > maxSizes[i]) {
        sizes[i] = maxSizes[i]
      }
    }
    if (yPos[i] >= hillY(xPos[i])) {
      drawFlower(xPos[i], yPos[i], sizes[i], bloomColors[i])
    }
  }
}

function drawAurora() {
  let alpha = 100
  noFill()
  strokeWeight(10)
  stroke(auroraColor, alpha)
  for (let i = 0; i < 3; i++) {
    let offsetY = i * 20
    beginShape()
    for (let x = 0; x <= width; x++) {
      let y = (height * 0.2) + 100 * sin(TWO_PI * (x + auroraOffset) / width) + offsetY
      vertex(x, y)
    }
    endShape()
  }
  auroraOffset += 0.5
}

function drawHill() {
  noStroke()
  fill(34, 139, 34)
  beginShape()
  vertex(0, height)
  for (let x = 0; x <= width; x++) {
    let y = height - 300 * sin(TWO_PI * x / (2 * width))
    vertex(x, y)
  }
  vertex(width, height)
  endShape(CLOSE)
}

function hillY(x) {
  return height - 300 * sin(TWO_PI * x / (2 * width))
}

function drawFlower(x, y, size, c) {
  let numPetals = 6
  let petalAngle = TWO_PI / numPetals
  let petalLength = size
  noStroke()
  fill(c)
  for (let i = 0; i < numPetals; i++) {
    let angle = i * petalAngle
    let px = x + cos(angle) * petalLength
    let py = y + sin(angle) * petalLength
    ellipse(px, py, size, size)
  }
  fill(255, 255, 0)
  ellipse(x, y, size * 0.4, size * 0.4)
}

function drawOcean() {
  fill(0, 0, 255)
  noStroke()
  if (addWaves) {
    for (let x = 0; x <= width; x++) {
      let waveHeight = 5 * sin(8 * TWO_PI * (x + waveOffset) / width)
      rect(x, height * 0.75 + waveHeight, 1, height * 0.25)
    }
    waveOffset += 2
  } else {
    rect(0, height * 0.75, width, height * 0.25)
  }
}

function randomFlowerColor() {
  let r = int(random(4))
  switch (r) {
    case 0: return color(186, 85, 211)
    case 1: return color(128, 0, 128)
    case 2: return color(138, 43, 226)
    case 3: return color(223, 115, 255)
    default: return color(186, 85, 211)
  }
}

function keyPressed() {
  if (key == 'b' || key == 'B') {
    blooming = true
  } else if (key == 'r' || key == 'R') {
    blooming = false
    for (let i = 0; i < numShapes; i++) {
      sizes[i] = random(2, 8)
    }
  } else if (key == 'n' || key == 'N') {
    auroraColor = color(random(100, 255), random(100, 255), random(100, 255))
  } else if (key == 'v' || key == 'V') {
    addWaves = !addWaves
  }
}
