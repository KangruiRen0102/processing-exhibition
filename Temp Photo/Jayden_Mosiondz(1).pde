PImage home;
PGraphics highResBackground;

boolean expandSmallerCircle = false;  // Flag to control the expansion of the smaller circle
float smallerRadius = 40;  // Smaller starting radius of the smaller circle
float largerSize = 300;  // Size of the larger square
float growthSpeed = 1.5;  // Speed at which the smaller circle expands
float time = 0;  // Timer for animation

void setup() {
  size(800, 800);  // Canvas size
  home = loadImage("home.jpg");  // Load the image
  if (home == null) {
    println("Image not loaded. Check file name and location.");
    exit();
  }

  // Create off-screen graphics for higher resolution background
  highResBackground = createGraphics(1920, 1080);  // Set higher resolution for background
  home.resize(highResBackground.width, highResBackground.height);
  highResBackground.beginDraw();
  highResBackground.image(home, 0, 0);
  highResBackground.endDraw();
}

void draw() {
  image(highResBackground, 0, 0, width, height);  // Display the high-res background image

  // Center the drawing coordinates
  translate(width / 2, height / 2);  // Move the origin to the center of the canvas

  // Draw the transparent square with black outline and thicker border
  noFill();  // Remove fill (makes it transparent)
  stroke(0);  // Set the outline color to black
  strokeWeight(5);  // Set a thicker border for the square
  rectMode(CENTER);  // Rectangle centered on the origin
  rect(0, 0, largerSize, largerSize);  // Draw square with larger size

  // Draw the smaller expanding circle
  stroke(200, 100, 50);
  beginShape();
  for (float angle = 0; angle < TWO_PI; angle += 0.1) {
    // If mouse is clicked, the smaller circle grows faster
    float radius = expandSmallerCircle ? smallerRadius + growthSpeed * time : smallerRadius;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);

  // Increase time for the smaller circle growth if expanding
  if (expandSmallerCircle) {
    time += 0.05;  // Faster growth after mouse click
  }
}

// Detect mouse click to start the expansion of the smaller circle
void mousePressed() {
  expandSmallerCircle = true;  // Start expanding the smaller circle
  growthSpeed = 2.5;  // Increase the growth speed after click
}
