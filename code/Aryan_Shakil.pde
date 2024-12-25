// "A frozen memory of my hometown, where snowflakes whisper stories of the past."

// Array to hold snowflakes
ArrayList<Snowflake> snowflakes = new ArrayList<>();
float windowAlpha = 0; // Alpha for window fading
boolean fadeDirection = true; // Direction of fading
boolean memoryEffect = false; // Toggle for memory effect

void setup() {
  size(800, 600);
  for (int i = 0; i < 100; i++) {
    snowflakes.add(new Snowflake());
  }
}

void draw() {
  if (memoryEffect) {
    background(80, 30, 40); // Dark red maroon hue
  } else {
    background(30, 40, 80); // Default dark blue twilight sky
  }

  // Update window alpha for fading effect
  updateWindowAlpha();

  // Draw city silhouette
  drawCitySilhouette();

  // Draw ground layer
  drawGroundLayer();

  // Draw snowflakes
  for (Snowflake s : snowflakes) {
    s.update();
    s.display();
  }
}

void mousePressed() {
  memoryEffect = !memoryEffect; // Toggle memory effect on mouse click
}

void updateWindowAlpha() {
  if (fadeDirection) {
    windowAlpha += 2;
    if (windowAlpha >= 255) {
      fadeDirection = false;
    }
  } else {
    windowAlpha -= 2;
    if (windowAlpha <= 50) { // Ensure windows don't fully disappear
      fadeDirection = true;
    }
  }
}

void drawGroundLayer() {
  fill(10, 10, 10); // Dark ground color
  noStroke();
  rect(0, height * 0.85, width, height * 0.15); // Ground layer at the bottom
}

void drawCitySilhouette() {
  noStroke();

  // Example city skyline with larger buildings and some spacing
  drawBuildingWithWindows(0, height * 0.4, width * 0.1, height * 0.6);
  drawBuildingWithWindows(width * 0.12, height * 0.3, width * 0.12, height * 0.7);
  drawBuildingWithWindows(width * 0.25, height * 0.5, width * 0.1, height * 0.5);
  drawBuildingWithWindows(width * 0.36, height * 0.35, width * 0.18, height * 0.65); // No space between these
  drawBuildingWithWindows(width * 0.54, height * 0.4, width * 0.1, height * 0.6);
  drawBuildingWithWindows(width * 0.66, height * 0.3, width * 0.15, height * 0.7); // No space between these
  drawBuildingWithWindows(width * 0.82, height * 0.5, width * 0.1, height * 0.5);
  drawBuildingWithWindows(width * 0.94, height * 0.4, width * 0.06, height * 0.6);
}

void drawBuildingWithWindows(float x, float y, float w, float h) {
  // Draw building
  fill(20, 20, 20); // Dark building color
  rect(x, y, w, h);

  // Draw windows
  fill(220, 220, 200, windowAlpha); // Off-white window color with fading alpha
  float windowSize = w * 0.15; // Window size relative to building width
  float spacing = w * 0.05; // Spacing between windows

  for (float i = x + spacing; i < x + w - windowSize; i += windowSize + spacing) {
    for (float j = y + spacing; j < y + h - windowSize; j += windowSize + spacing) {
      rect(i, j, windowSize, windowSize);
    }
  }
}

// Snowflake class
class Snowflake {
  float x, y, speed, size;

  Snowflake() {
    x = random(width);
    y = random(-height, 0);
    speed = random(1, 3);
    size = random(2, 5);
  }

  void update() {
    y += speed;
    if (y > height) {
      y = random(-height, 0);
      x = random(width);
    }
  }

  void display() {
    fill(255);
    noStroke();
    ellipse(x, y, size, size);
  }
}
