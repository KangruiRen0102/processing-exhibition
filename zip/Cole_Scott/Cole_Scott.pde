// Variables for the waves
float[] waveOffsets;
float waveSpeed = 0.02;
int numWaves = 10;

// Variables for the aurora
float[][] auroraPoints;
int auroraLayers = 12;
int auroraSegments = 200;
float auroraSpeed = 0.002;

// Variables for the ship
float shipX, shipY;
float shipAmplitude = 20; // Amplitude of sine wave for ships travel
float WaveFrequency = 0.013; // Frequency of sine waves
float shipBaseY; // Base height for the wave

// List for all the stars
ArrayList<Star> stars = new ArrayList<>(); 

void setup() {
  size(1920, 1080, P3D); // Use 3D canvas
  background(15, 20, 60); // Make a Night sky background
  
  // Initializes waves
  waveOffsets = new float[numWaves];
  for (int i = 0; i < numWaves; i++) {
    waveOffsets[i] = random(1000); // Randomizes wave offsets
  }
  
  // Initializes aurora points
  auroraPoints = new float[auroraLayers][auroraSegments];
  for (int i = 0; i < auroraLayers; i++) {
    for (int j = 0; j < auroraSegments; j++) {
      auroraPoints[i][j] = random(5, 300);
    }
  }

  // Initializes ship position
  shipX = width / 2;
  shipBaseY = height / 1.3;
  
  // This generates stars
  for (int i = 0; i < 150; i++) {
    stars.add(new Star(random(width), random(height / 1.5), random(1, 3)));
  }
}

//This function draws every layer of the drawing, starting with the waves, and ending with the instructions.
void draw() {
  background(15, 20, 60);
  
  pushMatrix();
  rotateX(PI / 6); // Rotate for 3D perspective
  for (int i = 0; i < numWaves; i++) {
    drawWave(i); 
  }
  popMatrix();
  
  //This changes the ships position to follow the cursor horizontally, and it follows a sine wave vertically.
  shipX = lerp(shipX, mouseX, 0.025); 
  shipY = shipBaseY + sin((shipX * WaveFrequency) + waveOffsets[0]) * shipAmplitude + 50; 
  
  drawShip(); 
  
  drawStars(); 
  drawAurora(); 
  
  drawInstructions(); 
}

//This function draws the stars for the background and calls the function to make then twinkle.
void drawStars() {
  
  for (Star s : stars) {
    s.twinkle(); 
    s.display(); 
  }
}

//This function is to draw the aurora in the nightsky, looping many layers of sine and cosine waves with vertexes to simulate a flowing aurora borealis.
void drawAurora() {
  noFill(); 
  pushMatrix(); 
  rotateX(PI / 6); 

  
  for (int i = 0; i < auroraLayers; i++) {
    
    color startColor = color(100 + i * 30, 0, 255, 200); // Purple hues
    color endColor = color(0, 255, 100 + i * 20, 150); // Green hues
    color auroraColor = lerpColor(startColor, endColor, float(i) / float(auroraLayers)); 

    stroke(auroraColor); 

    beginShape(); 
    for (int j = 0; j < auroraSegments; j++) {
      float x = map(j, 0, auroraSegments - 1, 0, width); 
      float y = 100 + auroraPoints[i][j] + 
                sin((j * 0.2) + frameCount * auroraSpeed) * 20 + 
                cos((j * 0.1) + frameCount * auroraSpeed) * 10; // Simulate flowing motion
      vertex(x, y); // Add vertex to the shape
    }
    endShape(); 
  }

  popMatrix();
}

// This function is to draw the ocean waves using sin functions, with differing heights and positions. It also creates a gradient below the waves to fill in the ocean.
void drawWave(int i) {
  float yOffset = i * 16 + height / 1.5;
  for (int x = 0; x < width; x++) {
    float waveY = yOffset + sin((x * WaveFrequency) + waveOffsets[i]) * 30;
    color seaColor = lerpColor(color(0, 50, 100), color(0, 0, 50), map(yOffset, height / 1.5, height, 0, 1));
    stroke(seaColor);
    line(x, waveY, x, height);
  }
  waveOffsets[i] += waveSpeed;
}

// This function draws the ship, by drawing the hull, mast, and sails. It also includes transformation functions to move the ship to the user's cursor and keeps the ship's vertical position following a sine wave.
void drawShip() {
  pushMatrix();

 
  translate(shipX, shipY, 0);

  // Draw the ship hull
  fill(139, 69, 19); 
  stroke(0);
  beginShape();
  vertex(-40, 20, 0);
  vertex(40, 20, 0);
  vertex(60, -10, 0);
  vertex(-60, -10, 0);
  endShape(CLOSE);

  // Draw the mast and sail
  stroke(150, 75, 0); 
  line(0, -60, 0, 0);
  drawSails(); 

  popMatrix(); 
}

// This function is called to draw the sail.
void drawSails() {
  pushMatrix();
  rotateZ(PI / 6); 
  fill(255); 
  beginShape();
  vertex(-5, -10, 0);
  vertex(-32, -55, 0);
  vertex(20, -50, 0);
  endShape(CLOSE); 
  popMatrix(); 
}

// This function is to draw the written instructions in the top left corner of the media. The instructions state to move the cursor for the ship to follow it.
void drawInstructions() {
  fill(255); 
  textSize(20); 
  text("Move your ship with the cursor to explore the flowing aurora and sea!", 10, 20); 
}

// This creates a star class for all the stars in the background. It randomized brightness to create a twinkling effect.
class Star {
  float x, y, size; 
  float alpha; 

  Star(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.alpha = random(100, 255); 
  }

  void twinkle() {
    alpha += random(-5, 5); 
    alpha = constrain(alpha, 100, 255); 
  }

  void display() {
    fill(255, alpha); 
    noStroke();
    ellipse(x, y, size, size); 
  }
}
