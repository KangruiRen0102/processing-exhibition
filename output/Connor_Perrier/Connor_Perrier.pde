// Base class representing a generic shape
class Shape {
  float x, y; // Position of the shape
  color fillColor; // Fill color of the shape

  // Constructor for the Shape class
  Shape(float x, float y, color fillColor) {
    this.x = x; // Assign the x-coordinate
    this.y = y; // Assign the y-coordinate
    this.fillColor = fillColor; // Set the fill color
  }

  // Method to display the shape, to be overridden by subclasses
  void display() {
    fill(fillColor); // Set the fill color
    noStroke(); // Disable borders for the shape
  }
}

// A factory method, should be a seperate class here with this static method, can try yourself
Shape createRandomShape(int x, int y) {
    return new Rectangle(x, y, random(40, 120), random(20, 80), color(int(mouseX)*255, int(mouseY)*255, 0));
  }
// triangle class


// Rectangle class inheriting from Shape
class Rectangle extends Shape {
  float width, height; // Width and height of the rectangle
  
  // Constructor for Rectangle
  Rectangle(float x, float y, float width, float height, color fillColor) {
    super(x, y, fillColor); // Call the parent constructor
    this.width = width; // Assign the width
    this.height = height; // Assign the height
  }

  // Override the display method to draw the rectangle
  void display() {
    super.display(); // Call the base class display method
    rectMode(CENTER); // Set rectangle mode to center
    rect(x, y, width, height); // Draw the rectangle
  }

 
}

ArrayList<Shape> shapes; // Create an ArrayList to store shapes
Shape selectedShape = null; // To track the selected shape

void setup() {
  size(900,600); // sets size, proportional to the colorado flag
  shapes = new ArrayList<Shape>(); // initializes the arraylist
  shapes.add(new Rectangle(450, 500, 900, 200, color(0,200,10))); // creates the lovely very green grass on the ground
}

void draw() {
  background(50,100,200); //creates the awesomely blue sky in the air
  for(Shape shape : shapes) {
    shape.display(); // Display each shape
  }
}

// the mousePressed block allocates the corresponding colour to the location clicked, as to approximate the flag of Colorado
// all of the colours have a bit of randomness baked in, helping alter the brightness, saturation, and hue and "breaking up" otherwise solid colour blocks
// this is much like how an Aurora Borealis/Australis has changing hues, even if largely one colour

void mousePressed() {
  //this block ensures all rectangles/buildings at the top/bottom of the screen are allocated a dark blue colour
  if (mouseY < 100) { 
      shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(random(10), 28+random(20) , 91+random(20))));
    }
    else if (mouseY> 500) {
      shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(random(10), 28+random(20) , 91+random(20))));
    }
    
    
    //this block here takes the bands between the middle and very outside (100 < y < 200 and 400 < y < 500)
    //it then allocates either red or blue depending on where the user clicked, approximating the circular focal point of the flag
    else if (mouseY < 200) {
      if (180 < mouseX) {
        if (mouseX < 580){
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(181 + random(20), 1 + random(20), 58 - random(20))));
      }}
      if (mouseX > 580) {
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(random(10), 28+random(20) , 91+random(20))));
    }
    if (mouseX < 180) {
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(random(10), 28+random(20) , 91+random(20))));
    }
    }
      else if (mouseY > 400) {
      if (580 > mouseX) {
      if (mouseX > 180){
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(181 + random(20), 1 + random(20), 58 - random(20))));
      }}
      if (mouseX < 180) {
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(random(10), 28+random(20) , 91+random(20))));
    }
      if (mouseX > 580) {
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(random(10), 28+random(20) , 91+random(20))));
    }}
     
     
     // this then takes the middle band of the flag (200 < y < 400)
     // it then allocates the corresponding color to the location clicked
     // middle of the "circle" --> yellow
     // outer ring of the of the "circle" --> red
     // outside of the "circle" --> white
    else {
      if (mouseX <180) {
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(255-random(20),255-random(20),255-random(20))));
      }
      if (mouseX >480) {
        shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(255-random(20),255-random(20),255-random(20))));
    }
       if (280 < mouseX) {
         if (mouseX< 480) {
          shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(255 - random(20), 195 + random(20), 0 + random(20))));
      }}
      else if (180 < mouseX) {
      if (mouseX < 480) {
         shapes.add(new Rectangle(mouseX, mouseY, random(35,100), random(50,160), color(181 + random(20), 1 + random(20), 58 - random(20))));
      }
      
    
     }
        
 }
}
