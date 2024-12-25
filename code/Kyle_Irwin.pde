float boatX, boatY;   // Position of the boat
float lightX, lightY;  // Position of the heavenly light
float speed = 0.7;      // Speed of the boat following the cursor

// Cloud data
int cloudCount = 6;   // Number of clouds
float[] cloudX = new float[cloudCount];
float[] cloudY = new float[cloudCount];
float[] cloudSpeed = new float[cloudCount];
float[] cloudSize = new float[cloudCount];
int[] cloudShape = new int[cloudCount]; // Number of puffs for each cloud
float[][] puffOffsetX; // Offset X for each puff of each cloud
float[][] puffOffsetY; // Offset Y for each puff of each cloud
float[][] puffSizes;   // Size for each puff of each cloud

float oarAngle = 0;    // Current angle of the oars
float oarSpeed = 0.1;  // Speed of the rowing animation

// Rain data
int rainCount = 100;  // Number of rain drops
float[] rainX = new float[rainCount];
float[] rainY = new float[rainCount];
float[] rainSpeed = new float[rainCount];

// Water wave data
int waveCount = 10;   // Number of waves
float waveSpeed = 0.02;
float waveOffset = 0;

void setup() {
  size(800, 600);
  boatX = width / 2;
  boatY = height / 2;

  // Initialize arrays for cloud shapes
  puffOffsetX = new float[cloudCount][];
  puffOffsetY = new float[cloudCount][];
  puffSizes = new float[cloudCount][];

  // Initialize cloud positions, sizes, speeds, and shapes
  for (int i = 0; i < cloudCount; i++) {
    initializeCloud(i);
  }

  // Initialize rain positions and speeds
  for (int i = 0; i < rainCount; i++) {
    rainX[i] = random(width);
    rainY[i] = random(height);
    rainSpeed[i] = random(4, 8); // Rain falls at different speeds
  }
}

void draw() {
  background(20, 24, 82); // Night sky (dark blue)

  // Draw the moon
  drawMoon();

  // Draw the clouds and make them drift
  drawClouds();

  // Draw the rain
  drawRain();

  // Draw the ocean waves
  drawWaves();

  // Move the boat toward the cursor with smooth movement
  float dx = mouseX - boatX;
  float dy = mouseY - boatY;
  float distance = sqrt(dx * dx + dy * dy); // Distance to the cursor
  if (distance > 1) { // Move only if the distance is significant
    float moveX = dx / distance * speed;
    float moveY = dy / distance * speed;
    boatX += moveX;
    boatY += moveY;
  }

  // Prevent the boat from going above the horizon (y-position)
  boatY = constrain(boatY, height / 2, height);  // Boat can't go above the horizon line

  // Position the heavenly light at the cursor
  lightX = mouseX;
  lightY = mouseY;
  
  // Get the maximum y-position of the waves
  float maxWaveY = height / 2 + (waveCount - 1) * 15 + 5; // Bottom-most wave position

  // Prevent the boat from going below the bottom-most wave
  boatY = constrain(boatY, height / 2, maxWaveY - 20); // Add some buffer above the wave

  // Draw the boat
  drawBoat(boatX, boatY, color(255, 0, 0));  // Boat in red

  // Draw the heavenly light
  drawLight(lightX, lightY);

  // Update wave offset for animation
  waveOffset += waveSpeed;
}

// Function to draw the boat with a more boat-like shape
void drawBoat(float x, float y, color c) {
  // Hull of the boat
  fill(139, 69, 19); // Brown color for the boat hull
  beginShape();
  vertex(x - 40, y + 50);  // Left top of the boat hull
  vertex(x + 40, y + 50);  // Right top of the boat hull
  vertex(x + 60, y + 20);  // Right bottom of the hull
  vertex(x - 60, y + 20);  // Left bottom of the hull
  endShape(CLOSE);

  // Mast of the boat
  stroke(0); // Dark color for the mast
  strokeWeight(4);
  line(x, y + 20, x, y - 40); // Vertical line for the mast
  
  // Sail of the boat (triangle shape)
  fill(255); // White sail
  noStroke();
  beginShape();
  vertex(x, y);  // Bottom of the sail (attached to the mast)
  vertex(x + 40, y - 40);  // Top right of the sail
  vertex(x - 40, y - 40);  // Top left of the sail
  endShape(CLOSE);
}

