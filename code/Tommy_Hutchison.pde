int currentState = 1; // This keeps track of which scene comes first
int numRaindrops = 200; // # of raindrops
Raindrop[] raindrops = new Raindrop[numRaindrops];
ArrayList<Cloud> clouds = new ArrayList<Cloud>(); // This stores the clouds for our second scene as a list
ArrayList<GrassBlade> grassBlades = new ArrayList<GrassBlade>(); // This stores the grass as a list

void setup() {
  size(800, 800); 
  frameRate(30);

  // Create the raindrops
  for (int i = 0; i < numRaindrops; i++) {
    raindrops[i] = new Raindrop();
  }
  // Create the clouds
  clouds.add(new Cloud(200, 150, 100));
  clouds.add(new Cloud(400, 100, 120));
  clouds.add(new Cloud(600, 200, 100));

  // Create the grass blades
  for (int x = 0; x < width; x += 10) {
    grassBlades.add(new GrassBlade(x, height, 40));
  }
}

void draw() {
  if (currentState == 1) {//The rainy scene
    background(169, 169, 169); // Makes the background grey and gloomy
    for (GrassBlade blade : grassBlades) {
      blade.display();
    }

    // Draw raindrops
    for (Raindrop drop : raindrops) {
      drop.update();
      drop.display();
    }

    // Draw the sprout
    drawSprout(width / 2, height - 100);
  } else if (currentState == 2) {
    // The sunny Scene
    background(135, 206, 250); // Makes the background Blue
    drawSun();//Draw the sun
    for (Cloud cloud : clouds) {// Display clouds
      cloud.display();
    }
    for (GrassBlade blade : grassBlades) {//Display Grass
      blade.display();
    }
    drawDaisy(width / 2, height / 2, 300);//Draw the daisy and leaves
    drawLeaves(width / 2, height / 2 + 300, 300);
  }
}
//switches the current scene
void mousePressed() {
  currentState = currentState == 1 ? 2 : 1;
}
// charcterisitics of raindrop
class Raindrop {
  float x, y, speed;

  Raindrop() {
    x = random(width);
    y = random(-500, -50);
    speed = random(4, 10);
  }

  void update() {
    y += speed;
    if (y > height) {
      y = random(-500, -50);
      x = random(width);
    }
  }

  void display() {
    stroke(0, 0, 255);
    line(x, y, x, y + 10);
  }
}
//Characteristics of clouds
class Cloud {
  float x, y, size;

  Cloud(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  void display() {
    fill(255);
    noStroke();
    ellipse(x, y, size, size * 0.6);
    ellipse(x + size * 0.3, y - size * 0.1, size * 0.8, size * 0.5);
    ellipse(x - size * 0.3, y + size * 0.1, size * 0.9, size * 0.5);
  }
}
//Characteristics for Grass
class GrassBlade {
  float x, baseY, height;

  GrassBlade(float x, float baseY, float height) {
    this.x = x;
    this.baseY = baseY;
    this.height = height;
  }

  void display() {
    fill(34, 139, 34);
    triangle(x, baseY, x + 5, baseY - height, x + 10, baseY);
  }
}
//Draws the sprout and gives it color
void drawSprout(float x, float y) {
  fill(34, 139, 34);
  noStroke();
  rect(x - 5, y, 10, 100);
}
//draws the daisy and creates the color of the stem and petals and position of them
void drawDaisy(float centerX, float centerY, float size) {
  float petalLength = size / 2;
  float petalWidth = size / 6;
  int petalCount = 20;

  fill(34, 139, 34);
  rect(centerX - size / 20, centerY + size / 2.9, size / 10, size);

  fill(255);
  noStroke();
  for (int i = 0; i < petalCount; i++) {
    float angle = TWO_PI / petalCount * i;
    float x = centerX + cos(angle) * size / 4;
    float y = centerY + sin(angle) * size / 4;
    pushMatrix();
    translate(x, y);
    rotate(angle);
    ellipse(0, 0, petalWidth, petalLength);
    popMatrix();
  }

  fill(255, 215, 0);
  ellipse(centerX, centerY, size / 3, size / 3);
}
//draws the leaves and gives it characteristics like position and colour
void drawLeaves(float centerX, float baseY, float size) {
  fill(34, 139, 34);
  noStroke();
  float leafSize = size / 6;

  pushMatrix();
  translate(centerX - size / 6, baseY - size / 4);
  rotate(-PI / 4);
  ellipse(0, 0, leafSize, leafSize * 2);
  popMatrix();

  pushMatrix();
  translate(centerX + size / 6, baseY - size / 4);
  rotate(PI / 4);
  ellipse(0, 0, leafSize, leafSize * 2);
  popMatrix();
}
//Draws the sun and gives it characteristics like the position,rays, or colours
void drawSun() {
  fill(255, 223, 0);
  ellipse(700, 100, 100, 100);
  stroke(255, 223, 0, 150);
  strokeWeight(3);
  for (int i = 0; i < 360; i += 15) {
    float angle = radians(i);
    float x1 = 700 + cos(angle) * 60;
    float y1 = 100 + sin(angle) * 60;
    float x2 = 700 + cos(angle) * 80;
    float y2 = 100 + sin(angle) * 80;
    line(x1, y1, x2, y2);
  }
  noStroke();
}
