let t = 0;
let numCurves = 50;
let colorOffset = 0;

function setup() {
  createCanvas(800, 800);
  noFill();
  frameRate(30);
  background(0);
}

function draw() {
  fill(0, 25);
  rect(0, 0, width, height);

  let frequency = map(mouseX, 0, width, 0.05, 0.5);
  let amplitude = map(mouseY, 0, height, 200, 600);

  for (let i = 0; i < numCurves; i++) {
    let alpha = map(i, 0, numCurves, 50, 255);
    stroke(colorize(i, numCurves, alpha));
    strokeWeight(map(i, 0, numCurves, 1, 4));

    let x1 = width / 2 + cos(t + i * frequency) * amplitude;
    let y1 = height / 2 + sin(t + i * frequency) * amplitude;
    let x2 = width / 2 + cos(t + i * frequency * 1.5) * amplitude;
    let y2 = height / 2 + sin(t + i * frequency * 1.5) * amplitude;
    let cx1 = width / 2 + cos(t + i * frequency * 2) * amplitude * 1.2;
    let cy1 = height / 2 + sin(t + i * frequency * 2) * amplitude * 1.2;
    let cx2 = width / 2 + cos(t + i * frequency * 2.5) * amplitude * 1.2;
    let cy2 = height / 2 + sin(t + i * frequency * 2.5) * amplitude * 1.2;

    bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
  }

  t += 0.02;
  colorOffset += 1;
}

function colorize(curveIndex, totalCurves, alpha) {
  let gradientPosition = map(curveIndex, 0, totalCurves, 0, 1);
  let blue = lerp(255, 128, gradientPosition);
  let red = lerp(0, 128, gradientPosition);
  let green = lerp(0, 64, gradientPosition);
  return color(red, green, blue, alpha);
}
