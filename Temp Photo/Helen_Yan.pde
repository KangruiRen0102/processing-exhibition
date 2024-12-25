void setup() {
  size(800, 600);
  background(30, 30, 100); // night sky background
  noLoop();
}

void draw() {

  drawBuildings();
  drawBorder();
  drawThinBorder();
}

void drawBuildings() { // array of buildings
  noStroke();
  for (int i = 0; i < 10; i++) {
    float buildingWidth = random(50, 100);
    float buildingHeight = random(200, 500);
    float x = i * 80 + random(-10, 10);
    float y = height - buildingHeight;

    fill(50, 50, 70);
    rect(x, y, buildingWidth, buildingHeight);

    drawWindows(x, y, buildingWidth, buildingHeight);
  }
}

void drawWindows(float x, float y, float w, float h) { // for windows on buildings
  fill(255, 215, 0); //  window lights
  int rows = int(h / 30);
  int cols = int(w / 20);
  for (int i = 1; i < rows; i++) {
    for (int j = 1; j < cols; j++) {
      if (random(1) > 0.5) {
        float wx = x + j * 15;
        float wy = y + i * 25;
        rect(wx, wy, 10, 10);
      }
    }
  }
}

void drawBorder() {
  noFill();
  stroke(255);
  strokeWeight(80);
  rect(0, 0, width, height);
}
void drawThinBorder() {
  noFill();
  stroke(0); // Black thin border
  strokeWeight(10); // Thin border
  rect(5, 5, width - 10, height - 10);
}
