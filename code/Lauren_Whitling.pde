
// Keywords: bloom, grow, frozen

Flower flower;
int stage = 0; 
int timer = 0; // Timer to track transitions

void setup() {
  size(600, 600);  // Set canvas size to 600x600 pixels
  flower = new Flower(width / 2, height - 100);  // Create flower object at the center of the canvas
}

void draw() {
  background(135, 206, 235); // Creates blue background

  // Update the flower state based on time
  timer++;  // Increment the timer by 1 each frame
  if (timer < 300) {
    stage = 0; // Growth stage for 5 seconds (0 to 300 frames)
  } else if (timer < 600) {
    stage = 1; // Bloom stage for 5 seconds (300 to 600 frames)
  } else if (timer < 900) {
    stage = 2; // Frozen stage for 5 seconds (600 to 900 frames)
  }

  // Display and update the flower based on the current stage
  if (stage == 0) {
    flower.grow(); // Flower is in the growth stage
  } else if (stage == 1) {
    flower.bloom(); // Flower is in the bloom stage
  } else if (stage == 2) {
    flower.freeze(); // Flower is in the frozen stage
  }

  flower.display(); // Draw the flower on the screen
}

// Flower class handles different states of the flower (growth, bloom, frozen)
class Flower {
  float x, y; // Position of the flower
  float stemHeight = 0; // Stem growth (starts at 0)
  float petalSize = 0; // Petal size (starts as a small bud)
  float centerSize = 8; // Initial center size (slightly larger)
  float leafSize = 0; // Leaf size (starts at 0)
  color petalColor = color(255, 105, 180); // Initial petal color (pink)
  boolean frosted = false; // Flag to indicate if the flower is frosted

  Flower(float x, float y) {
    this.x = x; // Set the x-position of the flower
    this.y = y; // Set the y-position of the flower
  }

  // Growth stage: Grow the stem, petals, center, and leaves
  void grow() {
    if (stemHeight < 200) {
      stemHeight += 1; // Increase stem height gradually
    }
    if (petalSize < 20) {
      petalSize += 0.1; // Grow the petals slightly
    }
    if (centerSize < 18) {
      centerSize += 0.05; // Grow the center slightly
    }
    if (leafSize < 30) {
      leafSize += 0.2; // Grow the leaves gradually
    }
    frosted = false; // Remove frost in the growth stage
  }

  // Bloom stage: Fully expand petals, center, and leaves
  void bloom() {
    if (petalSize < 80) {
      petalSize += 0.5; // Increase petal size to full bloom
    }
    if (centerSize < 55) {
      centerSize += 0.3; // Grow the center to fill the petals
    }
    if (leafSize < 50) {
      leafSize += 0.2; // Expand leaves 
    }
    petalColor = color(255, 105, 180); // Set petal color to vibrant pink
  }

  // Frozen stage: Apply frost effect to all parts of the flower
  void freeze() {
    frosted = true; // Enable frost effect
    petalColor = lerpColor(color(255, 105, 180), color(200, 230, 255), 0.5); // Change petal color to icy blue
  }

  // Display the flower
  void display() {
    pushMatrix(); // Preserve transparency settings

    // Draw frosted stem if the flower is frosted
    if (frosted) {
      stroke(180, 230, 255); // Frosty blue tone for the stem
    } else {
      stroke(0, 100, 0); // Green stem color if not frosted
    }
    strokeWeight(4); // Set stroke weight for drawing the stem
    line(x, y, x, y - stemHeight); // Draw the stem

    // Draw frosted leaves if the flower is frosted
    if (leafSize > 0) {
      if (frosted) {
        fill(200, 230, 255); // Frosty blue color for leaves
      } else {
        fill(34, 139, 34); // Forest green color for leaves
      }
      noStroke(); // No border for leaves
      ellipse(x - 20, y - stemHeight / 2, leafSize, leafSize / 2); // Left leaf
      ellipse(x + 20, y - stemHeight / 2, leafSize, leafSize / 2); // Right leaf
    }

    // Draw petals
    fill(petalColor); // Set the petal color
    for (int i = 0; i < 6; i++) { // Draw six petals
      float angle = radians(60 * i); // Set angle for each petal
      float px = x + cos(angle) * (petalSize * 0.7); // Position petals closer to the center
      float py = y - stemHeight + sin(angle) * (petalSize * 0.7); // Position petals closer vertically
      ellipse(px, py, petalSize, petalSize * 0.8); // Draw each petal
    }

    // Draw flower center
    if (frosted) {
      fill(200, 230, 255, 150); // Frosty center color (blueish)
    } else {
      fill(255, 204, 0); // Yellow center color
    }
    ellipse(x, y - stemHeight, centerSize, centerSize); // Draw the center

    popMatrix(); // Restore transparency settings
  }
}
