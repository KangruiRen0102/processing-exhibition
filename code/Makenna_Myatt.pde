// Northern Lights Art in Processing
// Theme: "The Northern Lights guide a path through the endless expanse of time."

// Global variables for aurora behavior
float auroraAmplitude; // Controls the height of the aurora waves
float auroraFrequency = 0.02; // Frequency of the sinusoidal waves
float timeOffset = 0; // Phase offset for aurora animation
boolean chaosMode = false; // Toggles chaotic color mode
int chaosTimer = 0; // Timer for switching between chaos and normal modes

void setup() {
  // Set up the canvas size, frame rate, and initial aurora amplitude
  size(800, 600);
  frameRate(60);
  noStroke();
  auroraAmplitude = 100;
}

void draw() {
  // Render the gradient background to simulate the night sky
  backgroundGradient();

  // Update aurora amplitude dynamically based on mouse position
  auroraAmplitude = map(mouseX, 0, width, 50, 150);

  // Handle chaos mode toggling with a randomized timer
  if (chaosTimer <= 0) {
    chaosMode = !chaosMode; // Toggle chaos mode
    chaosTimer = chaosMode ? int(random(60, 120)) : int(random(240, 360)); // Set timer duration
  }
  chaosTimer--;

  // Draw the "Northern Lights" using sinusoidal waves
  for (int y = 100; y < height / 2; y += 20) {
    aurora(y, auroraAmplitude, auroraFrequency + y * 0.0005, timeOffset + y * 0.02);
  }

  // Increment the time offset to create smooth aurora animation
  timeOffset += 0.05;

  // Draw a clock to represent the passage of time
  clock();
}

// Function to draw the background gradient
void backgroundGradient() {
  for (int i = 0; i < height; i++) {
    // Interpolate between two colors to create a gradient
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(10, 10, 50), color(0, 0, 0), inter);
    stroke(c);
    line(0, i, width, i);
  }
}

// Function to draw a sinusoidal wave representing the Northern Lights
void aurora(int yOffset, float amplitude, float frequency, float phase) {
  beginShape();
  for (int x = 0; x <= width; x++) {
    // Calculate the y-coordinate of the wave using the sine function
    float y = yOffset + sin(x * frequency + phase) * amplitude;
    fillAuroraColor(y, yOffset, amplitude); // Set the color dynamically
    vertex(x, y); // Add vertex to the shape
  }
  vertex(width, height); // Close the shape at the bottom
  vertex(0, height);
  endShape(CLOSE);
}

// Function to set the color of the aurora dynamically
void fillAuroraColor(float y, int yOffset, float amplitude) {
  if (chaosMode) {
    // In chaos mode, use random colors for the aurora
    fill(random(100, 255), random(100, 255), random(100, 255), 150);
  } else {
    // In normal mode, blend colors based on the aurora position
    float green = map(y, yOffset - amplitude, yOffset + amplitude, 100, 255);
    float pink = map(y, yOffset - amplitude, yOffset + amplitude, 150, 255);
    float blue = map(y, yOffset - amplitude, yOffset + amplitude, 200, 255);
    fill(green, pink, blue, 150);
  }
}

// Function to draw a clock representing the concept of time
void clock() {
  pushMatrix();
  translate(width / 2, height / 2); // Center the clock on the canvas

  float waveEffect = sin(timeOffset) * 20; // Tie clock motion to aurora animation

  // Draw hour hand with a dynamic length
  stroke(0, 255, 150);
  strokeWeight(6);
  line(0, 0, cos(frameCount * 0.05) * (70 + waveEffect), sin(frameCount * 0.05) * (70 + waveEffect));

  // Draw minute hand with a dynamic length
  stroke(255, 105, 180);
  line(0, 0, cos(frameCount * 0.1) * (100 + waveEffect), sin(frameCount * 0.1) * (100 + waveEffect));

  popMatrix();

  // Add a glowing effect around the clock
  for (int i = 0; i < 50; i += 10) {
    noFill();
    stroke(50, 255 - i, 150 + i, 100 - i); // Gradual transparency and color change
    ellipse(width / 2, height / 2, 150 + i, 150 + i); // Draw concentric circles
  }
}
