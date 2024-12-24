// Scene management variables
int scene = 0; // 0 = Day, 1 = Twilight, 2 = Night
ArrayList<ArrayList<PVector>> northernLights; // Paths for the northern lights
ArrayList<PVector> stars; // Star positions
ArrayList<Building> buildings; // Town buildings
float northernLightsOffset = 0; // Offset for moving the northern lights

void setup() {
  size(800, 600);
  buildings = new ArrayList<Building>();
  northernLights = new ArrayList<ArrayList<PVector>>();
  stars = new ArrayList<PVector>();
  generateSmallTown(); // Generate the town with houses and stores
  generateNorthernLights(); // Generate the initial northern lights paths
  generateStars(); // Generate the starfield
}

void draw() {
  switch (scene) {
    case 0:
      drawDayScene(); // Render the day scene
      break;
    case 1:
      drawTwilightScene(); // Render the twilight scene
      break;
    case 2:
      drawNightScene(); // Render the night scene
      break;
  }
}

void mousePressed() {
  scene = (scene + 1) % 3; // Cycle through day, twilight, and night
}

void drawDayScene() {
  background(135, 206, 235); // Light blue sky
  fill(255, 223, 0);
  noStroke();
  ellipse(700, 100, 100, 100); // Sun in the top-right corner
  drawTown(50, color(50, 50, 50)); // Draw the town with a dark gray silhouette
}

void drawTwilightScene() {
  for (int y = 0; y < height; y++) {
    float lerpFactor = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(255, 94, 58), color(64, 27, 110), lerpFactor)); // Gradient from orange to purple
    line(0, y, width, y);
  }
  noStroke();
  fill(255, 150, 0, 200); // Faint orange glow
  ellipse(700, height - 100, 120, 120); // Glow near the horizon
  fill(255, 223, 0);
  ellipse(700, height - 100, 80, 80); // Brighter sun core
  drawTown(50, color(30, 30, 30)); // Darker silhouette
}

void drawNightScene() {
  background(10, 15, 45); // Dark blue sky
  drawNorthernLights(); // Render the moving northern lights
  drawStars(); // Render the starfield
  fill(240, 240, 240);
  noStroke();
  ellipse(700, 100, 80, 80); // Moon
  drawTown(50, color(30, 30, 30)); // Black silhouette
}

void drawNorthernLights() {
  northernLightsOffset += 0.005; // Animate the northern lights
  for (ArrayList<PVector> light : northernLights) {
    noFill();
    strokeWeight(10);
    for (int i = 0; i < light.size(); i++) {
      PVector p = light.get(i);
      float shift = sin(northernLightsOffset + i * 0.05) * 10; // Subtle wave effect
      stroke(lerpColor(color(0, 255, 100, 100), color(50, 200, 255, 150), random(1)));
      line(p.x, p.y + shift, p.x + 10, p.y + shift);
    }
  }
}

void drawStars() {
  noStroke();
  fill(255);
  for (PVector star : stars) {
    ellipse(star.x, star.y, 2, 2); // Static stars
  }
}

void drawTown(float baseHeight, color silhouetteColor) {
  fill(silhouetteColor);
  noStroke();
  rect(0, height - baseHeight, width, baseHeight); // Ground
  for (Building b : buildings) {
    rect(b.x, height - baseHeight - b.height, b.width, b.height); // Building body
    if (b.type.equals("house")) {
      triangle(b.x, height - baseHeight - b.height, 
               b.x + b.width / 2, height - baseHeight - b.height - b.height / 3, 
               b.x + b.width, height - baseHeight - b.height); // Roof
    }
    for (PVector window : b.windowPositions) {
      strokeWeight(2);
      stroke(255);
      noFill();
      rect(b.x + window.x - 0.8, height - baseHeight - b.height / 2 + window.y - 2, 20, 20);
      fill(175, 214, 255);
      noStroke();
      rect(b.x + window.x, height - baseHeight - b.height / 2 + window.y, 18, 18);
      stroke(255);
      line(b.x + window.x + 9, height - baseHeight - b.height / 2 + window.y, 
           b.x + window.x + 9, height - baseHeight - b.height / 2 + window.y + 18);
      line(b.x + window.x, height - baseHeight - b.height / 2 + window.y + 8, 
           b.x + window.x + 18, height - baseHeight - b.height / 2 + window.y + 8);
    }
    if (b.type.equals("store")) {
      fill(255);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("STORE", b.x + b.width / 2, height - baseHeight - b.height / 2);
    }
  }
}

void generateSmallTown() {
  float x = 50; // Initial offset
  Building house1 = new Building(x, 100, 80, "house");
  house1.windowPositions.add(new PVector(50 - 8, -20)); // Window position
  buildings.add(house1);
  x += 140; // Spacing
  Building house2 = new Building(x, 100, 80, "house");
  house2.windowPositions.add(new PVector(50 - 8, -20));
  buildings.add(house2);
  x += 140;
  Building store = new Building(x, 200, 120, "store");
  store.windowPositions.add(new PVector(50 - 8, -30));
  store.windowPositions.add(new PVector(150 - 8, -30));
  buildings.add(store);
}

void generateNorthernLights() {
  for (int i = 0; i < 10; i++) {
    ArrayList<PVector> light = new ArrayList<PVector>();
    float xStart = random(0, width);
    float xEnd = xStart + random(100, 200);
    float yStart = random(100, 200);
    float yEnd = yStart + random(50, 150);
    for (float x = xStart; x <= xEnd; x += 10) {
      float y = lerp(yStart, yEnd, noise(x * 0.01));
      light.add(new PVector(x, y));
    }
    northernLights.add(light);
  }
}

void generateStars() {
  for (int i = 0; i < 100; i++) {
    stars.add(new PVector(random(width), random(height / 2)));
  }
}

class Building {
  float x, width, height;
  String type;
  ArrayList<PVector> windowPositions;

  Building(float x, float width, float height, String type) {
    this.x = x;
    this.width = width;
    this.height = height;
    this.type = type;
    this.windowPositions = new ArrayList<PVector>();
  }
}
