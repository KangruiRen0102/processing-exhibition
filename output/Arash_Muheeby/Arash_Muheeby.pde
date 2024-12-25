float x = 450; // Initial x-position of the lines 
float y = 420; 
float angle; // stores the current angle of rotation
float dia = 22; // Initial diameter of the shape
float changeSpeed = 0.7; // controls how fast the diamter changes based on mouse postion
boolean isRed = true; // tracks if the line color is red or blue
boolean reverseRotation = false; // determines if rotation is reversed
color bgColor = color(255); // white background
int lastClickTime = 0; // Differentiate between a single and double click
int doubleClickThreshold = 500; // limit for double click

void setup() {
  size(960, 1080); // window size
  surface.setLocation(957, 0); // postion of window on the screen
}

void draw() {
  background(bgColor); // sets up the background color
  
  // calculates distance of the mouse from the center of canvas
  float distFromCenter = dist(mouseX, mouseY, width / 2, height / 2);
  
  // adjusts the speed based on the distance from the center
  if (distFromCenter < 120) { 
    changeSpeed = 0.015; // Slower change when close to the center 
  } else {
    changeSpeed = 0.12; // faster change when further from the center 
  }
  
  mouseX = constrain(mouseX, 30, width); // Changed lower limit of mouseX
  dia = lerp(dia, mouseX, changeSpeed); // lerp syntax allows for smoother change
  
  translate(width / 2, height / 2); // Origin moves to center of canvas 
  if (reverseRotation) {
    rotate(radians(angle / 2)); // When statment is true then direction reverses
  } else {
    rotate(-radians(angle / 2)); // direction of rotation stays the same
  }

// Drawing the ellipses and rotating lines 
  for (float a = 0; a < 360; a += dia / 3) { // Slightly increasing the increment   
    pushMatrix();
    rotate(radians(a)); // each shape rotates by an increment 
    
    // setting up the line color based on `isRed` from previous steps
    stroke(isRed ? color(255, 0, 0) : color(0, 0, 255)); // Toggles the line between red and blue
    strokeWeight(dia / 4); // Stroke weight is set based on the diameter
    line(0, y * sin(radians(a + angle)), x - dia / 3, 0); // draws the line for the center. go over this 
    line(width, y * sin(radians(a + angle)), x + dia / 3, 0); // draws line to the right side 
    
    noStroke(); // disables the stroke
    fill(0); // fill color to black 
    ellipse(0, y * sin(radians(a + angle)), dia / 2, dia / 2); // smalle ellipses at endpoint of each line 
    
    stroke(0); //stroke color back to black
    if (y <= y * sin(radians(a + angle)) + dia / 4) fill(0); // condition slightly adjusted
    else noFill(); // if condition is not met then no fill
    ellipse(0, y, dia, dia); // ellipses at the center
    popMatrix(); // stores the previous transformation 
  }
  angle++; // Increases the angle for rotation animation
}

void mousePressed() {
  int currentTime = millis(); // current time in milliseconds
  
  if (currentTime - lastClickTime < doubleClickThreshold) {
    // if time between click  is than the threshold then its a double click
    reverseRotation = !reverseRotation; // Toggle rotation direction
    bgColor = (bgColor == color(255)) ? color(255, 255, 0) : color(255); // background color between white and yellow
  } else {
    // Single click detection
    isRed = !isRed; // Toggle between red and blue for line color
  }
  
  lastClickTime = currentTime; // Updates the time of the last click
}
