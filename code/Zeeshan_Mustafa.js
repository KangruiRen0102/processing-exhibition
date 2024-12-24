// Tree Growth with Day-Night Cycle

// Growth variables
let baseX, baseY; // Position of the plant's base
let plantHeight = 0; // Current stem height
let maxPlantHeight = 200; // Maximum stem height
let branches = []; // List to hold branches
let flower; // Flower at the top

// Day and night transition variables
let backgroundLerp = 0; // Controls day-night gradient
let day = true; // Day starts as true
let morningColor, nightColor;

// Clouds and stars
let clouds = [];
let stars = [];

// Progression flags
let growingTree = false; // Whether tree is growing
let flowerBloomed = false; // Whether flower has bloomed

function setup() {
  createCanvas(800, 600); // Canvas size
  baseX = width / 2; // X center
  baseY = height; // Bottom of the canvas

  morningColor = color(135, 206, 250); // Morning sky color
  nightColor = color(25, 25, 112); // Night sky color

  clouds = createClouds(5); // Create 5 clouds
  stars = createStars(50); // Create 50 stars
  noStroke(); // Disable strokes for cleaner visuals
}

function draw() {
  // Day-night transition logic
  if (day) {
    backgroundLerp += 0.005;
    if (backgroundLerp >= 1) {
      backgroundLerp = 1;
      day = false; // Switch to night
    }
  } else {
    backgroundLerp -= 0.005;
    if (backgroundLerp <= 0) {
      backgroundLerp = 0;
      day = true; // Switch to day
    }
  }
  background(lerpColor(morningColor, nightColor, backgroundLerp)); // Sky color

  // Day or night-specific elements
  if (backgroundLerp < 0.5) {
    drawSun();
    drawClouds();
  } else {
    drawMoon();
    drawStars();
  }

  // Draw the tree trunk as it grows
  if (plantHeight < maxPlantHeight) {
    fill(0, 255, 0); // Green stem for growing trunk
    rect(baseX - 5, baseY - plantHeight, 10, plantHeight);
    plantHeight += 0.5; // Gradual growth
  } else {
    fill(139, 69, 19); // Brown for grown trunk
    rect(baseX - 5, baseY - maxPlantHeight, 10, maxPlantHeight);
    if (!growingTree) {
      growingTree = true;
      growTree(); // Start branch growth
    }
  }

  // Draw and update branches
  for (let b of branches) {
    b.update();
    b.display();
  }

  // Display the flower if it has bloomed
  if (flowerBloomed && flower) {
    flower.update();
    flower.display();
  }
}

// Create cloud positions
function createClouds(numClouds) {
  let cloudPositions = [];
  for (let i = 0; i < numClouds; i++) {
    cloudPositions.push(createVector(random(width), random(height / 3)));
  }
  return cloudPositions;
}

// Draw clouds
function drawClouds() {
  fill(255, 255, 255, 200);
  for (let cloud of clouds) {
    ellipse(cloud.x, cloud.y, 80, 50);
    ellipse(cloud.x + 30, cloud.y - 10, 60, 40);
    ellipse(cloud.x - 30, cloud.y - 10, 60, 40);
  }
}

// Draw the sun
function drawSun() {
  fill(255, 223, 0);
  ellipse(width / 4, height / 6, 80, 80);
}

// Create star positions
function createStars(numStars) {
  let starPositions = [];
  for (let i = 0; i < numStars; i++) {
    starPositions.push(createVector(random(width), random(height / 2)));
  }
  return starPositions;
}

// Draw stars
function drawStars() {
  fill(255, 255, 255, 200);
  for (let star of stars) {
    ellipse(star.x, star.y, 3, 3);
  }
}

// Draw the moon
function drawMoon() {
  fill(245, 245, 245);
  ellipse(width / 1.5, height / 6, 60, 60);
  fill(nightColor);
  ellipse(width / 1.5 + 10, height / 6, 60, 60);
}

// Start tree growth
function growTree() {
  for (let i = 0; i < 64; i++) { // Increase branches for a fuller look
    let angle = map(i, 0, 63, -PI, PI); // Spread branches to fill gaps
    branches.push(new Branch(baseX, baseY - maxPlantHeight, angle, random(50, 150), color(139, 69, 19)));
  }
  bloomFlower();
}

// Bloom flower at the top
function bloomFlower() {
  flowerBloomed = true;
  flower = new Flower(baseX, baseY - maxPlantHeight - 30, 10, color(255, 192, 203)); // Smaller flower
}

// Branch class for drawing and updating branches
class Branch {
  constructor(x, y, angle, length, branchColor) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.length = length;
    this.branchColor = branchColor;
    this.growth = 0; // Progress of branch growth
  }

  update() {
    if (this.growth < 1) this.growth += 0.01; // Gradually grow the branch
  }

  display() {
    let endX = this.x + cos(this.angle) * this.length * this.growth;
    let endY = this.y + sin(this.angle) * this.length * this.growth;
    stroke(this.branchColor);
    line(this.x, this.y, endX, endY);

    // Add more leaves at the ends of fully grown branches
    if (this.growth >= 1) {
      fill(0, 128, 0);
      for (let i = 0; i < 10; i++) { // Add even more leaves around the branch ends
        let leafAngle = this.angle + random(-PI / 6, PI / 6);
        let leafX = endX + cos(leafAngle) * random(10, 20);
        let leafY = endY + sin(leafAngle) * random(10, 20);
        ellipse(leafX, leafY, random(10, 15), random(10, 15));
      }
    }
  }
}

// Flower class for creating and displaying the flower
class Flower {
  constructor(x, y, size, petalColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.petalColor = petalColor;
    this.bloomSize = 0; // Current bloom size
  }

  update() {
    if (this.bloomSize < this.size) this.bloomSize += 0.2; // Gradual blooming
  }

  display() {
    fill(this.petalColor);
    for (let i = 0; i < 8; i++) { // Draw 8 petals
      let angle = TWO_PI / 8 * i;
      ellipse(this.x + cos(angle) * this.bloomSize, this.y + sin(angle) * this.bloomSize, this.bloomSize, this.bloomSize);
    }
    fill(255, 204, 0); // Yellow center of the flower
    ellipse(this.x, this.y, this.bloomSize / 2, this.bloomSize / 2);
  }
}
