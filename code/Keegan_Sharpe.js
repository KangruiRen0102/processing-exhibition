let rectX, rectY;
let speedX, speedY;
let areaX, areaY;
let areaWidth, areaHeight;
let rectColor;
let colorIndex;

function setup() {
  createCanvas(800, 600);
  
  rectX = 250;
  rectY = 250;
  speedX = 1.5;
  speedY = 1.5;

  areaX = 50;
  areaY = 50;
  areaWidth = 700;
  areaHeight = 500;

  colorIndex = 0;
  rectColor = color(0, 0, 255);
  textSize(32);
  textAlign(CENTER, CENTER);
}

function draw() {
  drawMovingRectangle();
}

function drawMovingRectangle() {
  background(0);

  rectX += speedX;
  rectY += speedY;

  if (rectX < areaX || rectX + 100 > areaX + areaWidth) {
    speedX *= -1;
    changeColor();
  }
  if (rectY < areaY || rectY + 50 > areaY + areaHeight) {
    speedY *= -1;
    changeColor();
  }

  noFill();
  stroke(255);
  rect(areaX, areaY, areaWidth, areaHeight);

  fill(rectColor);
  rect(rectX, rectY, 100, 50);

  fill(0);
  text("DVD", rectX + 50, rectY + 25);
}

function changeColor() {
  colorIndex = (colorIndex + 1) % 3;

  if (colorIndex === 0) {
    rectColor = color(0, 0, 255);
  } else if (colorIndex === 1) {
    rectColor = color(0, 255, 0);
  } else if (colorIndex === 2) {
    rectColor = color(255, 0, 0);
  }
}
