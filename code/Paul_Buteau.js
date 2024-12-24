let history = [];
let x, y, x2, y2, x3, y3, x4, y4;
let b = 255.0; // Star alpha value
let l = 255.0; // Aurora alpha value
let k = 0.0;   // Color transformation factor

function setup() {
  createCanvas(1000, 600);
  noStroke();
  background(0);

  // Initialize random positions for stars
  x = random(0, 1000);
  y = random(0, 600);
  x2 = random(0, 1000);
  y2 = random(0, 600);
  x3 = random(0, 1000);
  y3 = random(0, 600);
  x4 = random(0, 1000);
  y4 = random(0, 600);
}

function draw() {
  aurora();
  star();
}

function star() {
  // Update alpha value for stars
  b -= 2;
  if (b < 2) {
    b = 0;
    noLoop(); // Stop the draw loop when alpha reaches 0
  }
  let c = color(b);

  // Draw stars with specified alpha value
  fill(c);
  drawStar(x, y);
  drawStar(x2, y2);
  drawStar(x3, y3);
  drawStar(x4, y4);
}

function drawStar(centerX, centerY) {
  let angle = TWO_PI / 4;
  let halfAngle = angle / 2.0;
  beginShape();
  for (let a = 0; a < TWO_PI; a += angle) {
    let sx = centerX + cos(a) * 25;
    let sy = centerY + sin(a) * 25;
    vertex(sx, sy);
    sx = centerX + cos(a + halfAngle) * 5;
    sy = centerY + sin(a + halfAngle) * 5;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

function aurora() {
  // Update alpha value for aurora
  l -= 2;
  if (l < 0) l = 0;

  // Update color transformation
  k += 0.01;
  let g = abs(cos(k)) * 255 + 155;
  let h = abs(sin(k)) * 255 + 155;

  // Draw aurora trails
  background(0);
  fill(0, g, h, l);

  // Store mouse position history
  history.push([mouseX, mouseY]);
  if (history.length > 200) history.shift();

  for (let i = 0; i < history.length; i++) {
    let [hx, hy] = history[i];
    ellipse(hx, hy, i / 4, i / 4);
  }
}

function mousePressed() {
  // Reset star positions
  x = random(0, 1000);
  y = random(0, 600);
  x2 = random(0, 1000);
  y2 = random(0, 600);
  x3 = random(0, 1000);
  y3 = random(0, 600);
  x4 = random(0, 1000);
  y4 = random(0, 600);

  // Reset alpha values
  b = 255.0;
  l = 255.0;

  loop(); // Resume draw loop
}
