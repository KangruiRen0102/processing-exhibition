function setup() {
  createCanvas(800, 600);
}

function draw() {
  drawSky();        // Sky and birds
  drawSea();        // Sea with waves
  drawField();      // Green field
  drawFarm();       // Farmhouse, barn, and more
  drawBirds();      // Birds flying in the air
}

// Draw the sky
function drawSky() {
  for (let y = 0; y < height / 2; y++) {
    let inter = map(y, 0, height / 2, 0, 1);
    stroke(lerp(135, 255, inter), lerp(206, 255, inter), 250);
    line(0, y, width, y);
  }
}

// Draw the sea
function drawSea() {
  noStroke();
  fill(70, 130, 180); // Deep sea blue
  rect(0, height / 2, width, height / 4);

  // Waves
  stroke(255);
  strokeWeight(2);
  for (let i = 0; i < width; i += 20) {
    let waveY = height / 2 + height / 8 + sin(frameCount * 0.05 + i * 0.2) * 10;
    line(i, waveY, i + 10, waveY - 5);
  }
}

// Draw the green field
function drawField() {
  noStroke();
  fill(34, 139, 34); // Grass green
  rect(0, height / 2 + height / 4, width, height / 4);
}

// Draw the farm area
function drawFarm() {
  drawFarmhouse();
  drawBarn();
  drawFence();
  drawPathway();
  drawTrees();
  drawBushes();
}

// Draw the farmhouse
function drawFarmhouse() {
  fill(220, 20, 60); // Red
  rect(600, height - 150, 100, 80); // Main body
  fill(139, 69, 19); // Roof
  triangle(600, height - 150, 700, height - 150, 650, height - 200);
}

// Draw the barn
function drawBarn() {
  fill(255, 165, 0); // Orange
  rect(500, height - 140, 80, 60); // Main body
  fill(139, 69, 19); // Roof
  triangle(500, height - 140, 580, height - 140, 540, height - 180);

  // Barn door
  fill(139, 69, 19); // Brown
  rect(530, height - 100, 20, 40);
}

// Draw the fence
function drawFence() {
  stroke(139, 69, 19); // Brown wood
  strokeWeight(3);
  for (let x = 0; x < width; x += 40) {
    line(x, height - 100, x, height - 80); // Vertical posts
    line(x, height - 90, x + 40, height - 90); // Horizontal bar
  }
}

// Draw the pathway
function drawPathway() {
  fill(210, 180, 140); // Light brown path
  noStroke();
  beginShape();
  vertex(640, height - 70); // Starting near the farmhouse
  vertex(680, height - 70);
  vertex(720, height);
  vertex(600, height);
  endShape(CLOSE);
}

// Draw trees
function drawTrees() {
  for (let i = 50; i < 250; i += 80) {
    drawTree(i, height - 150);
  }
}

function drawTree(x, y) {
  fill(139, 69, 19); // Brown trunk
  rect(x - 5, y, 10, 50);

  fill(34, 139, 34); // Green foliage
  ellipse(x, y, 40, 40);
  ellipse(x - 10, y + 10, 40, 40);
  ellipse(x + 10, y + 10, 40, 40);
}

// Draw bushes
function drawBushes() {
  for (let i = 300; i < 450; i += 50) {
    drawBush(i, height - 50);
  }
}

function drawBush(x, y) {
  fill(34, 139, 34); // Green
  ellipse(x, y, 40, 20);
}

// Draw birds flying in the sky
function drawBirds() {
  fill(0); // Black birds
  noStroke();

  for (let i = 0; i < 5; i++) {
    let x = width / 6 * i + sin(frameCount * 0.03 + i) * 30; // Wavy horizontal motion
    let y = height / 6 + sin(frameCount * 0.02 + i * 2) * 20; // Wavy vertical motion
    drawBird(x, y);
  }
}

function drawBird(x, y) {
  let wingSpan = 20;
  arc(x, y, wingSpan, wingSpan / 2, PI, TWO_PI); // Left wing
  arc(x + 10, y, wingSpan, wingSpan / 2, PI, TWO_PI); // Right wing
}
