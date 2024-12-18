function setup() {
  createCanvas(800, 800); // Canvas size
  noLoop();
}

function draw() {
  background(20); // Dark background to symbolize the unknown chaos of life

  // Create chaotic shapes and colors
  for (let i = 0; i < 150; i++) {
    let x = random(width);
    let y = random(height);
    let size = random(10, 50);
    let r = int(random(100, 255));
    let g = int(random(100, 255));
    let b = int(random(100, 255));

    fill(r, g, b, 150);
    noStroke();
    ellipse(x, y, size, size);
  }

  // Add a "frozen moment" at the center
  push();
  translate(width / 2, height / 2);
  for (let i = 0; i < 50; i++) {
    let angle = TWO_PI / 50 * i;
    let x = cos(angle) * 150;
    let y = sin(angle) * 150;

    stroke(255);
    strokeWeight(2);
    line(0, 0, x, y);
  }
  pop();

  // Add flowing lines to symbolize the journey ahead
  noFill();
  stroke(255, 200, 0);
  strokeWeight(2);
  for (let i = 0; i < 10; i++) {
    let offset = i * 15;
    beginShape();
    for (let x = 0; x < width; x += 5) {
      let y = height / 2 + sin(x * 0.01 + offset) * 100;
      vertex(x, y);
    }
    endShape();
  }
}
