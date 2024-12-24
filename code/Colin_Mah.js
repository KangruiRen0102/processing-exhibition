let angle = 0; // Rotation angle for animation
let mergeFactor = 1; // Controls the merging of the spirals

function setup() {
  createCanvas(800, 800, WEBGL); // Canvas with WEBGL renderer for 3D
  background(0); // Black background
}

function draw() {
  background(0); // Reset the background each frame
  lights(); // Add 3D lighting
  translate(width / 2, height / 2, 0); // Center the spirals
  rotateY(angle); // Rotate around the Y-axis
  rotateX(angle * 0.5); // Add slight rotation around X-axis for depth
  noFill();

  // Draw the first spiral (gold, propagating upward)
  stroke(255, 215, 0); // Gold color
  draw3DSpiral(100, 0.1, 8, 6, 0, mergeFactor); // Upward spiral

  // Draw the second spiral (blue, propagating downward)
  stroke(0, 102, 255); // Blue color
  draw3DSpiral(100, 0.1, 8, -6, PI / 2, mergeFactor); // Downward spiral with offset

  // Update rotation and merging
  angle += 0.01; // Increment rotation angle
  mergeFactor = max(0, mergeFactor - 0.005); // Gradually reduce mergeFactor to 0
}

function draw3DSpiral(initialRadius, angleStep, rotations, verticalSpacing, offset, mergeFactor) {
  let goldenRatio = (1 + sqrt(5)) / 2; // Golden ratio
  let radius = initialRadius; // Starting radius
  let z = 0; // Initial Z position

  beginShape();
  for (let a = 0; a < TWO_PI * rotations; a += angleStep) {
    let x = radius * cos(a + offset) * (1 + mergeFactor); // Separate initially, merge over time
    let y = radius * sin(a + offset) * (1 + mergeFactor); // Separate initially, merge over time
    vertex(x, y, z); // Add 3D vertex to the shape
    radius *= pow(goldenRatio, angleStep / TWO_PI); // Expand radius by the golden ratio
    z += verticalSpacing; // Increment Z for 3D height
  }
  endShape();
}
