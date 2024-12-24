let studyTime = 0;
let studying = true;

let candleHeight = 100;
let candleWaxRate = 0.1;
let flameHeight = 10;
let isFlameFlickering = true;

function setup() {
  createCanvas(800, 800);
  frameRate(60);
}

function draw() {
  background(255);
  
  drawClock(700, 50);
  drawStudent(width / 2, height / 2 + 50);
  drawCandle(100, height - 150);
  
  studyTime++;
  
  if (studyTime % 60 === 0) {
    drawBookPageTurn(width / 2 - 30, height / 2 + 50);
  }
  
  fill(0);
  textSize(32);
  textAlign(CENTER);
  text("Studying forever...", width / 2, height - 100);
}

function drawStudent(x, y) {
  fill(255, 224, 189);
  ellipse(x, y - 60, 40, 40);

  stroke(0);
  line(x, y - 40, x, y + 40);
  line(x, y, x - 30, y + 40);
  line(x, y, x + 30, y + 40);
  line(x, y - 20, x - 30, y - 40);
  line(x, y - 20, x + 30, y - 40);

  fill(200, 150, 100);
  rect(x - 30, y - 40, 60, 20);

  fill(0);
  ellipse(x - 10, y - 65, 5, 5);
  ellipse(x + 10, y - 65, 5, 5);
}

function drawBookPageTurn(x, y) {
  stroke(0);
  fill(255, 255, 255, 200);
  beginShape();
  vertex(x, y);
  vertex(x + 30, y - 10);
  vertex(x + 30, y + 10);
  vertex(x, y + 20);
  endShape(CLOSE);
}

function drawClock(x, y) {
  stroke(0);
  noFill();
  ellipse(x, y, 100, 100);

  let secondAngle = map(studyTime % 60, 0, 60, 0, TWO_PI) - HALF_PI;
  let minuteAngle = map((studyTime / 60) % 60, 0, 60, 0, TWO_PI) - HALF_PI;
  let hourAngle = map((studyTime / 3600) % 12, 0, 12, 0, TWO_PI) - HALF_PI;

  stroke(255, 0, 0);
  line(x, y, x + cos(secondAngle) * 40, y + sin(secondAngle) * 40);

  stroke(0, 0, 255);
  line(x, y, x + cos(minuteAngle) * 30, y + sin(minuteAngle) * 30);

  stroke(0);
  line(x, y, x + cos(hourAngle) * 20, y + sin(hourAngle) * 20);

  fill(0);
  ellipse(x, y, 10, 10);
}

function drawCandle(x, y) {
  fill(255, 255, 0);
  rect(x - 10, y - candleHeight, 20, candleHeight);

  candleHeight -= candleWaxRate;
  if (candleHeight < 0) candleHeight = 0;

  drawFlame(x, y - candleHeight);
}

function drawFlame(x, y) {
  if (isFlameFlickering) {
    flameHeight = random(8, 15);
  } else {
    flameHeight = 12;
  }

  fill(255, 69, 0);
  triangle(x - 5, y - flameHeight, x + 5, y - flameHeight, x, y - flameHeight - 20);

  if (studyTime % 20 === 0) {
    isFlameFlickering = !isFlameFlickering;
  }
}
