class flower{ // Class by the name of 'flower' is defined
  float hue; // Value holds the colour of the flower to be created
  int petalCount; // Value indicates how many petals the flower will have
  int rowCount; // Indicates how many layers the petals will have
  float len; // Indicates the length of the petals
  float wid; // Indicates the width of the petals
  float rotate; // Indicates the amount of rotation a petal will undergo before the next one is made
  
  flower(){ // Constructor for the flower class
    hue = random(0,360); // Sets the hue to a random colour on the entire spectrum
    petalCount = int(random(2,8))*4; // Determines a random amount of petals ensuring symmetry by multiplying by 4
    len = random(100,200); // Sets a random length of the petals between 100 and 200 pixels
    wid = random(0.2,0.5); // Sets a random width of the petals between 0.2 and 0.5 pixels
    rowCount = int(random(4,10)); // Randomly chooses how many layer of petals the flower will have
    rotate = random(0.5,2.0); // Randomly decides an amount each petal should rotate relative to the previous petal
  }
//creates a black stroke around the flower with a weight of 1. It then creates
//a way to rotate the petals over the entire 2pi range depending on how many
//petals there are. 
  void display(){
    stroke(0); // Creates a black stroke
    strokeWeight(1); // Stroke weight is set to 1 pixel
    float deltaA = (2*PI)/petalCount; // Calculates the angle between each petal based on total amount of petals
    float petalLen = len; // Assigns petal length to the flower's length
    pushMatrix();
    for(int r = 0; r < rowCount; r++){ // Loops over the number of layers of petals
      for(float angle = 0; angle < 2*PI; angle += deltaA){ // Loops around the entirety of a circle
        rotate(deltaA); // Rotates canvas before drawing future petals
        petal(petalLen*0.75,0,petalLen,petalLen*wid,(hue-r*20)%360); // Draws singular petal
      }
      rotate(rotate); 
      petalLen = petalLen*(1-3.0/rowCount); // Reduces length of petal for inner layer
    }
    popMatrix();
  }
  
  void petal(float x, float y, float lenP, float widP, float hueP){ // Draws petal at position (x,y) with a certain size and colour
    stroke(0); // Stroke colour is set to black
    for(int i=20; i>0; i--){ // 20 loops are made to create a gradient effect
      fill((hueP+i*2)%360,100,5*i); // Fills each petal with a colour based on the hue, changing brightness with each loop
      ellipse(x,y,lenP*i/20.0,widP*i/20.0); // Draws petals with decreasing size for each loop
      noStroke(); // Disables stroke
    }
  }
}

flower f1;

int grassWidth = 5;  // Width of each grass blade
int grassHeight = 5 ; // Height of each grass blade
int rows, cols;  // Number of rows and columns to cover the screen
int value = 0; // Base counter value

void setup(){
  size(1000,1000); // Sets the canvas to 1000 by 1000 pixels
  smooth(); // Enables anti-aliasing
  colorMode(HSB,360,100,100); // Swithces to HSB colour mode
  background(200, 20, 100); // Sky colour
  rows = height / grassHeight; // Calculate number of rows
  cols = width / grassWidth;  // Calculate number of columns
  drawGrassField(); // Calls function to draw grass blades
  fill(60, 100, 100); 
  strokeWeight(0);
  circle(850, 150, 100); // Creates a circle representing the sun
  fill(30, 255, 30);
  rect(-5, 930, width+10, 70); // Creates the dirt patch at the bottom
  strokeWeight(12);
  translate(width/2, 898); // Translates the origin to the center to draw the tree
  tree(0); // Calls function to draw tree
  f1 = new flower(); // Creates new instance of the class 'flower'
  frameRate(0.5); // Sets framerate to 0.5 fps to slow down flower generation
}

void draw(){
  pushMatrix(); 
  if (value % 2 == 0){ // If the amount of times the user has clicked is even, this statement is called
  float randomposition = floor(random(width/10))*10; // Generates a position to generate the flowers on
  translate(randomposition, 898); // Moves origin to draw the flowers at a random x value and a known y value
  scale(0.1); // Sets scale for drawing flowers to a factor of 0.1
  f1.display(); // Displays flower
  popMatrix();
  f1 = new flower(); // Creates a new flower object for next loop
  }
}
  
