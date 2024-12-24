let noiseOffsetRiver;
let numKids = 10;
let kidX = [];
let kidY = [];
let BaseX1, BaseY1, Lodgeheight;

function setup() {
  createCanvas(800, 600);
  noStroke();

  // Generate random positions for the ski kids
  for (let i = 0; i < numKids; i++) {
    kidX[i] = random(width * 0.53, width * 0.6);
    kidY[i] = random(height * 0.42, height * 0.6);
  }

  // Random Ski Lodge position
  BaseX1 = random(0.33, 0.48);
  BaseY1 = random(0.61, 0.65);
  Lodgeheight = 20;

  noiseOffsetRiver = random(10000);
}

function draw() {
  drawSky();
  drawGlacier();
  drawMountains();
  drawRiver();
  drawSkiLodge();
  drawSkiSlopeKids();
}

// SKY (Gradient)
function drawSky() {
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0.0, 1.0);
    let c1 = color(135, 206, 235);
    let c2 = color(0, 102, 204);
    let col = lerpColor(c1, c2, inter);
    stroke(col);
    line(0, y, width, y);
  }
  noStroke();
}

// MOUNTAINS
function drawMountains() {
  noStroke();
  fill(60, 60, 80);

  // Background mountains (Darker)
  triangle(-400, 800, 350, 230, 700, 800);
  triangle(300, 700, 900, 0, 1400, 700);

  // Second Glacier (In between mountains)
  let Ymin = 370;
  let amplitude = 50;
  let Xmin = 190;
  let Xmax = 450;
  fill(218, 237, 255, 255);
  rect(Xmin, Ymin, Xmax - Xmin);

  beginShape();
  vertex(Xmin, Ymin);
  for (let x = Xmin; x <= Xmax; x += 15) {
    let n = noise(x * 0.02 + 100);
    let GlacierTop = Ymin - amplitude * n;
    vertex(x, GlacierTop);
  }
  vertex(Xmax, Ymin);
  endShape(CLOSE);

  // Foreground mountains
  fill(80, 80, 100);
  triangle(-200, 800, 50, 100, 500, 800);
  triangle(100, 700, 700, 175, 1200, 700);
}

// Drawing the glacier at the top
function drawGlacier() {
  let Ymin = 270;
  let amplitude = 50;
  let Xmin = 350;
  let Xmax = 650;
  fill(218, 237, 255, 255);
  rect(Xmin, Ymin, Xmax - Xmin);

  beginShape();
  vertex(Xmin, Ymin);
  for (let x = Xmin; x <= Xmax; x += 15) {
    let n = noise(x * 0.02 + 100);
    let GlacierTop = Ymin - amplitude * n;
    vertex(x, GlacierTop);
  }
  vertex(Xmax, Ymin);
  endShape(CLOSE);
}

// River
function drawRiver() {
  fill(30, 144, 255, 180);
  beginShape();

  let riverTop = 430;
  let riverBottom = height;

  // Left edge of river
  for (let y = riverTop; y <= riverBottom; y += 5) {
    let ny = noiseOffsetRiver + y * 0.005;
    let riverX = map(noise(ny), 0, 0.5, -0.15 * y + 330, -0.15 * y + 378);
    vertex(riverX, y);
  }

  // Right edge of river
  for (let y = riverBottom; y >= riverTop; y -= 5) {
    let ny = noiseOffsetRiver + y * 0.005;
    let riverX = map(noise(ny), 0, 0.5, 0.2 * y + 200, 0.2 * y + 230);
    vertex(riverX, y);
  }

  endShape(CLOSE);
  noiseOffsetRiver += 0.0005;
}

// Ski Lodge
function drawSkiLodge() {
  fill(153, 76, 0, 255);
  rect(BaseX1 * width, BaseY1 * height, Lodgeheight, Lodgeheight);
  fill(102, 51, 0, 255);
  triangle(
    BaseX1 * width - 10,
    BaseY1 * height,
    BaseX1 * width + 0.5 * Lodgeheight,
    BaseY1 * height - 10,
    BaseX1 * width + Lodgeheight + 10,
    BaseY1 * height
  );
}

// Skiiers on the slope
function drawSkiSlopeKids() {
  fill(255, 0, 0);
  noStroke();
  for (let i = 0; i < numKids; i++) {
    triangle(
      kidX[i], kidY[i] - 5, // top point
      kidX[i] - 4, kidY[i] + 5, // left foot
      kidX[i] + 4, kidY[i] + 5 // right foot
    );
  }
}
