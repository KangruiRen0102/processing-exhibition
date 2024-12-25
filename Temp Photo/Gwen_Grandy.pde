//Shape class was created
class Shape {
  float x, y;
  color fillColor;

  Shape(float x, float y, color fillColor) {
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }

  void display() {
    fill(fillColor);
    noStroke();
  }
}

//Circle Instance created under Shape Class
class Circle extends Shape {
  float radius;

  Circle(float x, float y, float radius, color fillColor) {
    super(x, y, fillColor);
    this.radius = radius;
  }

//Displays Circle
  void display() {
    super.display();
    ellipse(x, y, radius * 2, radius * 2);
  }
}

//Rectangle Instance created under Shape Class
class Rectangle extends Shape {
  float width, height;

  Rectangle(float x, float y, float width, float height, color fillColor) {
    super(x, y, fillColor);
    this.width = width;
    this.height = height;
  }

//Displays Rectangle
  void display() {
    super.display();
    rectMode(CENTER);
    rect(x, y, width, height);
  }
}

//Creates Triangle Instance in Shape Class
class Triangle extends Shape {
  float x1, y1, x2, y2, x3, y3;

  Triangle(float x, float y, float size, color fillColor) {
    super(x, y, fillColor);
    this.x1 = x - size / 2;  
    this.y1 = y + size / 3; 
    this.x2 = x + size / 2; 
    this.y2 = y + size / 3;
    this.x3 = x;
    this.y3 = y - size / 3;
  }

//Displays Triangle
  void display() {
    super.display();
    triangle(x1, y1, x2, y2, x3, y3);
  }
}

ArrayList<Shape> shapes;

//Creates Background and Shapes
void setup() {
  size(500, 500);
  shapes = new ArrayList<Shape>();
  shapes.add(new Triangle(0, 300, 350, color(112, 115, 125))); 
  shapes.add(new Triangle(100, 200, 350, color(112, 115, 125)));
  shapes.add(new Triangle(150, 300, 200, color(112, 115, 125)));
  shapes.add(new Triangle(250, 250, 250, color(112, 115, 125)));
  shapes.add(new Triangle(300, 300, 350, color(112, 115, 125)));
  shapes.add(new Triangle(40, 200, 200, color(112, 115, 125)));
  shapes.add(new Triangle(100, 350, 200, color(112, 115, 125)));
  shapes.add(new Triangle(400, 300, 200, color(112, 115, 125)));
  shapes.add(new Triangle(350, 325, 300, color(112, 115, 125)));
  shapes.add(new Triangle(500, 300, 300, color(137, 140, 152)));
  shapes.add(new Triangle(400, 350, 250, color(137, 140, 152)));
  shapes.add(new Triangle(325, 400, 300, color(137, 140, 152)));
  shapes.add(new Triangle(375, 350, 300, color(137, 140, 152)));
  shapes.add(new Triangle(225, 450, 300, color(137, 140, 152)));
  shapes.add(new Circle(10, 425, 50, color(135, 186, 114))); 
  shapes.add(new Circle(75, 450, 60, color(135, 186, 114))); 
  shapes.add(new Circle(120, 415, 20, color(135, 186, 114))); 
  shapes.add(new Circle(160, 450, 50, color(135, 186, 114))); 
  shapes.add(new Circle(70, 450, 60, color(135, 186, 114))); 
  shapes.add(new Circle(210, 475, 40, color(135, 186, 114))); 
  shapes.add(new Circle(270, 480, 50, color(135, 186, 114)));
  shapes.add(new Circle(350, 450, 60, color(135, 186, 114)));
  shapes.add(new Circle(400, 425, 50, color(135, 186, 114)));
  shapes.add(new Circle(450, 400, 40, color(135, 186, 114)));
  shapes.add(new Circle(500, 400, 60, color(135, 186, 114))); 
  shapes.add(new Rectangle(50, 450, 165, 100, color(135, 186, 114)));
  shapes.add(new Rectangle(500, 450, 250, 100, color(135, 186, 114)));
  shapes.add(new Rectangle(200, 500, 165, 100, color(135, 186, 114)));
  shapes.add(new Rectangle(50, 430, 100, 25, color(191, 174, 127)));
  shapes.add(new Rectangle(450, 420, 100, 25, color(191, 174, 127)));
  shapes.add(new Rectangle(100, 450, 25, 100, color(191, 174, 127)));
  shapes.add(new Rectangle(400, 450, 25, 125, color(191, 174, 127)));
  shapes.add(new Rectangle(250, 445, 300, 25, color(191, 174, 127)));
  shapes.add(new Circle(375, 75, 30, color(253, 221, 126))); 
}

//Draws/Displays Backrgound and Shapes
void draw() {
  background(151,202,224);
  
  for (Shape shape : shapes) {
    shape.display();
  }
}
