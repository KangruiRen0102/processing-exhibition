//Create ArrayLists to hold the ripples and circles
ArrayList<Ripple> ripples;
ArrayList<Circle> circles;


//Background wave parameters
float waveHeight = 20; //Height of the waves
float waveFrequency = 0.05; //Frequency of the waves


//Making the background of the drawing
void setup() {
  size(800, 600); // Set the size of the window
  background(130, 213, 232); // blue color for the background of the drawing
  
  //Initialize the ripples and circles ArrayLists
  ripples = new ArrayList<Ripple>();
  circles = new ArrayList<Circle>();
}


//defining variables temporarily until they can be defined further later on in the code
int maxRadius = 50;
float circleX = 1;
float circleY = 1;
float circleRadius = 5;


//Mouse Click
void mousePressed() {
  circleX = mouseX; //Set circle's X position to mouse's X position
  circleY = mouseY; //Set circle's Y position to mouse's Y position
  circleRadius = random(5, 100); //Set radius to a random value between 5 and 100
  
  //Add a new circle to the circles ArrayList
  circles.add(new Circle(circleX, circleY, circleRadius));
  
  //Create a ripple at the mouse position when the mouse is pressed
  ripples.add(new Ripple(mouseX, mouseY));
}


void draw() {
  
  //Draw the background waves
  drawWaves();
  
  //Draw each circle in the circles ArrayList
  //Counter that keeps track of the number of circles and will continue drawing them as long as the number is less than the length of the list.
  //Updates the list when each circle is drawn.
  for (int i = 0; i < circles.size(); i++) { 
    Circle c = circles.get(i);
    fill(255); //Set fill color to white
    ellipse(c.x, c.y, c.radius*2, c.radius*2); //Draw the circle
  }
  
  //Update and display each ripple
  for (int i = ripples.size() - 1; i >= 0; i--) {
    Ripple ripple = ripples.get(i); //Gets the ripple from index i in the loop
    ripple.update(); //Makes the ripple's radius increase and fade over time
    ripple.display(); //Draws the ripple
    
    // Remove ripple if it's completely faded
    if (ripple.alpha <= 0) { //alpha determines the opacity of the ripple, so if it is <0 then it has no opacity and is not visible
      ripples.remove(i); //Remove the index i from the page when the ripple is no longer visible
    }
  }
}

//Draw dark blue waves in the background
void drawWaves() {
  noFill();
  stroke(0,0,139); //Dark blue color for the line
  strokeWeight(2); //Lineweight for the wave lines
  
  float offset = 0; //Offset for wave movement
  
  //Loop to draw multiple waves on the screen
  for (int y = 100; y < height; y += 30) { //Sine wave equation for smooth curves
    beginShape();
    for (float x = 0; x <= width; x++) {
      float wave = sin(x*waveFrequency + offset) * waveHeight; //Sine wave equation for smooth curves
      
      //Making sure the wave stays within reasonable vertical bounds
      float clampedWave = constrain(wave, -waveHeight, waveHeight);
      
      vertex(x, y + clampedWave); //Set the vertex of the wave at each point
      
    }
    endShape();
  }
}


//Circle class to store information about each circle
class Circle { //Creating the class
  float x, y; //Position of the circle
  float radius; //Radius of the circle
  
  Circle(float x, float y, float radius) { //Constructor for the circle class
  //Setting the object's position and size
    this.x = x; 
    this.y = y;
    this.radius = radius;
  }
}

// Ripple class to manage individual ripples
class Ripple {
  float x, y;    // Position of the ripple
  float radius;  // Radius of the ripple
  float alpha;   // Alpha value for fading
  
  Ripple(float x, float y) { //Constructor for the ripple class
  //Setting the ripple's position,size, and the way it fades as the radius increases
    this.x = x;
    this.y = y;
    this.radius = circleRadius; // Initial radius
    this.alpha = 600; // Initial alpha value
  }
  
  // Update the ripple's size and alpha
  void update() {
    radius += 2; // Increase the radius over time
    alpha -= 5;  // Decrease the alpha for fading
  }
  
  // Display the ripple
  void display() {
    noFill();
    stroke(255, alpha); // Set stroke color with alpha for fading effect
    strokeWeight(0.5); // Set the stroke weight
    ellipse(x, y, radius, radius); // Draw the ellipse
  }
}
