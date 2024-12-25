ArrayList<Creature> creatures;
ArrayList<PVector> flowerPositions;
ArrayList<color[]> flowerColors; // Store colors for each flower

void setup() {
  size(1000, 800); //Canvas size
  creatures = new ArrayList<Creature>();
  flowerPositions = new ArrayList<PVector>();
  flowerColors = new ArrayList<color[]>();
  
  // Draw stable flowers first
  createStableFlowers();
  
  // Create 7 initial caterpillars
  for (int i = 0; i < 7; i++) {
    creatures.add(new Caterpillar(random(width), random(height)));
  }
}

void draw() {
  background(200, 255, 200);  // Light green background
  
  // Redraw flowers with stored color
  drawStoredFlowers();
  
  // Update and display all creatures
  for (int i = creatures.size() - 1; i >= 0; i--) {
    Creature c = creatures.get(i);
    c.display();
    c.update();
  }
}

void createStableFlowers() {
  int numFlowers = 100;  // Number of flowers
  
  for (int i = 0; i < numFlowers; i++) {
    float x, y;
    boolean overlap;
    
    //Assigning random positions to flowers within the canvas
    //Preventing flower overlap, 
    // will keep making positions until all positions don't overlap using a loop
    do {
      x = random(50, width - 50); 
      y = random(50, height - 50);
      
      overlap = false;
      
      for (PVector pos : flowerPositions) {
        float distToFlower = dist(x, y, pos.x, pos.y);
        
        if (distToFlower < 50) {
          overlap = true;
          break;
        }
      }
    } while (overlap);
    
    // Store flower position to use for later
    flowerPositions.add(new PVector(x, y));
    
    // Create and store controlled random flower colors 
    color[] flowerColorSet = new color[3];
    flowerColorSet[0] = color(
      200 + random(-30, 30), 
      150 + random(-30, 30), 
      255,
      random(100, 200)
    );
    flowerColorSet[1] = color(
      255, 
      204 + random(-20, 20), 
      0
    );
    flowerColorSet[2] = color(
    255,
    192,
    203,
    random(100,200)
    );
    
    flowerColors.add(flowerColorSet);
  }
}

//Drawing flowers calling on the position's and color's previously stored
void drawStoredFlowers() {
  for (int i = 0; i < flowerPositions.size(); i++) {
    PVector pos = flowerPositions.get(i);
    color[] colors = flowerColors.get(i);
    
    // Making the petals
    fill(colors[0]);
    noStroke();

    // Draw 6 flower petals (rotated around the center)
    for (int j = 0; j < 6; j++) {
      float angle = TWO_PI / 6 * j;
      float petalX = pos.x + cos(angle) * 20;
      float petalY = pos.y + sin(angle) * 20;
      ellipse(petalX, petalY, 30, 40); // Petal size
    }

    // Flower center
    fill(colors[1]);
    ellipse(pos.x, pos.y, 20, 20);
  }
}

// Creating the mouse pressed to be able to click caterpillars into butterflies
void mousePressed() {
  // Check if any creature is clicked
  for (int i = creatures.size() - 1; i >= 0; i--) {
    Creature c = creatures.get(i);
    if (c.isClicked(mouseX, mouseY)) {
      // Replace caterpillar with butterfly
      if (c instanceof Caterpillar) {
        Butterfly butterfly = new Butterfly(c.x, c.y);
        creatures.set(i, butterfly);
        break;  // Exit after first transformation
      }
    }
  }
}

// Base class for both Caterpillar and Butterfly
abstract class Creature {
  float x, y;
  float size;
  
  Creature(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  abstract void display();
  
  void update() {
    // Creatin the catterpillar motion
    x += random(-1, 1);
    y += random(-1, 1);
    
    // Keep the caterpillars within canvas by constraining to width and heigth
    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
  }
  
  boolean isClicked(float mx, float my) {
    float distance = dist(mx, my, x, y);
    return distance < size / 2;
  }
}

// Caterpillar class withing Creature
class Caterpillar extends Creature {
  float moveSpeed = 0.2; //Making a slow speed for caterpillar
  Caterpillar(float x, float y) {
    super(x, y);
    size = 40;  // Size of caterpillar
  }
  
  // Defining color and shape of caterpillars
  void display() {
    // Caterpillar body
    fill(100, 200, 100);  // Green color
    noStroke();
    ellipse(x, y, size, size/2);
    
    // Antennae
    stroke(0);
    line(x-10, y-10, x-15, y-15);
    line(x+10, y-10, x+15, y-15);
  }
  //Making the caterpillars move slowly
  @Override
  void update(){
    x += random(-moveSpeed, moveSpeed);
    y += random(-moveSpeed, moveSpeed);
    //Constained to canvas
    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
  }
}

//Buterfly class within Creature
class Butterfly extends Creature {
  float wingAngle = 0;
  float speedX, speedY;
  
  Butterfly(float x, float y) {
    super(x, y);
    size = 60;  // Larger size for butterfly
    
    // Initialize random speeds for the butterfly flight
    speedX = random(-3,3);
    speedY = random(-3,3);
  }
  
  //Appearance of Butterfly
  void display() {
    // Animate wing movement
    wingAngle += 0.1;
    float wingOffset = sin(wingAngle) * 10;
    
    // Wings design
    fill(255, 165, 0, 200);  // Purple translucent wings
    noStroke();
    
    // Left wing
    pushMatrix();
    translate(x, y);
    rotate(radians(-20 + wingOffset));
    ellipse(-size/2, 0, size, size/2);
    popMatrix();
    
    // Right wing
    pushMatrix();
    translate(x, y);
    rotate(radians(20 - wingOffset));
    ellipse(size/2, 0, size, size/2);
    popMatrix();
    
    // Butterfly body
    fill(50);
    ellipse(x, y, 10, 30);
  }
  
  // Override update to allow flight
  @Override
  void update() {
    x += speedX;
    y += speedY;
    
    // Some random movement for butterfly
    x += sin(frameCount * 0.1) * 1;
    y += cos(frameCount * 0.1) * 1;
    
  }
}

// Creating new caterpillars through pressing key
void keyPressed() {
  if (key == 'c' || key == 'C') {
    // Create a new caterpillar at mouse position
    creatures.add(new Caterpillar(mouseX, mouseY));
  }
}
