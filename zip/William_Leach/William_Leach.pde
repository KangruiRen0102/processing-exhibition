MorphingCreature creature;          // The main morphing creature
ArrayList<SmallFish> smallFishes;   // List of stationary small fish

// Setup the canvas and initialize the morphing creature and small fish
void setup() {
  size(800, 600); // Canvas size
  creature = new MorphingCreature(new PVector(width / 2, height / 2), 50, color(255, 150, 100));
  
  // Initialize a list of small fish with random positions and sizes
  smallFishes = new ArrayList<>();
  for (int i = 0; i < 10; i++) {
    smallFishes.add(new SmallFish(random(width), random(height), 15, color(200, 100, 50)));
  }
}

// Main draw loop: update the display
void draw() {
  drawBackground(); // Draw the underwater background
  
  // Display all small fish
  for (int i = smallFishes.size() - 1; i >= 0; i--) {
    smallFishes.get(i).display();
  }
  
  // Update and draw the morphing creature
  creature.updatePosition(); // Smoothly move creature to the target position
  creature.morph(0.0);       // Render the current stage of the creature
}

// Handle mouse clicks: interact with fish or move the morphing creature
void mousePressed() {
  // Check if a small fish is clicked
  for (int i = smallFishes.size() - 1; i >= 0; i--) {
    if (smallFishes.get(i).isClicked(mouseX, mouseY)) {
      smallFishes.remove(i); // Remove the clicked fish
    }
  }
  
  // Move the morphing creature to the clicked location and advance its stage
  creature.setTarget(mouseX, mouseY);
  creature.advanceMorphStage();
}

// Draw the underwater background with light rays
void drawBackground() {
  // Gradient effect for the ocean
  for (int y = 0; y < height; y++) {
    float brightness = map(y, 0, height, 50, 150);
    stroke(0, 100, 200, brightness); // Gradient blue
    line(0, y, width, y);
  }
  drawLightRays(); // Add dynamic light rays
}

// Draw dynamic light rays moving across the screen
void drawLightRays() {
  for (int i = 0; i < 5; i++) {
    float x = sin(frameCount * 0.01 + i) * width; // Oscillating x positions
    stroke(255, 50); // Transparent white for light rays
    line(x, 0, x + 100, height);
  }
}

// Class representing the morphing creature
class MorphingCreature {
  PVector position, target; // Current position and target destination
  float size;               // Size of the creature
  int morphStage;           // Current transformation stage
  color bodyColor;          // Base color of the creature

  // Constructor: Initialize the morphing creature
  MorphingCreature(PVector pos, float sz, color c) {
    position = pos;       // Initial position
    target = pos.copy();  // Target starts at the initial position
    size = sz;            // Size of the creature
    bodyColor = c;        // Initial color
    morphStage = 0;       // Start at the first stage (fish)
  }

  // Set a new target position for the creature to move to
  void setTarget(float x, float y) {
    target.set(x, y);
  }

  // Smoothly update the creature's position toward the target
  void updatePosition() {
    position = PVector.lerp(position, target, 0.05); // Linear interpolation
  }

  // Advance to the next transformation stage
  void advanceMorphStage() {
    morphStage = (morphStage + 1) % 3; // Cycle through three stages
  }

  // Draw the creature based on its current transformation stage
  void morph(float step) {
    if (morphStage == 0) drawFish();       // Stage 1: Fish
    else if (morphStage == 1) drawShark(); // Stage 2: Shark
    else drawMegalodon();                  // Stage 3: Megalodon
  }

  // Draw the creature as a fish
  void drawFish() {
    fill(bodyColor);
    noStroke();
    // Fish body using Bézier curves
    beginShape();
    vertex(position.x - size * 0.6, position.y);
    bezierVertex(position.x - size * 0.3, position.y - size * 0.5, position.x + size * 0.3, position.y - size * 0.5, position.x + size * 0.6, position.y);
    bezierVertex(position.x + size * 0.3, position.y + size * 0.5, position.x - size * 0.3, position.y + size * 0.5, position.x - size * 0.6, position.y);
    endShape(CLOSE);
    // Fish tail
    beginShape();
    vertex(position.x - size * 0.6, position.y);
    vertex(position.x - size * 0.9, position.y - size * 0.2);
    vertex(position.x - size * 0.9, position.y + size * 0.2);
    endShape(CLOSE);
  }

  // Draw the creature as a shark
  void drawShark() {
    fill(50, 50, 100);
    noStroke();
    // Shark body
    beginShape();
    vertex(position.x - size, position.y);
    bezierVertex(position.x - size * 0.5, position.y - size, position.x + size * 0.5, position.y - size, position.x + size, position.y);
    bezierVertex(position.x + size * 0.5, position.y + size, position.x - size * 0.5, position.y + size, position.x - size, position.y);
    endShape(CLOSE);
    // Shark dorsal fin
    beginShape();
    vertex(position.x - size * 0.2, position.y - size * 0.5);
    vertex(position.x, position.y - size * 1.2);
    vertex(position.x + size * 0.2, position.y - size * 0.5);
    endShape(CLOSE);
  }

  // Draw the creature as a Megalodon
  void drawMegalodon() {
    fill(30, 30, 80);
    noStroke();
    // Megalodon body
    beginShape();
    vertex(position.x - size * 1.5, position.y);
    bezierVertex(position.x - size, position.y - size * 1.5, position.x + size, position.y - size * 1.5, position.x + size * 1.5, position.y);
    bezierVertex(position.x + size, position.y + size * 1.5, position.x - size, position.y + size * 1.5, position.x - size * 1.5, position.y);
    endShape(CLOSE);
    // Megalodon dorsal fin
    beginShape();
    vertex(position.x - size * 0.3, position.y - size * 0.8);
    vertex(position.x, position.y - size * 1.6);
    vertex(position.x + size * 0.3, position.y - size * 0.8);
    endShape(CLOSE);
  }
}

// Class representing small stationary fish
class SmallFish {
  float x, y, size; // Position and size of the fish
  color bodyColor;  // Color of the fish

  // Constructor: Initialize the small fish
  SmallFish(float x, float y, float size, color bodyColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.bodyColor = bodyColor;
  }

  // Display the small fish on the screen
  void display() {
    fill(bodyColor);
    noStroke();
    ellipse(x, y, size, size * 0.6); // Fish body
    triangle(x - size * 0.5, y, x - size, y - size * 0.2, x - size, y + size * 0.2); // Fish tail
  }

  // Check if the fish is clicked by the mouse
  boolean isClicked(float mouseX, float mouseY) {
    return dist(mouseX, mouseY, x, y) < size; // Check if click is within fish bounds
  }
}
