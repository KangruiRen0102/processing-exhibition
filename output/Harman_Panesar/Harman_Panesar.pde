
// Start of the code

float StudentPosX, StudentPosY;  // Position of the student (circle)
float InitialStudentSize = 30;         // Initial size of the student
float FinalStudentSize = 40;          // Target size when the student grows
float YellowToBlue = 0;   // Transition from yellow to blue color of student
color Initialcolor = color(255, 204, 0);  // Starting yellow color for the student
color Finalcolor = color(0, 204, 255);    // Ending blue color for the student 
float StudentParticleSpeedX = 2;           // Speed of student in X direction
float StudentParticleSpeedY = 2;           // Speed of student in Y direction
float GrowthRate = 0.1;        // Speed of the student's metamorphosis

float CupPosX, CupPosY;           // Position of the cup
float cupHeight = 0;              // Height of the fluid (knowledge) in the cup
boolean KnowledgeCup = true;      // Whether the cup is filling or not

// Particle system variables
ArrayList<Particle> particles;  // List to hold the particles
float particleSpeed = 0.1;      // Speed of particles

void setup() {
  size(399, 399);
  RedoScene();  // Initialize the scene
  particles = new ArrayList<Particle>();  // Initialize the particle list
}

void draw() {
  background(255);              // Start with a white background
  
  // Create and update particles
  for (int i = 0; i < particles.size(); i++) {
    Particle r = particles.get(i);
    r.update();
    r.display();
  }
  
  // Position the cup at the bottom center
  CupPosX = width / 2 - 100;  // Horizontal center (subtract half the cup's width)
  CupPosY = height - 200;     // Vertical position at the bottom
  
  fill(150, 75, 0, 100);        // color for the cup
  rect(CupPosX, CupPosY, 200, 200);  // Cup size
  
  // Draw the water level in the cup
  fill(0, 0, 255, 150);         // Semi-transparent blue color for the water
  rect(CupPosX, CupPosY + 200 - cupHeight, 200, cupHeight);  // Water filling up
  
  // Draw the engineering student (always a circle)
  moveStudent();
  
  // Gradually change the size of the student (circle grows)
  if (KnowledgeCup) {
    if (InitialStudentSize < FinalStudentSize) {
      InitialStudentSize += GrowthRate;  // Gradually increase the size
    }
  }
  
  // Change the color of the student gradually as the cup fills
  color currentColor = lerpColor(Initialcolor, Finalcolor, cupHeight / 200);  // Smooth color transition
  
  // Draw the engineering student as a circle
  fill(currentColor);           // Interpolated color
  noStroke();
  ellipse(StudentPosX, StudentPosY, InitialStudentSize, InitialStudentSize);
  
  // Gradually fill the cup with water as the student morphs
  if (KnowledgeCup) {
    cupHeight += 0.5;  // Gradually increase the water level
    if (cupHeight >= 200) {  // When the cup is full
      KnowledgeCup = false;
    }
  }

  // If the cup is full, stop the filling and the metamorphosis
  if (!KnowledgeCup) {
    // Once the scene finishes, reset everything for a loop
    if (cupHeight >= 200) {
      delay(100); // Pause before resetting the scene
       RedoScene();  // Reset everything
    }
  }

  // New particles to fill the background
  if (random(1) < 0.05) {
    particles.add(new Particle(random(width), random(height), random(-1, 1), random(-2, 2)));
  }
}

void moveStudent() {
  StudentPosX += StudentParticleSpeedX; // student randomly moved across screen
  StudentPosY += StudentParticleSpeedY; // student randomly moved across screen
  
  // reverses the student direction everytime in contact with screen 
  if (StudentPosX <= 0 || StudentPosX >= width) {
    StudentParticleSpeedX *= -1;  // Reverse direction on X axis
  }
  if (StudentPosY <= 0 || StudentPosY >= height) {
    StudentParticleSpeedY *= -1;  // Reverse direction on Y axis
  }
}

// Function to reset the scene for looping
void RedoScene() {
  StudentPosX = width / 2;         // Reset student position to the center
  StudentPosY = height / 2;
  InitialStudentSize = 30;             // Reset the student's size to initial value
  cupHeight = 0;                // Reset the water height in the cup
  KnowledgeCup = true;            // Begin filling the cup again
  particles = new ArrayList<Particle>(); // Reinitialize the particles list

  }


// Particle class to represent small moving particles
class Particle {
  float x, y;        // Position of the particle
  float ParticleSpeedX, ParticleSpeedY;   // Speed of the particle
  color col;         // color of the particle
  
  // Constructor
  Particle(float x, float y, float ParticleSpeedX, float ParticleSpeedY) {
    this.x = x;
    this.y = y;
    this.ParticleSpeedX = ParticleSpeedX;
    this.ParticleSpeedY = ParticleSpeedY;
    this.col = color(random(255), random(255), random(255), 100);  // Semi-transparent color
  }
  
  // Update the particle's position
  void update() {
    x += ParticleSpeedX * particleSpeed;
    y += ParticleSpeedY * particleSpeed;
    
    // Wrap the particles around the screen if they go off the edges
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;
  }
  
  // Display the particle
  void display() {
    noStroke();
    fill(col);
    ellipse(x, y, 4, 4);  // Draw the particle as a small circle
  }
}

// End of the code