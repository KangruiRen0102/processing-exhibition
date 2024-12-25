NorthernLights northernLights; // Instance of NorthernLights class
Ocean ocean;                   // Instance of Ocean class
Moon moon;                     // Instance of Moon class
Rowboat rowboat;               // Instance of Rowboat class
ArrayList<Star> stars;         // List to store stars

void setup() {
  size(800, 600);              // Set the size of the canvas
  noStroke();                  
  
  northernLights = new NorthernLights(); // Initialize NorthernLights instance
  ocean = new Ocean();                   // Initialize Ocean instance
  moon = new Moon();                     // Initialize Moon instance
  rowboat = new Rowboat();               // Initialize Rowboat instance
  stars = new ArrayList<Star>();         // Initialize the list of stars
}

void draw() {
  background(0, 0, 50);        // Set the background color to dark blue (night sky)

  northernLights.display();    // Display the northern lights
  moon.display();              // Display the moon
  ocean.display();             // Display the ocean
  rowboat.display();           // Display the rowboat with a person in it
  
  // Display stars
  for (int i = stars.size() - 1; i >= 0; i--) {
    Star star = stars.get(i);
    star.display();
    if (star.isDone()) {
      stars.remove(i);         // Remove the star when it is done flickering
    }
  }
}

void mousePressed() {
  if (mouseY < height - 100) { // Ensure the star only occurs in the sky
    stars.add(new Star(mouseX, mouseY)); // Add a new star at the mouse position
  }
}

class NorthernLights {
  float alpha;                 // Transparency level of the northern lights
  float time;                  // Time variable to animate the northern lights

  NorthernLights() {
    alpha = 100;               // Set initial transparency
    time = 0;                  // Initialize time to 0
  }

  void display() {
    time += 0.001;             // Increment time to animate

    for (float y = 100; y < height / 2; y += 30) { // Loop to create multiple horizontal bands of northern lights. 
      float greenShade = map(y, 100, height / 2, 50, 255); // Map y position to green shade intensity ranging from 50 to 255
      fill(0, greenShade, 0, alpha); // Set fill color with mapped green shade and transparency

      beginShape();            // Begin custom shape
      for (float x = 0; x < width; x++) { // Loop to create vertices along the x-axis
        float noiseFactor = noise(x * 0.01, y * 0.01, time); //Computes a noise value based on the x, y, and time variables to create a natural, wave-like effect.
        float offset = sin(noiseFactor * 2 * PI) * 50; // Use sine function to create an offeset for the vertices
        vertex(x, y + offset); // Create vertex with offset
      }
      endShape(CLOSE);         
    }
  }
}

class Ocean {
  Ocean() {}

  void display() {
    fill(0, 0, 150);           // Set fill color to dark blue for the ocean
    rect(0, height - 100, width, 100); // Draw a rectangle to represent the ocean
  }
}

class Moon {
  float x, y, radius;

  Moon() {
    x = width - 100;           // Set x, y, and radius coordinates for moon
    y = 100;                   
    radius = 50;               
  }

  void display() {
    fill(255, 255, 255, 200);  // Set colour of moon to white 
    circle(x, y, radius * 2); // Draw the moon as an circle
  }
}

class Rowboat {
  float x, y, width, height;

  Rowboat() {
    x = 400;                   // Set x and y coordinates of rowboat
    y = 500;                   
    width = 100;               // Set width and height of rowboat
    height = 20;               
  }

  void display() {
    // Draw the boat
    fill(139, 69, 19);         // Set fill color of rowboat to brown
    beginShape();              // Make basic shape for rowboat
    vertex(x - width / 2, y);   
    vertex(x + width / 2, y);  
    vertex(x + width / 2 - 10, y + height); 
    vertex(x - width / 2 + 10, y + height); 
    endShape(CLOSE);           

    // Draw boat details
    fill(160, 82, 45);         // Set fill color for rowboat details
    rect(x - width / 2 + 5, y + 5, width - 10, height / 2); // Draw details for rowboat

    // Draw a person in the boat
    float personY = y - 15;    // Set y position of the person 
    fill(255, 224, 189);       // Set fill color 
    circle(x, personY - 10, 20); // Draw the head as an circle
    fill(0);                   // Set fill color to black for the body
    rect(x - 5, personY, 10, 20); // Draw the body as a rectangle
  }
}

class Star {
  float x, y;
  int timer;                  // A timer to track how long the star has been visible
  boolean flickering;         // A boolean to determine whether the star is still flickering

// Constructor to initialize a new star with given x and y coordinates
  Star(float x, float y) {
    this.x = x;
    this.y = y;
    this.timer = 0;           // Initialize the timer to 0, indicating the star has just appeared
    this.flickering = true;   // Set the flickering status to true, meaning the star is visible and flickering
  }

  void display() {
    if (flickering) {
      fill(255);              // White color for the star
      beginShape();           // Begin custom shape for pointy star
      for (int i = 0; i < 10; i++) {
        float angle = TWO_PI / 10 * i;
        float r = (i % 2 == 0) ? 7 : 3.5; // radii for small pointy shape
        float sx = x + cos(angle) * r;
        float sy = y + sin(angle) * r;
        vertex(sx, sy);
      }
      endShape(CLOSE);
      timer++;
      if (timer > 50) {        // Star flickers for 50 frames
        flickering = false;
      }
    }
  }

  boolean isDone() {
    return !flickering;
  }
}