// Function to draw the moon
void drawMoon() {
  noStroke();
  fill(255, 255, 224); // Pale yellow for the moon
  ellipse(width - 100, 100, 80, 80); // Moon in the top-right corner
}

// Function to initialize a cloud's properties
void initializeCloud(int index) {
  cloudX[index] = random(width);
  cloudY[index] = random(50, height / 3);
  cloudSpeed[index] = random(0.2, 1);  // Random speed for each cloud
  cloudSize[index] = random(30, 80);   // Random size for each cloud
  cloudShape[index] = int(random(3, 6)); // Random number of puffs (3 to 5)

  // Generate offsets and sizes for the puffs of this cloud
  puffOffsetX[index] = new float[cloudShape[index]];
  puffOffsetY[index] = new float[cloudShape[index]];
  puffSizes[index] = new float[cloudShape[index]];
  for (int j = 0; j < cloudShape[index]; j++) {
    puffOffsetX[index][j] = random(-cloudSize[index] * 0.5, cloudSize[index] * 0.5);
    puffOffsetY[index][j] = random(-cloudSize[index] * 0.3, cloudSize[index] * 0.3);
    puffSizes[index][j] = random(cloudSize[index] * 0.6, cloudSize[index]);
  }
}

// Function to draw multiple clouds and make them drift
void drawClouds() {
  for (int i = 0; i < cloudCount; i++) {
    drawCloud(cloudX[i], cloudY[i], puffOffsetX[i], puffOffsetY[i], puffSizes[i], cloudShape[i]);
    cloudX[i] += cloudSpeed[i]; // Move the cloud to the right

    // Reset the cloud's position if it drifts off the screen
    if (cloudX[i] > width + 50) {
      initializeCloud(i); // Reinitialize cloud properties
      cloudX[i] = -50; // Start from the left again
    }
  }
}

// Function to draw a single cloud
void drawCloud(float x, float y, float[] offsetX, float[] offsetY, float[] sizes, int puffs) {
  noStroke();
  fill(100, 100, 100, 200); // Dark gray clouds
  for (int i = 0; i < puffs; i++) {
    ellipse(x + offsetX[i], y + offsetY[i], sizes[i], sizes[i] * 0.6);
  }
}

// Function to draw ocean waves
void drawWaves() {
  fill(10, 10, 50); // Dark blue water
  rect(0, height / 2, width, height / 2); // Base ocean rectangle

  // Draw sine waves to simulate ocean waves
  for (int i = 0; i < waveCount; i++) {
    float waveHeight = height / 2 + i * 15; // Distance between waves
    stroke(173, 216, 230, 150); // Light blue wave color
    strokeWeight(2);
    noFill();
    beginShape();
    for (float x = 0; x < width; x += 10) {
      float y = waveHeight + sin((x * 0.05) + waveOffset + i) * 5;
      vertex(x, y);
    }
    endShape();
  }
}

// Function to draw rain
void drawRain() {
  stroke(200, 200, 255, 150); // Light blue rain color with transparency
  strokeWeight(2);
  for (int i = 0; i < rainCount; i++) {
    line(rainX[i], rainY[i], rainX[i] + 2, rainY[i] + 10);
    rainY[i] += rainSpeed[i]; // Rain falls downward

    // Reset rain position if it goes off-screen
    if (rainY[i] > height) {
      rainY[i] = random(-50, 0); // Reset above the screen
      rainX[i] = random(width);
    }
  }
}

// Function to draw the heavenly light
void drawLight(float x, float y) {
  noStroke();
  fill(255, 255, 224, 200); // Light yellow color with some transparency
  ellipse(x, y, 60, 60);
}