void drawGrassField(){
  for (int i = 0; i < cols; i++) { 
    for (int j = 0; j < rows; j++) {
      float x = i * grassWidth;  // X position of the grass blade
      float y = 930; // Y position with random variation to simulate randomness
      float angle = random(-PI / 4, PI / 4); // Random tilt for each grass blade
      float length = random(10, 30); // Random blade length
      drawGrassBlade(x, y, angle, length); // When called, grass blades are drawn
    }
  }
}

void drawGrassBlade(float x, float y, float angle, float length){
  pushMatrix();
  translate(x, y); // Move to the correct position
  rotate(angle); // Random tilt for natural randomness
  if (value % 2 == 0){
    stroke(120, 100, 30); // Grass blade colour during summer
  }
  if (value % 2 != 0){ // If the amount of times the user has clicked is odd, this statement is called
    stroke(0, 0, 100); // Grass blade colour during winter
  }
  strokeWeight(2);  // Set stroke width
  line(0, 0, 0, -length);  // Draw the grass blade by specifying start and end points
  popMatrix();
}

void tree(int x){ // Function tree is defined by the parameter x, representing branch depth
  if (x < 14) { // Determines depth of recursion, limiting branch length
    stroke(20, 32, 37); // Tree branch and trunk colour
    line(0, 0, 0, -height/10); // Draws trunk of the tree
    translate(0, -height/10); // Moves origin to draw next branch at the top of the trunk
    rotate(random(-0.1,0.1)); // Applies random rotation to draw next branch
    if (random(1.0) < 0.6) { // If condition is met, more branches are made
      rotate(0.3); // Rotates new branch away from previous branch
      scale(0.75); // Scales down branch by a factor of 0.75
      pushMatrix(); // Saves current transformation
      tree(x + 1); // Deepens recursion and makes smaller branches
      popMatrix(); // Restores previously defined transformation state
      rotate(-0.7); // Rotates tree branch
      pushMatrix();
      tree(x + 1); 
      popMatrix();
    } else if (x > 9){ // If condition is met, deeper section is made
      stroke(120, 100, 100); // Changes colour of future sections
      line(0, 0, 0, -height/10); // Creates a new section
      translate(0, -height/10); // Moves origin
      rotate(random(-0.1, 0.1)); // Applies random rotation between -0.1 and 0.1 radians
      if (random(1.0) < 0.6) { // If condition is met, more sections are made
        rotate(0.3);
        scale(0.75);
        pushMatrix();
        tree(x + 1);
        popMatrix();
        rotate(-0.7);
        pushMatrix();
        tree(x + 1);
        popMatrix();
      }
    } else { // If none of the conditions are met anymore, the tree is printed
      tree(x);
    }
  }
}

void wintertree(int x){ // Function wintertree is defined by the parameter x, representing branch depth
  if (x < 14) { // Functions are extremely similar to 'tree' and are all previously defined
    stroke(20, 32, 37);
    line(0, 0, 0, -height/10);
    translate(0, -height/10);
    rotate(random(-0.1,0.1));
    if (random(1.0) < 0.6) {         
      rotate(0.3);
      scale(0.75);
      pushMatrix();
      wintertree(x + 1);
      popMatrix();
      rotate(-0.7);
      pushMatrix();
      wintertree(x + 1);
      popMatrix();
    } else {
      wintertree(x);
    }
  }
}

void mouseClicked(){ // Switches between summer and winter scenes for every click
  value++;
  if (value % 2 != 0){ // If times clicked is odd, function is called (code is previously defined)
    smooth();
    background(0, 0, 70);
    rows = height / grassHeight;
    cols = width / grassWidth;
    drawGrassField();
    fill(0, 0, 100);
    strokeWeight(0);
    circle(850, 150, 100);
    fill(192, 2, 94);
    rect(-5, 930, width+10, 70);
    strokeWeight(12);
    translate(width/2, 898);
    wintertree(0);
  }
  if (value % 2 == 0){ // If times clicked is even, function is called (code is previously defined)
    background(200, 20, 100); // Sky colour
    rows = height / grassHeight; // Calculate number of rows
    cols = width / grassWidth;  // Calculate number of columns
    drawGrassField();
    fill(60, 100, 100);
    strokeWeight(0);
    circle(850, 150, 100);
    fill(30, 255, 30);
    rect(-5, 930, width+10, 70);
    strokeWeight(12);
    translate(width/2, 898);
    tree(0);
  }
}
