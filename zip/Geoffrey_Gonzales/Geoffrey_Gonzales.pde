/////////---------------------------------------------------------------------------------------
// Sky Generation:
// Uses a simple linear gradient to mimic dawn/dusk

Sky sky;                           // "Sky" object to manage the background sky colors and their transitions
color sky1 = color(237, 165, 80);  // Lower sky color
color sky2 = color(0,92,159);      // Upper sky color

class Sky {  // Sets up class for sky
  color sky1, sky2;

  Sky(color c1, color c2) {  // Colors for the gradient transition of the sky
    sky1 = c1; 
    sky2 = c2;
  }

  void displaySky(int x, int y, float w, float h) {
    noFill();   // No fill for shapes since we're drawing lines.
    for (int i = y; i <= y + h; i++) {        // Loop through each vertical pixel line to create the gradient effect
      float inter = map(i, y, y + h, 0, 1);   // Calculates interpolation factor based on the current y position
      color c = lerpColor(sky1, sky2, inter); // Sets stroke color for the current line
      stroke(c);
      line(x, i, x + w, i); // Draws horizontal line for current y position
    }
  }
  
  // Changes upper sky color
  void changeSkyColor(color newskycolor) {
    sky1 = newskycolor;
  }
}


/////////---------------------------------------------------------------------------------------
// Sun Generation:
// Creates increasingly smaller, glowing layered circles by increasing opacity

void TheSun() {
  noStroke();   // Disables stroke for smooth shapes
  
  // Glowing effect of the sun
  float opacity1 = map(1, 0, 150, 100, 0);  // Opacity of outer ring
  fill(237, 165, 80, opacity1);             // Makes color and opacity of outer ring
  ellipse(500 + random(-0.3,0.3), 600 + random(-0.3,0.3), 310, 310); // Dictates size of ring and randomly 
                                                                     // shifts position to mimic shimmering effect
  
  // 
  for (int i = 1; i < 150; i = i + 2) {        // Loop for layered circles
    float opacity2 = map(i, 0, 150, 50, 0);    // Gradually increases the opacity as the ellipses get smaller
    fill(237, 165+float(i)/2, 80+i, opacity2); // Adjusts the color gradient for the "glow"
    ellipse(500, 600, 300-(2*i), 300-(2*i));   // Draws the concentric ellipses smaller and smaller
  }
}


/////////---------------------------------------------------------------------------------------
// Wave Generation:

ArrayList<Wave> waves = new ArrayList<Wave>(); // ArrayList to hold the 5 waves

class Wave {  // Sets up class for waves
  
  int wavespace;        // Distance between each wave particle
  float theta;          // Starting angle
  float amplitude;      // Amplitude of the wave
  float period;         // Period of the wave
  float dx;             // Incrementing x, function of period and xspacing
  float[] waveheights;  // Array to wave heights
  int ywave;            // Largest y position of the wave
  color waveColor;      // Color of the wave
  float dtheta;         // Speed & direction of wave

  // Constructor for the Wave class
  Wave(int wavespace, float amplitude, float period, int ywave, int width, color waveColor) {
    this.wavespace = wavespace;
    this.amplitude = amplitude;
    this.period = period;
    this.ywave = ywave;
    this.waveColor = waveColor;

    // Calculates dx and initialize waveheights array
    this.dtheta = random(-0.0025,0.0025) + 0.001;     // Small random variation in wave speed and direction
    this.dx = (TWO_PI / period) * wavespace;          // Step size for x based on period and wave spacing
    this.waveheights = new float[width / wavespace];  // Array to store wave heights for rendering
  }

  // Calculates the height of the waves
  void calcWave(int offsetY, float thetamod) {
    theta += dtheta + thetamod;                     // Updates the wave's phase (speed and direction)
    float x = theta;                                // Initializes x with the updated phase
    for (int i = 0; i < waveheights.length; i++) {
      waveheights[i] = sin(x) * amplitude + ywave + offsetY;  // Calculate the wave heights
      x += dx;                                                // Increments x for the next wave point
    }
  }

  // Displays the wave
  void WaveDisplay() {
    fill(waveColor);
    noStroke();
    for (int x = 0; x < waveheights.length; x++) {
      ellipse(x * wavespace, height / 2 + waveheights[x], 16, 16);  // Creates individual wave "particles"
    }
  }

  // Update the wave (calculate and render)
  void update() {
    for (int i = 0; i < 150; i = i + 15) {   // Loop through multiple vertical offsets in order to create a thicker wave
      calcWave(i,0);                         // Calculate wave heights for the given offset
      WaveDisplay();                          // Render the wave for this offset
    }
  }
}


/////////---------------------------------------------------------------------------------------
// Cloud Generation:

ArrayList<Cloud> clouds = new ArrayList<Cloud>(); // ArrayList to hold all clouds
color currentCloudColor;

class Cloud {  // Sets up class for clouds
  PVector position;            // Position of the cloud
  int numEllipses;             // Number of ellipses in the cloud
  float sizeRange;             // Range of sizes for the ellipses
  color cloudColor;            // Color of the cloud
  ArrayList<Ellipse> ellipses; // List of ellipses forming the cloud
  float opacity2 = map(1, 0, 150, 100, 0);  // Opacity of the cloud

