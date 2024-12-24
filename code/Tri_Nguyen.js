let maxDepth = 4; // Original recursion depth
let angle; // Branch angle
let growth = 0; // Growth factor (0 to 1)
let growing = false; // Track whether the tree is growing or withering
let raining = false; // Track whether it's raining
let dustStorm = false; // Track whether the dust storm is active
let raindrops = []; // List of raindrops
let dustParticles = []; // List of dust particles

function setup() {
  createCanvas(800, 800);
  frameRate(60); // Standard frame rate
}

function draw() {
  background(30, 30, 40); // Dark background

  // Draw the hill at the bottom of the screen
  drawHill();

  // Draw the rain if it is raining
  if (raining) {
    for (let r of raindrops) {
      r.update();
      r.display();
    }
  }

  // Draw the dust storm if it is active (withering)
  if (dustStorm) {
    for (let d of dustParticles) {
      d.update();
      d.display();
    }
  }

  translate(width / 2, height - 50); // Start at the bottom center, above the hill
  stroke(255); // White branches
  angle = map(growth, 0, 1, 15, 45); // Adjust angle dynamically
  drawBranch(height / 4, 0); // Start drawing the tree

  // Ensure growth stays between 0 and 1
  growth = constrain(growth, 0, 1);
}

function drawHill() {
  noStroke();

  // Change hill color to brown when the tree is withering
  if (!growing) {
    fill(139, 69, 19); // Brown color for the hill when withering
  } else {
    fill(34, 139, 34); // Green color for the hill during growth
  }

  beginShape();
  vertex(0, height); // Start at the bottom left
  bezierVertex(width / 4, height - 100, 3 * width / 4, height - 100, width, height); // Curve for the hill
  vertex(width, height); // End at the bottom right
  endShape(CLOSE);
}

function drawBranch(len, depth) {
  if (depth > maxDepth || len < 2) return;

  // Adjust branch length based on growth factor
  let adjustedLen = len * growth;

  // Branch color logic: brown during growth, gray during withering
  let branchColor = growing ? color(139, 69, 19) : color(128, 128, 128);
  stroke(branchColor);
  strokeWeight(map(depth, 0, maxDepth, 8, 1)); // Thicker base, thinner tips

  line(0, 0, 0, -adjustedLen); // Draw the branch
  translate(0, -adjustedLen); // Move to the end of the branch

  // Dynamic branching based on growth
  let branchCount = map(growth, 0, 1, 1, 4); // Increase branches as the tree grows
  let angleOffset = angle / branchCount;

  for (let i = 0; i < branchCount; i++) {
    // Right side branches
    push();
    rotate(radians(i * angleOffset));
    drawBranch(len * 0.7, depth + 1);
    pop();

    // Left side branches
    push();
    rotate(-radians(i * angleOffset));
    drawBranch(len * 0.7, depth + 1);
    pop();
  }

  // Simulate leaves
  if (depth === maxDepth && growth > 0.5) {
    let leafColor = growing ? color(34, 139, 34) : color(255, 165, 0);
    fill(leafColor);
    noStroke();
    ellipse(0, 0, 10 * growth, 10 * growth); // Leaf size grows with `growth`
  }
}

function keyPressed() {
  if (key === 'w' || key === 'W') {
    growing = true; // Set growing state
    growth += 0.01; // Increase growth
    raining = true; // Start raining
    dustStorm = false; // Stop dust storm if growing

    // Add new raindrops when 'w' is pressed
    for (let i = 0; i < 10; i++) {
      raindrops.push(new Raindrop(random(width), random(-100, -500)));
    }
  } else if (key === 's' || key === 'S') {
    growing = false; // Set withering state
    growth -= 0.01; // Decrease growth
    raining = false; // Stop raining
    dustStorm = true; // Start dust storm when withering
    raindrops = []; // Clear raindrops when rain stops

    // Add new dust particles when 'S' is pressed
    for (let i = 0; i < 10; i++) {
      dustParticles.push(new DustParticle(random(width), random(height)));
    }
  }
}

class Raindrop {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speed = random(3, 7); // Random speed for each raindrop
    this.size = random(2, 6); // Random size for each raindrop
  }

  update() {
    this.y += this.speed; // Raindrop falls down
    if (this.y > height) {
      this.y = random(-100, -500); // Reset raindrop to top if it falls off screen
    }
  }

  display() {
    noStroke();
    fill(0, 0, 255, 150); // Blue color with some transparency
    ellipse(this.x, this.y, this.size, this.size * 2); // Ellipse for raindrop shape
  }
}

class DustParticle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speed = random(1, 3); // Random speed for each dust particle
    this.size = random(3, 8); // Random size for each dust particle
  }

  update() {
    this.x += this.speed; // Dust particle moves to the right
    if (this.x > width) {
      this.x = 0; // Reset dust particle to left side if it moves off screen
    }
  }

  display() {
    noStroke();
    fill(139, 69, 19, 100); // Brown color with transparency for dust
    ellipse(this.x, this.y, this.size, this.size); // Ellipse for dust particle shape
  }
}
