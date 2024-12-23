let sliderX, sliderY;
let sliderWidth = 200;
let sliderHeight = 10;
let sliderPosX;
let dragging = false; // Defining the slider

function setup() {
  createCanvas(800, 400);
  sliderX = width / 2 - sliderWidth / 2;
  sliderY = height - 50;
  sliderPosX = sliderX;
}

function draw() {
  let bgColor = map(sliderPosX, sliderX, sliderX + sliderWidth, 0, 255);
  background(200 - bgColor, 197, 134); // Background changes based on slider position

  // Draw the sine wave
  drawSineWave();

  // Draw the slider
  drawSlider();

  // Draw the flowers
  drawFlowers();
}

function drawSineWave() {
  let amplitude = 100;
  let frequency = 0.01;
  let centerY = height / 2;

  stroke(68, 109, 198);
  strokeWeight(2);
  for (let x = 0; x < width; x++) {
    let y = centerY + amplitude * sin(frequency * x);
    point(x, y);
  }
}

function drawFlowers() {
  let growthFactor = map(sliderPosX, sliderX, sliderX + sliderWidth, 10, 100);
  growthFactor = constrain(growthFactor, 10, 30);

  // Set specific positions for flowers
  drawFlower(100, 200, growthFactor); // Left
  drawFlower(400, 50, growthFactor); // Middle
  drawFlower(500, 250, growthFactor); // Right
  drawFlower(700, 120, growthFactor);
}

function drawFlower(x, y, size) {
  let petals = int(map(sliderPosX, sliderX, sliderX + sliderWidth, 3, 10)); // Number of petals
  let angleStep = TWO_PI / petals;

  push();
  translate(x, y);

  // Draw petals
  fill(255, 100, 150); // Petal color
  noStroke();
  for (let angle = 0; angle < TWO_PI; angle += angleStep) {
    let px = cos(angle) * size;
    let py = sin(angle) * size;

    ellipse(px, py, size / 2, size); // Petal shape
  }

  // Draw flower center
  fill(255, 200, 50);
  ellipse(0, 0, size / 2, size / 2);

  pop();
}

function drawSlider() {
  // Draw the slider track
  strokeWeight(3);
  stroke(0);
  fill(200);
  rect(sliderX, sliderY, sliderWidth, sliderHeight);

  // Draw the slider handle
  fill(50);
  ellipse(sliderPosX, sliderY + sliderHeight / 2, 20, 20);
}

function mousePressed() {
  // Check if the mouse is over the slider handle
  if (
    mouseX > sliderPosX - 10 &&
    mouseX < sliderPosX + 10 &&
    mouseY > sliderY &&
    mouseY < sliderY + sliderHeight
  ) {
    dragging = true;
  }
}

function mouseDragged() {
  if (dragging) {
    // Move the slider handle within the track
    sliderPosX = constrain(mouseX, sliderX, sliderX + sliderWidth);
  }
}

function mouseReleased() {
  dragging = false;
}
