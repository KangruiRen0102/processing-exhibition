// Keywords: Memory, Mother, Backhome
// Thematic Sentence: "Fleeting memories drift across a peaceful home scene, while falling leaves evoke the warmth of a mother's embrace."

// VARIABLES
PImage backgroundImage;     // Variable to store the background image
MemoryFragment[] fragments; // Array to store memory fragment objects
int numFragments = 50;      // Number of memory fragments

// MAIN CODE
void setup() {
  // WINDOW SETUP
  size(700, 700); // Set the window size
  
  // LOAD IMAGE
  backgroundImage = loadImage("Background.jpg"); // Replace with your background image
  backgroundImage.resize(width, height);
  
  // CREATE MEMORY FRAGMENTS
  fragments = new MemoryFragment[numFragments]; // Initialize the fragments array
  for (int i = 0; i < numFragments; i++) {
    fragments[i] = new MemoryFragment();
  }
}

void draw() {
  // DISPLAY BACKGROUND IMAGE
  background(backgroundImage); // Display the home scene image
  
  // UPDATE MEMORY FRAGMENTS
  for (MemoryFragment fragment : fragments) {
    fragment.update();  // Update the memory fragment's position
    fragment.display(); // Draw the memory fragment 
  }
}

// MOUSE INTERACTION
void mouseMoved() {
  // When the mouse is moved, attract fragments to the mouse position
  for (MemoryFragment fragment : fragments) {
    fragment.attractToMouse(); // Call the attract function to move toward the mouse
  }
}

void mousePressed() {
  // When the mouse is pressed, change the color or size of the fragments
  for (MemoryFragment fragment : fragments) {
    fragment.changeSizeOnClick(); // Increase the size of the fragment on click
  }
}

// CLASSES

// MEMORY FRAGMENT CLASS
class MemoryFragment {
  
  // VARIABLES
  float x, y, size, speed, alpha; // Position (x, y), size, speed, and transparency
  color fragmentColor;           // Color for the fragment
  float attractionStrength = 1;   // How strongly fragments are attracted to the mouse
  
  // MEMORY FRAGMENT CONSTRUCTOR
  MemoryFragment() {
    x = random(width);           // Random horizontal position
    y = random(height);          // Random vertical position
    size = random(15, 30);       // Random size of the fragment (15 to 30 pixels)
    speed = random(0.5, 1.5);    // Random upward speed (0.5 to 1.5 pixels per frame)
    alpha = random(100, 200);    // Random transparency (100 to 200)
    
    // Random warm colors (pink, light orange) to evoke warmth
    fragmentColor = color(random(255, 255), random(150, 255), random(100, 150)); 
  }

  // UPDATE MEMORY FRAGMENT POSITION
  void update() {
    y -= speed;                // Fragment drifts upward
    alpha -= 0.5;              // Fragment gradually fades out
    if (alpha <= 0) {          // If fragment is fully faded
      reset();                 // Reset its position and transparency
    }
  }

  // RESET FRAGMENT TO INITIAL STATE
  void reset() {
    x = random(width);         // New random horizontal position
    y = height + random(10);   // Start just below the canvas
    size = random(15, 30);     // New random size
    speed = random(0.5, 1.5);  // New random speed
    alpha = random(100, 200);  // New random transparency
  }

  // DISPLAY MEMORY FRAGMENT (Now as a leaf shape)
  void display() {
    fill(fragmentColor, alpha);  // Color with transparency
    noStroke();                  // No outline
    // Draw memory fragment as a leaf shape
    pushMatrix();
    translate(x, y);
    rotate(radians(frameCount / 10));  // Slow rotation for effect
    beginShape();
    vertex(0, -size / 2);
    bezierVertex(-size / 3, -size, -size / 2, 0, 0, size / 2);
    bezierVertex(size / 2, 0, size / 3, -size, 0, -size / 2);
    endShape(CLOSE);
    popMatrix();
  }

  // ATTRACT MEMORY FRAGMENT TO MOUSE
  void attractToMouse() {
    // Calculate the distance between the fragment and the mouse
    float distance = dist(x, y, mouseX, mouseY);
    
    // If the fragment is within a certain range of the mouse, attract it
    if (distance < 200) {
      float angle = atan2(mouseY - y, mouseX - x);
      x += cos(angle) * attractionStrength;  // Move the fragment towards the mouse
      y += sin(angle) * attractionStrength;
    }
  }

  // CHANGE FRAGMENT SIZE AND COLOR WHEN MOUSE IS PRESSED
  void changeSizeOnClick() {
    // Increase the size and change the color when clicked
    if (dist(mouseX, mouseY, x, y) < size) {  // Check if the mouse is near the fragment
      size += 5;                             // Increase the size
      fragmentColor = color(random(255, 255), random(150, 255), random(100, 150));  // Change the color
    }
  }
}
