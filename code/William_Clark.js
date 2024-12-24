let xposition = 200
let yposition = -800
let randomsize
let randompos
let ycar = 400
let lp = -400

function setup() {
  createCanvas(800, 800)
  noFill()
  stroke(0)
  randomsize = random(180, 200)
  randompos = random(-30, 30)
}

function draw() {
  background(80, 135, 81)
  drawrect()
  tree(xposition, yposition, randompos, randomsize)
  tree(xposition - 100, yposition - 400, randompos, randomsize)
  tree(xposition - 50, yposition - 700, randompos, randomsize)
  tree(xposition + 476, yposition - 300, randompos, randomsize)
  tree(xposition + 500, yposition + 400, randompos, randomsize)
  tree(xposition + 600, yposition - 900, randompos, randomsize)
  stroke(201, 196, 48)
  strokeWeight(2)
  drawline(lp)
  lp += 4
  if (lp >= 0) {
    lp = -60
  }
  drawcar(ycar)
  yposition += 4
  if (yposition >= 1800) {
    yposition = -500
  }
}

function tree(x, y, rpos, rsize) {
  fill(35, 110, 62)
  ellipse(x, y, rsize, rsize)
  stroke(0)
  strokeWeight(1)
}

function drawcar(y) {
  let mouseXrestrict = constrain(mouseX, 335, 465)
  stroke(0)
  fill(176, 41, 26)
  rect(mouseXrestrict - 25, y, 50, 80)
  stroke(0)
  fill(0)
  rect(mouseXrestrict - 32, y + 8, 7, 20)
  rect(mouseXrestrict + 25, y + 8, 7, 20)
  rect(mouseXrestrict - 32, y + 50, 7, 20)
  rect(mouseXrestrict + 25, y + 50, 7, 20)
}

function drawrect() {
  fill(156, 156, 156)
  stroke(0)
  strokeWeight(1)
  rect(300, 0, 200, 800)
}

function drawline(pos) {
  for (let i = 0; i < 50; i++) {
    let y = pos + i * 60
    fill(201, 196, 48)
    rect(397.5, y, 5, 40)
  }
}
