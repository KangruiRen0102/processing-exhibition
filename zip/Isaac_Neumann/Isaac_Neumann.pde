int buildingHeight = 100; // Initial height of the building
int buildingWidth = 200; // Width of the building
int buildingX; // X-position of the building 
int buildingY; // Y-position of the building 

int windowWidth = 30; // Window width
int windowHeight = 40; // Window height
int windowPadding = 20; // Padding between windows and from edges

int monthCount = 0; // Counter to keep track of months
int maxMonths = 28; // Maximum number of months before stopping

// Define the clouds size, coordinates and speed
class Cloud {
  float x, y, size, speed;

  Cloud(float x, float y, float size, float speed) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
  }

// moves clouds across the screen from left to right
  void move() {
    x += speed;
    if (x > width) {
      x = -size;  // If the cloud goes off the screen, reset its position to the left side of the screen 
    }
  }

// displays cloud on screen
  void display() {
    drawCloud(x, y, size);  
  }
}

ArrayList<Cloud> clouds = new ArrayList<Cloud>();  // List to store multiple clouds

void setup() {
  size(1200, 900);  // Set canvas size 
  noFill();        // No fill so the rectangles can be outlined
  stroke(0);       // Set outline color to black
  buildingX = (width - buildingWidth) / 2; //center the building horizontally on the canvas 
  buildingY = height - 50; //position the building vertically on the screen
  
  // Create some clouds with random positions, sizes, and speeds
  for (int i = 0; i < 8; i++) { // makes 8 clouds 
    float cloudX = random(width); // gives X position
    float cloudY = random(50, 200); // keeps clouds in upper part of screen  
    float cloudSize = random(50, 100); // gives random size 
    float cloudSpeed = random(0.2, 0.5); // Random speed for each cloud keeping them relatively slow 
    clouds.add(new Cloud(cloudX, cloudY, cloudSize, cloudSpeed)); // add clouds to a list 
  }
}

void draw() {
  background(135, 206, 235); //colors in the sky blue
  
  // move and display each cloud
  for (Cloud cloud : clouds) {
    cloud.move();   
    cloud.display();  
  }

  // draw the individual stories of the building
  for (int i = 0; i < buildingHeight / 100; i++) {
    int storyY = buildingY - (i * 100); // adjust Y-position for each story
    
    // draws and colors each level
    fill(150);  
    rect(buildingX, storyY - 100, buildingWidth, 100); 
 
    // draw the windows for this level
    drawWindows(storyY - 100);
  }

  // draw the grass on the bottom
  drawGrass();

  // draw the month counter in the top right corner
  drawMonthCounter();
}

void drawWindows(int baseY) {
  fill(255);  // set window color to white
  int totalWindowWidth = 3 * windowWidth + 2 * windowPadding;  // total width of the 3 windows with padding
  int startX = buildingX + (buildingWidth - totalWindowWidth) / 2;  // centering the windows on the floor
  
  // draw 3 parallel windows in a row
  for (int i = 0; i < 3; i++) {  //tThree windows on each floor
    int windowX = startX + i * (windowWidth + windowPadding);  // adjust X position for each window
    int windowY = baseY + windowPadding;  // keep windows on consistent height
    rect(windowX, windowY, windowWidth, windowHeight);  // draw the window
  }
}

void drawCloud(float x, float y, float size) {
  fill(255);  // color clouds white
  ellipse(x, y, size, size); //center of cloud 
  ellipse(x + size * 0.5, y - size * 0.25, size * 0.8, size * 0.8); // right side of cloud 
  ellipse(x - size * 0.5, y - size * 0.25, size * 0.8, size * 0.8); //left side of cloud 
}

void drawGrass() {
  fill(34, 139, 34);  // color grass green
  rect(0, height - 50, width, 50);  // grass area at the bottom of the screen
}

void drawMonthCounter() {
  fill(0);  // text color is black 
  textSize(32);  // set text size
  textAlign(RIGHT, TOP);  // put text in top right corner
  
  // display the current month count in the top-right corner
  text("Months: " + monthCount, width - 20, 20); 
}

void mousePressed() {
  if (monthCount < maxMonths) { //if max months isn't exceeded the following happens
    buildingHeight += 100; //increase builiding height by one floor 
    monthCount += 4; // add 4 months per click
  }
}
