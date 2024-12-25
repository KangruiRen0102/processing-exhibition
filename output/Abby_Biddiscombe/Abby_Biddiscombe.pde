//Keywords: Aurora, Choas, Infinity
//Sentence: "In the chaos of infinity, an aurora danced across the sky."


// Base class for shapes
abstract class Shape {
  float x, y;
  color fillColor;

  Shape(float x, float y, color fillColor) { //defines instances for Shape
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }

  abstract void display(); //creates function for detecting the mouse over a shape
  abstract boolean isInside(float mx, float my);
}

// Ellipse class extending Shape, creates ellipses with no outline
class EllipseShape extends Shape {
  float width, height;

  EllipseShape(float x, float y, float width, float height, color fillColor) {
    super(x, y, fillColor);
    noStroke();
    this.width = width;
    this.height = height;
  }

  @Override
  void display() {
    fill(fillColor);
    ellipse(x, y, width, height);
  }

  @Override //detects mouse inside the shape
  boolean isInside(float mx, float my) {
    return dist(mx, my, x, y) < width / 2;
  }
}

//Removed Class/functions from final code
// Rectangle class extending Shape
//class RectangleShape extends Shape {
  //float width, height;

  //RectangleShape(float x, float y, float width, float height, color fillColor) {
    //super(x, y, fillColor);
    //this.width = width;
    //this.height = height;
  //}

  //@Override
  //void display() {
    //fill(fillColor);
    //rect(x - width / 2, y - height / 2, width, height, 20);  // Rounded corners

 // Add the text "CHAOS" inside the rectangle
    //fill(0); // Set text color to black
    //textSize(32); // Set text size
    //textAlign(CENTER, CENTER); // Center the text
    //text("CHAOS", x, y); // Display the word "CHAOS" inside the rectangle
  //}

  //@Override
  //boolean isInside(float mx, float my) {
    //return (mx > x - width / 2 && mx < x + width / 2 && my > y - height / 2 && my < y + height / 2);
  //}
//}

// ShapeManager to manage shapes
class ShapeManager {
  ArrayList<Shape> shapes = new ArrayList<>();

  void addShape(Shape shape) {
    shapes.add(shape);
  }

  void displayShapes() {
    for (Shape shape : shapes) {
      shape.display();
    }
  }

  Shape getShapeAt(float mx, float my) {
    for (Shape shape : shapes) {
      if (shape.isInside(mx, my)) {
        return shape;
      }
    }
    return null;
  }

  void clearShapes() {
    shapes.clear();
  }
}

// InteractionController to manage user interactions
class InteractionController {
  ShapeManager shapeManager;
  Shape selectedShape = null; // Keep track of the selected shape
  float offsetX, offsetY; // Offset for dragging

  InteractionController(ShapeManager shapeManager) {
    this.shapeManager = shapeManager;
  }

//Allows shape movement when mouse is pressed over the shape
  void handleMousePressed(float mx, float my) {
    selectedShape = shapeManager.getShapeAt(mx, my); // Check if a shape is selected
    if (selectedShape != null) {
      offsetX = mx - selectedShape.x; // Calculate offset for dragging
      offsetY = my - selectedShape.y;
    }
  }

  void handleMouseDragged(float mx, float my) { //Moves shape when cursor is dragged
    if (selectedShape != null) {
      selectedShape.x = mx - offsetX;
      selectedShape.y = my - offsetY;
    }
  }

  void handleMouseReleased() { //Stops shape movement when mouse is released
    selectedShape = null;
  }
}

// Main program variables and setup
ShapeManager shapeManager = new ShapeManager();
InteractionController interactionController = new InteractionController(shapeManager);

void setup() { //Draw background
  size(800, 600);

  // Create a gradient background to mimic an aurora or northern lights
  createGradientBackground();

  // Create several ellipses arranged in the shape of an infinity sign
  float centerX = width / 2;
  float centerY = height / 2;
  float loopWidth = 150; // Width of each loop
  float loopHeight = 100; // Height of each loop
  int numEllipses = 20;  // Total number of ellipses (increased to complete the infinity sign)
  float ellipseWidth = 50;
  float ellipseHeight = 30;
  int numEllipsesInLoop = numEllipses / 2; //Distributes the total number of ellipses equally throughout the loops

  // Create the left and right loops of the infinity sign
  for (int i = 0; i < numEllipsesInLoop; i++) {
    float angleLeft = map(i, 0, numEllipsesInLoop, -PI, PI);  // Angle for left loop
    float angleRight = map(i, 0, numEllipsesInLoop, -PI, PI);  // Angle for right loop

    // Positions for the left loop
    float xLeft = centerX - loopWidth + loopWidth * cos(angleLeft);
    float yLeft = centerY + loopHeight * sin(angleLeft);
    shapeManager.addShape(new EllipseShape(xLeft, yLeft, ellipseWidth, ellipseHeight, color(random(255), random(255), random(255))));

    // Positions for the right loop
    float xRight = centerX + loopWidth + loopWidth * cos(angleRight);
    float yRight = centerY + loopHeight * sin(angleRight);
    shapeManager.addShape(new EllipseShape(xRight, yRight, ellipseWidth, ellipseHeight, color(random(255), random(255), random(255))));
  }
  
//Rectangle removed
  // Add a rounded rectangle in the center
  //shapeManager.addShape(new RectangleShape(width / 2, height / 2 + 200, 200, 100, color(0, 255, 255)));
}

void draw() {
  // Background is already accounted for
  shapeManager.displayShapes();
}

// Activate/apply the previous functions for interaction
void mousePressed() {
  interactionController.handleMousePressed(mouseX, mouseY);
}

void mouseDragged() {
  interactionController.handleMouseDragged(mouseX, mouseY);
}

void mouseReleased() {
  interactionController.handleMouseReleased();
}

// Loop colours over 'y' locations to create a gradient background
void createGradientBackground() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0.0, 1.0);
    color c = lerpColor(color(60,0,200), color(65,145,100), inter);  // Gradient from deep blue to green
    stroke(c);
    line(0, y, width, y);
  }
}
