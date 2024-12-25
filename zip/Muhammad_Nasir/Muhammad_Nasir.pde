// Project: Mother and Child Journey - A hopeful night sky scene

float motherX, childX; // Positions for the mother and child
float[] starX, starY;  // Arrays to store star positions
int numStars = 200;    // Number of stars in the sky
boolean starsVisible = true; // Whether stars should be displayed
float starSpeed = 0.5; // Speed of star movement (falling effect)

void setup() {
  size(800, 800); // Setting up a square canvas
  
  motherX = width / 2;    // Mother starts centered horizontally
  childX = motherX - 40;  // Child starts slightly to the left of the mother

  // Initialize star positions in the top half of the screen
  starX = new float[numStars];
  starY = new float[numStars];
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(width);          // Random X within canvas width
    starY[i] = random(height / 2);     // Random Y in the upper half
  }
}

void draw() {
  background(30, 30, 60); // Night sky: dark blue
  if (starsVisible) drawStars(); // Draw stars only if they're toggled on
  drawMoon();           // Add the moon (top-right corner)
  drawMountainRange();  // Paint mountains at the bottom
  drawMotherAndChild(); // Add figures of the mother and child
  drawPath();           // Add a path to guide the journey
  drawInstructions();   // Display user instructions
}

void drawStars() {
  // Animate the stars
  fill(255, 255, 100); // Stars have a soft yellow glow
  noStroke();
  for (int i = 0; i < numStars; i++) {
    ellipse(starX[i], starY[i], random(3, 6), random(3, 6)); // Stars vary in size
    starY[i] += starSpeed; // Move stars downward at the current speed
    
    // Reset stars when they "fall" past a certain point
    if (starY[i] > height / 2) { 
      starY[i] = 0;                 // Reset to top
      starX[i] = random(width);     // Randomize X for a natural look
    }
  }
}

void drawMoon() {
  // Simple moon in the top-right corner
  fill(255, 255, 200); // Pale yellow moon
  ellipse(width - 100, 100, 80, 80); // Slightly off-center moon
}

void drawMountainRange() {
  // Paint mountains using triangles
  fill(50, 50, 80); // Dark grayish-blue
  noStroke();
  
  // Multiple different mountains to create a horiuzon effect
  triangle(50, height - 200, 150, height - 400, 250, height - 200);
  triangle(200, height - 200, 300, height - 350, 400, height - 200);
  triangle(350, height - 200, 450, height - 300, 550, height - 200);
  triangle(500, height - 200, 600, height - 400, 700, height - 200);
  triangle(650, height - 200, 750, height - 350, 850, height - 200);
}

void drawPath() {
  // Draw a horizontal line representing the path
  stroke(200); // Soft gray
  line(0, height - 50, width, height - 50);
}

void drawMotherAndChild() {
  // Draw the mother figure
  fill(150, 0, 150); // Purple
  ellipse(motherX, height - 90, 50, 50);  // Head
  rect(motherX - 15, height - 65, 30, 40); // Body
  
  // Draw the child figure
  fill(0, 150, 150); // Cyan
  ellipse(childX, height - 90, 30, 30);  // Head
  rect(childX - 10, height - 65, 20, 30); // Body
}

void drawInstructions() {
  // Display text instructions for interaction
  fill(255); // White text
  textSize(12);
  text("Press SPACE to toggle stars on/off.", 10, height - 60); // Stars visibility
  text("Press UP/DOWN to adjust star speed.", 10, height - 40); // Control speed
}

void keyPressed() {
  // Handle key interactions
  if (key == ' ') starsVisible = !starsVisible; // SPACE toggles star visibility
  if (keyCode == UP) starSpeed = min(5, starSpeed + 0.1);    // Increase speed
  if (keyCode == DOWN) starSpeed = max(0.1, starSpeed - 0.1); // Decrease speed
}
