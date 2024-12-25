/// The following code makes Snowflakes and sets an variables for snowflakes, mountains, and a boat
int numSnowflakes = 500; 
ArrayList<Snowflakes> Snowflakes;
Mountain mountain;
Boat boat;
/// The following code sets the Snowflakes speed initially and then keeps track of the mouse clicks to keep the speed constant for 0 mouse clicks
float snowSpeed = 1; 
int clickCount = 0; 

void setup() {
  size(800, 600);

/// The following code makes mountains across the landscape
  mountain = new Mountain(height / 2, 100, width);

/// The following code makes Snowflakes appear all across the screen 
  Snowflakes = new ArrayList<Snowflakes>();
  for (int i = 0; i < numSnowflakes; i++) {
    Snowflakes.add(new Snowflakes(random(width), random(-height, height), random(2, 5), random(1, 3)));
  }

/// The following code makes a boat during the sunset scene
  boat = new Boat(width / 2, height / 2 + 100, 100, 20);

  noStroke();
}
// The following code makes Snowflakes fall at normal speed with no clicks, fall at fast speed with 1 click and transition to a sunset or sunrise scene with 2 click
void draw() {
  if (clickCount == 0) {
    drawchaoticsnowstorm();
    for (Snowflakes flake : Snowflakes) {
      flake.update(snowSpeed);
      flake.display();
    }
  } else if (clickCount == 1) {
    snowSpeed = 5;
    drawchaoticsnowstorm();
    for (Snowflakes flake : Snowflakes) {
      flake.update(snowSpeed);
      flake.display();
    }
  } else {
    drawSunsetSunrisescene();
    boat.display();
  }
}

// The following code makes a busy snow storm scene with dark moving clouds, mountains and a lake
void drawchaoticsnowstorm() {
  background(50, 60, 70); 
  fill(40, 40, 50);
  for (int i = 0; i < 6; i++) { 
    float cloudX = i * width / 6 + random(-30, 30);
    float cloudY = random(50, 150);
    ellipse(cloudX, cloudY, 200, 60);
    ellipse(cloudX - 50, cloudY + 20, 150, 50);
    ellipse(cloudX + 50, cloudY + 20, 150, 50);
  }
  mountain.display();
  fill(30, 60, 120);
  rect(0, height / 2 + 50, width, height / 2);
}

// The following code makes the sunrise/sunset scene
void drawSunsetSunrisescene() {
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    int r = (int)lerp(255, 255, inter);
    int g = (int)lerp(94, 60, inter);
    int b = (int)lerp(77, 120, inter);
    stroke(r, g, b);
    line(0, i, width, i);
  }

// The following code makes a half sun appear behind the mountains
  fill(255, 204, 0); 
  ellipse(100, height / 2 + 50, 150, 150); 
  mountain.displaySilhouette();

// The following code reflects the sunset/rise sky onto the lake
  fill(255, 94, 77, 150); 
  rect(0, height / 2 + 50, width, height / 2);
}
// The following code stops anymore changes for clicks past 2
void mousePressed() {
  clickCount++;
  if (clickCount > 2) {
    clickCount = 2; 
  }
}

// The following code makes a class for Snowflakes and make them fall down the screen at speeds 
class Snowflakes {
  float x, y, size, speed;
  Snowflakes(float x, float y, float size, float speed) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
  }
  void update(float multiplier) {
    y += speed * multiplier;
    if (y > height) {
      y = random(-50, -10);
      x = random(width);
    }
  }
  void display() {
    fill(255);
    ellipse(x, y, size, size);
  }
}

//The following code makes a mountain class and makes the mountains, sets the diameters/constraints for them and adds snow ontop/on of them
class Mountain {
  float baseHeight, noiseScale, width;
  float[] heights;
  Mountain(float baseHeight, float noiseScale, int width) {
    this.baseHeight = baseHeight;
    this.noiseScale = noiseScale;
    this.width = width;
    heights = new float[width];
    for (int i = 0; i < width; i++) {
      heights[i] = baseHeight + noise(i * 0.01) * noiseScale - 50;
    }
  }
  void display() {
    fill(100, 100, 120);
    beginShape();
    for (int i = 0; i < width; i++) {
      vertex(i, heights[i]);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    fill(255);
    beginShape();
    for (int i = 0; i < width; i++) {
      vertex(i, heights[i] - 20);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  void displaySilhouette() {
    fill(50, 50, 70);
    beginShape();
    for (int i = 0; i < width; i++) {
      vertex(i, heights[i]);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// The following code makes a class for the boat, makes the boat on the lake and puts a person in the boat watching the sunset/rise
class Boat {
  float x, y, width, height;
  Boat(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
  void display() {
    fill(139, 69, 19); 
    rect(x - width / 2, y, width, height); 
    triangle(x - width / 2 - 10, y, x - width / 2, y + height, x - width / 2, y);
    triangle(x + width / 2 + 10, y, x + width / 2, y + height, x + width / 2, y);
    fill(0); 
    ellipse(x, y - 10, 15, 15);
    rect(x - 5, y, 10, 20);
  }
}
