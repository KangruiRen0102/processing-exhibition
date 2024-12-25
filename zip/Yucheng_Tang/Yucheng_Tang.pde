int numBands = 8;  // Number of aurora bands
float[] offsets;  // Offset for each band
float speed = 0.01;  // Speed of movement
int snowflakes = 200; // Number of snowflakes
float[] snowX = new float[snowflakes];
float[] snowY = new float[snowflakes];
float[] snowSpeed = new float[snowflakes];

color auroraColor1 = color(0, 255, 150);  // Initial aurora color
color auroraColor2 = color(100, 0, 255);  // Initial aurora color
float snowFallSpeed = 1.0;  // Initial snow falling speed

void setup() {
  size(800, 600);  // Canvas size
  noStroke();
  offsets = new float[numBands];
  for (int i = 0; i < numBands; i++) {
    offsets[i] = random(1000);  // Initialize random offsets for Perlin noise
  }
  
  // Initialize snowflake positions
  for (int i = 0; i < snowflakes; i++) {
    snowX[i] = random(width);
    snowY[i] = random(height);
    snowSpeed[i] = random(1, 3);
  }
}

void draw() {
  background(10, 10, 30);  // Dark sky background
  
  // Draw Aurora
  drawAurora();
  
  // Draw snow-covered ground
  drawSnowGround();
  
  // Draw houses on the ground
  drawHouses();
  
  // Draw falling snow
  drawSnow();
}

void drawAurora() {
  for (int i = 0; i < numBands; i++) {
    float xStart = 0;  // Start from the left edge
    float xEnd = width;  // Cover the entire canvas width

    for (float x = xStart; x < xEnd; x++) {
      float alpha = map(x, xStart, xEnd, 150, 0);  // Gradual transparency
      float noiseValue = noise(offsets[i] + x * 0.01);  // Use Perlin noise for smooth movement
      float yWave = map(noiseValue, 0, 1, -100, 100);  // Aurora waviness
      
      fill(lerpColor(auroraColor1, auroraColor2, noiseValue), alpha);  // Aurora color gradient
      rect(x, yWave + height / 2 - 200, 1, 200);  // Draw a thin vertical rectangle
    }
    offsets[i] += speed;  // Move the noise offset for animation
  }
}

void drawSnow() {
  for (int i = 0; i < snowflakes; i++) {
    fill(255, 200); // Semi-transparent snowflakes
    noStroke();
    ellipse(snowX[i], snowY[i], 5, 5); // Draw snowflake
    snowY[i] += snowSpeed[i] * snowFallSpeed; // Snowfall animation
    if (snowY[i] > height) {
      snowY[i] = 0; // Reset snowflake to the top
      snowX[i] = random(width); // Randomize horizontal position
    }
  }
}

void drawSnowGround() {
  fill(240);  // White snow
  rect(0, height - 100, width, 100);  // Snow-covered ground
}

void drawHouses() {
  fill(60, 40, 200); // Dark brown for house walls
  for (int i = 0; i < 5; i++) {
    float houseX = i * 160 + 40;
    rect(houseX, height - 180, 80, 80); // House base
    fill(255, 200); // Windows
    rect(houseX + 20, height - 160, 20, 20);
    rect(houseX + 50, height - 160, 20, 20);
    fill(200, 40, 50); // Roof color
    triangle(houseX - 10, height - 180, houseX + 40, height - 220, houseX + 90, height - 180); // Roof
  }
}

void mousePressed() {
  // Change aurora colors randomly when mouse is clicked
  auroraColor1 = color(random(255), random(255), random(255));
  auroraColor2 = color(random(255), random(255), random(255));

  // Randomize the snow falling speed
  snowFallSpeed = random(0.5, 3.0); 
}
