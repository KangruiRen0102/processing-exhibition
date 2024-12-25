// Defines Flower class
class Flower { 
  float x, y; 
  color fillColor;
  float lifespan; // Lifespan in frames
  int age; // Age of the flower to define blooming
  
  Flower(float x, float y, color fillColor) {
    this.x = x; //  x coordinate of flower center
    this.y = y; // y coordinate of flower center
    this.fillColor = fillColor;
    this.lifespan = 60; // 1 second at 60 FPS
    this.age = 0; // Start at age 0
  }
  
  // General display method of flower class, so long as flower is alive
  void display() {
    if (lifespan > 0) {
      fill(fillColor, lifespan*2.125); // Fade as lifespan decreases
    }
  }
  
  // Updates the age and lifespan of the flowers
  void update() {
    float distanceToMouse = dist(x, y, mouseX, mouseY); // Distance from flower to mouse
    if (distanceToMouse > 140) { // Roughly the illuminated radius
      lifespan--; // Reduce lifespan over time
    } else if (lifespan < 60) {
      lifespan++; // Bring lifespan back up if faded flower is illuminated again
    }
    age++; // Increase age each frame
  }
  
  boolean isDead() {
    return lifespan <= 0; // Checks if the flower is dead
  }
}

// Creating a subclass of Flower, "Simple", representing a simple flower
class Simple extends Flower { 
  int petals; // Changed to int
  float size;
  color[] petalColors; // Array to store random colors for the petals
  
  // Inherets parameters from Flower class, as well as has its own parameters
  Simple(float x, float y, int petals, float size, color fillColor) {
    super(x, y, fillColor);
    this.petals = petals;
    this.size = size;
    this.petalColors = new color[petals]; // Use the integer directly
    
    // Assigns a random petal color to each flower
    for (int i = 0; i < petals; i++) {
      petalColors[i] = color(random(255), random(255), random(255)); 
    }
  }
  
  // Displays the flower
  void display() {
    if (lifespan > 0) { // Only display if still alive
      super.display();
      pushMatrix();
      translate(x, y);
      
       // Calculates the scaling factor based on age for bloom effect
      float scaleFactor = min(1.0, age / 15.0); // Fully grown after 15 frames
      scale(scaleFactor);
      
      float alpha = map(lifespan, 0, 60, 0, 255); // Map lifespan to alpha range (fully opaque at max lifespan)
      
      // Draws the petals of elliptical shape
      fill(petalColors[2], alpha); // Use pre-assigned petal colors
      for (int i = 0; i < petals; i++) {
        strokeWeight(1);
        stroke(0, alpha);
        rotate(2 * PI / petals);
        ellipse(0, size, size / (petals / 5.0), size * 2);
        line(0,0,0,size); // Petal detail
      }
      
      // Draws the center, which ades with lifespan; alpha capped at 255
      fill(255, 255, 0, alpha);
      ellipse(0, 0, size, size);
      popMatrix();
    }
  }
}

// Creating a subclass of Flower, "Pointy", representing a diamond-petalled flower
class Pointy extends Flower { 
  int petals; 
  float size;
  color[] petalColors; // Array to store random colors for petals
  
  // Inherets parameters from Flower class, as well as has its own parameters
  Pointy(float x, float y, int petals, float size, color fillColor) {
    super(x, y, fillColor);
    this.petals = petals;
    this.size = size;
    this.petalColors = new color[petals]; // Use the integer directly
    
    // Assign random petal color to each flower
    for (int i = 0; i < petals; i++) {
      petalColors[i] = color(random(255), random(255), random(255)); 
    }
  }
  
  // Displays the flower
  void display() {
    if (lifespan > 0) { // Only display if still alive
      super.display();
      pushMatrix();
      translate(x, y);
      
      // Calculate the scaling factor based on age
      float scaleFactor = min(1.0, age / 15.0); // Fully grown after 15 frames
      scale(scaleFactor);
      
      float alpha = map(lifespan, 0, 60, 0, 255); // Map lifespan to alpha range (fully opaque at max lifespan)
      
      // Draws the diamond-shaped petals
      fill(petalColors[2], alpha); // Uses pre-assigned, random petal colors
      for (int i = 0; i < petals; i++) {
        strokeWeight(1);
        stroke(0, alpha);
        rotate(2 * PI / petals);
        quad(0,0,size/(petals/2),size,0,size*2,-size/(petals/2),size); // Diamond-shaped petals
        line(0,0,0,size); // Petal detail
      }
      
      // Draws the center, which fades with lifespan; alpha capped at 255
      fill(255, 255, 0, alpha);
      ellipse(0, 0, size, size);
      popMatrix();
    }
  }
}


