float waveSpeed = 0.05; // Waves' movement speed
float waveFrequency = 0.02; // Waves' frequency
float offsetLeftToRight = 0; 
float offsetRightToLeft = 0; 
float fishSpeed = 2; // Speed that the fish will move at
int numFish = 7; // Number of fish to be displayed

// Fish parameters
float[] fishX = new float[numFish];
float[] fishY = new float[numFish];
float[] fishBaseHeight = new float[numFish]; 
float fishDirection = 1; // Movement of fish

// Fixed lower height for fish, but with random variation
float minFishBaseHeight = 380; // Minimum height of fishes
float maxFishBaseHeight = 520; // Maximum height of fishes

// Ocean floor parameters
float[] floorHeights; 
int floorOffset = 50; // Height offset for ocean floor bumps

// Pile of rubies and gold coins parameters
int numGoldCoins = 10; // Number of gold coins 
int numRubies = 10; // Number of rubies 
float[][] goldCoins = new float[numGoldCoins][3]; //coin positions 
float[][] rubies = new float[numRubies][3]; //ruby positions
float coinAreaStartX = 500; // X-coordinate for the start of the coin pile area
float coinAreaEndX = 540;  // X-coordinate for the end of the coin pile area
float pileDistanceThreshold = 30; // Distance threshold to show the pile based on mouseX

// Sparkle parameters
int maxSparkles = 3; // Maximum number of sparkles per item
float sparkleChance = 0.1; // Chance that a sparkle will appear each frame
ArrayList<Sparkle> goldCoinSparkles = new ArrayList<Sparkle>();
ArrayList<Sparkle> rubySparkles = new ArrayList<Sparkle>();

void setup() {
  size(1100, 600); 
  noStroke(); 

  for (int i = 0; i < numFish; i++) {
    fishX[i] = random(width); // Random starting position for each fish along the X-axis
    // Set random heights for each fish
    fishBaseHeight[i] = random(minFishBaseHeight, maxFishBaseHeight); // Randomize fish height
  }
  
  // Ocean Floor 
  floorHeights = new float[width];
  for (int i = 0; i < width; i++) {
    floorHeights[i] = sin(i * 0.025) * 15 + height - 50; // Create bumpy floor
  }
  
  // Initialize positions and sizes of gold coins in the pile
  for (int i = 0; i < numGoldCoins; i++) {
    goldCoins[i][0] = random(coinAreaStartX, coinAreaEndX); // Random x position within the pile area
    goldCoins[i][1] = random(height - 50, height - 10); // Move y position closer to the bottom
    goldCoins[i][2] = random(8, 12); // Random size for the coins
  }

  // Initialize positions and sizes of rubies in the concentrated area with the gold
  for (int i = 0; i < numRubies; i++) {
    rubies[i][0] = random(coinAreaStartX, coinAreaEndX); // Random x position within the pile area
    rubies[i][1] = random(height - 50, height - 10); // Move y position closer to the bottom
    rubies[i][2] = random(8, 12); // Random size for the rubies
  }
}

void draw() {
  background(135, 206, 250); // Sky blue background (for the sky)
  
  // Draw the second wave moving right to left with a lighter blue and fill below it
  fill(56, 113, 151); // Sea color (light blue) for the second wave
  drawFilledWaves(100, 30, offsetRightToLeft); // Second wave moves right to left
  
  // Draw the sea with filled area under the first wave with a dark blue colour
  fill(30, 64, 97); // Sea color will be a dark blue and lowered by 50 pixels in respect ot hte firt wave
  drawFilledWaves(50, 30, offsetLeftToRight);
  
  // Draw the fishes swimming below the waves at random heights
  drawFishes();
  
  // Draw the ocean floor
  drawOceanFloor();
  
  // Only draw the gold coins and rubies if mouseX is near the pile's area
  if (mouseX >= coinAreaStartX - pileDistanceThreshold && mouseX <= coinAreaEndX + pileDistanceThreshold) {
    // Draw the gold coins and rubies concentrated in a small area
    drawGoldCoins();
    drawRubies();
  }
  
  // Draw the sun in the top right corner
  drawSun();
  
  // Draw the magnifying glass as a custom cursor
  drawMagnifyingGlass(mouseX, mouseY);
  
  // Update offsets for both waves
  offsetLeftToRight -= waveSpeed; // Wave moving left to right
  offsetRightToLeft += waveSpeed; // Wave moving right to left
  
  // Update and display sparkles
  updateAndDrawSparkles();
}

// Draw the fish swimming below the waves in a straight line
void drawFishes() {
  for (int i = 0; i < numFish; i++) {
    // Update the fish position based on the direction (left to right)
    fishX[i] += fishDirection * fishSpeed;

    // Keep the fish swimming at a random height below the waves
    fishY[i] = fishBaseHeight[i]; // Use the randomized height for each fish

    // If the fish goes off the screen, reset its position
    if (fishX[i] > width) {
      fishX[i] = 0; // Reset to the left side if fish reaches the right
    }

    // Draw the fish (ellipse for the body and triangle for the tail)
    drawFish(fishX[i], fishY[i]);
  }
}

