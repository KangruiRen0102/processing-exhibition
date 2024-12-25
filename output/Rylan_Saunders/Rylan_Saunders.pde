int numWaves = 10;
float[] offsets;
float time = 0;
float[] hoverTimes; // Track when each wave is being hovered over by the mouse
float brightDuration = 0.3; // Duration for the wave to brighten
boolean[] waveActive; // Track whether the mouse is hovering over the wave

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100); // Use HSB for colours
  offsets = new float[numWaves];
  hoverTimes = new float[numWaves];
  waveActive = new boolean[numWaves];
  
  // Creating offsets and hover states for waves
  for (int i = 0; i < numWaves; i++) {
    offsets[i] = random(1000);
    hoverTimes[i] = -brightDuration;
    waveActive[i] = false;
  }
}

void draw() {
  background(10, 20, 20); // Dark background for night sky
  
  // Drawing flowing waves
  for (int i = 0; i < numWaves; i++) {
    drawWave(i);
  }
  
  // Making the animation take longer so it is smoother
  time += 0.02;
}

void drawWave(int waveIndex) {
  noFill();
  
  float waveY = map(waveIndex, 0, numWaves - 1, height, 0); // Vertical position
  float hue = (waveIndex * 30 + frameCount * 0.5) % 360; // Gradual hue shift
  float mouseProximity = abs(mouseY - waveY); // Distance from the mouse to the wave
  
  // Checking if the mouse is hovering over the wave
  if (mouseProximity < 30) { // Adjust this value to define the hover range
    if (!waveActive[waveIndex]) {
      hoverTimes[waveIndex] = time; // Record the time the wave is first hovered over by the mouse
      waveActive[waveIndex] = true;
    }
  } else {
    if (waveActive[waveIndex]) {
      hoverTimes[waveIndex] = time; // Record the time when the wave stops being hovered over by the mouse
      waveActive[waveIndex] = false;
    }
  }
  
  // Calculating the brightnesss transition based on how long the mouse has been hovering
  float activeTime = time - hoverTimes[waveIndex];
  float brightTransition = map(activeTime, 0, brightDuration, 0, 1);
  
  // Applying colour transition to a brighter version of the original colour
  color waveColor;
  if (waveActive[waveIndex]) {
    waveColor = lerpColor(color(hue, 80, 80), color(hue, 100, 100), brightTransition); // Transition to brighter colour
  } else {
    waveColor = color(hue, 80, 80); // Default aurora colour
  }
  
  // Drawing the waves
  stroke(waveColor);
  strokeWeight(waveActive[waveIndex] ? 4 : 2); // Thicker stroke for glowing effect when hovering
  
  beginShape();
  for (float x = 0; x <= width; x += 10) {
    float noiseFactor = noise(x * 0.01, offsets[waveIndex], time);
    float y = waveY + sin(x * 0.02 + offsets[waveIndex] + time) * 50 * noiseFactor;
    vertex(x, y);
  }
  endShape();
  
  // Updating wave offset for movement
  offsets[waveIndex] += (waveActive[waveIndex] ? 0.05 : 0.005); // Increase speed when mouse is hovering over it
}
