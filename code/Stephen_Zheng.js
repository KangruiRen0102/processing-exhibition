let cracks = []; // Array to store cracks
let crackMax = 8, crackCount = 0; // Crack counter and max cracks for when chick spawns
let chickSpawned = false; // Start chick not spawned
let chickX, chickY; // Position of chick

function setup() {
  createCanvas(400, 400);
  noFill();
  noStroke();
}

function draw() {
  background(0, 128, 0);
  fill(150, 75, 0); // Podium color
  rect(width / 2 - 150, height / 2 + 100, 300, 30); // Podium

  if (!chickSpawned) {
    drawEgg();
    addCracks();
  }

  if (crackCount >= crackMax && !chickSpawned) {
    spawnChick(); // Spawn chick when crack count is reached
    chickSpawned = true; // Mark chick as spawned
  }

  if (chickSpawned) displayChick(); // Display the chick
}

function addCracks() {
  if (frameCount % 40 === 0) { // Add a new crack every 40 frames
    cracks.push(new Crack());
    crackCount++; // crack counter
  }

  for (let c of cracks) {
    c.update(); // Update crack's growth
    c.display(); // Draw crack
  }
}

function drawEgg() {
  fill(255); // Egg color
  ellipse(width / 2, height / 2, 150, 200); // The egg
}

function spawnChick() {
  chickX = width / 2;
  chickY = height / 2 + 50; // Position chick below egg center
}

function displayChick() {
  fill(255, 255, 0); // Chick body color
  ellipse(chickX, chickY, 50, 50); // Chick body

  // Chick's eyes
  fill(0);
  ellipse(chickX - 15, chickY - 10, 8, 8);
  ellipse(chickX + 15, chickY - 10, 8, 8);

  // Chick's beak
  fill(255, 165, 0);
  triangle(chickX - 5, chickY + 5, chickX + 5, chickY + 5, chickX, chickY + 12);

  // Chick's legs
  stroke(255, 165, 0);
  strokeWeight(3);
  line(chickX - 11, chickY + 25, chickX - 23, chickY + 55);
  line(chickX + 11, chickY + 25, chickX + 23, chickY + 55);

  // Chick's arms
  line(chickX - 25, chickY, chickX - 60, chickY - 30);
  line(chickX + 25, chickY, chickX + 60, chickY - 30);

  noStroke();
}

class Crack {
  constructor() {
    this.points = []; // List for crack points
    this.x1 = width / 2 + random(-45, -10);
    this.y1 = height / 2 + random(-80, 80);
    this.points.push(createVector(this.x1, this.y1));
    this.length = 10; // Initial crack length
    this.crackColor = color(0);
  }

  update() {
    if (this.length < 20) {
      this.length += random(1, 2);
      let angle = (frameCount % 2 === 0) ? PI / 4 : -PI / 4; // Zigzag direction
      let last = this.points[this.points.length - 1];
      let newPoint = createVector(
        last.x + this.length * cos(angle),
        last.y + this.length * sin(angle)
      );
      this.points.push(newPoint); // Add new point to the crack's path
    }
  }

  display() {
    stroke(this.crackColor);
    strokeWeight(3);
    for (let i = 0; i < this.points.length - 1; i++) {
      let p1 = this.points[i];
      let p2 = this.points[i + 1];
      line(p1.x, p1.y, p2.x, p2.y); // Draw lines connecting points
    }
  }
}
