let northernLights = [];
let stars = [];

function setup() {
  createCanvas(750, 750);
  background(0, 20, 0);

  for (let i = 0; i < 200; i++) {
    stars.push(new Star(random(width), random(height)));
  }
}

function draw() {
  for (let star of stars) {
    star.display();
  }

  for (let light of northernLights) {
    light.display();
  }

  fill(100);
  let rectHeight = height / 3;
  for (let i = 0; i < width; i += 80) {
    rect(i, height - rectHeight, 60, rectHeight);
  }
}

function mousePressed() {
  northernLights.push(new NorthernLight(mouseX + 25, mouseY + 25));
}

function mouseDragged() {
  northernLights.push(new NorthernLight(mouseX + 25, mouseY + 25));
}

class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(1, 3);
  }

  display() {
    fill(255);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}

class NorthernLight {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.width = random(100, 400);
    this.height = random(5, 20);

    this.startColor = color(random(50, 150), random(150, 255), random(100, 255), 150);
    this.endColor = color(random(100, 200), random(100, 255), random(100, 255), 100);
  }

  display() {
    for (let i = 0; i < this.width; i++) {
      let inter = map(i, 0, this.width, 0, 1);
      let c = lerpColor(this.startColor, this.endColor, inter);
      fill(c);
      rect(this.x + i - this.width / 2, this.y - this.height / 2, 3, this.height);
    }
  }
}
