// p5.js implementation
let vines = [];
let topWidth = 150; // Width of the top side
let baseWidth = 100; // Width of the base side
let Height = 250; // Height of the shape
let angle1 = 0; // Current rotation angle
let targetAngle = Math.PI / 3; // Target angle to stop rotation
let isRotating = false; // Flag to track if rotation is active
let showChaoticLines = true; // Flag to toggle chaotic lines
let rotateButton;
let noiseX1 = 0;
let noiseY1 = 1000;
let noiseX2 = 0;
let noiseY2 = 1000;

function setup() {
  createCanvas(1200, 800);
  rotateButton = new Button("Rotate", width / 2 - 50, height - 60, 100, 40);
  vines.push(new Vine(width / 10, height / 2)); // Start a vine near the left
}

function draw() {
  // Gradient background
  let c1 = color(0, 0, 0); // Start color (black)
  let c2 = color(0, 0, 150); // End color (blue)
  drawGradient(0, 0, width, height, c1, c2);

  // Define cup dimensions
  let centerX = width / 2;
  let centerY = height - Height / 2 - 100;
  let topLeftX = centerX - topWidth / 2;
  let topRightX = centerX + topWidth / 2;
  let baseLeftX = centerX - baseWidth / 2;
  let baseRightX = centerX + baseWidth / 2;
  let topY = centerY - Height / 2;
  let baseY = centerY + Height / 2;

  // Draw ground
  fill(0);
  noStroke();
  quad(0, baseY, width, baseY, width, height, 0, height);

  // Draw button
  rotateButton.display();

  // Rotate the cup
  if (isRotating && angle1 < targetAngle) {
    angle1 += radians(1.5);
    if (angle1 >= targetAngle) {
      angle1 = targetAngle;
      isRotating = false;
    }
  }

  // Apply rotation around the base point
  push();
  translate(baseRightX, baseY);
  rotate(angle1);
  translate(-baseRightX, -baseY);

  // Disable chaotic lines when rotating
  if (showChaoticLines && !isRotating && mouseIsPressed) {
    drawChaoticLines(centerX, centerY, topY);
  }

  // Draw cup
  drawCup(topLeftX, topRightX, baseLeftX, baseRightX, topY, baseY, centerX, centerY);
  pop();

  // Draw vines over the cup
  if (!showChaoticLines && !isRotating) {
    for (let i = vines.length - 1; i >= 0; i--) {
      let v = vines[i];
      v.grow();

      if (v.shouldBranch()) {
        vines.push(v.branch());
      }

      if (v.isDead()) {
        vines.splice(i, 1);
      } else {
        v.display();
      }
    }
  }
}

function mousePressed() {
  if (rotateButton.isMouseOver()) {
    isRotating = true;
    showChaoticLines = false;
    angle1 = 0;
  }
}

function drawCup(topLeftX, topRightX, baseLeftX, baseRightX, topY, baseY, centerX, centerY) {
  stroke(153, 76, 0);
  fill(153, 76, 0);
  ellipse(centerX, centerY - 25, 250, 150);
  fill(51, 0, 102);
  ellipse(centerX, centerY - 25, 200, 100);
  fill(153, 76, 0);
  quad(topLeftX, topY, topRightX, topY, baseRightX, baseY, baseLeftX, baseY);
  quad(topLeftX - 20, topY - 20, topRightX + 20, topY - 20, topRightX, topY, topLeftX, topY);
}

function drawChaoticLines(centerX, centerY, topY) {
  noFill();
  let numLines = 8;

  for (let i = 0; i < numLines; i++) {
    let targetX1 = mouseX + map(noise(noiseX1 + i * 3), 0, 1, -150, 150);
    let targetY1 = mouseY + map(noise(noiseY1 + i * 3), 0, 1, -150, 150);

    let targetX2 = mouseX + map(noise(noiseX2 + i * i / 5), 0, 1, -300, 300);
    let targetY2 = mouseY + map(noise(noiseY2 + i * i / 5), 0, 1, -300, 300);

    strokeWeight(5);
    beginShape();
    vertex(targetX1, targetY1);
    vertex(targetX1 + 45, targetX1 + 100);
    vertex(targetY1, targetX1);
    vertex(400 + targetX1 * 0.5, 300 - targetY1 / 10);
    vertex(centerX - i * 10, topY - 20);
    endShape();

    noiseX1 += 0.05;
    noiseY1 += 0.05;
    noiseX2 += 0.07;
    noiseY2 += 0.02;
  }
}

function drawGradient(x, y, w, h, c1, c2) {
  for (let i = 0; i < h; i++) {
    let inter = map(i, 0, h, 0, 1);
    let c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, y + i, x + w, y + i);
  }
}

class Button {
  constructor(label, x, y, w, h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  display() {
    fill(200);
    rect(this.x, this.y, this.w, this.h, 5);
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.label, this.x + this.w / 2, this.y + this.h / 2);
  }

  isMouseOver() {
    return mouseX > this.x && mouseX < this.x + this.w && mouseY > this.y && mouseY < this.y + this.h;
  }
}

class Vine {
  constructor(startX, startY) {
    this.segments = [createVector(startX, startY)];
    this.vineColor = color(34, 139, 34);
    this.thickness = random(4, 8);
    this.curlFactor = random(2, 6);
    this.waveOffset = random(TWO_PI);
    this.age = 50;
    this.maxAge = int(random(200, 300));
    this.looping = random(1) < 0.3;
    this.baseAngle = random(0, TWO_PI);
  }

  grow() {
    if (this.segments.length > 100) return;
    let last = this.segments[this.segments.length - 1];
    let angle = this.baseAngle + sin(this.waveOffset) * this.curlFactor;
    this.waveOffset += random(0.1, 0.3);
    let stepSize = random(5, 10);
    let newX = last.x + stepSize * cos(angle);
    let newY = last.y + stepSize * sin(angle);

    if (this.looping) {
      let loopAngle = cos(this.waveOffset) * this.curlFactor;
      newX += stepSize * cos(loopAngle);
      newY += stepSize * sin(loopAngle);
    }

    newX = constrain(newX, 0, width);
    newY = constrain(newY, 0, height);

    this.segments.push(createVector(newX, newY));
    this.age++;
  }

  display() {
    noFill();
    stroke(this.vineColor);
    strokeWeight(this.thickness);
    beginShape();
    for (let point of this.segments) {
      curveVertex(point.x, point.y);
    }
    endShape();
  }

  shouldBranch() {
    return random(1) < 0.02 && this.age > 20 && this.segments.length < this.maxAge;
  }

  branch() {
    let last = this.segments[this.segments.length - 1];
    let branch = new Vine(last.x, last.y);
    branch.curlFactor = this.curlFactor + random(-1, 1);
    branch.looping = random(1) < 0.3;
    return branch;
  }

  isDead() {
    return this.age > this.maxAge;
  }
}
