int maxDepth = 4; // Original recursion depth
float angle;      // Branch angle, control the angle the branch growth at
float growth = 0; // Control the growth factor (0 to 1)
boolean growing = false; // To track whether the tree is growing or withering
boolean raining = false; // To track whether it's raining
boolean dustStorm = false; // To track whether the dust storm is active
ArrayList<Raindrop> raindrops = new ArrayList<Raindrop>(); // List of raindrops
ArrayList<DustParticle> dustParticles = new ArrayList<DustParticle>(); // List of dust particles

void setup() {
  size(800, 800);
  frameRate(60); // The standard frame rate
}

void draw() {
  background(30, 30, 40); // Dark background
  
  // Draw the hill at the bottom of the screen
  drawHill();
  
  // Draw the rain if it is raining
  if (raining) {
    for (Raindrop r : raindrops) {
      r.update();
      r.display();
    }
  }
  
  // Draw the dust storm if it is active (withering)
  if (dustStorm) {
    for (DustParticle d : dustParticles) {
      d.update();
      d.display();
    }
  }

  translate(width / 2, height - 50); // Start at the bottom center, above the hill
  stroke(255); // White branches
  angle = map(growth, 0, 1, 15, 45); // Adjust angle dynamically
  drawBranch(height / 4, 0); // Start drawing the tree
  
  // Ensure growth stays between 0 and 1
  growth = constrain(growth, 0, 1);
}

void drawHill() {
  noStroke();
  
  // Change hill color to brown when the tree is withering
  if (!growing) {
    fill(139, 69, 19); // Brown color for the hill when withering
  } else {
    fill(34, 139, 34); // Green color for the hill during growth
  }

  beginShape();
  vertex(0, height); // Start at the bottom left
  bezierVertex(width / 4, height - 100, 3 * width / 4, height - 100, width, height); // Curve for the hill
  vertex(width, height); // End at the bottom right
  endShape(CLOSE);
}

void drawBranch(float len, int depth) {
  if (depth > maxDepth || len < 2) return;

  // Adjust branch length based on growth factor
  float adjustedLen = len * growth;

  // Branch color logic: brown during growth, gray during withering
  color branchColor;
  if (growing) {
    branchColor = color(139, 69, 19); // Brown during growth
  } else {
    branchColor = color(128, 128, 128); // Gray during withering
  }
  stroke(branchColor);
  strokeWeight(map(depth, 0, maxDepth, 8, 1)); // Thicker base, thinner tips
  
  line(0, 0, 0, -adjustedLen); // Draw the branch
  translate(0, -adjustedLen); // Move to the end of the branch

  // Dynamic branching based on growth
  int branchCount = (int)map(growth, 0, 1, 1, 4); // Increase branches as the tree grows
  float angleOffset = angle / branchCount;

  for (int i = 0; i < branchCount; i++) {
    // Right side branches
    pushMatrix();
    rotate(radians(i * angleOffset));
    drawBranch(len * 0.7, depth + 1);
    popMatrix();
    
    // Left side branches
    pushMatrix();
    rotate(-radians(i * angleOffset));
    drawBranch(len * 0.7, depth + 1);
    popMatrix();
  }
  
  // Simulate leaves
  if (depth == maxDepth && growth > 0.5) {
    // Leaf color logic: green during growth, orange during withering
    color leafColor;
    if (growing) {
      leafColor = color(34, 139, 34); // Green during growth
    } else {
      leafColor = color(255, 165, 0); // Orange during withering
    }
    fill(leafColor);
    noStroke();
    ellipse(0, 0, 10 * growth, 10 * growth); // Leaf size grows with `growth`
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    growing = true; // Set growing state
    growth += 0.01; // Increase growth
    raining = true; // Start raining
    dustStorm = false; // Stop dust storm if growing
    // Add new raindrops when 'w' is pressed
    for (int i = 0; i < 10; i++) {
      raindrops.add(new Raindrop(random(width), random(-100, -500)));
    }
  } else if (key == 's' || key == 'S') {
    growing = false; // Set withering state
    growth -= 0.01; // Decrease growth
    raining = false; // Stop raining
    dustStorm = true; // Start dust storm when withering
    raindrops.clear(); // Clear raindrops when rain stops
    // Add new dust particles when 'S' is pressed
    for (int i = 0; i < 10; i++) {
      dustParticles.add(new DustParticle(random(width), random(height)));
    }
  }
}

// Raindrop class to simulate rain
class Raindrop {
  float x, y; // Position of the raindrop
  float speed; // Speed of the raindrop
  float size;  // Size of the raindrop
  
  Raindrop(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = random(3, 7); // Random speed for each raindrop
    this.size = random(2, 6);  // Random size for each raindrop
  }
  
  // Update the raindrop position
  void update() {
    y += speed; // Raindrop falls down
    if (y > height) {
      y = random(-100, -500); // Reset raindrop to top if it falls off screen
    }
  }
  
  // Display the raindrop
  void display() {
    noStroke();
    fill(0, 0, 255, 150); // Blue color with some transparency
    ellipse(x, y, size, size * 2); // Ellipse for raindrop shape
  }
}

// DustParticle class to simulate dust storm
class DustParticle {
  float x, y; // Position of the dust particle
  float speed; // Speed of the dust particle
  float size;  // Size of the dust particle
  
  DustParticle(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = random(1, 3); // Random speed for each dust particle
    this.size = random(3, 8);  // Random size for each dust particle
  }
  
  // Update the dust particle position
  void update() {
    x += speed; // Dust particle moves to the right
    if (x > width) {
      x = 0; // Reset dust particle to left side if it moves off screen
    }
  }
  
  // Display the dust particle
  void display() {
    noStroke();
    fill(139, 69, 19, 100); // Brown color with transparency for dust
    ellipse(x, y, size, size); // Ellipse for dust particle shape
  }
}
