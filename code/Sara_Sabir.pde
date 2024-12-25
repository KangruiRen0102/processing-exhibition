// Constants for the window size and colors
final int WINDOW_WIDTH = 800;  // Width of the window
final int WINDOW_HEIGHT = 600; // Height of the window
final color DAY_SKY_COLOR = color(200, 255, 255);  // Daytime sky color (light blue)
final color NIGHT_SKY_COLOR = color(25, 25, 50);  // Nighttime sky color (dark blue)
final int GROUND_HEIGHT = 100;  // Height of the ground from the bottom of the window

// Lists to hold objects of grass, flowers, birds, and trees
ArrayList<Grass> grassBlades; 
ArrayList<Flower> flowers;
ArrayList<Bird> birds;
ArrayList<Tree> trees;
Sun sun; // Sun object, will control the sunlight and its intensity

// Variables for tracking time of day and weather
float dayTime = 0; // Variable to track the time of day (0 to 2*PI)
float sunlightIntensity = 0;  // Intensity of sunlight affecting plant growth
int treeCount = 4;  // Number of trees in the scene
boolean isNight = false;  // Flag to track whether it's night time or not

// Setup function: initializes the scene elements
void setup() {
  size(800, 600);  // Set window size
  colorMode(HSB, 360, 100, 100);  // Use HSB color mode for easy color manipulation

  // Initialize the lists
  grassBlades = new ArrayList<Grass>();
  flowers = new ArrayList<Flower>();
  birds = new ArrayList<Bird>();
  trees = new ArrayList<Tree>();

  // Generate a bunch of grass blades with random positions
  for (int i = 0; i < 2000; i++) {
    grassBlades.add(new Grass(random(width), height - GROUND_HEIGHT + random(10)));
  }

  sun = new Sun(100, 100, 40);  // Initialize the sun with a starting position and radius

  // Generate a few flowers at random positions
  for (int i = 0; i < 5; i++) {
    flowers.add(new Flower(random(width), height - GROUND_HEIGHT));
  }

  // Calculate the spacing between trees and place them accordingly
  float spaceBetweenTrees = width / (float)(treeCount + 1);
  for (int i = 0; i < treeCount; i++) {
    float treeX = (i + 1) * spaceBetweenTrees; // Evenly distribute trees across the width
    trees.add(new Tree(treeX, height - GROUND_HEIGHT, 100, 0.2)); // Add tree object
  }

  initializeFlowers();  // Initializes and sorts flowers to ensure proper placement
}

// Main draw function: continuously updates the scene
void draw() {
  dayTime += 0.01;  // Increment the time of day
  updateWeather();  // Update weather (sunlight intensity based on time of day)

  // Set the background color based on whether it's day or night
  background(isNight ? NIGHT_SKY_COLOR : DAY_SKY_COLOR);
  
  sun.update();  // Update the sun's position
  if (!isNight) {
    sun.display();  // Display the sun if it's daytime
  }

  // Draw the ground
  fill(34, 51, 51);
  noStroke();
  rect(0, height - GROUND_HEIGHT, width, GROUND_HEIGHT); // Ground rectangle

  // Draw each blade of grass, grow and display based on sunlight intensity
  for (Grass blade : grassBlades) {
    blade.grow(sunlightIntensity);  // Adjust growth based on sunlight
    blade.display();  // Display the grass
  }

  // Draw flowers, grow and display based on sunlight intensity
  for (Flower flower : flowers) {
    flower.grow(sunlightIntensity);  // Grow flowers depending on sunlight
    flower.display();  // Display the flower
  }

  // Draw and update each bird in the scene
  for (Bird bird : birds) {
    bird.update();  // Update bird position and movement
    bird.display();  // Display the bird
  }

  // Draw trees, grow and display based on sunlight intensity
  for (Tree tree : trees) {
    tree.grow(sunlightIntensity);  // Grow the tree based on sunlight
    tree.display();  // Display the tree
  }
}

// Updates the weather by calculating sunlight intensity from the sun's position
void updateWeather() {
  sunlightIntensity = sun.calculateIntensity();  // Calculate sunlight intensity based on sun's angle
}

// Initializes flowers and arranges them evenly across the screen
void initializeFlowers() {
  int maxFlowers = 15;  // Maximum number of flowers
  float spaceBetweenFlowers = width / (float)(maxFlowers + 1); // Evenly space flowers
  ArrayList<Flower> sortedFlowers = new ArrayList<Flower>();

  // Create flowers and add them to the list
  for (int i = 0; i < maxFlowers; i++) {
    float flowerX = (i + 1) * spaceBetweenFlowers;  // Calculate flower's x position
    sortedFlowers.add(new Flower(flowerX, height - GROUND_HEIGHT));  // Add flower to the list
  }

  // Sort the flowers based on their x position to ensure no overlap
  sortedFlowers.sort((f1, f2) -> Float.compare(f1.x, f2.x));

  flowers = sortedFlowers;  // Update the flowers list with sorted flowers
}

