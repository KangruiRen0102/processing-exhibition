// Variables for aurora animation
float[] auroraY;
float[] waveSpeed;
color[] auroraColors;
float[] auroraAmplitudes;

void setup() {
  size(800, 600);  // Canvas size
  auroraY = new float[5];  // Five aurora bands
  waveSpeed = new float[5];
  auroraColors = new color[5];
  auroraAmplitudes = new float[5];  // Amplitude for each aurora band
  
  // Initialize aurora properties
  for (int i = 0; i < auroraY.length; i++) {
    auroraY[i] = random(height / 10, height / 3);  // Randomize vertical position for each band
    waveSpeed[i] = random(0.001, 0.005);  // Very slow movement
    auroraColors[i] = color(random(100, 255), random(150, 255), random(255));  // Random color
    auroraAmplitudes[i] = random(20, 50);  // Randomize amplitude for more variation
  }
}

void draw() {
  // Background: Night sky with stars
  background(10, 20, 50);
  drawStars();
  
  // Draw aurora
  drawAurora();
  
  // Frozen sea
  drawFrozenSea();
}

// Function to draw shimmering stars
void drawStars() {
  for (int i = 0; i < 100; i++) {
    float x = random(width);
    float y = random(height / 2);
    noStroke();
    fill(255, 255, 255, random(150, 255));
    ellipse(x, y, random(1, 3), random(1, 3));
  }
}

// Function to draw aurora lights
void drawAurora() {
  noStroke();
  for (int i = 0; i < auroraY.length; i++) {
    fill(auroraColors[i], 80);
    beginShape();
    for (float x = 0; x <= width; x += 10) {
      // Use sine wave for vertical movement
      float y = auroraY[i] + sin(x * 0.02 + millis() * waveSpeed[i]) * auroraAmplitudes[i];
      vertex(x, y);
    }
    // Extend the aurora to cover most of the sky
    vertex(width, height / 4);  // Top end near the sky
    vertex(0, height / 4);  // Top end near the sky
    endShape(CLOSE);
  }
}

// Function to draw the frozen sea
void drawFrozenSea() {
  for (int i = 0; i < 10; i++) {
    float y = map(i, 0, 10, height / 2, height);
    fill(200, 220, 255, 100 - i * 10);
    rect(0, y, width, height / 10);
  }
}

// Interaction: Click to add dynamic shimmer
void mousePressed() {
  for (int i = 0; i < auroraColors.length; i++) {
    auroraColors[i] = color(random(100, 255), random(150, 255), random(255));
  }
}
