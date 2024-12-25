int scene = 0; // 0 = Day, 1 = Twilight, 2 = Night
ArrayList<ArrayList<PVector>> northernLights; // -----(Northern lights movement path)
ArrayList<PVector> stars; //  ----(star Array)
ArrayList<Building> buildings;
float northernLightsOffset = 0; //--- (Offset to move northern lights)

void setup() {
  size(800, 600);
  buildings = new ArrayList<Building>();
  northernLights = new ArrayList<ArrayList<PVector>>();
  stars = new ArrayList<PVector>();
  generateSmallTown();       // ----(Generate the layout of the "small town with house and store)
  generateNorthernLights();  // -----(Generate northern lights once)
  generateStars();           // ----(Generate stars once)
}

void draw() {
  switch (scene) {
    case 0:
      drawDayScene(); //(click**)
      break;
    case 1:
      drawTwilightScene(); //(click**)
      break;
    case 2:
      drawNightScene(); //(click**)
      break;
  }
}

void mousePressed() {
  scene = (scene + 1) % 3; // ---(Cycle through day, twilight, and night)
}

void drawDayScene() {
  background(135, 206, 235); // ---(Daytime blue sky)colour(light blue)

  // Sun
  fill(255, 223, 0);
  noStroke();
  ellipse(700, 100, 100, 100); // --(Sun in top-right corner) colour(yellow)

  drawTown(50, color(50, 50, 50)); // Dark gray silhouette
}

void drawTwilightScene() {
  for (int y = 0; y < height; y++) {
    float lerpFactor = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(255, 94, 58), color(64, 27, 110), lerpFactor));//(colour gradiant)
    line(0, y, width, y);
  }

  // Glowing sun near the horizon
  noStroke();
  fill(255, 150, 0, 200); // - - (Faint orange glow) (colour)
  ellipse(700, height - 100, 120, 120); // Sun near the horizon (circle)

  fill(255, 223, 0, 255); // Brighter center (colour gradient)
  ellipse(700, height - 100, 80, 80);

  drawTown(50, color(30, 30, 30)); // Black silhouette (same as before just darker)
}

void drawNightScene() {
  background(10, 15, 45); // Dark blue for night sky (colour - dark blue)
  
  drawNorthernLights(); // Pre-drawn, slightly moving northern lights (movement)

  drawStars(); // Static stars (no movement)

  // Moon
  fill(240, 240, 240);
  noStroke();
  ellipse(700, 100, 80, 80); // Moon in top-right corner (white - no movement)

  drawTown(50, color(30, 30, 30)); // Black silhouette
}

void drawNorthernLights() {
  northernLightsOffset += 0.005; // Slowly shift the noise offset for animation (shimmer/ movement effect)
  for (ArrayList<PVector> light : northernLights) {
    noFill();
    strokeWeight(10);
    for (int i = 0; i < light.size(); i++) {
      PVector p = light.get(i);
      float shift = sin(northernLightsOffset + i * 0.05) * 10; // Subtle vertical movement
      stroke(lerpColor(color(0, 255, 100, 100), color(50, 200, 255, 150), random(1)));
      line(p.x, p.y + shift, p.x + 10, p.y + shift);
    }
  }
}

void drawStars() {
  noStroke();
  fill(255);
  for (PVector star : stars) {
    ellipse(star.x, star.y, 2, 2); // Draw each star at its static position
  }
}

void drawTown(float baseHeight, color silhouetteColor) {
  fill(silhouetteColor);// - -- (same as dark)
  noStroke();
  
  rect(0, height - baseHeight, width, baseHeight); // Ground

  for (Building b : buildings) {
    // Draw building body
    rect(b.x, height - baseHeight - b.height, b.width, b.height);

    // Add peaked roof for houses
    if (b.type.equals("house")) {
      triangle(b.x, height - baseHeight - b.height, 
               b.x + b.width / 2, height - baseHeight - b.height - b.height / 3, 
               b.x + b.width, height - baseHeight - b.height);
    }

    // Draw windows  - - - (background color with white border)
    for (PVector window : b.windowPositions) {
      // Set the thivknress for the window borders to all be same
      strokeWeight(2); // ---(Fixed thickness for the window border)
      stroke(255); // White color for the border
      noFill();
      rect(b.x + window.x-0.8 , height - baseHeight - b.height/2 + window.y - 2, 20, 20); // Big window
      
      // Window "closed" (same color as the background)
      fill(175, 214, 255); // Same as sky color (closed window effect)
      noStroke();
      rect(b.x + window.x, height - baseHeight - b.height/2 + window.y, 18, 18); // Larger window size

        // Vertical line through the middle
      stroke(255); // White color for the lines
      line(b.x + window.x + 9, height - baseHeight - b.height/2 + window.y, 
           b.x + window.x + 9, height - baseHeight - b.height/2 + window.y + 18);

      // Horizontal line through the middle
      line(b.x + window.x, height - baseHeight - b.height/2 + window.y + 8, 
           b.x + window.x + 18, height - baseHeight - b.height/2 + window.y + 8);
           
    }

    // Store sign inside the store
    if (b.type.equals("store")) {
      fill(255);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("STORE", b.x + b.width / 2, height - baseHeight - b.height / 2); // Sign inside the store
    }

    fill(silhouetteColor); // Reset fill for next building
  }
}

void generateSmallTown() {
  // Set fixed count of buildings: 1 store and 2 houses
  float x = 50; // Start with some spacing from the left

  // House 1
  float houseWidth = 100;
  float houseHeight = 80;
  Building house1 = new Building(x, houseWidth, houseHeight, "house");
  house1.windowPositions.add(new PVector(houseWidth / 2 - 8, -houseHeight / 4)); // Lower and larger window
  buildings.add(house1);
  x += houseWidth + random(40, 60); // Add spacing

  // House 2
  float houseWidth2 = 100;
  float houseHeight2 = 80;
  Building house2 = new Building(x, houseWidth2, houseHeight2, "house");
  house2.windowPositions.add(new PVector(houseWidth2 / 2 - 8, -houseHeight2 / 4)); // Lower and larger window
  buildings.add(house2);
  x += houseWidth2 + random(40, 60); // Add spacing

  // Store (larger)
  float storeWidth = 200;  // Wider store
  float storeHeight = 120;
  Building store = new Building(x, storeWidth, storeHeight, "store");
  store.windowPositions.add(new PVector(storeWidth / 4 - 8, -storeHeight / 4)); // Lower and larger window
  store.windowPositions.add(new PVector(3 * storeWidth / 4 - 8, -storeHeight / 4)); // Lower and larger window
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
    stars.add(new PVector(random(width), random(height / 2))); // Random star positions
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
