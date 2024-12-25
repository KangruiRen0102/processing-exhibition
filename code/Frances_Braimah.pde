// Global Variables
int numParticles = 500;  // Number of particles in the simulation
float[] particleX = new float[numParticles];  // Array to store X positions of particles
float[] particleY = new float[numParticles];  // Array to store Y positions of particles
float[] particleSize = new float[numParticles];  // Array to store sizes of the particles
float[] particleSpeed = new float[numParticles];  // Array to store speeds of the particles
boolean isBouncing = false;  // Control for the bouncing effect of particles
boolean isGrow = false;  // Control for bloom size (grow or shrink)
float particleSpeedMultiplier = 1.0;  // Multiplier to adjust particle speed

int numBlooms = 30;  // Number of blooms
float[] bloomX = new float[numBlooms];  // Array to store X positions of blooms
float[] bloomY = new float[numBlooms];  // Array to store Y positions of blooms
float[] bloomSize = new float[numBlooms];  // Array to store size of blooms
float[] bloomAngle = new float[numBlooms];  // Array to store rotation angle of each bloom
float[] petalAngle = new float[numBlooms];  // Array to store petal rotation angle
float[] petalSpeed = new float[numBlooms];  // Array to store petal speed for rotation
float[] bloomGrowth = new float[numBlooms];  // Array to control growth of blooms
float[] bloomOpacity = new float[numBlooms];  // Array to store opacity of blooms
color[] bloomColors = new color[numBlooms];  // Array to store color of the bloom center
color[] petalColors = new color[numBlooms];  // Array to store petal colors
float[] rotationAngle = new float[numBlooms];  // Array to control rotation of blooms

// Time variables for displaying current time
int hours, minutes, seconds;

// Welcome Screen Control
boolean showWelcomeScreen = true;  // Flag to control showing the welcome screen
float colorOffset = 0;  // For animated gradient background

// Setup function to initialize the environment
void setup() {
  size(800, 600);  // Set the canvas size
  noStroke();  // Disable drawing stroke (outlines)

  // Initialize particle properties (positions, sizes, and speeds)
  for (int i = 0; i < numParticles; i++) {
    particleX[i] = random(width);  // Randomize particle X position
    particleY[i] = random(height);  // Randomize particle Y position
    particleSize[i] = random(2, 5);  // Randomize particle size
    particleSpeed[i] = random(0.5, 2);  // Randomize particle speed
  }

  // Initialize bloom properties (positions, sizes, angles, etc.)
  for (int i = 0; i < numBlooms; i++) {
    bloomX[i] = random(width);  // Randomize bloom X position
    bloomY[i] = random(height);  // Randomize bloom Y position
    bloomSize[i] = random(30, 60);  // Randomize bloom size
    bloomAngle[i] = random(TWO_PI);  // Randomize rotation angle
    petalAngle[i] = random(TWO_PI);  // Randomize petal rotation angle
    petalSpeed[i] = random(0.01, 0.05);  // Randomize petal rotation speed
    bloomGrowth[i] = 1;  // Set initial bloom growth to normal size
    bloomOpacity[i] = 0;  // Start blooms as fully transparent
    rotationAngle[i] = 0;  // Set initial rotation angle to 0
    bloomColors[i] = color(random(150, 255), random(150, 255), random(150, 255));  // Random bloom color
    petalColors[i] = color(random(150, 255), random(150, 255), random(255));  // Random petal color
  }
}

// Main drawing function
void draw() {
  if (showWelcomeScreen) {
    drawWelcomeScreen();  // Show the welcome screen if active
    return;  // Exit the draw function if the welcome screen is shown
  }

  // Draw a dim background with a slight gradient effect
  fill(20, 30);
  rect(0, 0, width, height);

  drawAurora();  // Draw the aurora effect in the background
  drawBlooms();  // Draw the blooming flowers
  drawParticles();  // Draw the particles
  drawTimeDisplay();  // Display the current time
  handleInteractions();  // Handle user interactions
}

// Function to display the welcome screen
void drawWelcomeScreen() {
  // Animated gradient background effect
  for (int i = 0; i < height; i++) {
    float lerpValue = map(i, 0, height, 0, 1);  // Calculate interpolation value
    color gradientColor = lerpColor(
      color(255, 102, 178 + sin(colorOffset) * 50),  // Start color with slight shift
      color(51 + cos(colorOffset) * 50, 153, 255),  // End color with slight shift
      lerpValue  // Blend between start and end colors
    );
    fill(gradientColor);  // Set fill color for the gradient
    rect(0, i, width, 1);  // Draw one pixel-high rectangle for the gradient
  }
  colorOffset += 0.02;  // Increment the color offset for animation

  // Display welcome text
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Welcome to the Bloom Garden", width / 2, height / 2 - 20);
  textSize(20);
  text("Press any key to start", width / 2, height / 2 + 40);
}

