float maxRadius = 600;  // Maximum radius of ripples
float speed = 3;        // Speed of ripple expansion
ArrayList<Ripple> ripples; // List to store multiple ripples
ArrayList<Flower> flowers; // List to store multiple flowers
ArrayList<ChaosShape> chaosShapes; // List for chaotic shapes
int numFlowers = 5;        // Number of flowers to draw
float angleOffset = 0;     // Petal rotation offset for animation
float minFlowerDistance = 200; // Minimum distance between flowers
float rippleInterval = 50; // Interval between spawning new ripples (milliseconds)
float lastRippleTime = 0;  // Time of the last ripple spawn
int colorStage = 0;        // Stage for color (0 = Blue, 1 = Red, 2 = Green)
float startTime;           // Time when the program starts
float redStartTime;        // Time when the red ripples start
float textAppearTime = 30000; // Time after which the text will start to appear (30 seconds)
float textAlpha = 0;       // Alpha value for the text (starts as invisible)
boolean textVisible = false; // Flag to indicate if the text should be visible
boolean chaosMode = false;  // Flag for chaos mode
float chaosStartTime;       // Time when chaos mode starts

void setup() {
  size(800, 800);  // Canvas size
  noFill();
  resetProgram(); // Initialize the program variables
}

void draw() {
  background(255);  // Clear the screen to white

  if (chaosMode) {
    // Chaos mode: Display chaotic shapes
    for (ChaosShape shape : chaosShapes) {
      shape.update();
      shape.display();
    }
    return; // Stop drawing anything else
  }

  // Draw all flowers
  for (Flower flower : flowers) {
    flower.display();
  }

  // Create ripples continuously from each flower's center
  if (millis() - lastRippleTime > rippleInterval) {
    for (Flower flower : flowers) {
      ripples.add(new Ripple(flower.x, flower.y, speed, colorStage));
    }
    lastRippleTime = millis();
  }

  // Update and draw each ripple
  for (int i = ripples.size() - 1; i >= 0; i--) {
    Ripple r = ripples.get(i);
    r.update();
    r.display();
    if (r.isOffScreen()) {
      ripples.remove(i);
    }
  }

  // Handle color transitions for ripples
  if (millis() - startTime > 5000 && colorStage == 0) {
    colorStage = 1;
    redStartTime = millis();
  }

  if (millis() - redStartTime > 5000 && colorStage == 1) {
    colorStage = 2;
  }

  // Gradually reveal the text after 30 seconds
  if (millis() - startTime > textAppearTime && !chaosMode) {
    textVisible = true;
    if (textAlpha < 255) {
      textAlpha += 1;
    }
  }

  // Display the text after it starts appearing
  if (textVisible) {
    fill(0, 0, 0, textAlpha);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("click to discover something cool", width / 2, height / 2);
  }
}

// Reset the program to its initial state
void resetProgram() {
  ripples = new ArrayList<Ripple>();  // Clear all ripples
  flowers = new ArrayList<Flower>(); // Clear all flowers
  chaosShapes = new ArrayList<ChaosShape>(); // Clear chaotic shapes
  startTime = millis();              // Reset the start time
  textAlpha = 0;
  textVisible = false;
  chaosMode = false;
  colorStage = 0;

  // Create new flowers at random positions ensuring no overlap
  for (int i = 0; i < numFlowers; i++) {
    float flowerX, flowerY;
    boolean overlaps;
    do {
      flowerX = random(width);
      flowerY = random(height);
      overlaps = false;
      for (Flower f : flowers) {
        float dist = dist(flowerX, flowerY, f.x, f.y);
        if (dist < minFlowerDistance) {
          overlaps = true;
          break;
        }
      }
    } while (overlaps);

    int flowerPetals = (int)random(5, 12); // Random number of petals for each flower
    flowers.add(new Flower(flowerX, flowerY, flowerPetals));
  }
}

// Track mouse click
void mousePressed() {
  if (!chaosMode && millis() - startTime >= 31000) {
    chaosMode = true;
    chaosStartTime = millis(); // Record chaos start time
    textVisible = false; // Hide text immediately
    generateChaos(); // Generate initial chaos shapes
  }
}

// Function to generate chaotic shapes
void generateChaos() {
  for (int i = 0; i < 100; i++) { // Generate 100 shapes
    chaosShapes.add(new ChaosShape(random(width), random(height), random(20, 100), random(20, 100)));
  }
}

// Flower class
class Flower {
  float x, y;
  int petals;

  Flower(float x, float y, int petals) {
    this.x = x;
    this.y = y;
    this.petals = petals;
  }

  void display() {
    drawFlower(x, y, 100, petals, angleOffset);
  }
}

void drawFlower(float x, float y, float radius, int petals, float angleOffset) {
  pushMatrix();
  translate(x, y);

  for (int i = 0; i < petals; i++) {
    float angle = TWO_PI / petals * i + angleOffset;
    float petalX = cos(angle) * radius;
    float petalY = sin(angle) * radius;
    drawPetal(petalX, petalY, 100, 40);
  }

  popMatrix();
}

void drawPetal(float x, float y, float w, float h) {
  pushMatrix();
  translate(x, y);
  rotate(atan2(y, x));
  noStroke();
  fill(255, 100, 100, 150);
  ellipse(0, 0, w, h);
  popMatrix();
}

// Ripple class
class Ripple {
  float x, y;
  float radius;
  float speed;
  int colorStage;

  Ripple(float x, float y, float speed, int colorStage) {
    this.x = x;
    this.y = y;
    this.radius = 0;
    this.speed = speed;
    this.colorStage = colorStage;
  }

  void update() {
    radius += speed;
  }

  void display() {
    noFill();
    if (colorStage == 0) {
      stroke(0, 100, 255, 150);
    } else if (colorStage == 1) {
      stroke(255, 0, 0, 150);
    } else if (colorStage == 2) {
      stroke(0, 255, 0, 150);
    }
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
  }

  boolean isOffScreen() {
    return radius > max(width, height) * 1.2;
  }
}

// ChaosShape class
class ChaosShape {
  float x, y; // Position
  float w, h; // Size
  float dx, dy; // Movement direction
  color col; // Random color

  ChaosShape(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.dx = random(-5, 5); // Random x-speed
    this.dy = random(-5, 5); // Random y-speed
    this.col = color(random(255), random(255), random(255), random(150, 255));
  }

  void update() {
    x += dx;
    y += dy;

    // Bounce off edges
    if (x < 0 || x > width) dx *= -1;
    if (y < 0 || y > height) dy *= -1;
  }

  void display() {
    fill(col);
    noStroke();
    int shapeType = (int)random(4); // Random shape type
    switch (shapeType) {
      case 0: ellipse(x, y, w, h); break; // Circle
      case 1: rect(x, y, w, h); break; // Rectangle
      case 2: triangle(x, y, x + w / 2, y - h, x + w, y); break; // Triangle
      case 3: line(x, y, x + w, y + h); break; // Line
    }
  }
}
