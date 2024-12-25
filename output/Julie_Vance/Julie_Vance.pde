// Declare variables in the code
// Declare Circle objects
Circle CircleA;
Circle CircleB;

// Declare boolean flags 
boolean textDisplayed = false;  // flag to track if the first text has been displayed
boolean resetFlag = false; // flag to track if code has run once yet
boolean mousePressedAfterReset = false;  // flag to track if mouse has been pressed after reset
boolean circlesMoving = false;           // flag to track if the circles should be moving
boolean enter2 = false; // flag to track if enter has been pressed at the end - can we drop the balls
boolean spawnBallFlag = false; // flag to track if it is time to spawn small balls yet
boolean enterPressed = false; // flag to track if Enter is being pressed for displaying NO onscreen
boolean wordDisplayed = false; // flag to ensure only one random word is displayed at a time

// Declare strings
String inputText = "";  // Store the input text that the user types
String[] customWords = {"no", "nuh uh", "too low", "I don't like it", "different %", "try again", "you're wrong"}; // list of random words to be displayed
String randomWord = ""; // variable to store the random word

// List to store small balls
ArrayList<Circle> smallBalls = new ArrayList<Circle>(); // A list to hold small balls

//


// Functions to be used within the draw function

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


// Circle class inheriting from Shape
class Circle extends Shape {
  float radius; // Radius of the circle
  float vx, vy; // Velocity in x and y direction

  // Constructor for Circle
  Circle(float x, float y, float radius, color fillColor, float vx, float vy) {
    super(x, y, fillColor); // Call the parent constructor
    this.radius = radius; // Assign the radius
    this.vx = vx; // Set initial velocity in the x direction
    this.vy = vy; // Set initial velocity in the y direction
  }

  // Override the display method to draw the circle
  void display() {
    super.display(); // Call the base class display method to set color
    ellipse(x, y, radius * 2, radius * 2); // Draw the circle
  }

  // method to grow the circle's radius
  void grow(float growthRate) {
    this.radius += growthRate; // Increase the radius by growthRate
  }

  // method to reset the circle's properties
  void reset(float newRadius, color newColor) {
    this.radius = newRadius; // Reset radius
    this.fillColor = newColor; // Reset color
  }

  // method to move the circle based on velocity
  void move() {
    this.x += this.vx; // Update x based on velocity
    this.y += this.vy; // Update y based on velocity
  }

  // method to make the circle bounce off the screen edges
  void bounce() {
    // Check for horizontal boundaries
    if (this.x - this.radius < 0 || this.x + this.radius > width) {
      this.vx *= -1; // Reverse direction on x-axis
    }

    // Check for vertical boundaries
    if (this.y - this.radius < 0 || this.y + this.radius > height) {
      this.vy *= -1; // Reverse direction on y-axis
    }
  }
}


// Function to reset the display
void resetDisplay() {
  // Reset the circle properties 
  CircleA.reset(100, color(255, 0, 0)); // Reset CircleA to its initial state
  CircleB.reset(10, color(0, 0, 255)); // Reset CircleB to its initial state
  
  resetFlag = true; // Set the reset flag to true after reset
}


// Function so if you press enter key you reset the drawing
void keyPressed() {
  if (key == ENTER && !resetFlag) {
    resetDisplay(); // reset the display when enter is pressed
  }
  
  // Capture the grade when a key is pressed
  if (resetFlag && mousePressedAfterReset) {
    if (key == BACKSPACE) {
      // delete a letter
      if (inputText.length() > 0) {
        inputText = inputText.substring(0, inputText.length() - 1);
      }
    }
    else if (key != ENTER) {  // Ignore enter key during typing
      inputText += key;  // Add the typed character to the inputText string
    }
  }
}


// Setup function
void setup() {
  size(1200, 800); // Set the canvas size
  noStroke(); // Disable the stroke for shapes
  frameRate(60); // Set frame rate to 60 frames per second
  
  // Add circles with initial velocities
  CircleA = new Circle(300, 400, 100, color(255, 0, 0), 3, 2); // Red circle moving with velocity 
  CircleB = new Circle(900, 400, 10, color(0, 0, 255), -3, 2); // Blue circle moving with velocity 
}



// Function to spawn many small bouncing balls
void spawnBalls(int numBalls) {
  float spawnX = width / 2; // Spawn balls
  float spawnY = height / 2; // Spawn balls
  
  for (int i = 0; i < numBalls; i++) {
    float radius = random(5, 15); // random size between 5 and 15
    color ballColor = color(random(0, 256), random(0, 256), random(0, 256)); // random colour for the balls
    
    // random velocity for each ball
    float vx = random(-3, 3);
    float vy = random(-3, 3);
    
    // Add the new ball to the list with the spawn position and random velocity
    smallBalls.add(new Circle(spawnX, spawnY, radius, ballColor, vx, vy));
  }
}


// function to update and display the small bouncy balls
void updateBalls() {
  for (int i = 0; i < smallBalls.size(); i++) {
    Circle ball = smallBalls.get(i);
    ball.move(); // Move ball
    ball.bounce(); // Make the ball bounce off the edges
    ball.display(); // Display the ball
  }
}


