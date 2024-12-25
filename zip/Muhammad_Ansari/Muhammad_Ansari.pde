int numBuildings = 10; // Number of buildings in the skyline
float[] buildingHeights = new float[numBuildings]; // Heights of buildings
float[] buildingWidths = new float[numBuildings]; // Widths of buildings
float timeAngle = 0; // Angle for the sun movement
float mouseInfluence = 0; // Factor for mouse interaction
ArrayList<Snowflake> snowflakes = new ArrayList<Snowflake>(); // Snowflakes

void setup() {
  size(800, 600);
  noStroke();
  // Generate random building heights and widths
  for (int i = 0; i < numBuildings; i++) {
    buildingHeights[i] = random(height / 4, height / 2);
    buildingWidths[i] = random(width / 20, width / 10);
  }
  // Initialize snowflakes
  for (int i = 0; i < 200; i++) {
    snowflakes.add(new Snowflake());
  }
}

void draw() {
  background(135, 206, 235); // Sky blue
  drawSun();
  drawSkyline();
  drawShadows();
  drawSnow();

  // Update sun position
  timeAngle += 0.01;
  if (timeAngle > TWO_PI) timeAngle = 0;

  // Update mouse influence
  mouseInfluence = map(mouseX, 0, width, -100, 100);
}

void drawSkyline() {
  float xPos = 0;
  for (int i = 0; i < numBuildings; i++) {
    // Draw building base
    fill(50);
    rect(xPos, height - buildingHeights[i], buildingWidths[i], buildingHeights[i]);
    // Draw snow cap
    fill(255);
    rect(xPos, height - buildingHeights[i], buildingWidths[i], buildingHeights[i] / 10);
    xPos += buildingWidths[i] + 5; // Space between buildings
  }
}

void drawShadows() {
  fill(0, 0, 0, 50); // Transparent black for shadows
  float xPos = 0;
  float shadowOffset = map(cos(timeAngle), -1, 1, -100, 100) + mouseInfluence; // Shadows move back and forth and react to mouse
  for (int i = 0; i < numBuildings; i++) {
    float shadowWidth = buildingWidths[i] * 1.5;
    rect(xPos + shadowOffset, height, shadowWidth, -buildingHeights[i]);
    xPos += buildingWidths[i] + 5; // Space between shadows
  }
}

void drawSun() {
  float sunX = width / 2 + cos(timeAngle) * width / 3 + mouseInfluence;
  float sunY = height / 2 + sin(timeAngle) * height / 3;
  fill(255, 204, 0); // Sun yellow
  ellipse(sunX, sunY, 50, 50);
}

void drawSnow() {
  for (Snowflake flake : snowflakes) {
    flake.update();
    flake.display();
  }
}

class Snowflake {
  float x, y, speed;

  Snowflake() {
    x = random(width);
    y = random(-height, 0);
    speed = random(1, 3);
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
    ellipse(x, y, 5, 5);
  }
}
