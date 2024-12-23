let numSegments = 10; // Number of segments in the kaleidoscope
let growth = 1; // Growth factor for shapes

function setup() {
  createCanvas(800, 800);
  background(0);
  frameRate(60);
}

function draw() {
  translate(width / 2, height / 2); // Center the kaleidoscope
  let t = millis() * 0.001; // Time for growth

  // Interactive element for growth and memory creation over time
  if (mouseIsPressed) {
    growth += 0.2; // Growth increases with interaction
    let x = mouseX - width / 2;
    let y = mouseY - height / 2;
    drawKaleidoscope(x, y, growth);
  } else {
    growth *= 0.99;
  }

  fill(0, 20);
  rect(-width / 2, -height / 2, width, height); // Fades for memory blending
}

function drawKaleidoscope(x, y, size) {
  for (let i = 0; i < numSegments; i++) {
    push();
    let angle = TWO_PI / numSegments * i;
    rotate(angle);
    mirrorSymmetry(x, y, size);
    pop();
  }
}

// Draw and mirror the memory shapes
function mirrorSymmetry(x, y, size) {
  fill(colorMap(size), 100, 200, 150);
  noStroke();
  ellipse(x, y, size * 0.5, size * 0.5); // Primary shape

  fill(colorMap(size + 50), 150, 250, 100);
  triangle(
    x - size * 0.1, y - size * 0.1,
    x + size * 0.1, y - size * 0.1,
    x, y + size * 0.2
  ); // Supporting shapes

  // Mirroring effect for reflection
  push();
  scale(-1, 1); // Flip horizontally
  ellipse(x, y, size * 0.5, size * 0.5);
  triangle(
    x - size * 0.1, y - size * 0.1,
    x + size * 0.1, y - size * 0.1,
    x, y + size * 0.2
  );
  pop();
}

// Map colors based on the growth size
function colorMap(size) {
  return int(map(size % 255, 0, 255, 100, 255));
}
