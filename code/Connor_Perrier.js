class Shape {
  constructor(x, y, fillColor) {
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }

  display() {
    fill(this.fillColor);
    noStroke();
  }
}

class Rectangle extends Shape {
  constructor(x, y, width, height, fillColor) {
    super(x, y, fillColor);
    this.width = width;
    this.height = height;
  }

  display() {
    super.display();
    rectMode(CENTER);
    rect(this.x, this.y, this.width, this.height);
  }
}

let shapes = [];
let selectedShape = null;

function setup() {
  createCanvas(900, 600);
  shapes.push(new Rectangle(450, 500, 900, 200, color(0, 200, 10)));
}

function draw() {
  background(50, 100, 200);

  for (let shape of shapes) {
    shape.display();
  }
}

function mousePressed() {
  if (mouseY < 100 || mouseY > 500) {
    shapes.push(new Rectangle(mouseX, mouseY, random(35, 100), random(50, 160), color(random(10), 28 + random(20), 91 + random(20))));
  } else if (mouseY < 200 || mouseY > 400) {
    if (mouseX > 180 && mouseX < 580) {
      shapes.push(new Rectangle(mouseX, mouseY, random(35, 100), random(50, 160), color(181 + random(20), 1 + random(20), 58 - random(20))));
    } else {
      shapes.push(new Rectangle(mouseX, mouseY, random(35, 100), random(50, 160), color(random(10), 28 + random(20), 91 + random(20))));
    }
  } else {
    if (mouseX < 180 || mouseX > 480) {
      shapes.push(new Rectangle(mouseX, mouseY, random(35, 100), random(50, 160), color(255 - random(20), 255 - random(20), 255 - random(20))));
    } else if (mouseX > 280 && mouseX < 480) {
      shapes.push(new Rectangle(mouseX, mouseY, random(35, 100), random(50, 160), color(255 - random(20), 195 + random(20), 0 + random(20))));
    } else {
      shapes.push(new Rectangle(mouseX, mouseY, random(35, 100), random(50, 160), color(181 + random(20), 1 + random(20), 58 - random(20))));
    }
  }
}
