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

class Circle extends Shape {
  constructor(x, y, radius, fillColor) {
    super(x, y, fillColor);
    this.radius = radius;
  }

  display() {
    super.display();
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
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

class Triangle extends Shape {
  constructor(x, y, size, fillColor) {
    super(x, y, fillColor);
    this.x1 = x - size / 2;
    this.y1 = y + size / 3;
    this.x2 = x + size / 2;
    this.y2 = y + size / 3;
    this.x3 = x;
    this.y3 = y - size / 3;
  }

  display() {
    super.display();
    triangle(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);
  }
}

let shapes;

function setup() {
  createCanvas(500, 500);
  shapes = [];
  shapes.push(new Triangle(0, 300, 350, color(112, 115, 125)));
  shapes.push(new Triangle(100, 200, 350, color(112, 115, 125)));
  shapes.push(new Triangle(150, 300, 200, color(112, 115, 125)));
  shapes.push(new Triangle(250, 250, 250, color(112, 115, 125)));
  shapes.push(new Triangle(300, 300, 350, color(112, 115, 125)));
  shapes.push(new Triangle(40, 200, 200, color(112, 115, 125)));
  shapes.push(new Triangle(100, 350, 200, color(112, 115, 125)));
  shapes.push(new Triangle(400, 300, 200, color(112, 115, 125)));
  shapes.push(new Triangle(350, 325, 300, color(112, 115, 125)));
  shapes.push(new Triangle(500, 300, 300, color(137, 140, 152)));
  shapes.push(new Triangle(400, 350, 250, color(137, 140, 152)));
  shapes.push(new Triangle(325, 400, 300, color(137, 140, 152)));
  shapes.push(new Triangle(375, 350, 300, color(137, 140, 152)));
  shapes.push(new Triangle(225, 450, 300, color(137, 140, 152)));
  shapes.push(new Circle(10, 425, 50, color(135, 186, 114)));
  shapes.push(new Circle(75, 450, 60, color(135, 186, 114)));
  shapes.push(new Circle(120, 415, 20, color(135, 186, 114)));
  shapes.push(new Circle(160, 450, 50, color(135, 186, 114)));
  shapes.push(new Circle(70, 450, 60, color(135, 186, 114)));
  shapes.push(new Circle(210, 475, 40, color(135, 186, 114)));
  shapes.push(new Circle(270, 480, 50, color(135, 186, 114)));
  shapes.push(new Circle(350, 450, 60, color(135, 186, 114)));
  shapes.push(new Circle(400, 425, 50, color(135, 186, 114)));
  shapes.push(new Circle(450, 400, 40, color(135, 186, 114)));
  shapes.push(new Circle(500, 400, 60, color(135, 186, 114)));
  shapes.push(new Rectangle(50, 450, 165, 100, color(135, 186, 114)));
  shapes.push(new Rectangle(500, 450, 250, 100, color(135, 186, 114)));
  shapes.push(new Rectangle(200, 500, 165, 100, color(135, 186, 114)));
  shapes.push(new Rectangle(50, 430, 100, 25, color(191, 174, 127)));
  shapes.push(new Rectangle(450, 420, 100, 25, color(191, 174, 127)));
  shapes.push(new Rectangle(100, 450, 25, 100, color(191, 174, 127)));
  shapes.push(new Rectangle(400, 450, 25, 125, color(191, 174, 127)));
  shapes.push(new Rectangle(250, 445, 300, 25, color(191, 174, 127)));
  shapes.push(new Circle(375, 75, 30, color(253, 221, 126)));
}

function draw() {
  background(151, 202, 224);

  for (let shape of shapes) {
    shape.display();
  }
}
