// Create an ArrayList to hold NorthernLights objects
ArrayList<NorthernLights> northernLights;
ArrayList<Star> stars;

void setup() { //The setup portion 
  size(750, 750);   // Set the window size to 750 x 750
  
  // Create a new list for the northern lights
  northernLights = new ArrayList<NorthernLights>();
  stars = new ArrayList<Star>(); // create a new list for all of the stars 
  background(0, 20, 0);  // Dark background with a slight green hue resembling the northern lights
  // Add some stars to the screen
  for (int i = 0; i < 200; i++) {
    stars.add(new Star(random(width), random(height)));
  }
}

void draw() {
  // Display the stars
  for (Star star : stars) {
    star.display(); //This operation actually displays the stars that have been created
  }
  
  // Display the northern lights
  // Loop through the northernLights list and display each individual one
  for (NorthernLights light : northernLights) {
    light.display(); //similar to the star one above, this displays the northern lights
  }
  
  // Display grey rectangles at the bottom of the screen to represent skyscrapers
  fill(100);  // Grey color...I looked online and this was supposed to be dark grey
  float rectHeight = height / 3; // Height of the grey rectangles is one third of the screen
  for (float i = 0; i < width; i += 80) { // Have the rectangles be evenly spaced
    rect(i, height - rectHeight, 60, rectHeight); // Draw a rectangle from the bottom upwards. I needed some help with this part to figure out how to do it
  }
}

void mousePressed() {
  // Start drawing northern lights when mouse is pressed. I want it to work BOTH when ressed and dragged
  northernLights.add(new NorthernLights(mouseX+25, mouseY+25)); 
  //the location is slightly off of the mouse coordinate because the mouse blends into the black background and it can be seen better
}

void mouseDragged() {
  // Keep adding northern lights as the mouse is dragged. This makes it so that it also works when dragged
  northernLights.add(new NorthernLights(mouseX+25, mouseY+25));
  //the location is slightly off of the mouse coordinate because the mouse blends into the black background and it can be seen better
}


class Star { //This part assigns the star as a class
  float x, y; // Position of the star
  float size; // Let's deal with the size

  Star(float x, float y) {
    this.x = x; //set the x coordinate
    this.y = y; //set the y coordinate
    this.size = random(1, 3);  // Random size for the stars as dots
  }

  void display() {
    fill(255);  // ... 255 is supposed to be opaque...
    noStroke(); //it was making the northern lights weird but this fixed the problem
    ellipse(x, y, size, size);  // Draw it as a small elippse
  }
}


class NorthernLights { //Creates a class for the northern lights
  float x, y;           // the x,y position of the northern light
  float width, height;  // Dimensions of the northern light
  color startColor, endColor;  // these colors are defined a little bit later on down below
  
  NorthernLights(float x, float y) {
    this.x = x; //set the northern light's x coordinate
    this.y = y; //set the northern light's y coordinate
    this.width = random(100, 400);  // Random width for the northern light
    this.height = random(5, 20);    // Random height (thin beams)
    
    // Random colors for the northern light...but between some different ranges since northern lights are mostly blue, purple, green, etc  
    startColor = color(random(50, 150), random(150, 255), random(100, 255), 150);
    endColor = color(random(100, 200), random(100, 255), random(100, 255), 100);
  }
  
  void display() {
    // Make the northern lights appear as horizontal rectangles
    for (float i = 0; i < width; i++) {
      float inter = map(i, 0, width, 0, 1);  // Calculate gradient transition. I needed some help with this part
      color c = lerpColor(startColor, endColor, inter); //this part assigns the color
      fill(c);
      rect(x + i - width / 2, y - height / 2, 3, height);  // Draws the rectangle for the buildings. I needed help with this since they kept floating
    }
  }
}
