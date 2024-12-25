int maxPetals = 20; // Maximum number of petals
int petalCount = 0; // Number of petals currently drawn
float petalRadius = 0; // Radius of petals at start
float petalGrowthRate = 0.6; // Speed of petal growth
float growthStage = 0; // Stage of flower growth (from 0 to 1)
float wiltingStage = 0; // Stage of wilting after full bloom
float timeFactor = 1; // Controls the speed of growth (interactive)
float lightIntensity = 0; // Light intensity for time progression
float oscillationFactor = 0.05; // Subtle oscillation to make petals less shaky
boolean isGrowing = true; // Flag to track if growth is happening
boolean isDying = false; // Flag to track if the flower is dying
ArrayList<Particle> particles = new ArrayList<Particle>(); // Particle system for dynamic effects
boolean pauseGrowth = false; // Flag to pause flower growth
float fadeFactor = 0; // Factor to control the fading of all elements

void setup() {
  size(600, 600);
  frameRate(30); // Slow down frame rate to visualize time passing
}

void draw() {
  // If the flower is dying, increase the fade factor and make everything fade out
  if (isDying) {
    fadeFactor += 0.02; // Speed of fading process
    fadeFactor = constrain(fadeFactor, 0, 1); // Make sure fadeFactor stays between 0 and 1
  }

  // Smooth day-to-night background transition based on fade factor
  color bgColor = lerpColor(color(255, 223, 186), color(50, 50, 100), fadeFactor);
  background(bgColor);

  // Simulate a light intensity transition from dawn to dusk, affecting fade
  lightIntensity = map(fadeFactor, 0, 1, 50, 255);
  directionalLight(lightIntensity, lightIntensity, lightIntensity, 0, 0, -1); // Sunlight effect

  // Control flower growth over time, but stop growing if it's dying
  if (isGrowing && !isDying && !pauseGrowth) {
    growthStage += petalGrowthRate * timeFactor * 0.01;
    growthStage = constrain(growthStage, 0, 1); // Ensure growth stays within bounds
  }

  // Gradually start wilting after full bloom
  if (growthStage >= 1 && !isDying) {
    wiltingStage += 0.05; // Speed up wilting
    wiltingStage = constrain(wiltingStage, 0, 1);
  }

  // Increase the number of petals as the flower blooms
  if (petalCount < maxPetals && growthStage > 0.5) {
    petalCount++;
  }

  // Update petal angle offset for realistic movement
  float petalAngleOffset = sin(growthStage * PI);

  // Draw the flower at the center of the screen
  translate(width / 2, height / 2);

  // Draw the inner petals (layer 1)
  drawPetalsLayer(1, 50, 120, 255, 100, 100);

  // Draw the middle petals (layer 2)
  if (growthStage > 0.6) {
    drawPetalsLayer(2, 60, 140, 255, 50, 50);
  }

  // Draw the outer petals (layer 3)
  if (growthStage > 0.8) {
    drawPetalsLayer(3, 70, 160, 255, 20, 100);
  }

  // If flower has fully bloomed, begin wilting process
  if (wiltingStage > 0) {
    wiltingPetals();
  }

  // If the flower is dying, begin the dying process
  if (isDying) {
    dyingProcess();
  }

  // Draw the flower center (yellow core)
  fill(255, 200, 0, 180 * (1 - fadeFactor)); // Use fadeFactor to control the center fading
  ellipse(0, 0, 70, 70); // Central circle

  // Glow effect around the center
  noFill();
  stroke(255, 200, 0, 150 * (1 - fadeFactor)); // Glowing stroke fades as well
  strokeWeight(8);
  ellipse(0, 0, 80, 80); // Glowing effect around the flower center

  // Display instructions for user interaction
  fill(255, 180 * (1 - fadeFactor)); // Make instructions fade as well
  textAlign(CENTER, CENTER);
  textSize(18);
  text("Click to control speed, hold to stop growth, press 'r' to reset, press 'd' to make flower die, 'p' to pause growth", width / 2, height - 30);

  // Update particles and display them
  updateParticles();
  for (Particle p : particles) {
    p.display();
  }
  // Add new particles over time
  if (growthStage > 0.5) {
    addParticles();
  }
}

// Function to create a petal layer with different parameters
void drawPetalsLayer(int layer, float minSize, float maxSize, float r, float g, float b) {
  for (int i = 0; i < petalCount; i++) {
    float angle = map(i, 0, petalCount, 0, TWO_PI);
    float x = (petalRadius + (layer * 30)) * cos(angle);
    float y = (petalRadius + (layer * 30)) * sin(angle);

    // Oscillation effect for natural petal movement
    float oscillation = sin(angle * 3 + sin(growthStage * PI)) * oscillationFactor;
    
    pushMatrix();
    rotate(angle + radians(30) + oscillation); // Oscillating rotation for petals
    fill(r, g, b, 180 * (1 - fadeFactor)); // Petal color with fading transparency
    noStroke();
    drawCurvedPetal(x, y, minSize, maxSize); // Petal shape with randomized sizes
    popMatrix();
  }
}

