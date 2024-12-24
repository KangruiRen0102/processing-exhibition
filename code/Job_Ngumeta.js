let numSwirls = 600; // Increased number of chaotic swirls
let maxNoise = 1000; // Increased noise offset for more chaos

function setup() {
  createCanvas(1920, 1080); // Higher resolution for more detail
  background(0);
  noStroke();
  frameRate(30);
}

function draw() {
  background(0, 10); // Darker background with faint trail effect

  drawChaos();
  drawAnimal();
  drawTormentedFigures();
  drawClouds();

  if (frameCount > 600) noLoop(); // Stop after a while for static effect
}

function drawChaos() {
  for (let i = 0; i < numSwirls; i++) {
    let x = width / 2 + random(-maxNoise, maxNoise);
    let y = height / 2 + random(-maxNoise, maxNoise);
    let r = random(2, 12);
    fill(random(50, 100), random(10, 50), random(10, 50), 60);
    ellipse(x, y, r, r);
  }
}

function drawAnimal() {
  push();
  translate(width / 2, height / 2);

  // Shadow layer
  fill(10, 10, 20, 180);
  ellipse(0, 100, 600, 350);

  // Body with more texture
  fill(20, 20, 40, 250);
  ellipse(0, 50, 500, 250);

  for (let i = 0; i < 300; i++) {
    let x = random(-250, 250);
    let y = random(-150, 150);
    fill(30, 30, 50, 150);
    ellipse(x, y + 50, random(8, 20), random(20, 30));
  }

  // Head
  fill(30, 20, 50, 255);
  ellipse(0, -75, 200, 160);

  // Eyes
  fill(150, 50, 50, 250);
  ellipse(-60, -100, 40, 55);
  ellipse(60, -100, 40, 55);

  fill(10, 10, 20);
  ellipse(-60, -100, 10, 20);
  ellipse(60, -100, 10, 20);

  noFill();
  stroke(150, 50, 50, 150);
  strokeWeight(5);
  ellipse(-60, -100, 60, 70);
  ellipse(60, -100, 60, 70);

  // Ears
  noStroke();
  fill(20, 10, 40, 220);
  triangle(-90, -150, -130, -200, -50, -160);
  triangle(90, -150, 130, -200, 50, -160);

  // Tail
  fill(15, 10, 30, 220);
  ellipse(0, 250, 100, 500);
  for (let i = 0; i < 100; i++) {
    let x = random(-30, 30);
    let y = random(200, 500);
    fill(10, 10, 20, 180);
    ellipse(x, y, random(8, 20), random(25, 40));
  }

  pop();
}

function drawTormentedFigures() {
  for (let i = 0; i < 100; i++) {
    let x = random(width / 6, (5 * width) / 6);
    let y = random((2 * height) / 3, height);

    fill(30, 30, 40, 250);
    beginShape();
    vertex(x - 30, y);
    vertex(x + 30, y);
    vertex(x + random(-15, 15), y - 60);
    endShape(CLOSE);

    fill(10, 10, 20, 220);
    ellipse(x, y - 30, 25, 35);

    stroke(50, 20, 20, 180);
    strokeWeight(3);
    line(x - 15, y, x - 25, y + 30);
    line(x + 15, y, x + 25, y + 30);
    noStroke();
  }
}

function drawClouds() {
  for (let i = 0; i < 50; i++) {
    let x = random(width);
    let y = random(height);
    let w = random(200, 400);
    let h = random(100, 200);
    fill(20, 20, 30, 120);
    ellipse(x, y, w, h);
  }
}
