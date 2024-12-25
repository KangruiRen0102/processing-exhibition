PFont font;
int waveCount = 8; //how many waves there are 
float[] offsets;
ArrayList<Cloud> clouds = new ArrayList<Cloud>(); // list to store clouds

void setup() {
  size(800, 600);
  font = createFont("Georgia", 24);
  textFont(font);
  //assigning movement of waves
  offsets = new float[waveCount];
  for (int i = 0; i < waveCount; i++) {
    offsets[i] = random(TWO_PI); 
  }
         
}
//creating functions to elements in the art piece
void draw() {
  drawGradientBackground();
  drawMoon();
  drawSea();
  drawClouds();
}
//background functions and properties
void drawGradientBackground() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    int c = lerpColor(color(70, 130, 180), color(255, 105, 97), inter); //blue to pink
    c = lerpColor(c, color(255, 165, 0), inter * inter); //blend into orange lower down
    stroke(c);
    line(0, y, width, y);
  }
}

void drawMoon() {
  noStroke();
  fill(255, 255, 200, 100); //faint yellowish-white for the crescent
  ellipse(width * 0.8, height * 0.2, 50, 50); //moon's main body
  fill(70, 130, 180, 150); //match sky's blue to create crescent shape
  ellipse(width * 0.8 + 10, height * 0.2, 40, 50); //offset for crescent cut-out
}

void drawSea() {
  noStroke();
  for (int i = 0; i < waveCount; i++) {
    fill(10, 20 + i * 10, 50 + i * 15, 120); //dark blue tones with subtle transparency 
    beginShape();
    float y = height * 0.7 - i * 20;
    vertex(0, height);
    for (float x = 0; x <= width; x += 10) {
      float yOffset = sin(TWO_PI * (x / width) + millis() * 0.0002 + offsets[i]) * 20;
      vertex(x, y + yOffset);
    }
    vertex(width, height);
    endShape(CLOSE);
  }
}

void drawClouds() {
  for (int i = clouds.size() - 1; i >= 0; i--) {
    Cloud cloud = clouds.get(i);
    cloud.display();
    cloud.update();
    if (cloud.isFaded()) {
      clouds.remove(i);
    }
  }
}
 

//adding a new cloud when the mouse is moved
void mouseMoved() {
  clouds.add(new Cloud(mouseX, mouseY));
}

//cloud class
class Cloud {
  float x, y;
  float opacity;
  float size;

  Cloud(float x, float y) {
    this.x = x;
    this.y = y;
    this.opacity = 50;
    this.size = random(50, 100); //generates random size for the cloud
  }

  void display() {
    noStroke();
    fill(255, 255, 255, opacity); //white with variable opacity
    ellipse(x, y, size, size * 0.6); //central part
    ellipse(x - size * 0.4, y + size * 0.2, size * 0.6, size * 0.4); //left puff
    ellipse(x + size * 0.4, y + size * 0.2, size * 0.6, size * 0.4); //right puff
  }

  void update() {
    opacity -= 0.5; //gradually allow clouds to fade out
  }

  boolean isFaded() {
    return opacity <= 0;
  }
}
