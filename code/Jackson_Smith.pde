// Animal class to define each animal (now deer-like from the top view) A Herd of animals find Hope in the Frozen Tundra. 
class Animal {
  float x, y; // Position of the animal
  float speed; // Speed at which the animal moves
  float direction; // Current moving direction (angle)
  float targetAngle; // Target angle towards the flame
  float angleOffset; // Random offset for zigzag movement
  color c; // Color of the animal (brown)
  float headSize = 15; // Size of the animal's head
 
  
  // Constructor to initialize the animal's position, speed, and direction
  Animal(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.direction = random(TWO_PI); // Random starting direction for each animal
    this.targetAngle = random(TWO_PI); // Initial target angle towards the flame
    this.angleOffset = random(-1.0, 1.0); // Larger initial random offset for eratic movement
    this.c = color(139, 69, 19); // Brown color for the animal
  }
  
  // Method to make the animal move toward the flame in a nondirect pattern
  void moveTowards(float targetX, float targetY) {
    // Calculate the angle to the target (flame)
    float angleToTarget = atan2(targetY - y, targetX - x);
    
    // Introduce larger randomness to make the movement more wavy
    targetAngle = angleToTarget + sin(angleOffset) * 0.5; // Larger amplitude for wavy motion
    
    // Move the animal in the target direction with speed (random to change up consistency
    x += cos(targetAngle) * speed;
    y += sin(targetAngle) * speed;
    
    // Method for wavy motion 
    angleOffset += random(-0.1, 0.1); // Slight random change for continued wave motion
    
    // Leave a footprint trail
    leaveFootprint();
  }
  
  // Method to display the animal 
  void display() {
    pushMatrix();
    
    // Calculate the angle of movement for the entire creature
    float movementAngle = atan2(sin(targetAngle), cos(targetAngle)); // This creates the wavy movement pattern
    
    // Translate and rotate the entire creature toawrds the mouse 
    translate(x, y); // Move the origin to the animal's position
    rotate(movementAngle); // Rotate based on movement direction
    
    // Draw the body of the deer
    fill(c);
    ellipse(0, 0, 40, 20); // Deer body oval to seem natural 
    
    // Draw the head of the deer 
    fill(139, 69, 19); // Same brown color for the head
    ellipse(20, 0, headSize, headSize);
    
    popMatrix();
  }
  
  
  
  // Method to leave footprints behind
  void leaveFootprint() {
    Footprint footprint1 = new Footprint(x - 10, y + 5, millis()); // Left offset footprint
    Footprint footprint2 = new Footprint(x + 10, y + 5, millis()); // Right offset footprint
    footprints.add(footprint1); // Add the first footprint to the list
    footprints.add(footprint2); // Add the second footprint to the list
  }
}

class Footprint {
  float x, y; // Position of the footprint
  int timestamp; // Time when the footprint was created
  
  Footprint(float x, float y, int timestamp) {
    this.x = x;
    this.y = y;
    this.timestamp = timestamp;
  }
  
  // Method to display the footprint fading as time goes on 
  void display() {
    int age = millis() - timestamp; // Age of the footprint in milliseconds
    if (age > 2000) return; // If the footprint is older than 2 seconds, remove it
    
    // Calculate the alpha value based on age, so the footprint fades out
    float alpha = map(age, 0, 2000, 255, 0);
    fill(211, 211, 211, alpha); // Light gray color with fading transparency therefore the lines will look natural 
    noStroke();
    ellipse(x, y, 10, 10); // Small footprint circle
  }
}

ArrayList<Animal> animals; // List to hold all the animals
ArrayList<Footprint> footprints; // List to hold footprints
float flameX, flameY; // Position of the flame 
int numAnimals = 10; // Number of animals

void setup() {
  size(800, 600);
  animals = new ArrayList<Animal>();
  footprints = new ArrayList<Footprint>(); // Initialize the list of footprints
  
  // Creates a herd of our "animals" at random positions helps to creat a more realistic movement pattern
  for (int i = 0; i < numAnimals; i++) {
    float x = random(width);
    float y = random(height);
    float speed = random(1.5, 3); // Random speed for each animal to keep the realism 
    animals.add(new Animal(x, y, speed));
  }
  
  flameX = width / 2; // Flame initial point. 
  flameY = height / 2;
}

void draw() {
  background(255); // Frozen background
  
  // Draw the hope flame with the green cirlce thats larger
  fill(0, 255, 0, 150); // Semi-transparent green colour 
  noStroke();
  ellipse(flameX, flameY, 100, 100); 
  
  // Draw the bonfire-like flame inside the green circle
  drawFlame(flameX, flameY);
  
  // This creates a trail nehind our animals 
  for (Footprint footprint : footprints) {
    footprint.display();
  }
  
  // Make each animal move towards the flame (mouse)
  for (Animal a : animals) {
    a.moveTowards(flameX, flameY);
    a.display();
  }
}

// Function to draw the bonfire in the center of the green circle
void drawFlame(float x, float y) {
  noStroke();
  
//Total Flame Design this will follow the mouse
  fill(255, 204, 0, 180); // Bright yellow with some transparency
  ellipse(x, y, 20, 20); // Inner flame (smaller)
  fill(255, 102, 0, 150); // Orange with transparency
  ellipse(x, y - 5, 35, 35); // Outer flame (smaller)
  fill(255, 0, 0, 120); // Red with more transparency
  ellipse(x, y + 5, 50, 50); // Outer flame (largest)
}

// Mouse interaction: Move the flame shape that represents hope with the mouse
void mouseMoved() {
  flameX = mouseX;
  flameY = mouseY;
}
