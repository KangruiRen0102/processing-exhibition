int numStars = 800;  // Number of stars
//Creating different arrays for each different attributes
float[] starX = new float[numStars];  //X location
float[] starY = new float[numStars];  //Y location
float[] starSpeed = new float[numStars]; //Speed
float[] starSize = new float[numStars];  //Size
float[] R = new float[numStars];  // Red component for star color
float[] G = new float[numStars];  // Green component for star color
float[] B = new float[numStars];  // Blue component for star color
  
float angle = 0;  // Initial rotation of hourglass 
float rotationSpeed = 0;  // Inital speed of hourglass rotation 
  
  void setup() {
    size(800, 800);
    
    // Initialize star positions, speeds, and colors
    for (int i = 0; i < numStars; i++) { // the '++' is imporant as it increases the interger by 1, create number of stars - 1
      starX[i] = random(width);
      starY[i] = random(height);
      starSpeed[i] = random(1, 10);  // Initial star speed
      starSize[i] = random(2, 5);  // Randomize size of stars
      
      // Randomize the color components for each star
      R[i] = random(255);
      G[i] = random(255);
      B[i] = random(255);
    }
  }
  
  void draw() {
    background(0);  // Black background for space effect
    
    // Map the X location of the mouse to control both the speed of stars and the rotation of the hourglass
    rotationSpeed = map(mouseX, 0, width, -0.08, 0.08);  // Negative for reverse rotation
    float speedFactor = map(mouseX, 0, width, -3, 3);  // Speed of stars based on mouseX, max magnitutde of speed being -3 to 3
    
    // Set the speed/movement of the stars with the speeds based on mouse X location
    for (int i = 0; i < numStars; i++) {
      // Adjust the star's speed based on the cursor position (mouseX)
      starX[i] += starSpeed[i] * speedFactor;
      starY[i] += starSpeed[i] * speedFactor;
  
      // If the star moves off the screen, reset its position and randomize the color
      // If the leaves the right side
      if (starX[i] > width) {
        starX[i] = 0;
        R[i] = random(255);  // Randomize the red component
        G[i] = random(255);  // Randomize the green component
        B[i] = random(255);  // Randomize the blue component
      }
      //If it leaves the top
      if (starY[i] > height) {
        starY[i] = 0;
        R[i] = random(255);  // Randomize the red component
        G[i] = random(255);  // Randomize the green component
        B[i] = random(255);  // Randomize the blue component
      }
      // If it leaves the left side
      if (starX[i] < 0) {
        starX[i] = 800;
        R[i] = random(255);  // Randomize the red component
        R[i] = random(255);  // Randomize the green component
        G[i] = random(255);  // Randomize the blue component
      }
      //If it leaves the bottom
      if (starY[i] < 0) {
        starY[i] = 800;
        R[i] = random(255);  // Randomize the red component
        G[i] = random(255);  // Randomize the green component
        B[i] = random(255);  // Randomize the blue component
      }
  
      //Drawing the star [i] with colors that have been pre-determined (r,g,b)
      stroke(R[i], G[i], B[i]);  // Match stroke color to the fill color
      fill(R[i], G[i], B[i]);  // Fill with the same random color (no transparency)
      
      
      // Draw the star
      ellipse(starX[i], starY[i], starSize[i], starSize[i]);
    }
    
    
      // Coordinates for the top triangle (upper part of the hourglass)
    float topX1 = 400;
    float topY1 = 400;
    float topX2 = 300;
    float topY2 = 600;
    float topX3 = 500;
    float topY3 = 600;
    
    // Coordinates for the bottom triangle (lower part of the hourglass)
    float bottomX1 = 400;
    float bottomY1 = 400;
    float bottomX2 = 300;
    float bottomY2 = 200;
    float bottomX3 = 500;
    float bottomY3 = 200;
  
    
    // Rotate the entire drawing canvas around the center
    translate(400, 400); // Sets the origin at (400, 400) from (0, 0)
    rotate(angle); // Rotates the hourglass around the new origin
    translate(-400, -400);  // This keeps the center of the hourglass in the center, moves the center to the center
    
    // Draw the top triangle (upper part of the hourglass)
    fill(127, 107, 0, 150);  // Faint gold color for the top triangle and semi-transparent
    stroke(255);  // White outline
    triangle(topX1, topY1, topX2, topY2, topX3, topY3);
    
    // Draw the bottom triangle (lower part of the hourglass)
    fill(40, 40, 40, 150);  // Gray color for the bottom triangle and semi-transparent
    stroke(255);
    triangle(bottomX1, bottomY1, bottomX2, bottomY2, bottomX3, bottomY3);
    
    // Increment the rotation angle based on mouseX position
    angle += rotationSpeed;  // Rotation speed depends on mouseX position
  }
