let creatures = []; // Stores all caterpillars and butterflies
let flowerPositions = []; // Stores positions of flowers
let flowerColors = []; // Stores colors for each flower

function setup() {
  createCanvas(1000, 800);

  // Create stable flowers
  createStableFlowers();

  // Create 7 initial caterpillars
  for (let i = 0; i < 7; i++) {
    creatures.push(new Caterpillar(random(width), random(height)));
  }
}

function draw() {
  background(200, 255, 200); // Light green background

  // Draw stored flowers
  drawStoredFlowers();

  // Update and display all creatures
  for (let i = creatures.length - 1; i >= 0; i--) {
    let c = creatures[i];
    c.display();
    c.update();
  }
}

function createStableFlowers() {
  let numFlowers = 100;

  for (let i = 0; i < numFlowers; i++) {
    let x, y;
    let overlap;

    // Generate positions ensuring no overlap
    do {
      x = random(50, width - 50);
      y = random(50, height - 50);

      overlap = flowerPositions.some(pos => dist(x, y, pos.x, pos.y) < 50);
    } while (overlap);

    // Store flower position
    flowerPositions.push(createVector(x, y));

    // Store flower colors
    flowerColors.push([
      color(200 + random(-30, 30), 150 + random(-30, 30), 255, random(100, 200)),
      color(255, 204 + random(-20, 20), 0),
      color(255, 192, 203, random(100, 200))
    ]);
  }
}

function drawStoredFlowers() {
  for (let i = 0; i < flowerPositions.length; i++) {
    let pos = flowerPositions[i];
    let colors = flowerColors[i];

    // Draw petals
    fill(colors[0]);
    noStroke();
    for (let j = 0; j < 6; j++) {
      let angle = TWO_PI / 6 * j;
      let petalX = pos.x + cos(angle) * 20;
      let petalY = pos.y + sin(angle) * 20;
      ellipse(petalX, petalY, 30, 40);
    }

    // Draw flower center
    fill(colors[1]);
    ellipse(pos.x, pos.y, 20, 20);
  }
}

function mousePressed() {
  for (let i = creatures.length - 1; i >= 0; i--) {
    let c = creatures[i];
    if (c.isClicked(mouseX, mouseY)) {
      // Transform caterpillar to butterfly
      if (c instanceof Caterpillar) {
        creatures[i] = new Butterfly(c.x, c.y);
        break;
      }
    }
  }
}

class Creature {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = 40;
  }

  display() {}

  update() {
    // Random movement
    this.x += random(-1, 1);
    this.y += random(-1, 1);

    // Keep within canvas
    this.x = constrain(this.x, 0, width);
    this.y = constrain(this.y, 0, height);
  }

  isClicked(mx, my) {
    return dist(mx, my, this.x, this.y) < this.size / 2;
  }
}

class Caterpillar extends Creature {
  constructor(x, y) {
    super(x, y);
    this.size = 40;
    this.moveSpeed = 0.2;
  }

  display() {
    // Body
    fill(100, 200, 100);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size / 2);

    // Antennae
    stroke(0);
    line(this.x - 10, this.y - 10, this.x - 15, this.y - 15);
    line(this.x + 10, this.y - 10, this.x + 15, this.y - 15);
  }

  update() {
    this.x += random(-this.moveSpeed, this.moveSpeed);
    this.y += random(-this.moveSpeed, this.moveSpeed);
    this.x = constrain(this.x, 0, width);
    this.y = constrain(this.y, 0, height);
  }
}

class Butterfly extends Creature {
  constructor(x, y) {
    super(x, y);
    this.size = 60;
    this.speedX = random(-3, 3);
    this.speedY = random(-3, 3);
    this.wingAngle = 0;
  }

  display() {
    this.wingAngle += 0.1;
    let wingOffset = sin(this.wingAngle) * 10;

    // Left wing
    fill(255, 165, 0, 200);
    noStroke();
    push();
    translate(this.x, this.y);
    rotate(radians(-20 + wingOffset));
    ellipse(-this.size / 2, 0, this.size, this.size / 2);
    pop();

    // Right wing
    push();
    translate(this.x, this.y);
    rotate(radians(20 - wingOffset));
    ellipse(this.size / 2, 0, this.size, this.size / 2);
    pop();

    // Body
    fill(50);
    ellipse(this.x, this.y, 10, 30);
  }

  update() {
    this.x += this.speedX + sin(frameCount * 0.1);
    this.y += this.speedY + cos(frameCount * 0.1);

    this.x = constrain(this.x, 0, width);
    this.y = constrain(this.y, 0, height);
  }
}

function keyPressed() {
  if (key === 'c' || key === 'C') {
    // Add new caterpillar at mouse position
    creatures.push(new Caterpillar(mouseX, mouseY));
  }
}
