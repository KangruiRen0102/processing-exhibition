class ChaosShape {
  float x, y, size;
  color fillColor;

  ChaosShape(float x, float y, float size, color fillColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.fillColor = fillColor;
  }

  void display() {
    fill(fillColor, 150);
    noStroke();
    ellipse(x, y, size, size);
  }
}

class RadialLine {
  float angle, length;

  RadialLine(float angle, float length) {
    this.angle = angle;
    this.length = length;
  }

  void display(float centerX, float centerY) {
    float x = cos(angle) * length;
    float y = sin(angle) * length;
    stroke(255);
    strokeWeight(2);
    line(centerX, centerY, centerX + x, centerY + y);
  }
}

class FlowingWave {
  float offset;

  FlowingWave(float offset) {
    this.offset = offset;
  }

  void display() {
    noFill();
    stroke(255, 200, 0);
    strokeWeight(2);
    beginShape();
    for (float x = 0; x < width; x += 5) {
      float y = height / 2 + sin(x * 0.01 + offset) * 100;
      vertex(x, y);
    }
    endShape();
  }
}

ArrayList<ChaosShape> chaosShapes;
ArrayList<RadialLine> radialLines;
ArrayList<FlowingWave> flowingWaves;

void setup() {
  size(800, 800);
  noLoop();

  // Initialize chaotic shapes
  chaosShapes = new ArrayList<>();
  for (int i = 0; i < 150; i++) {
    float x = random(width);
    float y = random(height);
    float size = random(10, 50);
    color fillColor = color(random(100, 255), random(100, 255), random(100, 255));
    chaosShapes.add(new ChaosShape(x, y, size, fillColor));
  }

  // Initialize radial lines
  radialLines = new ArrayList<>();
  for (int i = 0; i < 50; i++) {
    float angle = TWO_PI / 50 * i;
    float length = 150;
    radialLines.add(new RadialLine(angle, length));
  }

  // Initialize flowing waves
  flowingWaves = new ArrayList<>();
  for (int i = 0; i < 10; i++) {
    flowingWaves.add(new FlowingWave(i * 15));
  }
}

void draw() {
  background(20);

  // Display chaotic shapes
  for (ChaosShape shape : chaosShapes) {
    shape.display();
  }

  // Display frozen moment (radial lines)
  pushMatrix();
  translate(width / 2, height / 2);
  for (RadialLine line : radialLines) {
    line.display(0, 0);
  }
  popMatrix();

  // Display flowing lines
  for (FlowingWave wave : flowingWaves) {
    wave.display();
  }
}
