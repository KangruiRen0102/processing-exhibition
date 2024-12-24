let fishSchool = []; // Array to store all fish objects
let numFish = 50;
let seaFlow;
let noiseFactor = 0.01;

function setup() {
  createCanvas(800, 600);
  seaFlow = createVector(1, 0.3); // Vector for ocean flow

  // Create the fish
  for (let i = 0; i < numFish; i++) {
    let fishColor = color(255, 165, 0); // Orange
    fishSchool.push(new Fish(random(width), random(height), fishColor, 8));
  }

  let uniqueColor = color(0, 0, 255); // Blue for the unique fish
  fishSchool.push(new Fish(random(width), random(height), uniqueColor, 12));
}

function draw() {
  background(30, 144, 255); // Sky blue background

  // Draw ocean waves
  for (let y = 0; y < height; y += 40) {
    stroke(0, 100, 255, 70);
    strokeWeight(2);
    noFill();
    beginShape();
    for (let x = 0; x < width; x += 20) {
      let waveY = y + sin((x + frameCount) * 0.05) * 10;
      vertex(x, waveY);
    }
    endShape();
  }

  // Draw ocean floor with seaweed and shells
  for (let i = 0; i < width; i += 50) {
    // Seaweed
    stroke(34, 139, 34);
    strokeWeight(3);
    noFill();
    beginShape();
    for (let j = height - 40; j < height; j += 10) {
      let swayX = sin((i + frameCount) * 0.02) * 10;
      vertex(i + swayX, j);
    }
    endShape();

    // Shells
    fill(255, 223, 196);
    stroke(210, 180, 140);
    strokeWeight(1);
    ellipse(i, height - 20, 15, 10);
    line(i - 7, height - 20, i + 7, height - 20); // Shell detail line
  }

  // Update and display all fish
  for (let fish of fishSchool) {
    fish.followFlow(seaFlow);
    fish.updatePosition();
    fish.display();
  }
}

// Fish class
class Fish {
  constructor(x, y, fishColor, size) {
    this.position = createVector(x, y);
    this.velocity = createVector(random(-2, 2), random(-1, 1));
    this.size = size;
    this.fishColor = fishColor;
  }

  // Update the position of the fish
  updatePosition() {
    this.position.add(this.velocity);

    // Wrap around edges
    if (this.position.x > width) this.position.x = 0;
    if (this.position.x < 0) this.position.x = width;
    if (this.position.y > height) this.position.y = 0;
    if (this.position.y < 0) this.position.y = height;
  }

  // Make the fish follow the ocean flow
  followFlow(flow) {
    let angle = noise(this.position.x * noiseFactor, this.position.y * noiseFactor, frameCount * 0.01) * TWO_PI;
    let flowDirection = flow.copy().rotate(angle).normalize().mult(0.5);
    this.velocity.add(flowDirection);
    this.velocity.limit(2); // Limit speed
  }

  // Display the fish
  display() {
    push();
    translate(this.position.x, this.position.y);
    let angle = atan2(this.velocity.y, this.velocity.x);
    rotate(angle);

    fill(this.fishColor);
    noStroke();

    // Fish body
    beginShape();
    vertex(-this.size * 1.5, 0);
    vertex(-this.size, this.size / 2);
    vertex(0, this.size / 2);
    vertex(this.size, this.size / 3);
    vertex(this.size * 1.5, 0);
    vertex(this.size, -this.size / 3);
    vertex(0, -this.size / 2);
    vertex(-this.size, -this.size / 2);
    vertex(-this.size * 1.5, 0);
    endShape(CLOSE);

    // Eye
    fill(0);
    ellipse(this.size * 0.8, -this.size * 0.2, this.size * 0.3, this.size * 0.3);

    // Scales
    stroke(255, 215, 0, 100);
    noFill();
    for (let i = -this.size * 1.2; i < this.size * 0.5; i += this.size * 0.3) {
      for (let j = -this.size * 0.6; j < this.size * 0.6; j += this.size * 0.3) {
        ellipse(i, j, this.size * 0.3, this.size * 0.3);
      }
    }

    pop();
  }
}
