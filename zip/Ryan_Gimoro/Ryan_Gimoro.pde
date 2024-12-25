int currentState = 0;  // Tracks the current state (0 = Aurora, 1 = Twilight, 2 = Galaxy with color change)
float auroraOffset = 0;  // Controls the movement of the aurora
float starlightAlpha = 0;  // Controls the fading effect of stars
ArrayList<Star> stars;  // List of stars for the starlight effect
ArrayList<GalaxySpiral> spirals;  // List to hold multiple spiral objects
float galaxyRotation = 0;  // Controls the rotation of the galaxy
float galaxyColorOffset = 0;  // Controls the color transition of the galaxy effect
int starCreationRate = 1; // Controls how many stars are created per click
int clickCount = 0; // Track the number of clicks

void setup() {
  size(800, 600, P3D);  // Set up 3D canvas
  smooth();
  noStroke();
  stars = new ArrayList<Star>();
  spirals = new ArrayList<GalaxySpiral>();
}

void draw() {
  background(0); // Start with a dark background for contrast
  
  // Always display the Galaxy effect (spirals) in the background
  drawGalaxy();

  // Twilight effect: overlapping with aurora and bloom
  if (currentState >= 1) {
    drawTwilight();
  }

  // Check for collapse after 20 clicks
  if (clickCount >= 20) {
    collapseEffect();
  }
}

// Draw the Galaxy effect with color change
void drawGalaxy() {
  galaxyRotation += 0.01;  // Rotate the galaxy effect over time

  // Draw each spiral in the spirals list
  for (GalaxySpiral s : spirals) {
    s.display();
  }
}

// Draw the Twilight effect (twinkling stars)
void drawTwilight() {
  // Gradually increase the starlight effect alpha for a smooth fade-in
  starlightAlpha += 0.01;  // Faster appearance of stars in twilight
  starlightAlpha = constrain(starlightAlpha, 0, 1); // Limit alpha to 1 for smooth transition

  // Create new stars over time with a higher rate for faster twilight
  for (int i = 0; i < starCreationRate; i++) {
    stars.add(new Star(random(width), random(height)));
  }

  // Draw the stars
  for (int i = stars.size() - 1; i >= 0; i--) {
    Star s = stars.get(i);
    s.update();
    s.display();
  }
}

// Star class for creating and displaying twinkling stars
class Star {
  float x, y;  // Position of the star
  float size;  // Size of the star
  float alpha; // Transparency for fading effect
  float speed; // Speed of the twinkle effect
  color starColor; // Color of the star

  Star(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(1, 3);  // Small stars
    this.alpha = random(100, 255);  // Initial alpha for each star
    this.speed = random(0.01, 0.05);  // Random speed for twinkling
    this.starColor = color(random(255), random(255), random(255));  // Random star color
  }

  // Update the star's transparency for twinkling effect
  void update() {
    alpha += sin(frameCount * speed) * 10; // Make it twinkle
    alpha = constrain(alpha, 100, 255); // Keep alpha within bounds
  }

  // Display the star
  void display() {
    fill(starColor, alpha * starlightAlpha);  // Star color with fading effect
    ellipse(x, y, size, size);  // Draw the star
  }
}

// GalaxySpiral class for creating spiral effects
class GalaxySpiral {
  float offset;  // Spiral rotation offset
  color spiralColor;  // Color of the spiral
  float rotationSpeed;  // Speed of spiral rotation
  float centerX, centerY;  // Position of the spiral center
  int numSpirals;  // Number of spirals in the center
  float scaleFactor = 1;  // Factor to control the size of the spiral (for collapse effect)

  GalaxySpiral(float offset, color spiralColor, float rotationSpeed, float centerX, float centerY, int numSpirals) {
    this.offset = offset;
    this.spiralColor = spiralColor;
    this.rotationSpeed = rotationSpeed;
    this.centerX = centerX;
    this.centerY = centerY;
    this.numSpirals = numSpirals;
  }

  void display() {
    pushMatrix();
    translate(centerX, centerY);  // Move the spiral to its center
    rotate(galaxyRotation);  // Apply rotation to the spiral
    
    // Draw the spiral with lines that get progressively further from the center
    for (int i = 0; i < numSpirals; i++) {
      float angle = radians(i * 5) + offset;  // Spiral angle
      float r = 2 + i * 0.5 * scaleFactor;  // Radius increases with each iteration, adjusted for collapse
      float x = r * cos(angle);  // X position of the spiral
      float y = r * sin(angle);  // Y position of the spiral
      
      // Set the color and draw the spiral as a line
      stroke(spiralColor);
      line(x, y, x + cos(angle) * 2, y + sin(angle) * 2);
    }
    popMatrix();
  }

  // Collapse the spiral by reducing its scale over time
  void collapse() {
    scaleFactor *= 0.95;  // Gradually shrink the spiral
  }
}

// Collapse all stars and galaxies into the center
void collapseEffect() {
  // Collapse stars into the center
  for (Star s : stars) {
    s.x = lerp(s.x, width / 2, 0.05);  // Move stars towards the center
    s.y = lerp(s.y, height / 2, 0.05);
  }
  
  // Collapse galaxies into the center
  for (GalaxySpiral s : spirals) {
    s.collapse();  // Shrink each spiral
  }
  
  // After the galaxies are fully collapsed, reset the canvas
  if (spirals.get(spirals.size() - 1).scaleFactor < 0.01) {
    // Reset the entire scene to black
    background(0);
    stars.clear();
    spirals.clear();
    currentState = 0;
    clickCount = 0;
  }
}

// Change states on mouse click
void mousePressed() {
  clickCount++; // Increment the click count

  if (currentState == 0) {
    // Create the first galaxy (spiral) in the center
    spirals.add(new GalaxySpiral(galaxyRotation, generateGalaxyColor(), 0.02, width / 2, height / 2, 200));  // White spiral in the center
    currentState = 1;
  } 
  else if (currentState == 1) {
    // Create a new twilight effect
    currentState = 2;
  } 
  else if (currentState == 2) {
    // Add more spirals with different colors and increase their size gradually
    int numSpirals = spirals.get(spirals.size() - 1).numSpirals + 10;  // Increase spiral complexity each time
    spirals.add(new GalaxySpiral(galaxyRotation, generateGalaxyColor(), 0.02, width / 2, height / 2, numSpirals));
    
    // Increase the star creation rate to add more stars on subsequent clicks
    starCreationRate += 1;
  }
}

// Function to generate a galaxy color that is different from the stars
color generateGalaxyColor() {
  color newColor = color(random(255), random(255), random(255));  // Initialize the color first
  boolean isDifferent = false;

  // Keep generating new color until it's different from the stars' colors
  while (!isDifferent) {
    isDifferent = true;
    newColor = color(random(255), random(255), random(255));  // Regenerate the color

    // Check if the new color is different from the stars' colors
    for (int i = stars.size() - 1; i >= max(0, stars.size() - 10); i--) {
      Star s = stars.get(i);
      if (dist(red(newColor), green(newColor), blue(newColor),
               red(s.starColor), green(s.starColor), blue(s.starColor)) < 100) {
        isDifferent = false;
        break;
      }
    }
  }
  return newColor;
}
