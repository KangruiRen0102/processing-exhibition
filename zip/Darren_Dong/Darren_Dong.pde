ArrayList<Stem> stems; // List to hold all stems
ArrayList<Stem> activeStems; // List to hold stems eligible for branching
int maxStems = 12000; // Maximum number of stems
float globalRotation = 0; // Global rotation angle
float rotationSpeed = 0.0005; // Speed of the global rotation
float baseSize = 150; // Initial size for the first square
color bgColor = generateRandomPastelColor();

boolean firstClick = true; // Flag to check if it's the first click

class Stem {
  float xPos;
  float yPos;
  float size; // Size of the square
  int gen; // Generation of this stem
  float angle; // Fixed branching angle
  float rotation; // Unique rotation angle for the stem
  color stemColor; // Color of this stem

  Stem(float x, float y, int gen, float angle, color parentColor) {
    this.xPos = x;
    this.yPos = y;
    this.gen = gen;
    this.size = baseSize / pow(1.7, gen); // Size decreases with generation
    this.angle = angle; // Fixed branching angle
    this.rotation = random(-PI, PI); // Random rotation for each square

    // Slightly modify the parent color to create a new color
    float offset = 15;
    float r = red(parentColor) + random(-offset, offset);
    float g = green(parentColor) + random(-offset, offset);
    float b = blue(parentColor) + random(-offset, offset);
    this.stemColor = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }

  void render() {
    pushMatrix();
    translate(xPos, yPos); // Move to the stem's position
    rotate(rotation); // Apply individual rotation
    fill(stemColor);
    rect(0, 0, size, size); // Render as a square
    popMatrix();
  }

  // Calculate new positions for branches
  ArrayList<Stem> branch() {
    ArrayList<Stem> newStems = new ArrayList<Stem>();
    int numBranches = (int) random(0, 4); // Spawn between 0 and 3 new stems
    float offset = size * 1.3; // Distance to next square's position

    for (int i = 0; i < numBranches; i++) {
      // Ensure branches point outward from the center
      float outwardAngle = atan2(yPos - height / 2, xPos - width / 2); // Angle pointing outward from center
      float newAngle = outwardAngle + random(-PI / 3, PI / 3); // Add some variation to the angle

      // Calculate the new position for the branch
      float newX = xPos + cos(newAngle) * offset;
      float newY = yPos + sin(newAngle) * offset;

      // Pass the current stem's color to the new stem
      newStems.add(new Stem(newX, newY, gen + 1, newAngle, stemColor));
    }

    // If no branches are created, this stem will stay active
    if (newStems.isEmpty()) {
      newStems.add(this); // Add the current stem back to remain active
    }

    return newStems;
  }
}

void setup() {
  size(1000, 1000); 
  noStroke();
  rectMode(CENTER);
  stems = new ArrayList<Stem>();
  activeStems = new ArrayList<Stem>();

  // Generate a random pastel color for the first stem
  // color pastelColor = generateRandomPastelColor();

  // Start with a single initial stem at the center
  Stem initialStem = new Stem(width / 2, height / 2, 0, 0, bgColor);
  stems.add(initialStem);
  activeStems.add(initialStem);
}

void draw() {
  background(darkenColor(bgColor));

  // Apply global rotation
  pushMatrix();
  translate(width / 2, height / 2); // Set rotation center
  rotate(globalRotation);
  translate(-width / 2, -height / 2); // Reset the translation to normal coordinates

  // Render all stems
  for (Stem stem : stems) {
    stem.render();
  }

  popMatrix();

  // Increment global rotation
  globalRotation += rotationSpeed;
}

void mousePressed() {
  if (firstClick) {
    // On first click, generate between 4 and 13 evenly spaced branches
    int numBranches = (int) random(4, 14); // Between 4 and 13 branches
    float angleIncrement = TWO_PI / numBranches; // Evenly spaced angles around the initial stem
    ArrayList<Stem> newStems = new ArrayList<Stem>();

    // Create evenly spaced branches from the center stem
    for (int i = 0; i < numBranches; i++) {
      float angle = angleIncrement * i; // Evenly spaced angle
      float newX = width / 2 + cos(angle) * baseSize; // Position each branch at an angle
      float newY = height / 2 + sin(angle) * baseSize;
      newStems.add(new Stem(newX, newY, 1, angle, stems.get(0).stemColor)); // Use initial stem's color
    }

    // Add the new stems to the main list
    stems.addAll(newStems);
    activeStems = newStems; // Update active stems to the newly created stems

    // After first click, set flag to false to avoid spawning new branches evenly spaced
    firstClick = false;
  } else {
    // Only spawn new stems if the total number of stems is less than maxStems
    if (stems.size() < maxStems) {
      ArrayList<Stem> newStems = new ArrayList<Stem>();

      for (Stem stem : activeStems) {
        newStems.addAll(stem.branch());
      }

      stems.addAll(newStems); // Add the new stems to the global list
      activeStems = newStems; // Update active stems
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    // Reset the scene back to the initial state
    stems.clear(); // Clear all stems
    activeStems.clear(); // Clear active stems

    // Generate a random pastel color for the first stem
    color pastelColor = generateRandomPastelColor();
    bgColor = darkenColor(pastelColor);

    // Start with the initial stem at the center
    Stem initialStem = new Stem(width / 2, height / 2, 0, 0, pastelColor);
    stems.add(initialStem);
    activeStems.add(initialStem);

    // Reset flags and rotation
    firstClick = true;
    globalRotation = 0;
  }
}

// Function to generate a random pastel color
color generateRandomPastelColor() {
  float r = random(128, 255); // Bright random red
  float g = random(128, 255); // Bright random green
  float b = random(128, 255); // Bright random blue
  return color(r, g, b); // Return the pastel color
}

// Function to darken a color
color darkenColor(color squareColor) {
    float offset = 50;
    float r = red(squareColor) - offset;
    float g = green(squareColor) - offset;
    float b = blue(squareColor) - offset;
    return color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
}
