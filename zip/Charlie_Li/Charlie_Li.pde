// Colors for background transition
color twilightTop = color(120, 80, 180);  // Twilight color
color twilightBottom = color(255, 120, 80);
color auroraTop = color(0, 100, 255);     // Aurora color
color auroraBottom = color(0, 255, 150);

float transitionSpeed = 0.01; // Speed of background transition
float transition = 0;        // Transition progress
boolean twilightToAurora = true; // Direction of transition

int snowflakeCount = 300; // Number of snowflakes
Snowflake[] snowflakes = new Snowflake[snowflakeCount]; // Array to hold snowflakes

void setup() {
  size(800, 600);
  
  // Initialize snowflakes
  for (int i = 0; i < snowflakeCount; i++) {
    snowflakes[i] = new Snowflake();
  }
}

void draw() {
  // Transition between twilight and aurora
  if (twilightToAurora) {
    transition += transitionSpeed;
    if (transition > 1) {
      transition = 1;
      twilightToAurora = false;
    }
  } else {
    transition -= transitionSpeed;
    if (transition < 0) {
      transition = 0;
      twilightToAurora = true;
    }
  }

  // Calculate background colors
  color topColor = lerpColor(twilightTop, auroraTop, transition);
  color bottomColor = lerpColor(twilightBottom, auroraBottom, transition);

  // Draw gradient background
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    stroke(lerpColor(topColor, bottomColor, inter));
    line(0, y, width, y);
  }

  // Draw saddle-shaped mountain with white top
  noStroke();
  fill(50, 30, 20); // Base mountain color

  // Draw the mountain shape
  beginShape();
  vertex(0, height); // Left base of mountain
  for (float x = 0; x <= width; x++) {
    float y = height * 0.6 + 100 * sin(TWO_PI * (x / width)) * sin(TWO_PI * (x / width));
    
    // Interpolate the color based on height (white at the top)
    color mountainColor = lerpColor(color(255), color(50, 30, 20), map(y, height * 0.6, height * 0.6 - 100, 0, 1));
    fill(mountainColor);
    
    vertex(x, y);
  }
  vertex(width, height); // Right base of mountain
  endShape(CLOSE);

  // Draw snowflakes
  for (int i = 0; i < snowflakeCount; i++) {
    snowflakes[i].update();
    snowflakes[i].display();
  }
}

// Snowflake class to handle individual snowflakes
class Snowflake {
  float x, y; // Position of the snowflake
  float speed; // Falling speed of the snowflake
  float size;  // Size of the snowflake
  
  Snowflake() {
    // Randomly initialize snowflake properties
    x = random(width); // Random x position
    y = random(-height, 0); // Start above the screen
    speed = random(1, 3); // Random falling speed
    size = random(2, 6); // Random size
  }
  
  void update() {
    // Update the position of the snowflake
    y += speed;
    
    // If the snowflake reaches the bottom, reset to the top
    if (y > height) {
      y = random(-height, 0);
      x = random(width);
    }
  }
  
  void display() {
    // Draw the snowflake as a white circle
    noStroke();
    fill(255, 255, 255, 200); // White color with slight transparency
    ellipse(x, y, size, size);
  }
}
