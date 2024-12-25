// The following lines of code define the Rectangle class for the program. This class will be used by many instances to do the majority of the art's drawing.
class Rectangle {
  float x, y; // Each instance has a set position. 
  float width, height; // Each instance has set dimensions.
  color c; // Each instance has a set color defined by RGB values.

  // This is the constructor for the Rectangle class that each instance will follow.
  Rectangle(float startX, float startY, float w, float h, color col) {
    x = startX;
    y = startY;
    width = w;
    height = h;
    c = col;
  }

  // This function draws each instance of Rectangle.
  void draw() {
    fill(c);  // This fills in each instance with its set colour.
    noStroke();  // This takes away the coloured borders of each shape so the drawing appears nicely.
    rect(x, y, width, height); // This builds the rectangle using the parameters provided.
  }

  // The following few lines of code are what make the Traveller able to move throughout the art. Inspiration for this was taken from class example and applied after a little research on the Processing website.
  void move() {
    if (keyPressed) { // This line checks to see if a key is being pressed down by the user.
      if (keyCode == RIGHT) { 
        x += 3; // If the keyCode is RIGHT then the rectangle(in this case it's just the traveller) will move to the right.
      } else if (keyCode == LEFT) {
        x -= 3; // If the keyCode is LEFT then the traveller will move to the left.
      } else if (keyCode == UP) {
        y -= 3; // If the keyCode is UP then the traveller will move up.
      } else if (keyCode == DOWN) {
        y += 3; // If the keyCode is DOWN then the traveller will move down.
      }
      
      // These lines of code constrain the area that the traveller can access and make appear as though the bridge rails and walls by the river block the traveller.
      if (x >= 390 && x <= 530 && y < 100 && y > 70) { // This is the bridge section of the drawing.
          y = constrain(y, 80, 120 - this.height); // Constrains the traveller to the bridge when in this part of the drawing.
        } else if (x < 420) {
          x = constrain(x, 0, 420 - this.width); // Constrains the traveller to the left side of the drawing and the left set of walls.
          y = constrain(y, 0, 400 - this.height); // Constrains the traveller to the top and bottom of the drawing.
        } else if (x > 520) {
          x = constrain(x, 531, 600 - this.width); // Constrains the traveller to the right set of walls and the right side of the drawing.
          y = constrain(y, 0, 400 - this. height); // Constrains the traveller to the top and bottom of the drawing.
        }
        
      // These lines of code are what make the traveller grow as they traverse the path.
      if (x >= 530 && x <= 580 && y >= 320 && y <= 350) { // When the traveller reaches the end of the path the following updates are made.
       width = 40;  // Updates the traveller's width.
       height = 40; // Updates the traveller's height.
       }
      if (x >= 400 && x <= 420 && y >= 70 && y <= 100) { // When the traveller reaches the bridge the following updates are made.
        width = 30; // Updates the traveller's width.
        height = 30; // Updates the traveller's height.
      }
     }
  }
}

// The following lines of code define the Circle class for the program. This class is used to draw many instances of trees in the art piece.
class Circle {
  float x, y; // Each instance has a set position.
  float radius; // Each instance has a set radius.
  color c;  // Each instance has a set colour defined by RGB values.
  
  // This is the constructor for the Circle class that each instance will follow.
  Circle(float startX, float startY, float r, color col) {
    x = startX;
    y = startY;
    radius = r;
    c = col;
  }
  
  // This function draws each instance of Circle.
  void draw() {
    fill(c); // This fills in each instance with its set colour.
    stroke(50, 50, 0); // This sets the border of each instance to a dark brown colour.
    ellipse(x, y, 2 * radius, 2 * radius); // This builds the circle using the parameters provided.
  }
}

// Here is where we define all of our instances so that we can modify them using the functions we have created in the program.
Rectangle Traveller;
Rectangle Bridge;
Rectangle River;
Rectangle Rail1;
Rectangle Rail2;
Rectangle Wall1;
Rectangle Wall2;
Rectangle Wall3;
Rectangle Wall4;
Rectangle Path1;
Rectangle Path2;
Rectangle Path3;
Rectangle Path4;
Rectangle Path5;
Rectangle Path6;
Rectangle Path7;
Rectangle Finish1;
Rectangle Finish2;
Rectangle Finish3;
Circle Tree1;
Circle Tree2;
Circle Tree3;
Circle Tree4;
Circle Tree5;
Circle Tree6;
Circle Tree7;
Circle Tree8;
Circle Tree9;
Circle Tree10;


// Here is where we create two empty lists for our instances. Later on in the program we use a loop to iterate through this list and draw each instance.
ArrayList<Rectangle> allRect;
ArrayList<Circle> allCirc;

