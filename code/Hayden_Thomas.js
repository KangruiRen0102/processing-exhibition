let xOffset = 0
let yOffset = 0

function setup() {
  createCanvas(800, 800)
  noStroke()
}

function draw() {
  background(10, 20, 40)
  for (let i = 0; i < 50; i++) {
    push()
    fill(100, 150, 255, 180)
    translate(
      (width / 2) + noise(i, frameCount * 0.001) * width - width / 2 + xOffset,
      (height / 2) + noise(i + 100, frameCount * 0.001) * height - height / 2 + yOffset
    )
    drawIceShape(random(20, 40))
    pop()
  }
  for (let i = 0; i < 10; i++) {
    fill(50, 100, 255, 100 - i * 10)
    ellipse(width / 2 + xOffset, height / 2 + yOffset, width - i * 80, height - i * 80)
  }
  for (let i = 0; i < width; i += 20) {
    fill(0, 50, 200, 200)
    ellipse(
      i + xOffset,
      height / 2 + sin((i + frameCount) * 0.05) * 50 + yOffset,
      15,
      15
    )
  }
}

function drawIceShape(size) {
  beginShape()
  for (let i = 0; i < 6; i++) {
    let angle = TWO_PI / 6 * i
    let x = cos(angle) * size
    let y = sin(angle) * size
    vertex(x, y)
  }
  endShape(CLOSE)
}
