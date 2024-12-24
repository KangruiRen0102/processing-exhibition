let numBuildings = 10; // Number of buildings in the skyline
let buildingHeights = []; // Heights of buildings
let buildingWidths = []; // Widths of buildings
let timeAngle = 0; // Angle for the sun movement
let mouseInfluence = 0; // Factor for mouse interaction
let snowflakes = []; // Array for snowflakes

function setup() {
  createCanvas(800, 600);
  noStroke();

  // Generate random building heights and widths
  for (let i = 0; i < numBuildings; i++) {
    buildingHeights[i] = random(height / 4, height / 2);
    buildingWidths[i] = random(width / 20, width / 10);
  }

  // Initialize snowflakes
  for (let i = 0; i < 200; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  background(135, 206, 235); // Sky blue
  drawSun();
  drawSkyline();
  drawShadows();
  drawSnow();

  // Update sun position
  timeAngle += 0.01;
  if (timeAngle > TWO_PI) timeAngle = 0;

  // Update mouse influence
  mouseInfluence = map(mouseX, 0, width, -100, 100);
}

function drawSkyline() {
  let xPos = 0;
  for (let i = 0; i < numBuildings; i++) {
    // Draw building base
    fill(50);
    rect(xPos, height - buildingHeights[i], buildingWidths[i], buildingHeights[i]);

    // Draw snow cap
    fill(255);
    rect(xPos, height - buildingHeights[i], buildingWidths[i], buildingHeights[i] / 10);

    xPos += buildingWidths[i] + 5; // Space between buildings
  }
}

function drawShadows() {
  fill(0, 0, 0, 50); // Transparent black for shadows
  let xPos = 0;
  let shadowOffset = map(cos(timeAngle), -1, 1, -100, 100) + mouseInfluence; // Shadows move back and forth and react to mouse
  for (let i = 0; i < numBuildings; i++) {
    let shadowWidth = buildingWidths[i] * 1.5;
    rect(xPos + shadowOffset, height, shadowWidth, -buildingHeights[i]);
    xPos += buildingWidths[i] + 5; // Space between shadows
  }
}

function drawSun() {
  let sunX = width / 2 + cos(timeAngle) * width / 3 + mouseInfluence;
  let sunY = height / 2 + sin(timeAngle) * height / 3;
  fill(255, 204, 0); // Sun yellow
  ellipse(sunX, sunY, 50, 50);
}

function drawSnow() {
  for (let flake of snowflakes) {
    flake.update();
    flake.display();
  }
}

// Snowflake class
class Snowflake {
  constructor() {
    this.x = random(width);
    this.y = random(-height, 0);
    this.speed = random(1, 3);
  }

  update() {
    this.y += this.speed;
    if (this.y > height) {
      this.y = random(-height, 0);
      this.x = random(width);
    }
  }

  display() {
    fill(255);
    ellipse(this.x, this.y, 5, 5);
  }
}
