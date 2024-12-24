let hours = 1;
let counter = 1;
let lineNum = 1;

function setup() {
  createCanvas(1920, 1080, WEBGL);
  frameRate(10);
  colorMode(RGB, 255, 255, 255, 255);
  background(0);
}

function draw() {
  if ((counter % 2 === 0) && (hours === 9)) {
    background(255 * sin(millis() * 0.001));
  } else {
    background(0);
  }

  stroke(252, 15, 192, 40);
  for (let i = 0; i < lineNum; i++) {
    let x0 = random(width) - width / 2;
    let y0 = random(height) - height / 2;
    let z0 = random(-100, 100);
    let x1 = random(width) - width / 2;
    let y1 = random(height) - height / 2;
    let z1 = random(-100, 100);

    line(x0, y0, z0, x1, y1, z1);

    if (counter % 2 === 0) {
      stroke(255, 255, 255, 255);

      if (hours < 9 && hours > 0) {
        fill(255);
        textSize(32);
        textAlign(LEFT, CENTER);
        text("Hours spent:", -width / 2 + 40, -height / 2 + 120);
        text(hours, -width / 2 + 400, -height / 2 + 120);
      }

      if (hours === 9) {
        fill(255);
        textSize(32);
        textAlign(LEFT, CENTER);
        text("Hours spent:", -width / 2 + 40, -height / 2 + 120);
        text("9+", -width / 2 + 400, -height / 2 + 120);
      }

      fill(0);
      rectMode(CENTER);
      rect(0, 0, 300, 1500);
      ellipse(0, -150, 300, 300);

      fill(hours * (255 / 9));
      ellipse(-75, -200, 50, 50);
      ellipse(75, -200, 50, 50);
    } else {
      lineNum = 20;
      textSize(64);
      fill(255);
      textAlign(LEFT, CENTER);
      text("Click the mouse to see how it feels working on assignments", -width / 2 + 40, -height / 2 + 120);
      text("Then press a number from 1 to 9", -width / 2 + 40, -height / 2 + 200);
    }
  }
}

function mousePressed() {
  counter += 1;
  redraw();
}

function keyPressed() {
  if (key >= '1' && key <= '9') {
    hours = int(key);
  }
  lineNum = hours * 50;
  redraw();
}