// Toggles day and night when the spacebar is pressed
void keyPressed() {
  if (key == ' ') {  // Check if spacebar is pressed
    isNight = !isNight;  // Toggle between day and night
    sun.update();  // Update sun's position for the new time of day
    if (!isNight) {
      sun.display();  // Display the sun during daytime
    }
  }
}

// Adds a bird to the scene when mouse is pressed
void mousePressed() {
  birds.add(new Bird(0, height - GROUND_HEIGHT - 20));  // Add a new bird at the bottom of the screen
}

// Sun class to manage the sun's position, display, and light intensity
class Sun {
  float x, y, radius;
  float angle = 0;  // Angle of the sun, used to track its movement across the sky

  // Constructor for Sun, initializes its position and size
  Sun(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }

  // Updates the sun's position based on time of day
  void update() {
    angle = (dayTime % TWO_PI);  // Loop angle between 0 and 2*PI (full rotation)
    x = width / 2 + cos(angle) * (width / 2 - radius);  // Calculate x position based on angle
    y = height / 2 + sin(angle) * (height / 2 - radius);  // Calculate y position based on angle
  }

  // Displays the sun and its rays
  void display() {
    noStroke();  // No outline for the sun
    fill(50, 80, 100);  // Set sun's color
    circle(x, y, radius * 2);  // Draw the sun as a circle

    stroke(50, 60, 100, 50);  // Set the color and transparency for sun rays
    for (float a = 0; a < TWO_PI; a += PI / 8) {  // Draw rays emanating from the sun
      float rayLength = radius * 1.5;
      line(x, y, x + cos(a) * rayLength, y + sin(a) * rayLength);
    }
  }

  // Calculates the sunlight intensity based on the sun's position
  float calculateIntensity() {
    return map(sin(angle), -1, 1, 0.2, 1.0);  // Map sun's angle to light intensity (morning/evening dim, midday bright)
  }
}

// Grass class to manage individual grass blades
class Grass {
  float x, y, height;
  float maxHeight;  // Maximum possible height of the grass blade
  float growthRate;  // Rate of growth for the grass
  color col;  // Color of the grass blade

  // Constructor to initialize grass position and properties
  Grass(float x, float y) {
    this.x = x;
    this.y = y;
    this.height = random(5, 8);  // Initial height of the grass blade
    this.maxHeight = random(30, 30);  // Set maximum height for the blade
    this.growthRate = random(0.1, 0.4);  // Set random growth rate
    this.col = color(random(85, 95), random(70, 90), random(40, 60));  // Random color for the grass
  }

  // Function to grow the grass blade based on sunlight intensity
  void grow(float sunlight) {
    if (height < maxHeight) {
      height += growthRate * sunlight;  // Increase height by growth rate scaled by sunlight
    }
  }

  // Function to display the grass blade
  void display() {
    stroke(col);  // Set the color for the grass blade
    strokeWeight(1);  // Set the stroke thickness
    float swayAmount = sin(x * 0.1 + dayTime) * 2;  // Calculate sway effect based on time
    line(x, y, x + swayAmount, y - height);  // Draw the grass blade with sway effect
  }
}

// Flower class to manage individual flowers
class Flower {
  float x, baseY;  // Position of the flower (x is the horizontal position, baseY is the ground level)
  float stemHeight;  // Height of the flower's stem
  float size;  // Size of the flower petals
  float growthStage;  // Growth stage of the flower, from 0 (seed) to 1 (fully grown)
  color petalColor;  // Color of the flower petals

  // Constructor to initialize the flower's position and properties
  Flower(float x, float baseY) {
    this.x = x;
    this.baseY = baseY;
    this.stemHeight = 0;  // Initially, the stem is not grown
    this.size = 0;  // Initially, the flower has no petals
    this.growthStage = 0;  // The flower starts at stage 0
    this.petalColor = color(random(360), 80, 90);  // Random color for the flower petals
  }

  // Function to grow the flower based on sunlight intensity
  void grow(float sunlight) {
    if (growthStage < 1) {  // The flower will keep growing until it reaches full size
      growthStage += 0.002 * sunlight;  // Growth speed is affected by sunlight intensity
      stemHeight = map(growthStage, 0, 1, 0, 40);  // Map the growth stage to the stem height
      size = map(growthStage, 0.3, 1, 0, 20);  // Map the growth stage to the petal size
      size = max(size, 0);  // Prevent the size from being negative
    }
  }

