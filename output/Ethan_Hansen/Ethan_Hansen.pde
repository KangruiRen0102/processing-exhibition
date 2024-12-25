
// Class of buildings
class Building {
  float x, y, width, height;
  color buildingColor;
  boolean isHovered;
  boolean isRebuilding;
  float rebuildProgress;
  Building(float x, float y, float width, float height, color buildingColor) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.buildingColor = buildingColor;
    this.isHovered = false;
    this.isRebuilding = false;
    this.rebuildProgress = 1.0;
  }
//make the buildings chanhe to a new colour when rebuilt
  void display() {
    if (isRebuilding) {
      rebuildProgress += 0.005; // Slower rebuilding
      if (rebuildProgress == 0.0) {
        buildingColor = color(random(50, 200), random(50, 200), random(50, 200));
        while (buildingColor == color(34, 139, 34)) { // Prevent matching grass color
          buildingColor = color(random(50, 200), random(50, 200), random(50, 200));
        }
      }
      if (rebuildProgress >= 1.0) {
        rebuildProgress = 1.0;
        isRebuilding = false;
      }
    }

    float currentHeight = height * rebuildProgress;
    fill(isHovered ? color(255, 150, 150) : buildingColor);
    rect(x, y + height - currentHeight, width, currentHeight);

    // adding windows, ask alex for help to make these work
    fill(color(255, 255, 200));
    float windowSize = 15;
    float gap = 10;
    float floorHeight = 2 * (windowSize + gap); 
    for (float wx = x + gap; wx < x + width - gap; wx += windowSize + gap) {
      for (float wy = y + height - currentHeight + floorHeight; wy < y + height - gap - floorHeight; wy += windowSize + gap) {
        rect(wx, wy, windowSize, windowSize);
      }
    }
  }

  boolean contains(float px, float py) {
    return px > x && px < x + width && py > y + height - height * rebuildProgress && py < y + height;
  }
//change building to random colour when clicked
  void breakDown() {
    isRebuilding = true;
    rebuildProgress = 0.0;
    buildingColor = color(random(50, 200), random(50, 200), random(50, 200));
    while (buildingColor == color(34, 139, 34)) { // Prevent matching grass color
      buildingColor = color(random(50, 200), random(50, 200), random(50, 200));
    }
  }
}
// class repesenting the sky
class Sky {
  color dayColor;
  color nightColor;
  float transitionFactor; // 0 for day and 1 for night

  Sky(color dayColor, color nightColor) {
    this.dayColor = dayColor;
    this.nightColor = nightColor;
    this.transitionFactor = 0.0;
  }
  void update(float factor) {
    transitionFactor = constrain(factor, 0.0, 1.0);
  }
  void display(boolean isDay) {
    color currentColor = isDay ? dayColor : nightColor;
    background(currentColor);
  }
}



// Class for the Sun and Moon
class CelestialBody {
  float x, y, radius;
  color bodyColor;
  CelestialBody(float x, float y, float radius, color bodyColor) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.bodyColor = bodyColor;
  }
//shaping the moon and suns path
  void update(float time, boolean isDay) {
    x = map(time, 0, 1, -radius, width + radius);
    float peakHeight = height / 4;
    float a = -4 * peakHeight / pow(width + 2 * radius, 2); // Parabolic arc (y = -x^2)
    y = -a * pow(x - width / 2, 2) + peakHeight; // Flip path to start by going up

    // Adjust color for day or night
    bodyColor = isDay ? color(255, 204, 0) : color(200);
  }
  void display() {
    fill(bodyColor);
    noStroke();
    ellipse(x, y, radius, radius);
  }
}
// Class representing the river(for the flow)
class River {
  float x, y, width, height;
  color riverColor;
  float flowOffset;//(this one is to make it look like he river is flowing)
  River(float x, float y, float width, float height, color riverColor) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.riverColor = riverColor;
    this.flowOffset = 0;
  }

  void display() {
    flowOffset += 0.5;
    fill(riverColor);
    beginShape();
    for (float i = 0; i <= width; i += 20) {
      float yVariation = 10 * sin((i + flowOffset) * 0.1);
      vertex(x + i, y + yVariation);
    }
    vertex(width, y + height);
    vertex(x, y + height);
    endShape(CLOSE);
  }
}

// Global variables for the whole code
Sky sky;
CelestialBody sun, moon;
Building[] buildings;
River river;
float dayNightCycle = 0.0;
boolean isDay = true;
color groundColor = color(34, 139, 34); // Green for grass

void setup() {
  size(800, 600);
  // starting sky
  sky = new Sky(color(135, 206, 235), color(25, 25, 112));

  // strting Sun and Moon
  sun = new CelestialBody(-50, height / 4, 50, color(255, 204, 0));
  moon = new CelestialBody(-50, height / 4, 50, color(200));

  // starting buildings
  buildings = new Building[5];
  for (int i = 0; i < buildings.length; i++) {
    float bWidth = random(50, 100);
    float bHeight = random(150, 300);
    buildings[i] = new Building(i * 160 + 20, height - 150 - bHeight, bWidth, bHeight, color(random(50, 200), random(50, 200), random(50, 200)));
    while (buildings[i].buildingColor == groundColor) {
      buildings[i].buildingColor = color(random(50, 200), random(50, 200), random(50, 200));
    }
  }


  // river start
  river = new River(0, height - 100, width, 50, color(0, 0, 255));
}
void draw() {
  // Update the sky based on a daily cycle
  sky.update(dayNightCycle);
  sky.display(isDay);
  // Draw the ground
  fill(groundColor);
  rect(0, height - 150, width, 150); // Extend grass further up
  // Update celestial bodies
  if (isDay) {
    sun.update(dayNightCycle, true);
    sun.display();
  } else {
    moon.update(dayNightCycle, false);
    moon.display();
  }
  // show the river and buildings
  for (Building building : buildings) {
    building.isHovered = building.contains(mouseX, mouseY);
    building.display();
  }

  // Update day-night cycle
  river.display();
  if (isDay) {
    dayNightCycle += 0.002;
    if (dayNightCycle >= 1.0) {
      isDay = false;
    }
  } else {
    dayNightCycle -= 0.002;
    if (dayNightCycle <= 0.0) {
      isDay = true;
    }
  }
}


//make mouse click officially change the buldings
void mousePressed() {
  for (Building building : buildings) {
    if (building.contains(mouseX, mouseY)) {
      building.breakDown();
    }
  }
}
//I feel like I did to much making all these classes, but i couldnt think of another method to do it
