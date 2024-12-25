// Tree Growth with Day-Night Cycle

// Growth variables
float baseX, baseY; // Position of the plant's base
float plantHeight = 0; // Current stem height
float maxPlantHeight = 200; // Maximum stem height
ArrayList<Branch> branches; // List to hold branches
Flower flower; // Flower at the top

// Day and night transition variables
float backgroundLerp = 0; // Controls day-night gradient
boolean day = true; // Day starts as true
color morningColor = color(135, 206, 250); // Morning sky color
color nightColor = color(25, 25, 112); // Night sky color

// Clouds and stars
PVector[] clouds;
PVector[] stars;

// Progression flags
boolean growingTree = false; // Whether tree is growing
boolean flowerBloomed = false; // Whether flower has bloomed

void setup() {
  size(800, 600); // Canvas size
  baseX = width / 2; // X center
  baseY = height; // Bottom of the canvas
  branches = new ArrayList<Branch>(); // Initialize branches
  clouds = createClouds(5); // Create 5 clouds
  stars = createStars(50); // Create 50 stars
  noStroke(); // Disable strokes for cleaner visuals
}

void draw() {
  // Day-night transition logic
  if (day) {
    backgroundLerp += 0.005;
    if (backgroundLerp >= 1) {
      backgroundLerp = 1;
      day = false; // Switch to night
    }
  } else {
    backgroundLerp -= 0.005;
    if (backgroundLerp <= 0) {
      backgroundLerp = 0;
      day = true; // Switch to day
    }
  }
  background(lerpColor(morningColor, nightColor, backgroundLerp)); // Sky color

  // Day or night-specific elements
  if (backgroundLerp < 0.5) {
    drawSun();
    drawClouds();
  } else {
    drawMoon();
    drawStars();
  }

  // Draw the tree trunk as it grows
  if (plantHeight < maxPlantHeight) {
    fill(0, 255, 0); // Green stem for growing trunk
    rect(baseX - 5, baseY - plantHeight, 10, plantHeight);
    plantHeight += 0.5; // Gradual growth
  } else {
    fill(139, 69, 19); // Brown for grown trunk
    rect(baseX - 5, baseY - maxPlantHeight, 10, maxPlantHeight);
    if (!growingTree) {
      growingTree = true;
      growTree(); // Start branch growth
    }
  }

  // Draw and update branches
  for (Branch b : branches) {
    b.update();
    b.display();
  }

  // Display the flower if it has bloomed
  if (flowerBloomed && flower != null) {
    flower.update();
    flower.display();
  }
}

// Create cloud positions
PVector[] createClouds(int numClouds) {
  PVector[] cloudPositions = new PVector[numClouds];
  for (int i = 0; i < numClouds; i++) {
    cloudPositions[i] = new PVector(random(width), random(height / 3));
  }
  return cloudPositions;
}

// Draw clouds
void drawClouds() {
  fill(255, 255, 255, 200);
  for (PVector cloud : clouds) {
    ellipse(cloud.x, cloud.y, 80, 50);
    ellipse(cloud.x + 30, cloud.y - 10, 60, 40);
    ellipse(cloud.x - 30, cloud.y - 10, 60, 40);
  }
}

// Draw the sun
void drawSun() {
  fill(255, 223, 0);
  ellipse(width / 4, height / 6, 80, 80);
}

// Create star positions
PVector[] createStars(int numStars) {
  PVector[] starPositions = new PVector[numStars];
  for (int i = 0; i < numStars; i++) {
    starPositions[i] = new PVector(random(width), random(height / 2));
  }
  return starPositions;
}

// Draw stars
void drawStars() {
  fill(255, 255, 255, 200);
  for (PVector star : stars) {
    ellipse(star.x, star.y, 3, 3);
  }
}

// Draw the moon
void drawMoon() {
  fill(245, 245, 245);
  ellipse(width / 1.5f, height / 6, 60, 60);
  fill(nightColor);
  ellipse(width / 1.5f + 10, height / 6, 60, 60);
}

// Start tree growth
void growTree() {
  for (int i = 0; i < 64; i++) { // Increase branches for a fuller look
    float angle = map(i, 0, 63, -PI, PI); // Spread branches to fill gaps
    branches.add(new Branch(baseX, baseY - maxPlantHeight, angle, random(50, 150), color(139, 69, 19)));
  }
  bloomFlower();
}

// Bloom flower at the top
void bloomFlower() {
  flowerBloomed = true;
  flower = new Flower(baseX, baseY - maxPlantHeight - 30, 10, color(255, 192, 203)); // Smaller flower
}

// Branch class for drawing and updating branches
class Branch {
  float x, y, angle, length;
  color branchColor;
  float growth = 0; // Progress of branch growth

  Branch(float x, float y, float angle, float length, color branchColor) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.length = length;
    this.branchColor = branchColor;
  }

  void update() {
    if (growth < 1) growth += 0.01; // Gradually grow the branch
  }

  void display() {
    float endX = x + cos(angle) * length * growth;
    float endY = y + sin(angle) * length * growth;
    stroke(branchColor);
    line(x, y, endX, endY);

    // Add more leaves at the ends of fully grown branches
    if (growth >= 1) {
      fill(0, 128, 0);
      for (int i = 0; i < 10; i++) { // Add even more leaves around the branch ends
        float leafAngle = angle + random(-PI / 6, PI / 6);
        float leafX = endX + cos(leafAngle) * random(10, 20);
        float leafY = endY + sin(leafAngle) * random(10, 20);
        ellipse(leafX, leafY, random(10, 15), random(10, 15));
      }
    }
  }
}

// Flower class for creating and displaying the flower
class Flower {
  float x, y, size;
  color petalColor;
  float bloomSize = 0; // Current bloom size

  Flower(float x, float y, float size, color petalColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.petalColor = petalColor;
  }

  void update() {
    if (bloomSize < size) bloomSize += 0.2; // Gradual blooming
  }

  void display() {
    fill(petalColor);
    for (int i = 0; i < 8; i++) { // Draw 8 petals
      float angle = TWO_PI / 8 * i;
      ellipse(x + cos(angle) * bloomSize, y + sin(angle) * bloomSize, bloomSize, bloomSize);
    }
    fill(255, 204, 0); // Yellow center of the flower
    ellipse(x, y, bloomSize / 2, bloomSize / 2);
  }
}