// Function to make both the small balls and the circles drop to the bottom of the screen
void dropBalls() {
  // Drop the small bouncing balls
  for (int i = 0; i < smallBalls.size(); i++) {
    Circle ball = smallBalls.get(i);
    ball.y += 5;  // Increase the y position to make the ball fall
    
    // Stop the balls when they reaches the bottom
    if (ball.y > height - ball.radius) {
      ball.y = height - ball.radius;  // keep the balls at the bottom
      ball.vx = 0;  // (no x-axis bouncing)
      ball.vy = 0;  // (no y-axis bouncing)
    }
  }
  
  // Drop CircleA
  CircleA.y += 5;  // Increase the y position to make the circle fall
  if (CircleA.y > height - CircleA.radius) {
    CircleA.y = height - CircleA.radius;  // Keep CircleA at the bottom
    CircleA.vx = 0;  // (no x-axis bouncing)
    CircleA.vy = 0;  // (no y-axis bouncing)
  }
  
  // Drop CircleB
  CircleB.y += 5;  // Increase the y position to make the circle fall
  if (CircleB.y > height - CircleB.radius) {
    CircleB.y = height - CircleB.radius;  // Keep CircleB at the bottom
    CircleB.vx = 0;  // (no x-axis bouncing)
    CircleB.vy = 0;  // no y-axis bouncing)
  }
}





// draw function (continuous loop)
void draw() {
  background(255); // Set background color to white
  
  // Display the circles
  CircleA.display(); // Display CircleA
  CircleB.display(); // Display CircleB
   
  // Grow the circles if the mouse is pressed and resetFlag is false
  if (mousePressed && !resetFlag) {
    CircleA.grow(4);  // Grow the radius of CircleA
    
    //only grow circle B until it reaches certain radius
    if (CircleB.radius < 200) { 
      CircleB.grow(4);  // Grow the radius of CircleB
    }
    
    // Check if CircleA is larger than 980 and text has not been displayed
    if (CircleA.radius > 980 && !textDisplayed) {
      CircleA.fillColor = color(0);  // set CircleA's fill to black
      CircleB.fillColor = color(0);  // set CircleB's fill to black
      textDisplayed = true;  // mark that the text has been displayed
    }
  }

  // Always display the text if it has been shown already
  if (textDisplayed && !resetFlag) {
    textSize(32);         // Set the text size
    fill(255);            // Set text color to white
    text("Syntax is Common Sense", 500, 400);  // Print the text at (500, 400)
    
    textSize(32);
    fill(255); //text colour to white
    text("Press enter", 520, 600);
  }
    
     // Check if the mouse was pressed after the reset flag is raised
  if (resetFlag && mousePressed && !mousePressedAfterReset) {
    mousePressedAfterReset = true;  // Mark that the mouse was pressed after reset
    circlesMoving = true;  // flag to start moving the circles
  }

  // If the circles should be moving, update their position and bounce
  if (circlesMoving) {
    CircleA.move(); // Move CircleA
    CircleA.bounce(); // Make CircleA bounce off the edges

    CircleB.move(); // Move CircleB
    CircleB.bounce(); // Make CircleB bounce off the edges
  }


// If resetFlag is true, allow the circles to move and display the text
if (resetFlag && mousePressedAfterReset) {
  // Display the text to prompt the professor for the grade
  textSize(32);         // Set text size
  fill(0);              // Set text colour
  text("Please Enter this Assignment's Grade:", 500, 400); 
  
  // Display the input text on the screen
  text(inputText + "%", 50, 200);  
  
  // Check the grade % input 
  if (inputText.length() > 0 && !inputText.equals("100")) {
    
    // flag to spawn many small balls if the grade% is not 100
    spawnBallFlag = true;
  }
  
  // If the input grade is 100 display text 
  if (inputText.equals("100")) {
    textSize(32);
    fill(0);  // Green text
    text("Oh my Goodness!", 250, 200);
    text("Thank you so much for giving me 100% on this assignment!", 250, 250);
    text("(Go put it in the markbook before you forget)", 250, 300);

    // Check if Enter has been pressed 
    if (keyPressed && key == ENTER) {
      enter2 = true; // flag to stop more small bouncy balls from spawning
    }
  }
}

// spawn tiny balls  (outside of statement so it is not overwritten by draw function)
if (spawnBallFlag && !enter2) {
  // Spawn small bouncing balls when the grade is not 100%
  spawnBalls(10);  // Add 10 balls to the screen
}

// If Enter is pressed and the grade is not 100, show "NO", has to be greater than 0 so text is not initially displayed
if (inputText.length() > 0 && !inputText.equals("100")) {
  if (keyPressed && key == ENTER) {
    enterPressed = true; // flags if Enter is pressed for displaying red "no" text
  } 
  else {
    enterPressed = false; // Reset the flag if Enter is not pressed
  }
}

// keep the existing balls existing/moving but prevent new balls spawning
updateBalls();  

// If Enter has been pressed and the grade is 100%, drop the balls
if (enter2) {
  dropBalls();  // function that makes the balls fall
}

// Check if Enter is pressed
if (enterPressed) {
  // Display the word only once when Enter is first pressed
  if (!wordDisplayed) {
    randomWord = customWords[(int) random(customWords.length)]; // randomly select a word from the array
    wordDisplayed = true;  // Set the flag to true, so the word is not changed again
  }

  // display the "no" word
  textSize(200);  // big text
  fill(255, 0, 0);  // Red color
  // Display the word centered on the screen
  text(randomWord, 100, 450);  
} 

else {
  // if enter is released, reset the flag to allow new word selection when pressed again
  wordDisplayed = false;
}
}
