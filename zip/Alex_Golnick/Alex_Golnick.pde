// Three words: Flow, Growth, Civil and Environmental Engineering

ArrayList<BridgeSegment> bridgeSegments; // List to hold bridge segments
boolean isBridgeComplete = false;        // Indicates if the bridge is complete
ArrayList<RiverBand> riverBands;         // List representing the flowing river
ArrayList<Tree> trees;                   // List for trees along the riverbank
ArrayList<House> rightHouses;            // Houses on the right side of the river
Car car;                                 // Car on the road

void setup() {
  size(800, 600);  // frame size
  frameRate(30);  

  bridgeSegments = new ArrayList<>();
  riverBands = new ArrayList<>();
  trees = new ArrayList<>();
  rightHouses = new ArrayList<>();

  initializeRiverBands();  // Create the flowing river
  
  initializeTrees();       // Place trees along the right riverbank
  
  car = new Car(50, height / 2 - 12);  // Place a car on the road
}

void draw() {
  drawRiver();
  drawBanks();
  drawBridge();
  drawRoads();
  drawHouses();
  drawRightHouses();
  drawTrees();
  car.display();
}

void mousePressed() {
  if (!isBridgeComplete) {
    addBridgeSegment();  // Add segments to the bridge until complete
  } else {
    addRightHouse();     // Add houses once the bridge is complete
  }
}

void initializeRiverBands() {
  for (int i = 0; i < 20; i++) {
    riverBands.add(new RiverBand(
      width / 4, height - i * 30, width / 2, 30, color(0, 0, 150 + i * 5)
    ));
  }
}

void initializeTrees() {
  for (int i = 0; i < 5; i++) {
    trees.add(new Tree(
      random(3 * width / 4 + 20, width - 20), random(height - 200, height - 50)
    ));
  }
}

void addBridgeSegment() {
  int segmentWidth = 60;
  int nextX = bridgeSegments.size() * segmentWidth;

  if (width / 4 + nextX < 3 * width / 4) {
    bridgeSegments.add(new BridgeSegment(width / 4 + nextX, height / 2 - 10));
  } else {
    isBridgeComplete = true;
  }
}

void addRightHouse() {
  if (rightHouses.size() < 3) {
    float newX = random(3 * width / 4 + 20, width - 70);
    float newY = random(height / 4, height / 2 - 50);

    if (!isOverlapping(newX, newY)) {
      rightHouses.add(new House(newX, newY));
    }
  }
}

boolean isOverlapping(float newX, float newY) {        // Makes sure houses dont overlap
  for (House house : rightHouses) {
    if (dist(newX + 25, newY + 25, house.x + 25, house.y + 25) < 55) {
      return true;
    }
  }
  return false;
}

void drawRiver() {
  for (RiverBand band : riverBands) {
    band.update();
    band.display();
  }
}

void drawBanks() {
  fill(124, 252, 0); // Green for the riverbanks
  rect(0, 0, width / 4, height);
  rect(3 * width / 4, 0, width / 4, height);
}

void drawBridge() {
  for (BridgeSegment segment : bridgeSegments) {
    segment.display();
  }
}

void drawRoads() {
  fill(50, 50, 50); // Grey for the roads
  rect(0, height / 2 - 10, width / 4, 20);
  rect(3 * width / 4, height / 2 - 10, width / 4, 20);
}

void drawHouses() {            //Colour for houses
  fill(139, 69, 19); 
  rect(50, height / 3, 50, 50);
  rect(150, height / 3 + 30, 50, 50);
  fill(178, 34, 34); 
  triangle(50, height / 3, 75, height / 3 - 30, 100, height / 3);
  triangle(150, height / 3 + 30, 175, height / 3, 200, height / 3 + 30);
}

void drawRightHouses() {
  for (House house : rightHouses) {
    house.display();
  }
}

void drawTrees() {
  for (Tree tree : trees) {
    tree.display();
  }
}

class BridgeSegment {
  float x, y;
  float width = 60;
  float height = 20;

  BridgeSegment(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {             // colours for bridge
    fill(105, 105, 105); 
    rect(x, y, width, height);
    fill(70, 70, 70); 
    rect(x + width / 4, y + height, width / 2, 20);
  }
}

class RiverBand {
  float x, y, w, h;
  color c;
  float speed = 2;

  RiverBand(float x, float y, float w, float h, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
  }

  void update() {
    y -= speed;
    if (y + h < 0) {
      y = height;
    }
  }

  void display() {
    fill(c);
    rect(x, y, w, h);
  }
}

class Tree {
  float x, y;

  Tree(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {          // Colours for trees
    fill(139, 69, 19); 
    rect(x - 5, y, 10, 20);
    fill(34, 139, 34);          
    ellipse(x, y - 10, 30, 30);
  }
}

class House {
  float x, y;

  House(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(139, 69, 19);                        // brown for house 
    rect(x, y, 50, 50);
    fill(178, 34, 34);                        // Red for hous roof
    triangle(x, y, x + 25, y - 30, x + 50, y);
  }
}

class Car {
  float x, y;

  Car(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(255, 0, 0);                // Red car
    rect(x, y, 40, 20);
    fill(0);                        // Black wheels
    ellipse(x + 10, y + 20, 10, 10);
    ellipse(x + 30, y + 20, 10, 10);
  }
}