// Draw an individual fish
void drawFish(float x, float y) {
  fill(255, 204, 0); // Yellow color for the fish body
  ellipse(x, y, 20, 10); // Fish body
  
  // Tail (small triangle for the tail)
  fill(255, 140, 0); // Orange color for the tail
  triangle(x - 10, y, x - 15, y - 5, x - 15, y + 5); // Tail
}

void drawOceanFloor() {
  // Draw the ocean floor as a series of bumps
  fill(112, 85, 56); // Brown color for the ocean floor
  beginShape();
  for (int i = 0; i < width; i++) {
    vertex(i, floorHeights[i]); // Use pre-generated bumpy heights
  }
  vertex(width, height); // Move to the bottom right of the screen
  vertex(0, height); // Move to the bottom left of the screen
  endShape(CLOSE); // Close the shape to fill the area
}

// Draw the waves
void drawFilledWaves(float k, float waveHeight, float offset) {
  // Start drawing the wave shape
  beginShape();
  for (float x = 0; x < width; x++) {
    // Use sine function to create wave motion
    float y = height / 2 + sin(x * waveFrequency + offset) * waveHeight;
    // Define the points of the wave and the bottom edge (y = height)
    vertex(x, y - k); // Add the wave points
  }
  // Fill the area below the wave by closing the shape
  vertex(width, height); // Move to the bottom right of the screen
  vertex(0, height); // Move to the bottom left of the screen
  endShape(CLOSE); // Close the shape and fill the area
}

// Draw the gold coins concentrated in the pile
void drawGoldCoins() {
  fill(255, 223, 0); // Gold color for the coins
  for (int i = 0; i < numGoldCoins; i++) {
    float x = goldCoins[i][0]; // Coin's x position within the pile area
    float y = goldCoins[i][1]; // Coin's y position
    float size = goldCoins[i][2]; // Coin's size
    ellipse(x, y, size, size); // Draw the coin as a yellow circle
    
    // Add sparkles around the coin
    if (random(1) < sparkleChance) {
      goldCoinSparkles.add(new Sparkle(x + random(-5, 5), y + random(-5, 5)));
    }
  }
}

// Draw the rubies concentrated in the pile
void drawRubies() {
  fill(255, 0, 0); // Red color for the rubies
  for (int i = 0; i < numRubies; i++) {
    float x = rubies[i][0]; // Ruby's x position within the pile area
    float y = rubies[i][1]; // Ruby's y position
    float size = rubies[i][2]; // Ruby's size
    ellipse(x, y, size, size); // Draw the ruby as a red circle
    
    // Add sparkles around the ruby
    if (random(1) < sparkleChance) {
      rubySparkles.add(new Sparkle(x + random(-5, 5), y + random(-5, 5)));
    }
  }
}

// Draw the sun in
void drawSun() {
  fill(255, 204, 0); // Yellow color for the sun
  ellipse(width - 100, 100, 80, 80); 
  
  // Draw sun rays
  for (int i = 0; i < 12; i++) {
    float angle = radians(i * 30); // Angle for the rays
    float rayLength = 40;
    float x1 = width - 100 + cos(angle) * 40;
    float y1 = 100 + sin(angle) * 40;
    line(width - 100, 100, x1, y1); // Draw the rays
  }
}

// Sparkle class for individual sparkles
class Sparkle {
  float x, y;
  float size;
  float alpha;
  
  Sparkle(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(3, 6);
    this.alpha = 255;
  }
  
  void update() {
    alpha -= 5; // Fade out the sparkle over time
  }
  
  void display() {
    fill(255, 255, 255, alpha); // White sparkle with fading opacity
    ellipse(x, y, size, size);
  }
  
  boolean isFinished() {
    return alpha <= 0; // Check if the sparkle has faded out
  }
}

// Update and draw all the sparkles
void updateAndDrawSparkles() {
  // Update and draw gold coin sparkles
  for (int i = goldCoinSparkles.size() - 1; i >= 0; i--) {
    Sparkle sparkle = goldCoinSparkles.get(i);
    sparkle.update();
    sparkle.display();
    if (sparkle.isFinished()) {
      goldCoinSparkles.remove(i); // Remove the sparkle if it has finished
    }
  }

  // Update and draw ruby sparkles
  for (int i = rubySparkles.size() - 1; i >= 0; i--) {
    Sparkle sparkle = rubySparkles.get(i);
    sparkle.update();
    sparkle.display();
    if (sparkle.isFinished()) {
      rubySparkles.remove(i); // Remove the sparkle if it has finished
    }
  }
}

// Function to draw the magnifying glass on the cursor
void drawMagnifyingGlass(float x, float y) {
  float glassRadius = 30; // Radius of the magnifying glass lens
  float handleLength = 40; // Length of the handle
  fill(255, 255, 255, 150); // Light grey for the lens
  ellipse(x, y, glassRadius * 2, glassRadius * 2); // Magnifying glass lens
  fill(100, 100, 100); // Dark grey for the handle
  rect(x + glassRadius - 5, y, handleLength, 8); // Draw the handle (rectangle)
}
