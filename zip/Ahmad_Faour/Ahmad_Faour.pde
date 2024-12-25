int numWaves = 10; // Number of waves
int numFish = 5;   // Number of fish
float sharkX = 50; // Initial shark position
float sharkSpeed = 0.5; // Shark speed
float waveSpeed = 0.02;
float time = 0;
boolean lightningActive = false;
float lightningTimer = 0;
float stormIntensity = 1.0;  // Control storm severity (1 = calm, 3 = extreme)
float boatX = width / 2;  // Boat position

void setup() {
  size(800, 600);
  noStroke();
}

void draw() {
  background(20, 50, 100); // Deep ocean color
  drawLightning();
  drawWaves();
  drawRain();
  drawMarineAnimals();
  drawBoat();
  time += waveSpeed * stormIntensity;  // Wave speed scales with storm intensity

  // Control lightning flicker
  lightningTimer -= 1 / 60.0;
  if (lightningTimer <= 0) {
    lightningActive = random(1) > 0.90 / stormIntensity;  // More frequent with higher intensity
    if (lightningActive) {
      lightningTimer = random(0.1, 0.2);
    }
  }
}

// Storm intensity control with keys
void keyPressed() {
  if (keyCode == UP) {
    stormIntensity = constrain(stormIntensity + 0.2, 1, 3);  // Max 3
  }
  if (keyCode == DOWN) {
    stormIntensity = constrain(stormIntensity - 0.2, 1, 3);  // Min 1
  }
  if (key == CODED) {
    if (keyCode == LEFT) boatX -= 10;
    if (keyCode == RIGHT) boatX += 10;
  }
}

void mousePressed() {
  // Trigger lightning instantly
  lightningActive = true;
  lightningTimer = 0.2;
}

// Lightning Effect
void drawLightning() {
  if (lightningActive) {
    fill(255, 255, 255, 150); // Flash effect
    rect(0, 0, width, height / 3);
    for (int i = 0; i < 3; i++) {
      float startX = random(width);
      float startY = random(height / 6);
      float endX = startX + random(-50, 50);
      float endY = startY + random(50, 150);
      stroke(255, 255, 255, 200);
      strokeWeight(2);
      line(startX, startY, endX, endY);
    }
    noStroke();
  }
}

// Wave Drawing (Affected by Storm Intensity)
void drawWaves() {
  for (int i = 0; i < numWaves; i++) {
    float waveY = map(i, 0, numWaves, height / 3, height / 2);
    for (float x = 0; x < width; x += 5) {
      float waveHeight = sin(x * 0.03 + time * (0.5 + i * 0.2)) * 20 * stormIntensity;
      fill(50, 100 + i * 10, 180 + i * 5, 150);
      ellipse(x, waveY + waveHeight, 10, 20);
    }
  }
}

// Rain Effect (Intensity Increases with Storm)
void drawRain() {
  for (int i = 0; i < 50 * stormIntensity; i++) {
    float rx = random(width);
    float ry = random(-50, height);
    stroke(200, 200, 255, 150);
    line(rx, ry, rx, ry + 10 * stormIntensity);
  }
}

// Marine Animals (Fish & Shark)
void drawMarineAnimals() {
  for (int i = 0; i < numFish; i++) {
    float fishX = map(i, 0, numFish, 50, width - 50);
    float fishY = height * 0.7 + sin(time + i) * 20;

    // Fish scatter if mouse is near
    if (dist(mouseX, mouseY, fishX, fishY) < 100) {
      fishX += random(-20, 20);
      fishY += random(-20, 20);
    }

    float size = random(15, 30);
    drawFish(fishX, fishY, size);
  }
  
  drawShark();
}

// Fish Drawing
void drawFish(float x, float y, float size) {
  fill(200, 100, 50);
  ellipse(x, y, size * 1.5, size);
  triangle(x - size * 0.8, y, x - size * 1.5, y - size * 0.5, x - size * 1.5, y + size * 0.5);
  fill(0);
  ellipse(x + size * 0.5, y, size * 0.2, size * 0.2);
}

// Shark Behavior
void drawShark() {
  float sharkY = height * 0.7 + sin(time * 0.5) * 30;
  float size = 70;
  
  sharkX = lerp(sharkX, mouseX, 0.02);

  fill(100, 100, 120);
  ellipse(sharkX, sharkY, size * 2, size);
  triangle(sharkX - size * 1.5, sharkY, sharkX - size * 2.2, sharkY - size * 0.6, sharkX - size * 2.2, sharkY + size * 0.6);
}

// Boat on Waves
void drawBoat() {
  float waveY = height / 3 + sin(boatX * 0.03 + time * 2) * 20 * stormIntensity;

  fill(150, 75, 0);  // Brown boat
  rect(boatX - 40, waveY - 20, 80, 40);  // Bigger boat
  fill(255);
  triangle(boatX, waveY - 50, boatX - 20, waveY - 20, boatX + 20, waveY - 20);  // Sail
}
