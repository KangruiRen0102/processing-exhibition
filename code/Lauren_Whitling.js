let flower;
let stage = 0;
let timer = 0; // Timer to track transitions

function setup() {
  createCanvas(600, 600); // Set canvas size to 600x600 pixels
  flower = new Flower(width / 2, height - 100); // Create flower object at the center of the canvas
}

function draw() {
  background(135, 206, 235); // Creates blue background

  // Update the flower state based on time
  timer++; // Increment the timer by 1 each frame
  if (timer < 300) {
    stage = 0; // Growth stage for 5 seconds (0 to 300 frames)
  } else if (timer < 600) {
    stage = 1; // Bloom stage for 5 seconds (300 to 600 frames)
  } else if (timer < 900) {
    stage = 2; // Frozen stage for 5 seconds (600 to 900 frames)
  }

  // Display and update the flower based on the current stage
  if (stage === 0) {
    flower.grow(); // Flower is in the growth stage
  } else if (stage === 1) {
    flower.bloom(); // Flower is in the bloom stage
  } else if (stage === 2) {
    flower.freeze(); // Flower is in the frozen stage
  }

  flower.display(); // Draw the flower on the screen
}

// Flower class handles different states of the flower (growth, bloom, frozen)
class Flower {
  constructor(x, y) {
    this.x = x; // Set the x-position of the flower
    this.y = y; // Set the y-position of the flower
    this.stemHeight = 0; // Stem growth (starts at 0)
    this.petalSize = 0; // Petal size (starts as a small bud)
    this.centerSize = 8; // Initial center size (slightly larger)
    this.leafSize = 0; // Leaf size (starts at 0)
    this.petalColor = color(255, 105, 180); // Initial petal color (pink)
    this.frosted = false; // Flag to indicate if the flower is frosted
  }

  // Growth stage: Grow the stem, petals, center, and leaves
  grow() {
    if (this.stemHeight < 200) {
      this.stemHeight += 1; // Increase stem height gradually
    }
    if (this.petalSize < 20) {
      this.petalSize += 0.1; // Grow the petals slightly
    }
    if (this.centerSize < 18) {
      this.centerSize += 0.05; // Grow the center slightly
    }
    if (this.leafSize < 30) {
      this.leafSize += 0.2; // Grow the leaves gradually
    }
    this.frosted = false; // Remove frost in the growth stage
  }

  // Bloom stage: Fully expand petals, center, and leaves
  bloom() {
    if (this.petalSize < 80) {
      this.petalSize += 0.5; // Increase petal size to full bloom
    }
    if (this.centerSize < 55) {
      this.centerSize += 0.3; // Grow the center to fill the petals
    }
    if (this.leafSize < 50) {
      this.leafSize += 0.2; // Expand leaves
    }
    this.petalColor = color(255, 105, 180); // Set petal color to vibrant pink
  }

  // Frozen stage: Apply frost effect to all parts of the flower
  freeze() {
    this.frosted = true; // Enable frost effect
    this.petalColor = lerpColor(color(255, 105, 180), color(200, 230, 255), 0.5); // Change petal color to icy blue
  }

  // Display the flower
  display() {
    push(); // Preserve transformation settings

    // Draw stem
    stroke(this.frosted ? color(180, 230, 255) : color(0, 100, 0)); // Frosted or green stem color
    strokeWeight(4);
    line(this.x, this.y, this.x, this.y - this.stemHeight); // Draw the stem

    // Draw leaves
    if (this.leafSize > 0) {
      fill(this.frosted ? color(200, 230, 255) : color(34, 139, 34)); // Frosted or green leaves
      noStroke();
      ellipse(this.x - 20, this.y - this.stemHeight / 2, this.leafSize, this.leafSize / 2); // Left leaf
      ellipse(this.x + 20, this.y - this.stemHeight / 2, this.leafSize, this.leafSize / 2); // Right leaf
    }

    // Draw petals
    fill(this.petalColor);
    for (let i = 0; i < 6; i++) {
      let angle = radians(60 * i);
      let px = this.x + cos(angle) * (this.petalSize * 0.7);
      let py = this.y - this.stemHeight + sin(angle) * (this.petalSize * 0.7);
      ellipse(px, py, this.petalSize, this.petalSize * 0.8);
    }

    // Draw flower center
    fill(this.frosted ? color(200, 230, 255, 150) : color(255, 204, 0));
    ellipse(this.x, this.y - this.stemHeight, this.centerSize, this.centerSize);

    pop(); // Restore transformation settings
  }
}
