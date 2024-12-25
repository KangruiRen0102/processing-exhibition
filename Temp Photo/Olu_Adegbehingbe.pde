int numLayers = 6; // Number of layers to create the sense of depth
int maxShapes = 10; // Maximum number of shapes per layer
float[][] offsets; // Offsets for animating the layers
color[] colors; // Colors for each layer

void setup() {
  size(800, 800);
  
  // Initialize offsets and colors for layers
  offsets = new float[numLayers][2];
  colors = new color[numLayers];
  for (int i = 0; i < numLayers; i++) {
    offsets[i][0] = random(100); // Random X offset
    offsets[i][1] = random(100); // Random Y offset
    colors[i] = color(random(100, 255), random(100, 255), random(100, 255), 100); // Soft, rich colors
  }
  
  noStroke();
}

void draw() {
  background(20, 20, 40); // A deep background to suggest introspection

  for (int i = 0; i < numLayers; i++) {
    pushMatrix();
    
    // Slowly move each layer over time to create the journey effect
    translate(offsets[i][0] + sin(frameCount * 0.01 + i) * 50, offsets[i][1] + cos(frameCount * 0.01 + i) * 50);
    
    // Draw shapes with scaling to suggest growth
    for (int j = 0; j < maxShapes; j++) {
      float scale = map(j, 0, maxShapes, 0.5, 3.0); // Larger shapes appear further back
      fill(colors[i]);
      ellipse(
        width / 2 + sin(frameCount * 0.02 + j) * 100 * scale,
        height / 2 + cos(frameCount * 0.02 + j) * 100 * scale,
        30 * scale, 30 * scale
      );
    }
    
    popMatrix();
  }

  // Central glowing point to symbolize self-discovery
  fill(255, 200, 0, 150);
  ellipse(width / 2, height / 2, 80, 80);
  fill(255, 255, 150, 200);
  ellipse(width / 2, height / 2, 50, 50);
}

// Key function breakdown:
// - setup(): Initializes the canvas and assigns colors and offsets for each layer.
// - draw(): Continuously updates and animates the layers, creating depth and a sense of dynamic motion.
// - Layer animation: Uses sinusoidal offsets for smooth movement to represent the journey.
// - Scaling: Gradually scales the shapes in each layer to suggest progress and growth.
// - Central glow: Represents the core of self-reflection and enlightenment.

// The interplay of colors, motion, and layering creates a rich, immersive piece, embodying a journey of personal growth and discovery.
