let snowflakeCount = 300;
let snowX = [];
let snowY = [];
let snowXSpeed = [];
let snowYSpeed = [];
let auroraWave = 0;

function setup() {
  createCanvas(800, 800);
  background(10, 10, 40);
  frameRate(2);

  for (let i = 0; i < snowflakeCount; i++) {
    snowX[i] = random(width);
    snowY[i] = random(height);
    snowXSpeed[i] = random(-2, 2);
    snowYSpeed[i] = random(2, 5);
  }
}

function draw() {
  background(10, 10, 40, 10);

  drawMountains();
  drawFrozen();
  drawAurora();
  drawMoon();
  drawSnow();
}

function drawMountains() {
  noStroke();

  fill(60, 100, 140, 200);
  triangle(100, height - 150, 300, height - 400, 500, height - 150);
  triangle(400, height - 150, 600, height - 350, 750, height - 150);

  fill(100, 140, 180, 220);
  triangle(50, height - 150, 200, height - 300, 350, height - 150);
  triangle(500, height - 150, 700, height - 300, 850, height - 150);
}

function drawFrozen() {
  noStroke();
  fill(200, 240, 255, 200);
  rect(0, height - 150, width, 150);
}

function drawAurora() {
  noStroke();
  for (let i = 0; i < 5; i++) {
    let y = random(height / 3);
    let widthAurora = random(200, 400);
    fill(random(0, 100), random(150, 255), random(0, 100), 120);
    ellipse(random(width), y, widthAurora, 60);
  }
  auroraWave += 0.1;
}

function drawMoon() {
  noStroke();
  fill(255, 255, 200, 200);
  ellipse(width - 100, 100, 80, 80);
}

function drawSnow() {
  noStroke();
  fill(255, 255, 255, 150);

  for (let i = 0; i < snowflakeCount; i++) {
    ellipse(snowX[i], snowY[i], 5, 5);

    snowY[i] += snowYSpeed[i];
    snowX[i] += snowXSpeed[i];

    if (snowY[i] > height) {
      snowY[i] = 0;
      snowX[i] = random(width);
      snowXSpeed[i] = random(-2, 2);
      snowYSpeed[i] = random(2, 5);
    }

    if (snowX[i] < 0) {
      snowX[i] = width;
    } else if (snowX[i] > width) {
      snowX[i] = 0;
    }
  }
}