  // Function to display the flower
  void display() {
    pushMatrix();  // Save the current transformation matrix
    translate(x, baseY);  // Move the drawing origin to the flower's position

    // Draw the stem
    stroke(120, 80, 40);  // Set stem color (brown)
    strokeWeight(2);  // Set stroke weight for the stem
    line(0, 0, 0, -stemHeight);  // Draw the stem

    // Draw the petals if the flower has reached a certain growth stage
    if (growthStage > 0.3) {
      translate(0, -stemHeight);  // Move to the top of the stem

      noStroke();  // Remove stroke for petals
      for (float angle = 0; angle < TWO_PI; angle += PI / 6) {  // Draw 6 petals in a circular pattern
        fill(petalColor);  // Set the petal color
        pushMatrix();  // Save the current transformation
        rotate(angle);  // Rotate for each petal
        ellipse(size / 2, 0, size, size / 2);  // Draw each petal as an ellipse
        popMatrix();  // Restore transformation
      }

      // Draw the center of the flower
      fill(50, 90, 90);  // Set color for the center of the flower
      circle(0, 0, size / 3);  // Draw the center
    }

    popMatrix();  // Restore the original transformation matrix
  }
}

// Bird class to manage the behavior of birds in the scene
class Bird {
  float x, y, speedX, speedY;  // Position and speed of the bird
  color birdColor;  // Color of the bird

  // Constructor to initialize bird's position and random movement
  Bird(float startX, float startY) {
    x = startX;
    y = startY;
    speedX = random(1, 2);  // Random horizontal speed
    speedY = random(-0.5, 0.5);  // Random vertical speed
    birdColor = color(0, 0, 0);  // Set the bird's color (black)
  }

  // Update the bird's position
  void update() {
    x += speedX;  // Move the bird horizontally
    y += speedY;  // Move the bird vertically

    // Prevent the bird from going too far up or down
    if (y < 10) y = 10;
    if (y > 150) y = 150;
  }

  // Display the bird
  void display() {
    fill(birdColor);  // Set bird color
    noStroke();  // Remove outline for bird

    float bodyBaseHeight = 10;  // Size of the bird's body (base)
    float bodyTipHeight = 10;   // Size of the bird's body (tip)

    // Draw the body of the bird
    beginShape();
    vertex(x, y);
    vertex(x - bodyBaseHeight, y + bodyTipHeight);
    vertex(x + bodyBaseHeight, y + bodyTipHeight);
    endShape(CLOSE);

    // Calculate the center of the bird's body for wing position
    float bodyCenterX = x;
    float bodyCenterY = y + (bodyTipHeight / 2);

    // Calculate wing offset based on time (swaying effect)
    float wingOffset = sin(frameCount * 0.2) * 5;

    // Draw the wings
    stroke(birdColor);  // Set the wing color
    strokeWeight(3);  // Set stroke weight for wings
    noFill();  // No fill for the wings

    beginShape();
    vertex(bodyCenterX, bodyCenterY);
    bezierVertex(bodyCenterX - 15, bodyCenterY - 10 + wingOffset, bodyCenterX - 25, bodyCenterY - 20 + wingOffset, bodyCenterX - 30, bodyCenterY - 10);  // Left wing
    endShape();

    beginShape();
    vertex(bodyCenterX, bodyCenterY);
    bezierVertex(bodyCenterX + 15, bodyCenterY - 10 + wingOffset, bodyCenterX + 25, bodyCenterY - 20 + wingOffset, bodyCenterX + 30, bodyCenterY - 10);  // Right wing
    endShape();
  }
}

// Tree class to manage the tree structure
class Tree {
  float x, baseY, height, maxHeight, growthRate;  // Tree position and size properties
  int foliageLayers;  // Number of layers of foliage (leaves)

  // Constructor to initialize tree properties
  Tree(float x, float baseY, float maxHeight, float growthRate) {
    this.x = x;
    this.baseY = baseY;
    this.height = 0;  // Tree starts at height 0
    this.maxHeight = maxHeight;  // Set maximum tree height
    this.growthRate = growthRate;  // Set tree growth rate
    this.foliageLayers = 3;  // Set number of foliage layers (levels of leaves)
  }

  // Grow the tree based on sunlight intensity
  void grow(float sunlight) {
    if (height < maxHeight * 0.8) {  // Limit tree height to 80% of max height
      height += growthRate * sunlight;  // Increase height based on sunlight
    }
  }

  // Display the tree on the screen
  void display() {
    fill(139, 69, 19);  // Set the color for the tree trunk (brown)
    rect(x - 10, baseY - height, 20, height);  // Draw the tree trunk as a rectangle

    // Draw foliage (leaves) in layers
    fill(34, 139, 34);  // Set the color for the leaves (green)
    float layerHeight = height / foliageLayers;  // Height of each foliage layer
    for (int i = 0; i < foliageLayers; i++) {
      float topY = baseY - height - (layerHeight * i);  // Position of each foliage layer
      if (i * 5 < 25) {  // Limit the size of foliage at higher levels
        triangle(  // Draw a triangle to represent foliage
          x - 40 - (i * 3),
          topY,
          x + 40 + (i * 3),
          topY,
          x,
          topY - 50
        );
      }
    }
  }
}
