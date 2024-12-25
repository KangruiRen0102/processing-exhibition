int sliderX, sliderY;   
int sliderWidth = 200;   
int sliderHeight = 10;   
int sliderPosX;         
boolean dragging = false; 
// Defining the slider

void setup() {
  size(800, 400);
  sliderX = width / 2 - sliderWidth / 2; 
  sliderY = height - 50; 
  sliderPosX = sliderX;  
}
// Implementing the slider's definitions

void draw() {
  
  float bgColor = map(sliderPosX, sliderX, sliderX + sliderWidth, 0, 255);
  background(200-bgColor, 197, 134); // Background changes based on slider position

  // Draw the sine wave
  drawSineWave();

  // Draw the slider
  drawSlider();
  
  //Draw the flowers
  drawFlowers();
}

void drawSineWave() {
  float amplitude = 100;
  float frequency = 0.01;
  float centerY = height / 2;

  stroke(68, 109, 198);
  for (int x = 0; x < width; x++) {
    float y = centerY + amplitude * sin(frequency * x);
    point(x, y);
    
   strokeWeight(30);
  }
}
//Defines the River/Sinewave

void drawFlowers() {
  float growthFactor = map(sliderPosX, sliderX, sliderX + sliderWidth, 10, 100);
   growthFactor = constrain(growthFactor, 10, 30); 


  // Set specific positions for flowers
  drawFlower(100, 200, growthFactor); // Left
  drawFlower(400, 50, growthFactor); // Middle
  drawFlower(500, 250, growthFactor); // Right
  drawFlower(700, 120, growthFactor);
}

void drawFlower(float x, float y, float size) {
  int petals = (int)map(sliderPosX, sliderX, sliderX + sliderWidth, 3, 10); // Number of petals
  float angleStep = TWO_PI / petals;

  pushMatrix();
  translate(x, y);

  // Draw petals
  fill(255, 100, 150); // Petal color
  noStroke();
  for (float angle = 0; angle < TWO_PI; angle += angleStep) {
    float px = cos(angle) * size;
    float py = sin(angle) * size;

    ellipse(px, py, size / 2, size); // Petal shape
  }

  // Draw flower center
  fill(255, 200, 50);
  ellipse(0, 0, size / 2, size / 2);

  popMatrix();
}


void drawSlider() {
  // Draw the slider track
  strokeWeight (3);
  stroke(0);
  fill(200);
  rect(sliderX, sliderY, sliderWidth, sliderHeight);

  // Draw the slider handle
  fill(50);
  ellipse(sliderPosX, sliderY + sliderHeight / 2, 20, 20);
}

void mousePressed() {
  // Check if the mouse is over the slider handle
  if (mouseX > sliderPosX - 10 && mouseX < sliderPosX + 10 &&
      mouseY > sliderY && mouseY < sliderY + sliderHeight) {
    dragging = true;
  }
}

void mouseDragged() {
  if (dragging) {
    // Move the slider handle within the track
    sliderPosX = constrain(mouseX, sliderX, sliderX + sliderWidth);
  }
}

void mouseReleased() {
  dragging = false;
}
