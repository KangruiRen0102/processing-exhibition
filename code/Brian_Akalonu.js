let isFrozen = false

function setup() {
  createCanvas(1000, 1000)
  background(20)
  frameRate(60)
  noCursor()
}

function draw() {
  if (!isFrozen) {
    for (let i = 0; i < 10; i++) {
      let x = random(width)
      let y = random(height)
      let size = random(30, 100)
      noStroke()
      fill(random(255), random(255), random(255), 150)
      ellipse(x, y, size, size)
    }
    stroke(255, 200)
    strokeWeight(frameCount % 10 + 1)
    line(pmouseX, pmouseY, mouseX, mouseY)
    let growthSpeed = millis() * 0.01
    stroke(random(255), 200)
    noFill()
    ellipse(width / 2, height / 2, growthSpeed % width, growthSpeed % height)
    fill(100, 10)
    rect(0, 0, width, height)
  }
}

function mousePressed() {
  isFrozen = !isFrozen
}