void setup() {
  size(600, 400);  // This creates the size of the drawing space that we will be working with.
  background(0, 100, 0); // This sets the colour of the drawing space we just created.

  // This is the part of the program that creates all the instances in the drawing using the two classes we defined above and values that are now given.
  Traveller = new Rectangle(5, 320, 20, 20, color(150, 0, 0));
  River = new Rectangle(450, 0, 50, height, color(0, 0, 150));
  Bridge = new Rectangle(425, 75, 100, 50, color(150, 75, 0));
  Rail1 = new Rectangle(420, 70, 110, 10, color(100, 75, 0));
  Rail2 = new Rectangle(420, 120, 110, 10, color(100, 75, 0));
  Wall1 = new Rectangle(420, 0, 10, 70, color(150, 150, 150));
  Wall2 = new Rectangle(520, 0, 10, 70, color(150, 150, 150));
  Wall3 = new Rectangle(420, 130, 10, height, color(150, 150, 150));
  Wall4 = new Rectangle(520, 130, 10, height, color(150, 150, 150));
  Path1 = new Rectangle(0, 300, 360, 60, color(50, 50, 0));
  Path2 = new Rectangle(300, 180, 60, 120, color(50, 50, 0));
  Path3 = new Rectangle(30, 180, 330, 60, color(50, 50, 0));
  Path4 = new Rectangle(30, 70, 60, 110, color(50, 50, 0));
  Path5 = new Rectangle(30, 70, 400, 60, color(50, 50, 0));
  Path6 = new Rectangle(520, 70, 40, 60, color(50, 50, 0));
  Path7 = new Rectangle(540, 70, 50, 250, color(50, 50, 0));
  Finish1 = new Rectangle(540, 320, 50, 10, color(0, 0, 0));
  Finish2 = new Rectangle(540, 330, 50, 10, color(255, 255, 255));
  Finish3 = new Rectangle(540, 340, 50, 10, color(0, 0, 0));
  Tree1 = new Circle(565, 30, 25, color(0, 165, 0));
  Tree2 = new Circle(200, 150, 40, color(0, 160, 0));
  Tree3 = new Circle(125, 153, 20, color(0, 160, 0));
  Tree4 = new Circle(350, 50, 35, color(0, 160, 0));
  Tree5 = new Circle(20, 60, 50, color(0, 160, 0));
  Tree6 = new Circle(200, 30, 25, color(0, 160, 0));
  Tree7 = new Circle(395, 300, 45, color(0, 160, 0));
  Tree8 = new Circle(120, 275, 30, color(0, 160, 0));
  Tree9 = new Circle(240, 380, 25, color(0, 160, 0));
  Tree10 = new Circle(390, 160, 20, color(0, 160, 0));

  // The following lines of the program add all of the Rectangle instances to the allRect list. The order matters as whatever is last will be on the "top" of the drawing.
  allRect = new ArrayList<Rectangle>();
  allRect.add(River); // The river is added first because the bridge, rails, and traveller all need to be on top of it.
  allRect.add(Path1);
  allRect.add(Path2);
  allRect.add(Path3);
  allRect.add(Path4);
  allRect.add(Path5);
  allRect.add(Path6);
  allRect.add(Path7);
  allRect.add(Finish1);
  allRect.add(Finish2);
  allRect.add(Finish3);
  allRect.add(Bridge);
  allRect.add(Rail1);
  allRect.add(Rail2);
  allRect.add(Wall1);
  allRect.add(Wall2);
  allRect.add(Wall3);
  allRect.add(Wall4);
  allRect.add(Traveller); // The traveller is added last because it is on top of everything else in the drawing.
  
  // The following lines of the program add all of the Circle instances to the allCirc list. The order doesn't matter here as none of the trees overlap in the drawing.
  allCirc = new ArrayList<Circle>();
  allCirc.add(Tree1);
  allCirc.add(Tree2);
  allCirc.add(Tree3);
  allCirc.add(Tree4);
  allCirc.add(Tree5);
  allCirc.add(Tree6);
  allCirc.add(Tree7);
  allCirc.add(Tree8);
  allCirc.add(Tree9);
  allCirc.add(Tree10);
}

// The following function is created so that a message can be displayed on the screen(to the traveller) when they reach the end of the path.
void showMessage(String message) {
    fill(0, 225, 200); // This sets the colour of the text.
    textSize(36);  // This sets the size of the text that will appear.
    textAlign(CENTER, CENTER);  // This ensures that the text is aligned so the center of the text is at the point we set the text to be at.
    text(message, width / 2, height / 2);  // This displays the text on the screen and sets it's postion at the center of the drawing.
}
  
void draw() { // This is the part of the program where everything we have prepared above is drawn and the functions we created are invoked.
 background(0, 100, 0); // This draws the grassy background that all the instances are overlain on.

  // This is where all the instances get drawn through the use of a for loop. The for loop iterates through each object in each list and draws each instance.
  // The Circle instances are drawn after the Rectangle instances so the trees are on top. This also allows the traveller to travel under the trees.
  for (int i = 0; i < allRect.size(); i++) {
    allRect.get(i).draw();
}
  for (int i = 0; i < allCirc.size(); i++) {
    allCirc.get(i).draw();
  }
  
  // This invokes the move function we created in the Rectangle class and allows the traveller to move around the drawing.
  Traveller.move();
  
  // This invokes the function we created to display text on the drawing if the traveller's postion is within the required bounds.
  if (Traveller.x >= 530 && Traveller.x <= 580 && Traveller.y >= 320 && Traveller.y <= 350) {
        showMessage("A good journey produces growth.");  // The chosen text is written as a string in the function.
    }
}
