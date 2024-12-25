ArrayList<BloomingFlower> flowers = new ArrayList<>();
PGraphics grassBackground; // Offscreen buffer for static grassy background

void setup() {
  size(800, 800);
  noStroke();

  // Create the grassy background
  grassBackground = createGraphics(width, height);
  grassBackground.beginDraw();
  grassBackground.background(34, 139, 34); // Base grassy green color
  
  // Draw random grass blades
  grassBackground.stroke(29, 115, 29); // Darker green for blades
  for (int i = 0; i < 500; i++) {
    float x = random(width);
    float y = random(height);
    float length = random(10, 30);
    grassBackground.line(x, y, x, y - length);
  }
  grassBackground.noStroke();

  // Add patches of grass
  grassBackground.fill(0, 100, 0, 150); // Darker green with transparency
  for (int i = 0; i < 20; i++) {
    grassBackground.ellipse(random(width), random(height), random(20, 60), random(10, 30));
  }
  grassBackground.endDraw();
}

void draw() {
  // Draw the static grassy background
  image(grassBackground, 0, 0);

  // Update and display all flowers
  for (int i = flowers.size() - 1; i >= 0; i--) {
    BloomingFlower flower = flowers.get(i);
    flower.update();
    flower.display();
    // Remove flower if it has fully withered and faded out
    if (flower.isFadedOut()) {
      flowers.remove(i);
    }
  }

  // Draw clock in the upper-right corner
  drawClock(width - 100, 100, 50); // Position and size of the clock
}

// Add a new flower at the mouse position on click
void mousePressed() {
  flowers.add(new BloomingFlower(mouseX, mouseY, random(30, 60), millis()));
}

// Function to draw the spinning clock
void drawClock(float x, float y, float radius) {
  pushMatrix();
  translate(x, y);
  
  // Clock face
  fill(255); // White face
  ellipse(0, 0, radius * 2, radius * 2);
  stroke(0);
  strokeWeight(2);

  // Fast-moving clock hands
  float elapsedTime = millis() / 1000.0; // Total elapsed time in seconds
  float fastSecondAngle = TWO_PI * elapsedTime * 2; // 2 rotations per second

  // Draw the hour hand (shorter, spins slower)
  float hourAngle = fastSecondAngle / 12; // 12x slower
  strokeWeight(6);
  line(0, 0, radius * 0.4 * cos(hourAngle - HALF_PI), radius * 0.4 * sin(hourAngle - HALF_PI));

  // Draw the minute hand (longer, spins faster)
  float minuteAngle = fastSecondAngle; // Matches the fast spin
  strokeWeight(4);
  line(0, 0, radius * 0.6 * cos(minuteAngle - HALF_PI), radius * 0.6 * sin(minuteAngle - HALF_PI));

  // Draw the second hand (longest, spins fastest)
  strokeWeight(2);
  stroke(255, 0, 0); // Red second hand
  line(0, 0, radius * 0.8 * cos(minuteAngle - HALF_PI), radius * 0.8 * sin(minuteAngle - HALF_PI));

  // Clock center
  fill(0);
  noStroke();
  ellipse(0, 0, 8, 8);

  popMatrix();
}

// Class representing a blooming flower
class BloomingFlower {
  float x, y;              // Position of the flower
  float maxRadius;         // Maximum radius of the bloom
  float radius = 0;        // Current bloom radius
  float growSpeed;         // Growth speed
  float bloomStartTime;    // When the bloom was "planted"
  float lifespan;          // Lifespan of the flower in milliseconds
  ArrayList<Petal> petals; // List of petals
  boolean withering = false;
  float witherStartTime = 0; // Time when withering begins
  float alpha = 255;        // Transparency for fading out
  float blackTransition = 0; // Interpolation factor for fading to black
  color baseColor;          // Base color of the flower