  // Constructor for the Cloud class
  Cloud(float x, float y, int numEllipses, float sizeRange, color cloudColor) {
    this.position = new PVector(x, y);
    this.numEllipses = numEllipses;
    this.sizeRange = sizeRange;
    this.cloudColor = cloudColor;
    this.ellipses = new ArrayList<Ellipse>();

    // Generate random ellipses to form the cloud
    for (int i = 0; i < numEllipses; i++) {
      float xoffset = random(-sizeRange, sizeRange);         // Random x position
      float yoffset = random(-sizeRange / 3, sizeRange / 3); // Random y position
      float size = random(sizeRange / 2, sizeRange);         // Random size
      ellipses.add(new Ellipse(xoffset, yoffset, size));     // Creates and adds ellipses to ArrayList
    }
  }
  
  // Changes color of the cloud ellipses
  void setColor(color newColor) {
    this.cloudColor = newColor;
  }

  // Displays the cloud
  void CloudDisplay() {
    fill(cloudColor,opacity2);  // Sets the color and opacity
    noStroke();
    for (Ellipse e : ellipses) {  // Iterates through each ellipse in the ellipses list.
      ellipse(position.x + e.xoffset, position.y + e.yoffset, e.size, e.size/2);  // Dictates position, size, and shape of ellipse iteration
    }
  }

  // Inner class representing a single cloud ellipse
  class Ellipse {
    float xoffset;  // x offset from the cloud center
    float yoffset;  // y offset from the cloud center
    float size;     // Size of the ellipse

    Ellipse(float xoffset, float yoffset, float size) {
      this.xoffset = xoffset;
      this.yoffset = yoffset;
      this.size = size;
    }
  }
}


/////////---------------------------------------------------------------------------------------
// Rain Generation:

ArrayList<RainDrop> rain;   // ArrayList to hold the raindrops
boolean rainActive = false; // Determines if its raining or not

class RainDrop {  // Sets up class for raindrops
  float x, y;       // Position of the raindrop
  float speed;      // Falling speed
  float length = 5; // Length of the raindrop

  RainDrop(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }
  
  // Dictates the descent of the raindrop
  void RainFall() {
    y += speed;
    if (y > height) {   // Resets position when the raindrop falls out of the screen
      y = random(-height * 0.5, 0);
      x = random(width);
    }
  }
  
  // Displays the raindrop
  void RainDisplay() {         
    stroke(21,76,121);         // Raindrop color
    line(x, y, x, y + length); // Creates the "raindrop" line
  }
}


/////////---------------------------------------------------------------------------------------
/////////---------------------------------------------------------------------------------------
// Main Code

void setup() {
  size(1000, 800);
  frameRate(45);
  currentCloudColor = color(255, 240, 210);   // Initial cloud color
  sky = new Sky(sky2,sky1);

  // Create waves with different properties
  waves.add(new Wave(2, 25, 410, 150, width, color(46, 66, 100)));
  waves.add(new Wave(2, 20, 430, 200, width, color(80, 110,190)));
  waves.add(new Wave(2, 30, 380, 250, width, color(46, 70, 110)));
  waves.add(new Wave(2, 20, 350, 300, width, color(78, 100,180)));
  waves.add(new Wave(2, 30, 400, 350, width, color(50, 72, 115)));
  
  // Create initial clouds with different properties
  clouds.add(new Cloud(200, 200, 20, 90, color(255,240,210)));
  clouds.add(new Cloud(100, 100, 25, 100, color(255,240,210)));
  clouds.add(new Cloud(250, 300, 20, 80, color(255,240,210)));
  clouds.add(new Cloud(100, 250, 20, 70, color(255,240,210)));
  clouds.add(new Cloud(850, 300, 25, 120, color(255,240,210)));
  clouds.add(new Cloud(800, 150, 20, 90, color(255,240,210)));
  clouds.add(new Cloud(700, 250, 21, 80, color(255,240,210)));
  clouds.add(new Cloud(900, 50, 20, 90, color(255,240,210)));
  
  
  // Initializes raindrop code
  rain = new ArrayList<RainDrop>();
    for (int i = 0; i < 80; i++) {
      rain.add(new RainDrop(random(width), random(-height, 0), random(40, 50)));
    }
}


void draw() {
  background(255);
  sky.displaySky(0, 0, width, 600);
  TheSun();
  for (Wave wave : waves) {     // Iterate through each wave in the waves list to update its state.
    wave.update(); 
  }
  for (Cloud cloud : clouds) {  // Iterate through each cloud in the cloud list to update its state.
    cloud.setColor(currentCloudColor);
    cloud.CloudDisplay();
  } 
  
  for (RainDrop drop : rain) {  // Iterate through each raindrop in the raindrop list to update its state.
    if (rainActive) {
      drop.RainFall();
      drop.RainDisplay();
    }
  }
}


void mousePressed() {  
  if (mouseY > 350) {  // Restricts cloud location above circle
    stroke(0);
  } else {
      clouds.add(new Cloud(mouseX, mouseY, (int)random(15,20), 90, color(255,240,210))); // Adds a new cloud of random size when mouse is clicked
  }
}


void keyPressed() { 
  if (key == '1') {  // Sunrise Setting
      sky.changeSkyColor(color(0,92,159));
      currentCloudColor = color(255, 240, 210); 
      rainActive = false; 
  } else if (key == '2') { // Sunset Setting
      sky.changeSkyColor(color(124,58,85));
      currentCloudColor = color(196,164,167);
      rainActive = false;
  } else if (key == '3') {  // Stormy Setting
      sky.changeSkyColor(color(13,23,29));
      currentCloudColor = color(59,64,64); 
      rainActive = true;
  }
}


/////////---------------------------------------------------------------------------------------

// - Reference List -
// Sine Wave: https://processing.org/examples/sinewave.html
// Simple Linear Gradient: https://processing.org/examples/lineargradient.html
// Radial Gradients: https://processing.org/examples/radialgradient.html
