let ripples = [];
let flowers = [];

function setup() {
  createCanvas(800, 800);
  frameRate(60);
}

function draw() {
  background(25, 25, 50); // Dark blue background

  // Update and display ripples
  for (let i = ripples.length - 1; i >= 0; i--) {
    let ripple = ripples[i];
    ripple.update();
    ripple.display();

    // Create flowers as the ripple expands
    if (ripple.lifetime % 20 === 0 && ripple.lifetime > 0) {
      let angle = random(TWO_PI);
      let x = ripple.x + cos(angle) * ripple.radius;
      let y = ripple.y + sin(angle) * ripple.radius;
      flowers.push(new Flower(x, y, random(10, 30)));
    }

    // Remove ripple if it is done
    if (ripple.isDone()) {
      ripples.splice(i, 1);
    }
  }

  // Display flowers
  for (let flower of flowers) {
    flower.display();
  }
}

function mousePressed() {
  ripples.push(new Ripple(mouseX, mouseY));
}

// Ripple class
class Ripple {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.radius = 0;
    this.speed = 2;
    this.lifetime = 0;
  }

  update() {
    this.radius += this.speed;
    this.lifetime++;
  }

  display() {
    noFill();
    stroke(255, 200, 100, 200 - this.lifetime * 2); // Gradually fade out
    strokeWeight(2);
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }

  isDone() {
    return this.lifetime > 100;
  }
}

// Flower class
class Flower {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.bloom = 0;
  }

  display() {
    if (this.bloom < this.size) {
      this.bloom += 0.5;
    }

    // Draw pink petals
    push();
    translate(this.x, this.y);
    for (let i = 0; i < 6; i++) {
      let angle = TWO_PI / 6 * i;
      let petalX = cos(angle) * this.bloom;
      let petalY = sin(angle) * this.bloom;
      noStroke();
      fill(250, 100, 150, 225);
      ellipse(petalX, petalY, this.bloom / 2, this.bloom);
    }
    pop();

    // Draw yellow center
    noStroke();
    fill(255, 200, 50);
    ellipse(this.x, this.y, this.bloom / 3, this.bloom / 3);
  }
}