// Creating an array to store the flowers generated
ArrayList<Flower> flowers;

// Setting up the canvas
void setup() {
  size(1000, 800);
  imageMode(CENTER);
  flowers = new ArrayList<Flower>();
  flowers.add(new Simple(200, 200, 8, 20, 40));
  flowers.add(new Pointy(300, 300, 8, 20, 40));
}

float flowerType = 0; // Will be assigned random value to choose a flower type

// Adds a new simple flower to the array when the mouse is pressed
void mousePressed() {
  flowerType = random (10);
  // Chooses based on random value if the flower will be Simple or Pointy
    if (flowerType < 5) {
      flowers.add(new Simple(mouseX + random(-100, 100), mouseY + random(-100, 100), int(random(4,10)), 20, color(200)));
    } else {
      flowers.add(new Pointy(mouseX + random(-100, 100), mouseY + random(-100, 100), int(random(4,10)), 20, color(200)));
    }
}

// Adds a new simple flower to the array when the mouse is dragged

int lastFlowerTime = 0; // Track the last time a flower was added
int flowerInterval = 150; // Time in milliseconds between flowers


// Generates flowers when the mouse is moved
void mouseMoved() {
  if (millis() - lastFlowerTime > flowerInterval) {
    // Adds a new flower only if enough time has passed
    flowerType = random (10);
    // Chooses based on random value if the flower will be Simple or Pointy
    if (flowerType < 5) {
      flowers.add(new Simple(mouseX + random(-100, 100), mouseY + random(-100, 100), int(random(4,10)), 20, color(200)));
    } else {
      flowers.add(new Pointy(mouseX + random(-100, 100), mouseY + random(-100, 100), int(random(4,10)), 20, color(200)));
    }
    lastFlowerTime = millis(); // Updates the last flower time
  }
}

// Key bindings to control season, or rate/amount of flowers generated
void keyPressed() {
  if (key == 's') {
    flowerInterval = max(flowerInterval - 100, 25); // Decrease interval (faster rate)
  } else if (key == 'f') {
    flowerInterval = flowerInterval + 100; // Increase interval (slower rate)
  }
}

// Draws circular gradient for the flashlight effect
void drawFilledGradient(float x, float y, float radius) {
  for (float r = radius; r > 0; r--) {
    if (r < radius / 1.5) {
      fill(65,120,70); // Forest green for the inner region
    } else {
      // Set a color range from black to (65,120,70), a forest green, from the radius to the radius divided by 1.5
      float colorValue1 = map(r, radius, radius / 1.5, 0, 65);
      float colorValue2 = map(r, radius, radius / 1.5, 0, 120);
      float colorValue3 = map(r, radius, radius / 1.5, 0, 70);
      fill(colorValue1,colorValue2,colorValue3); // Set gradually changing values for the gradient
    }
    noStroke();
    ellipse(x, y, r*2, r*2); // Draws concentric circles
  }
}

// Draws the flowers
void draw() {
  background(0);
  fill(200);
  ellipse(mouseX, mouseY, 400, 400);
  // Draws a circular gradient fading to black for the flashlight effect
  drawFilledGradient(mouseX, mouseY, 200);
  clip(mouseX, mouseY, 400, 400); // Confines view of the flowers on the display screen to an area around the mouse coordinates
  
  // Update and display flowers
  for (int i = flowers.size() - 1; i >= 0; i--) { // Iterate backward to safely remove elements
    Flower flower = flowers.get(i);
    flower.update();
    flower.display();
    
    if (flower.isDead()) {
      flowers.remove(i); // Remove dead flowers
    }
  }
  noFill();
  stroke(0);
  strokeWeight(120);
  ellipse(mouseX,mouseY,500,500); // Draws thick circle over the flowers around the mouse to make the clip appear circular (for the flashlight effect)
}
