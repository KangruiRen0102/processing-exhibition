let waterLevel = 0; // Initial water level
let cupHeight = 200; // The height of the mug
let cupWidth = 120; // Width of the mug
let mugX = 500; // X position of the mug (center of the canvas)
let mugY = 700; // Y position of the mug
let rainDropCount = 100; // Number of raindrops
let rainDrops = []; // Array for raindrops
let rainActive = true; // Flag for rain
let grassGrowing = false; // Flag to check if the grass is growing
let grassList = []; // List to hold the growing grass
let waterFilling = true; // Flag to control water filling (true means filling, false means stopped)
let startTime;
let sunX = 800;
let sunY = 200;
let sunRadius = 80;
let cloudX = 500;
let cloudY = 200;
let cloudWidth = 400;
let cloudHeight = 150;

function setup() {
  createCanvas(1000, 1000); // Set the size of the window
  for (let i = 0; i < rainDropCount; i++) {
    rainDrops.push(new Raindrop(random(cloudX - cloudWidth / 2, cloudX + cloudWidth / 2), random(cloudY - cloudHeight / 2, cloudY - cloudHeight / 4)));
  }
  startTime = millis();
}

function draw() {
  if (rainActive) {
    drawStormySky();
    drawCloud(cloudX, cloudY, cloudWidth, cloudHeight);
    drawRain();
  } else {
    drawSunnySky();
    drawGround();
    drawSun();
  }

  drawMug(mugX, mugY);

  if (waterFilling) {
    fillWater();
  }

  if (grassGrowing) {
    growGrass();
  }

  if (rainActive) {
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Press 'space' before the cup fills up", width / 2, 50);
  }

  displayDigitalClock();
}

// Function to draw the stormy sky
function drawStormySky() {
  background(50, 50, 50); // Dark grey background
}

// Function to draw the cloud
function drawCloud(x, y, w, h) {
  fill(80, 80, 80);
  noStroke();
  ellipse(x, y, w, h);
  ellipse(x - w / 4, y + h / 4, w * 0.7, h * 0.6);
  ellipse(x + w / 4, y + h / 4, w * 0.7, h * 0.6);
}

// Function to draw the sunny sky
function drawSunnySky() {
  background(135, 206, 235);
}

// Function to draw the ground
function drawGround() {
  fill(169, 169, 169);
  noStroke();
  rect(0, height * 2 / 3, width, height / 3);
}

// Function to draw the sun
function drawSun() {
  fill(255, 204, 0);
  noStroke();
  ellipse(sunX, sunY, sunRadius * 2, sunRadius * 2);
}

// Function to draw the mug
function drawMug(x, y) {
  for (let i = 0; i < cupHeight; i++) {
    let c = lerpColor(color(255, 255, 255), color(150, 150, 150), map(i, 0, cupHeight, 0, 1));
    stroke(c);
    line(x - cupWidth / 2, y - cupHeight + i, x + cupWidth / 2, y - cupHeight + i);
  }
  fill(150, 150, 150);
  noStroke();
  ellipse(x, y - cupHeight + 5, cupWidth, 20);
}

// Function to fill the mug with rainwater
function fillWater() {
  if (waterLevel < cupHeight) {
    fill(173, 216, 230, 200);
    noStroke();
    waterLevel += 0.1;
    rect(mugX - cupWidth / 2, mugY - cupHeight + cupHeight - waterLevel, cupWidth, waterLevel);
  }
}

// Function to draw rain
function drawRain() {
  fill(0, 0, 255);
  noStroke();
  for (let drop of rainDrops) {
    drop.fall();
    drop.display();
  }
}

// Raindrop class
class Raindrop {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.speed = random(1, 3);
  }

  fall() {
    this.y += this.speed;
    if (this.y > mugY - cupHeight) {
      waterLevel += 0.1;
      if (waterLevel >= cupHeight) {
        waterLevel = cupHeight;
      }
    }
    if (this.y > height) {
      this.y = random(cloudY - cloudHeight / 2, cloudY - cloudHeight / 4);
    }
  }

  display() {
    ellipse(this.x, this.y, 5, 10);
  }
}

// Handle spacebar press
function keyPressed() {
  if (key === ' ') {
    rainActive = false;
    waterFilling = false;
    grassGrowing = true;
    for (let i = 0; i < 20; i++) {
      grassList.push(new Grass(mugX + random(-50, 50), mugY - cupHeight + 5));
    }
  }
}

// Function to grow grass
function growGrass() {
  for (let g of grassList) {
    g.grow();
  }
}

// Grass class
class Grass {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.height = 0;
    this.maxHeight = random(40, 80);
    this.width = 3;
    this.grassColor = color(34, 139, 34);
  }

  grow() {
    if (this.height < this.maxHeight) {
      this.height++;
    }
    fill(this.grassColor);
    noStroke();
    rect(this.x - this.width / 2, this.y - this.height, this.width, this.height);
  }
}

// Function to display the digital clock
function displayDigitalClock() {
  let elapsedTime = millis() - startTime;
  let seconds = floor((elapsedTime / 1000) % 60);
  let minutes = floor((elapsedTime / 60000) % 60);
  let timeString = nf(minutes, 2) + ":" + nf(seconds, 2);
  fill(255);
  textSize(32);
  textAlign(LEFT, TOP);
  text(timeString, 20, 20);
}
