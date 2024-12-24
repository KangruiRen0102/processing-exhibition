// THEMATIC SENTENCE: "Through discovery, ideas bloom into innovation, fostering growth that shapes a brighter future."

// VARIABLES
let numPetals = 8; // Initial number of petals (Ideas taking shape)
let bloomFactor = 0; // Animation factor for smooth blooming (Gradual discovery)
let bloomSpeed = 0.03; // Speed of blooming (Steady growth over time)
let petalLength; // Length of each petal (The reach of innovation)
let center; // Central point of the flower (The core of opportunity)

function setup() {
  createCanvas(800, 800);
  center = createVector(width / 2, height / 2); // Core of the flower, symbolizing origin
  noStroke();
  frameRate(60);
}

function draw() {
  // BACKGROUND
  // Represents the vast unknown, a canvas of opportunity for discovery.
  background(10, 10, 30); // Dark navy background for elegance and depth

  // INTERACTIVITY: DYNAMIC PETALS AND GROWTH
  // Mouse X controls the number of petals (Ideas multiplying with exploration)
  numPetals = int(map(mouseX, 0, width, 5, 20)); 

  // Mouse Y controls the size of petals (The magnitude of innovation)
  petalLength = map(mouseY, 0, height, 50, 200);

  // Smooth blooming animation (Discovery is gradual and consistent)
  bloomFactor = lerp(bloomFactor, 1, bloomSpeed);

  // CORE OF THE FLOWER (The Origin of Ideas)
  // Represents the foundation of discovery, the seed from which innovation grows.
  fill(255, 200, 80); // Warm golden-yellow for hope and energy
  ellipse(center.x, center.y, 60, 60); // Stable center, the unshakable origin

  // DRAWING PETALS (Innovation in Action)
  // Each petal symbolizes an idea, radiating outward dynamically.
  for (let i = 0; i < numPetals; i++) {
    let angle = map(i, 0, numPetals, 0, TWO_PI); // Distributes petals evenly in a circle
    let x = center.x + cos(angle) * petalLength * bloomFactor;
    let y = center.y + sin(angle) * petalLength * bloomFactor;

    drawPetal(x, y, angle); // Creates a petal at the calculated position
  }

  // GLOW EFFECT (Future Potential)
  // Represents the intangible aura of progress and potential.
  fill(255, 255, 255, 30); // Soft white glow radiating possibility
  ellipse(center.x, center.y, petalLength * 2, petalLength * 2);
}

// PETAL CREATION FUNCTION
// Each petal represents a branch of discovery, colored with purpose and life.
function drawPetal(x, y, angle) {
  push(); 
  translate(x, y); // Move to petal position
  rotate(angle + HALF_PI); // Rotate outward to form a flower pattern

  // Gradient shading gives life and depth to each petal (Ideas are diverse and unique)
  for (let i = 0; i < 1; i += 0.1) {
    fill(lerpColor(color(255, 120, 180), color(180, 120, 255), i), 200); // Gradient: Pink to Lavender
    ellipse(0, i * -petalLength * 0.8, 30, 60); // Petal shape, gently tapering outward
  }
  pop();
}
