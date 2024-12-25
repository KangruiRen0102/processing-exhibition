float cont = 0;
PImage sky;
color colorSkyDark, colorSkyLight; // Colors for the sky 
PVector[] stars = new PVector[256];

// Wave 
int xspacing = 8;   // Spacing between horizontal locations
int w;              // Width of entire wave
int maxwaves = 4;   // Total number of waves

float theta = 0.0;
float[] amplitude = new float[maxwaves];   // Wave heights
float[] dx = new float[maxwaves];          // Increment values for the wave. Incrementing X, to be calculated as a function of period and xspacing
float[] yvalues;                           // Stores wave height values using an array

// Bubbles
Bubble[] bubbles = new Bubble[20];
Bubble selectedBubble = null;

// Initializes canvas and settings
void setup() {
  size(1400, 800); // Set the canvas size
  colorMode(HSB, 360, 100, 100); // Color mode

  colorSkyDark = color(261, 58, 9); // Dark sky color
  colorSkyLight = color(270, 72, 21); // Light sky color
  
  // Create sky gradient
  sky = createImage(width, height, HSB); 
  sky.loadPixels(); // Loads sky as pixels
  background(colorSkyDark); // Sets background
  for (int i = 0; i < height; i++) { // Create initial sky 
    color col = lerpColor(colorSkyDark, colorSkyLight, map(i, 0, height, 0, 1));
    for (int j = 0; j < width; j++) {
      sky.set(j, i, col); // Sets sky
    }
  }
  sky.updatePixels(); // Update pixels for the sky
  
  // Initialize stars
  for (int a = 0; a < stars.length; a++) {
    float x = random(width);
    float y = random(height);
    stars[a] = new PVector(x, y);
  }
  
  // Initialize wave
  frameRate(30);
  w = width + 16;

  for (int i = 0; i < maxwaves; i++) {
    amplitude[i] = random(10,30); // Wave amplitude
    float period = random(100,300); // How many pixels before the wave repeats (wave period)
    dx[i] = (TWO_PI / period) * xspacing;
  }

  yvalues = new float[w/xspacing];
  
  // Initialize bubbles
  for (int i = 0; i < bubbles.length; i++) {
    bubbles[i] = new Bubble(random(width), random(height), random(30, 60)); // Sets size for each bubble
  }
}
 
// The draw function runs continuously to create animation
void draw() {
  image(sky, 0, 0); // Display the sky
  background(0); // Background set to black 
    
  // Draw wave
  calcWave();
  renderWave();
  
  int lineWidth = 3;
  strokeWeight(lineWidth); // Sets line width
  strokeCap(SQUARE); // Sets stroke shape as a square
  for (int i = 0; i < width/lineWidth; i++) {
    float y1 = sin(cont + i * 0.01 * noise(cont)) * noise(cont) * height/6 + noise(i, millis() * 0.001) * height/4;
    float y2 = height/3 * 2 + sin(cont + i * (0.012 * noise(cont))) * (noise(cont) * height/4) + noise(i, millis() * 0.001) * 20;
    float levels = (y2 - y1) / 20;
    // og HUE 88
    float hue = map(sin((millis() + i) * 0.0001), -1, 1, 0, 130);
    for (float j = y1; j < y2; j += levels) {
      stroke(hue, map(j, y1, y2, 60, 40) + noise(i, millis() * 0.002) * 20, 80 + noise(i, millis() * 0.002) * 20, map(j, y1, y2, 0, 150));
      if (j < y2 - 10) {
        line(i * lineWidth, j, i * lineWidth, j + levels);
      } else {
        line(i * lineWidth, j, i * lineWidth, y2);
      }
    }
    int amp = 30;
    float y3 = y2 - amp * 1.5 * noise(i, millis() * 0.002);
    float y4 = y2 + amp * noise(i, (millis() + 2000) * 0.002);
    int cont = amp/3;
    float levels2 = (y4 - y3) / cont;
    for (float j = y3; j < y4; j += levels2) {
      float alpha = sin(cont * 0.35 + 2.4) * 255;
      cont++;
      stroke(hue, map(j, y3, y4, 40, 0) + noise(i, millis() * 0.002) * 20, 80 + noise(i, millis() * 0.002) * 20, alpha);
      line(i * lineWidth, j, i * lineWidth, j + levels2);
    }
  }

  cont += 0.01;
  
  // Draw bubbles
    for (Bubble bubble : bubbles) {
      bubble.display(); // Displays each bubble
    }
}

void mousePressed() {
  for (Bubble bubble : bubbles) {
    bubble.handleMouseClick();
    if (bubble.isMouseOver()) {
      selectedBubble = bubble;
      break;
    }
  }
}

// Move the selected bubble with the mouse
void mouseDragged() {
  if (selectedBubble != null) {
    selectedBubble.x = mouseX;
    selectedBubble.y = mouseY;
  }
}

// Release the selected bubble
void mouseReleased() {
  selectedBubble = null;
}

// Calculate wave height values 
void calcWave() {
  theta += 0.02; // Increment theta

  // Set all height values to zero
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = 0;
  }
 
  // Accumulate wave height values
  for (int j = 0; j < maxwaves; j++) {
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      // Every other wave is cosine instead of sine
      if (j % 2 == 0)  yvalues[i] += sin(x)*amplitude[j];
      else yvalues[i] += cos(x)*amplitude[j];
      x+=dx[j];
    }
  }
}

// Render the wave
void renderWave() {
  noStroke();
  fill(255,50); // Fill color 
  ellipseMode(CENTER);
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing,height/2+yvalues[x],16,16); // Creates ellipses throughout sine wave
  }
}

// Bubble class
class Bubble {
  float x, y, r; // Position and radius 
  color baseColor, hoverColor, clickColor; // Creates variables for different colors of bubbles
  boolean clicked = false;

  Bubble(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    baseColor = color(random(100, 200), random(100, 200), random(100, 200)); // Creates random colors
    hoverColor = color(random(200, 255), random(150, 255), random(150, 255)); // Creates random colors when mouse is hovered over bubble
    clickColor = color(random(255), random(255), random(255)); // Creates random colors when mouse clicks bubble
  }
  
  // Method to display the bubbles
  void display() {
    if (clicked) {
      fill(clickColor); // Sets the fill color when clicked
    } else if (isMouseOver()) {
      fill(hoverColor); // Sets the fill color when hovered over
    } else {
      fill(baseColor); // Sets a base color 
    }
    noStroke();
    ellipse(x, y, r * 2, r * 2); // Makes bubbles circular
  }
  
  boolean isMouseOver() { // Changes color when mouse is dragged/hovers over a bubble
    return dist(mouseX, mouseY, x, y) < r;
  }

  void handleMouseClick() { // Clicking bubble changes its color
    if (isMouseOver()) {
      clicked = !clicked; // Toggle clicked state
    }
  }
}
