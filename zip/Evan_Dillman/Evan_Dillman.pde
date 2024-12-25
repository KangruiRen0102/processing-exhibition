// Parameters for controlling animation dynamics
float t = 0;           // Time variable for sinusoidal motion
int numCurves = 50;    // Number of curves to draw
int colorOffset = 0;   // Offset to vary colors over time

void setup() {
  size(800, 800);      // Set canvas size to 800x800 pixels
  background(0);       // Start with a black background
  noFill();            // Disable shape fill (we're drawing only outlines)
  frameRate(30);       // Set the frame rate to 30 frames per second
}

void draw() {
  // Fade the previous frame slightly to create a trail effect
  fill(0, 25);         // Semi-transparent black fill
  rect(0, 0, width, height); // Cover the entire canvas with this fade

  // Map mouse position to control frequency and amplitude of the curves
  float frequency = map(mouseX, 0, width, 0.05, 0.5); // Adjust curve frequency based on horizontal mouse position
  float amplitude = map(mouseY, 0, height, 200, 600); // Adjust curve amplitude based on vertical mouse position

  // Loop through and draw all Bézier curves
  for (int i = 0; i < numCurves; i++) {
    // Calculate transparency for each curve (more transparent for earlier curves)
    float alpha = map(i, 0, numCurves, 50, 255);
    
    // Set the stroke color for the current curve using the gradient function
    stroke(colorize(i, numCurves, alpha));
    
    // Set the stroke weight to vary from thin (1) to thick (4)
    strokeWeight(map(i, 0, numCurves, 1, 4));

    // Define control points for the Bézier curve
    float x1 = width / 2 + cos(t + i * frequency) * amplitude;    // Start point (x)
    float y1 = height / 2 + sin(t + i * frequency) * amplitude;   // Start point (y)
    float x2 = width / 2 + cos(t + i * frequency * 1.5) * amplitude;  // End point (x)
    float y2 = height / 2 + sin(t + i * frequency * 1.5) * amplitude; // End point (y)
    float cx1 = width / 2 + cos(t + i * frequency * 2) * amplitude * 1.2;  // Control point 1 (x)
    float cy1 = height / 2 + sin(t + i * frequency * 2) * amplitude * 1.2; // Control point 1 (y)
    float cx2 = width / 2 + cos(t + i * frequency * 2.5) * amplitude * 1.2; // Control point 2 (x)
    float cy2 = height / 2 + sin(t + i * frequency * 2.5) * amplitude * 1.2; // Control point 2 (y)

    // Draw the Bézier curve
    bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
  }

  // Increment time to animate curves
  t += 0.02;

  // Increment color offset to vary colors over time
  colorOffset += 1;
}

// Helper function to calculate gradient colors from blue to purple
color colorize(int curveIndex, int totalCurves, float alpha) {
  // Map the curve's position in the list to a gradient position (0 to 1)
  float gradientPosition = map(curveIndex, 0, totalCurves, 0, 1);

  // Interpolate between blue and purple using linear interpolation (lerp)
  float blue = lerp(255, 128, gradientPosition); // Blue fades to a purple-blue
  float red = lerp(0, 128, gradientPosition);   // Red increases for purple tint
  float green = lerp(0, 64, gradientPosition);  // Green remains low

  // Return the calculated color with specified transparency (alpha)
  return color(red, green, blue, alpha);
}
