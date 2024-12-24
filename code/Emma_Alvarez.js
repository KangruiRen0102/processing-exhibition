let drops = []; // Array to store raindrops
let flowers = []; // Array to store flowers

function setup() {
  createCanvas(640, 360);
  background(173, 216, 230);
  
  // Initialize drops
  for (let i = 0; i < 75; i++) {
    drops.push(new Drop());
  }
}

function draw() {
  background(173, 216, 230);

  // Draw hills
  drawHills();

  // Display flowers
  for (let flower of flowers) {
    flower.display();
  }

  // Update and display drops
  for (let drop of drops) {
    drop.fall();
    drop.show();
  }
}

function drawHills() {
  noStroke();

  // Far hills
  fill(144, 238, 144);
  arc(-200, 400, 800, 600, PI, TWO_PI);
  arc(440, 400, 800, 600, PI, TWO_PI);

  // Middle hills
  fill(60, 179, 113);
  arc(0, 500, 700, 500, PI, TWO_PI);
  arc(500, 500, 700, 500, PI, TWO_PI);

  // Near hills
  fill(34, 139, 34);
  arc(-150, 600, 800, 700, PI, TWO_PI);
  arc(500, 600, 800, 700, PI, TWO_PI);
}

function mousePressed() {
  flowers.push(new Flower(mouseX, mouseY));
}

class Drop {
  constructor() {
    this.x = random(width);
    this.y = random(-500, -50);
    this.yrate = random(6, 7);
  }

  fall() {
    this.y += this.yrate;
    if (this.y > height) {
      this.y = random(-500, -50);
      this.x = random(width);
    }
  }

  show() {
    stroke(0, 0, 255);
    strokeWeight(1);
    line(this.x, this.y, this.x, this.y + 15);
  }
}

class Flower {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  display() {
    push();
    translate(this.x, this.y);

    // Stem
    stroke(34, 139, 36);
    strokeWeight(3);
    line(0, 0, 0, 70);

    // Leaves
    fill(0, 128, 0);
    noStroke();
    ellipse(-10, 20, 20, 10);
    ellipse(10, 20, 20, 10);

    // Petals
    fill(255, 153, 204);
    for (let i = 0; i < 6; i++) {
      let angle = TWO_PI / 6 * i;
      let petalX = cos(angle) * 20;
      let petalY = sin(angle) * 20;
      ellipse(petalX, petalY, 20, 30);
    }

    // Flower center
    fill(255, 255, 102);
    ellipse(0, 0, 20, 20);

    pop();
  }
}