// Function to create curved petals
void drawCurvedPetal(float x, float y, float width, float height) {
  beginShape();
  for (float t = 0; t <= 1; t += 0.1) {
    float xt = x + width * sin(PI * t);  // Curved X position
    float yt = y + height * cos(PI * t); // Curved Y position
    vertex(xt, yt);
  }
  endShape(CLOSE);
}

// Function to simulate wilting of the petals
void wiltingPetals() {
  // Decrease petal size and increase curvature to simulate wilting
  for (int i = 0; i < petalCount; i++) {
    float angle = map(i, 0, petalCount, 0, TWO_PI);
    float x = (petalRadius + 60) * cos(angle);
    float y = (petalRadius + 60) * sin(angle);

    float wiltingSize = lerp(70, 50, wiltingStage); // Decrease petal size
    float wiltingHeight = lerp(160, 120, wiltingStage); // Increase petal height to simulate drooping

    pushMatrix();
    rotate(angle + radians(15));
    fill(255, 20, 100, 180 * (1 - fadeFactor)); // Fade out the petals as they wilt
    noStroke();
    ellipse(x, y, wiltingSize, wiltingHeight); // Drooping petals
    popMatrix();
  }
}

// Function to simulate the flower dying process
void dyingProcess() {
  // Gradually fade and shrink the petals, center, and everything else
  for (int i = 0; i < petalCount; i++) {
    float angle = map(i, 0, petalCount, 0, TWO_PI);
    float x = (petalRadius + 60) * cos(angle);
    float y = (petalRadius + 60) * sin(angle);

    // Shrinking effect for petals and center
    float dyingSize = lerp(70, 0, fadeFactor); // Gradual shrinking of petals
    float dyingHeight = lerp(160, 0, fadeFactor); // Drooping effect for petals

    pushMatrix();
    rotate(angle + radians(15));
    fill(150, 50, 50, 180 * (1 - fadeFactor)); // Fade out the petals and color them more brownish
    noStroke();
    ellipse(x, y, dyingSize, dyingHeight); // Smaller drooping petals
    popMatrix();
  }

  // Shrink and fade the center as well
  fill(200, 100, 0, 180 * (1 - fadeFactor)); // Dimming center color
  ellipse(0, 0, 50, 50); // Smaller center

  // Shrink and fade the glowing effect around the center
  stroke(255, 200, 0, 150 * (1 - fadeFactor));
  strokeWeight(8);
  ellipse(0, 0, 80, 80); // Fading glowing effect

  // If the fade factor reaches 1, flower is completely dead
  if (fadeFactor >= 1) {
    isDying = false; // Flower has fully died
  }
}

// Particle class for dynamic effects
class Particle {
  float x, y, speedX, speedY, lifespan;
  color c;

  Particle(float startX, float startY) {
    x = startX;
    y = startY;
    speedX = random(-1, 1);
    speedY = random(-1, 1);
    lifespan = 255;
    c = color(random(100, 255), random(100, 200), random(100, 200), lifespan);
  }

  void update() {
    x += speedX;
    y += speedY;
    lifespan -= 2; // Fade out over time
    if (lifespan < 0) lifespan = 0;
    c = color(red(c), green(c), blue(c), lifespan * (1 - fadeFactor)); // Fade particles based on fadeFactor
  }

  void display() {
    noStroke();
    fill(c);
    ellipse(x, y, 5, 5); // Small particle
  }
}

// Function to add particles based on flower growth
void addParticles() {
  for (int i = 0; i < 5; i++) {
    float angle = random(TWO_PI);
    float radius = random(petalRadius, petalRadius + 60);
    float x = radius * cos(angle);
    float y = radius * sin(angle);

    particles.add(new Particle(x, y)); // Create and add a new particle
  }
}

// Update particles in the system
void updateParticles() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    if (p.lifespan == 0) {
      particles.remove(i); // Remove particles that have faded out
    }
  }
}

// Increase growth speed when mouse is pressed
void mousePressed() {
  timeFactor = 2;
  isGrowing = true; // Flower continues growing
}

// Slow down growth when mouse is released
void mouseReleased() {
  timeFactor = 0.5;
  isGrowing = false; // Stop growth when mouse is released
}

// Reset the flower's growth when 'r' is pressed
void keyPressed() {
  if (key == 'r' || key == 'R') {
    petalCount = 0;
    petalRadius = 0;
    growthStage = 0;
    wiltingStage = 0;
    fadeFactor = 0; // Reset fade factor
    isGrowing = true; // Restart growth
    isDying = false; // Reset dying process
    particles.clear(); // Clear particles
  }
  
  // Start the dying process when 'd' is pressed
  if (key == 'd' || key == 'D') {
    isDying = true; // Start dying process
    isGrowing = false; // Stop growth when dying
  }

  // Pause or resume growth when 'p' is pressed
  if (key == 'p' || key == 'P') {
    pauseGrowth = !pauseGrowth; // Toggle pause growth
  }
}