// Key press handling function to trigger interactions
void keyPressed() {
  if (showWelcomeScreen) {
    showWelcomeScreen = false;  // Hide welcome screen when any key is pressed
    return;
  }

  // Toggle bloom size growth/shrink when 'B' or 'b' is pressed
  if (key == 'B' || key == 'b') {
    isGrow = !isGrow;
  }

  // Toggle bouncing effect for particles when 'S' or 's' is pressed
  if (key == 'S' || key == 's') {
    isBouncing = !isBouncing;
  }

  // Toggle particle speed when 'P' or 'p' is pressed
  if (key == 'P' || key == 'p') {
    particleSpeedMultiplier = (particleSpeedMultiplier == 1.0) ? 1.5 : 1.0;  // Toggle between normal and increased speed
  }
}

// Function to draw the aurora effect in the background
void drawAurora() {
  for (int i = 0; i < height; i++) {
    float lerpValue = map(i, 0, height, 0, 1);  // Calculate interpolation value
    color auroraColor = lerpColor(color(62, 6, 95), color(107, 47, 221), lerpValue);  // Interpolate between colors
    fill(auroraColor, 80);  // Set fill color with some transparency
    rect(0, i, width, 1);  // Draw a line to create the aurora effect
  }
}

// Function to draw the blooming flowers
void drawBlooms() {
  for (int i = 0; i < numBlooms; i++) {
    // Random shimmer effect for sparkle
    float sparkleFactor = random(0.8, 1.2);

    // Control bloom size based on growth/shrink effect
    if (isGrow) {
      bloomGrowth[i] = lerp(bloomGrowth[i], 2 * sparkleFactor, 0.1);  // Grow bloom size
    } else {
      bloomGrowth[i] = lerp(bloomGrowth[i], 1 * sparkleFactor, 0.1);  // Shrink bloom size
    }

    bloomOpacity[i] = lerp(bloomOpacity[i], 255, 0.1);  // Gradually increase opacity
    rotationAngle[i] = lerp(rotationAngle[i], 0, 0.1);  // Gradually rotate the bloom

    pushMatrix();
    translate(bloomX[i], bloomY[i]);  // Move the bloom to its position
    rotate(rotationAngle[i]);  // Rotate the bloom

    // Draw the center of the bloom
    fill(bloomColors[i], bloomOpacity[i] * sparkleFactor);
    ellipse(0, 0, bloomSize[i] * bloomGrowth[i] / 3, bloomSize[i] * bloomGrowth[i] / 3);

    // Draw petals around the bloom
    int numPetals = 12;  // Number of petals
    float angleStep = TWO_PI / numPetals;  // Angle between each petal
    for (int j = 0; j < numPetals; j++) {
      float petalX = cos(petalAngle[i] + j * angleStep) * bloomSize[i] * bloomGrowth[i] / 2;
      float petalY = sin(petalAngle[i] + j * angleStep) * bloomSize[i] * bloomGrowth[i] / 2;
      fill(petalColors[i], bloomOpacity[i] * sparkleFactor);  // Set petal color with sparkle effect
      ellipse(petalX, petalY, bloomSize[i] * bloomGrowth[i] / 4, bloomSize[i] * bloomGrowth[i] / 2);  // Draw petals
    }
    popMatrix();

    petalAngle[i] += petalSpeed[i];  // Gradually rotate petals
  }
}

// Function to draw particles with movement and effects
void drawParticles() {
  for (int i = 0; i < numParticles; i++) {
    if (isBouncing) {
      // Bouncing effect for particles when they hit the edges
      if (particleX[i] <= 0 || particleX[i] >= width) {
        particleSpeed[i] *= -1;
      }
      if (particleY[i] <= 0 || particleY[i] >= height) {
        particleSpeed[i] *= -1;
      }
    }

    // Update particle positions based on speed and direction
    particleX[i] += cos(frameCount * 0.01 + i) * particleSpeed[i] * particleSpeedMultiplier;
    particleY[i] += sin(frameCount * 0.01 + i) * particleSpeed[i] * particleSpeedMultiplier;

    // Wrap particles around edges if they go out of bounds
    if (particleX[i] < 0) particleX[i] = width;
    if (particleX[i] > width) particleX[i] = 0;
    if (particleY[i] < 0) particleY[i] = height;
    if (particleY[i] > height) particleY[i] = 0;

    // Sparkling effect for particles
    float sparkle = random(0.5, 1.5);  // Random sparkle effect
    fill(255, 150 * sparkle);  // Set particle color with sparkle
    ellipse(particleX[i], particleY[i], particleSize[i] * sparkle, particleSize[i] * sparkle);  // Draw particle
  }
}

// Function to display the current time
void drawTimeDisplay() {
  // Get current time
  hours = hour();
  minutes = minute();
  seconds = second();

  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text(nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2), width / 2, height - 50);  // Display time in HH:MM:SS format
}

// Function to handle user interactions (currently empty)
void handleInteractions() {}
