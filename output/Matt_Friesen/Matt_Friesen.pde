
CivE265 - TP#2 Processing - Submission (Responses)
CivE265 - TP#2 Processing - Submission (Responses)
100%
mjfries
1 of 1
B17 mjfries1@ualberta.ca 
F17

int waveCount = 60;
float waveHeight;
float waveSpeed;
float growthSize = 10;
float growthSpeed = 0.3;

void setup() {
  size(800, 600);
  noStroke();
}

void draw() {
  // Background gradient for the sea
  background(0, 100, 200);
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(0, 100, 200), color(0, 0, 100), inter);
    stroke(c);
    line(0, i, width, i);
  }

  // Waves (symbolizing the challanges that come with change)
  for (int i = 0; i < waveCount; i++) {
    waveHeight = sin(radians(frameCount + (i * 180 / waveCount))) * 50 + 100;
    waveSpeed = sin(radians(frameCount * 200 + i)) * 2;
    ellipse(i * (width / waveCount), waveHeight, waveSpeed, 30);
  }

  // Growth: a shape that grows (symbolizing growth on the journey)
  fill(0, 200, 250); // Bright color for growth
  ellipse(width / 2, height / 2 + sin(radians(frameCount)) * 50, growthSize, growthSize);
  
  // Increase growth size to symbolize development
  growthSize += growthSpeed;
  if (growthSize > 200) {
    growthSize = 10;  // Reset size to represent ongoing growth
  }
}
 
Form_Responses1
 
 	
int waveCount = 60;
float waveHeight;
float waveSpeed;
float growthSize = 10;
float growthSpeed = 0.3;

void setup() {
  size(800, 600);
  noStroke();
}

void draw() {
  // Background gradient for the sea
  background(0, 100, 200);
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(0, 100, 200), color(0, 0, 100), inter);
    stroke(c);
    line(0, i, width, i);
  }

  // Waves (symbolizing the challanges that come with change)
  for (int i = 0; i < waveCount; i++) {
    waveHeight = sin(radians(frameCount + (i * 180 / waveCount))) * 50 + 100;
    waveSpeed = sin(radians(frameCount * 200 + i)) * 2;
    ellipse(i * (width / waveCount), waveHeight, waveSpeed, 30);
  }

  // Growth: a shape that grows (symbolizing growth on the journey)
  fill(0, 200, 250); // Bright color for growth
  ellipse(width / 2, height / 2 + sin(radians(frameCount)) * 50, growthSize, growthSize);
  
  // Increase growth size to symbolize development
  growthSize += growthSpeed;
  if (growthSize > 200) {
    growthSize = 10;  // Reset size to represent ongoing growth
  }
}
Turn on screen reader support
 
To enable screen reader support, press Ctrl+Alt+Z To learn about keyboard shortcuts, press Ctrl+slashGaang Lee has joined the document.Responder updated this value.