  // Constructor
  BloomingFlower(float x, float y, float maxRadius, float startTime) {
    this.x = x;
    this.y = y;
    this.maxRadius = maxRadius;
    this.bloomStartTime = startTime;
    this.growSpeed = random(0.1, 0.3); // Slower growth speed
    this.lifespan = random(10000, 15000); // Lifespan: 10-15 seconds
    this.petals = new ArrayList<>();

    // Randomly assign a color theme
    int colorChoice = (int) random(5);
    if (colorChoice == 0) baseColor = color(0, 0, 255);         // Blue
    else if (colorChoice == 1) baseColor = color(255, 0, 0);    // Red
    else if (colorChoice == 2) baseColor = color(128, 0, 128);  // Purple
    else if (colorChoice == 3) baseColor = color(255, 255, 0);  // Yellow
    else if (colorChoice == 4) baseColor = color(255, 165, 0);  // Orange

    // Generate random petals for the flower
    int petalCount = (int) random(6, 12); // Random number of petals
    for (int i = 0; i < petalCount; i++) {
      petals.add(new Petal(random(50, 150), random(10, 50), random(0.05, 0.1)));
    }
  }

  // Update the bloom
  void update() {
    // Gradually increase the radius until it reaches the max, or stop growing if withering starts
    if (!withering && radius < maxRadius) {
      radius += growSpeed;
    }

    // Check if the flower's lifespan has been exceeded
    if (!withering && millis() - bloomStartTime > lifespan) {
      withering = true; // Start withering phase
      witherStartTime = millis(); // Record the time withering began
    }

    // Update petals only if not withering
    if (!withering) {
      for (Petal petal : petals) {
        petal.update();
      }
    }

    // Handle withering phase
    if (withering) {
      float witherElapsed = millis() - witherStartTime;

      if (witherElapsed <= 3000) {
        // Interpolate petal colors towards black over 3 seconds
        blackTransition = map(witherElapsed, 0, 3000, 0, 1);
      } else {
        // Gradually fade out the entire flower after fully transitioning to black
        alpha -= 2;
      }
    }
  }

  // Display the bloom or withered state
  void display() {
    if (alpha <= 0) return; // Do not draw if fully invisible

    if (!withering) {
      // Normal flower state
      fill(255, 200, 0, alpha); // Yellow core
      ellipse(x, y, radius * 0.2, radius * 0.2);

      // Draw each petal around the flower
      for (int i = 0; i < petals.size(); i++) {
        float angle = TWO_PI / petals.size() * i;
        petals.get(i).display(x, y, angle, radius, false, alpha, blackTransition, baseColor);
      }
    } else {
      // Withering state
      fill(lerpColor(color(255, 200, 0), color(0), blackTransition), alpha); // Core fades to black
      ellipse(x, y, radius * 0.2, radius * 0.2);

      for (int i = 0; i < petals.size(); i++) {
        float angle = TWO_PI / petals.size() * i;
        petals.get(i).display(x, y, angle, radius, true, alpha, blackTransition, baseColor);
      }
    }
  }

  // Check if the flower has fully faded out and can be removed
  boolean isFadedOut() {
    return alpha <= 0;
  }
}

// Class representing a petal
class Petal {
  float length, width, waveSpeed;
  float angleOffset = 0;

  // Constructor
  Petal(float length, float width, float waveSpeed) {
    this.length = length;
    this.width = width;
    this.waveSpeed = waveSpeed;
  }

  void update() {
    angleOffset += waveSpeed;
  }

  void display(float centerX, float centerY, float angle, float flowerRadius, boolean isWithering, float alpha, float blackTransition, color baseColor) {
    pushMatrix();
    translate(centerX, centerY);
    rotate(angle + (isWithering ? 0 : sin(angleOffset) * 0.2)); // Stop waving during withering
    color currentColor = isWithering ? lerpColor(baseColor, color(0), blackTransition) : lerpColor(baseColor, darkenColor(baseColor), (sin(angleOffset) + 1) / 2);
    fill(currentColor, alpha);
    ellipse(flowerRadius, 0, width, length);
    popMatrix();
  }

  color darkenColor(color c) {
    return color(red(c) * 0.5, green(c) * 0.5, blue(c) * 0.5);
  }
}
