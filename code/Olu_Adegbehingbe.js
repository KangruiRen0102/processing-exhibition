let numLayers = 6; // Number of layers to create the sense of depth
let maxShapes = 10; // Maximum number of shapes per layer
let offsets; // Offsets for animating the layers
let colors; // Colors for each layer

function setup() {
  createCanvas(800, 800);

  // Initialize offsets and colors for layers
  offsets = [];
  colors = [];
  for (let i = 0; i < numLayers; i++) {
    offsets.push([random(100), random(100)]); // Random X and Y offsets
    colors.push(color(random(100, 255), random(100, 255), random(100, 255), 100)); // Soft, rich colors
  }

  noStroke();
}

function draw() {
  background(20, 20, 40); // A deep background to suggest introspection

  for (let i = 0; i < numLayers; i++) {
    push();

    // Slowly move each layer over time to create the journey effect
    translate(
      offsets[i][0] + sin(frameCount * 0.01 + i) * 50,
      offsets[i][1] + cos(frameCount * 0.01 + i) * 50
    );

    // Draw shapes with scaling to suggest growth
    for (let j = 0; j < maxShapes; j++) {
      let scale = map(j, 0, maxShapes, 0.5, 3.0); // Larger shapes appear further back
      fill(colors[i]);
      ellipse(
        width / 2 + sin(frameCount * 0.02 + j) * 100 * scale,
        height / 2 + cos(frameCount * 0.02 + j) * 100 * scale,
        30 * scale,
        30 * scale
      );
    }

    pop();
  }

  // Central glowing point to symbolize self-discovery
  fill(255, 200, 0, 150);
  ellipse(width / 2, height / 2, 80, 80);
  fill(255, 255, 150, 200);
  ellipse(width / 2, height / 2, 50, 50);
}
