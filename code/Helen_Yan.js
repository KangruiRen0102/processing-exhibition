function setup() {
  createCanvas(800, 600);
  background(30, 30, 100); // night sky background
  noLoop();
}

function draw() {
  drawBuildings();
  drawBorder();
  drawThinBorder();
}

function drawBuildings() {
  noStroke();
  for (let i = 0; i < 10; i++) {
    let buildingWidth = random(50, 100);
    let buildingHeight = random(200, 500);
    let x = i * 80 + random(-10, 10);
    let y = height - buildingHeight;

    fill(50, 50, 70);
    rect(x, y, buildingWidth, buildingHeight);

    drawWindows(x, y, buildingWidth, buildingHeight);
  }
}

function drawWindows(x, y, w, h) {
  fill(255, 215, 0); // window lights
  let rows = int(h / 30);
  let cols = int(w / 20);
  for (let i = 1; i < rows; i++) {
    for (let j = 1; j < cols; j++) {
      if (random(1) > 0.5) {
        let wx = x + j * 15;
        let wy = y + i * 25;
        rect(wx, wy, 10, 10);
      }
    }
  }
}

function drawBorder() {
  noFill();
  stroke(255);
  strokeWeight(80);
  rect(0, 0, width, height);
}

function drawThinBorder() {
  noFill();
  stroke(0); // Black thin border
  strokeWeight(10); // Thin border
  rect(5, 5, width - 10, height - 10);
}
