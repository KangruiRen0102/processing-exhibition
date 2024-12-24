let auroras = []; // Array to store aurora ribbons
let stars = []; // Array to store stars
let fireworkPositions = []; // Array to store firework positions
let twilightColor;
let showMessage = false;
let message = "We want the Cup!";
let messageStartTime;
let time = 0;

function setup() {
  createCanvas(800, 800);
  twilightColor = color(50, 30, 80);

  // Initialize auroras
  for (let i = 0; i < 5; i++) {
    auroras.push(new Aurora(random(50, height - 300), random(0.5, 1.5)));
  }

  // Initialize stars
  for (let i = 0; i < 100; i++) {
    stars.push(new Star(random(width), random(height / 2), random(2, 4)));
  }
}

function draw() {
  // Gradually change twilight background over time
  twilightColor = lerpColor(color(50, 30, 80), color(20, 10, 50), sin(time) * 0.5 + 0.5);
  background(twilightColor);
  time += 0.01;

  // Draw stars
  for (let star of stars) {
    star.twinkle();
    star.display();
  }

  // Draw the moon
  drawMoon();

  // Draw the Edmonton cityscape
  drawCityscape();

  // Draw the interactive Oilers symbol
  drawOilersSymbol();

  // Render auroras
  for (let aurora of auroras) {
    aurora.update();
    aurora.display();
  }

  // Display the message if triggered
  if (showMessage) {
    displayMessage();
  }
}

function drawMoon() {
  fill(255, 255, 200);
  noStroke();
  ellipse(650, 100, 80, 80);
}

function drawCityscape() {
  fill(20);
  noStroke();
  rect(0, height - 200, width, 200);

  // Add some buildings
  rect(100, height - 300, 50, 100);
  rect(200, height - 250, 80, 150);
  rect(350, height - 350, 100, 200);
  rect(500, height - 280, 60, 80);
  rect(650, height - 300, 70, 150);

  // Add text on the tallest building
  fill(255);
  textAlign(CENTER);
  textSize(12);
  text("Engineers Rock Inc.", 400, height - 335);
}

function drawOilersSymbol() {
  let centerX = 190;
  let centerY = height - 400;
  let radius = 50;

  // Draw glowing background
  noStroke();
  fill(255, 100, 50, 100);
  ellipse(centerX, centerY, radius * 2.5, radius * 2.5);

  // Draw outer circle (blue border)
  fill(0, 51, 153);
  ellipse(centerX, centerY, radius * 2, radius * 2);

  // Draw inner circle (white background)
  fill(255);
  ellipse(centerX, centerY, radius * 1.8, radius * 1.8);

  // Draw oil drop
  fill(255, 102, 0);
  beginShape();
  vertex(centerX, centerY - radius * 0.4);
  bezierVertex(centerX - radius * 0.2, centerY - radius * 0.2, centerX - radius * 0.2, centerY + radius * 0.2, centerX, centerY + radius * 0.4);
  bezierVertex(centerX + radius * 0.2, centerY + radius * 0.2, centerX + radius * 0.2, centerY - radius * 0.2, centerX, centerY - radius * 0.4);
  endShape(CLOSE);

  // Draw blue text bar
  fill(0, 51, 153);
  rect(centerX - radius * 0.8, centerY - radius * 0.1, radius * 1.6, radius * 0.2);

  // Add text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(radius * 0.3);
  text("OILERS", centerX, centerY);

  // Check for interaction
  if (mouseIsPressed && dist(mouseX, mouseY, centerX, centerY) < radius) {
    triggerMessage(centerX, centerY);
  }
}

function triggerMessage(x, y) {
  showMessage = true;
  messageStartTime = millis();

  // Generate random fireworks positions
  fireworkPositions = [];
  for (let i = 0; i < 10; i++) {
    let angle = random(TWO_PI);
    let distance = random(50, 100);
    fireworkPositions.push(createVector(x + cos(angle) * distance, y + sin(angle) * distance));
  }
}

function displayMessage() {
  let elapsedTime = millis() - messageStartTime;

  // Display fireworks
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(255, random(100, 255), random(100, 255), 200);
  for (let pos of fireworkPositions) {
    text(message, pos.x, pos.y);
  }

  // Disable the message after 3 seconds
  if (elapsedTime > 3000) {
    showMessage = false;
  }
}

class Aurora {
  constructor(y, speed) {
    this.y = y;
    this.speed = speed;
    this.col = color(random(100, 255), random(100, 255), random(255));
  }

  update() {
    this.y -= this.speed;
    if (this.y < 0) {
      this.y = height - 300;
    }
  }

  display() {
    stroke(this.col);
    strokeWeight(2);
    noFill();
    beginShape();
    for (let x = 0; x < width; x += 20) {
      vertex(x, this.y + sin((x + frameCount) * 0.02) * 30);
    }
    endShape();
  }
}

class Star {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.col = color(255, random(150, 255));
  }

  twinkle() {
    this.col = color(255, random(150, 255));
  }

  display() {
    fill(this.col);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}
