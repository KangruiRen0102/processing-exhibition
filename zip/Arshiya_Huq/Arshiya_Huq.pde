// Sky - Class for managing the sky color and transition
class Sky {
  color dayColor, nightColor, currentColor; // Colors for day, night, and current sky
  float timeOfDay; // Tracks the progression of time (0 to 1 cycle)

  // Constructor to initialize the sky colors and set the initial state
  Sky(color dayColor, color nightColor) {
    this.dayColor = dayColor; // Daytime sky color
    this.nightColor = nightColor; // Nighttime sky color
    this.currentColor = dayColor; // Start with day color
    this.timeOfDay = 0; // Start at the beginning of the day
  }

  // Update the time and calculate the current color based on the time of day
  void update() {
    timeOfDay += 0.0004; // Slow progression of time
    if (timeOfDay > 1) timeOfDay = 0; // Reset after a full day-night cycle
    // Interpolate between night and day colors using a sine wave for smooth transitions
    currentColor = lerpColor(nightColor, dayColor, abs(sin(TWO_PI * timeOfDay)));
  }

  // Display the current sky color as the background
  void display() {
    background(currentColor); // Set the background to the current sky color
  }
}

// Wave Class for managing the ocean waves
class Wave {
  float waveOffset, waveAmplitude, waveFrequency, waveSpeed; // Properties of the wave

  // Constructor initializes wave properties
  Wave(float waveAmplitude, float waveFrequency, float waveSpeed) {
    this.waveAmplitude = waveAmplitude; // Height of the wave
    this.waveFrequency = waveFrequency; // Frequency of the wave oscillations
    this.waveSpeed = waveSpeed; // Speed of wave movement
    this.waveOffset = 0; // Starting offset for wave animation
  }

  // Update the wave offset to simulate movement
  void update() {
    waveOffset += waveSpeed; // Shift the wave horizontally over time
  }

  // Display the ocean surface and waves
  void display() {
    fill(30, 144, 255); // Ocean blue color
    // Draw the flat surface of the ocean
    rect(0, height * 0.65, width, height * 0.35); 

    // Draw faint waves closer to the water's surface
    for (float x = 0; x < width; x += 5) {
      // Calculate wave height using a sine wave formula
      float waveHeight = sin(waveFrequency * x + waveOffset) * waveAmplitude;
      // Draw a small circle at each wave peak
      ellipse(x, height * 0.65 + waveHeight, 10, 10); 
    }
  }
}

// Star - Class for managing the stars
class Star {
  float x, y, size; // Star position and size

  // Constructor initializes a star with random position and size
  Star(float x, float y, float size) {
    this.x = x; // Horizontal position
    this.y = y; // Vertical position
    this.size = size; // Star size
  }

  // Display the star as a white ellipse
  void display() {
    fill(255); // Set fill color to white
    ellipse(x, y, size, size); // Draw the star
  }
}

// Ship - Class for managing the cruise ship
class Ship {
  float shipX, shipY, shipSpeed; // Ship position and speed

  // Constructor initializes the ship properties
  Ship(float shipX, float shipY, float shipSpeed) {
    this.shipX = shipX; // Horizontal starting position
    this.shipY = shipY; // Vertical position
    this.shipSpeed = shipSpeed; // Movement speed of the ship
  }

  // Update the ship's position and reset it if it moves off-screen
  void update() {
    shipX += shipSpeed; // Move the ship horizontally
    if (shipX > width + 150) shipX = -150; // Loop the ship back to the left when off-screen
  }

  // Display the ship as a composite of shapes
  void display() {
    // Ship hull
    fill(80, 80, 80); // Grey color for hull
    beginShape(); // Begin defining the hull shape
    vertex(shipX - 100, shipY); // Left edge
    vertex(shipX + 100, shipY); // Right edge
    vertex(shipX + 70, shipY + 30); // Bottom right
    vertex(shipX - 70, shipY + 30); // Bottom left
    endShape(CLOSE); // Close the hull shape

    // Ship deck
    fill(255); // White for the deck
    rect(shipX - 70, shipY - 30, 140, 30, 5); // Rounded rectangle for the deck

    // Ship windows
    fill(0, 0, 255); // Blue color for windows
    for (int i = -60; i <= 60; i += 30) {
      ellipse(shipX + i, shipY - 15, 10, 10); // Draw windows evenly spaced on the deck
    }

    // Chimney stack
    fill(200, 0, 0); // Red for the chimney
    rect(shipX - 20, shipY - 60, 40, 30); // Draw the chimney stack
  }
}

// Main setup and draw
Sky sky;
Ship ship;
Wave wave;
ArrayList<Star> stars;
int starCount = 100; // Total number of stars

void setup() {
  size(1200, 800); // Canvas size
  noStroke(); // Disable outlines for shapes

  // Initialize objects
  sky = new Sky(color(135, 206, 235), color(25, 25, 112)); // Sky with day and night colors
  ship = new Ship(-150, height * 0.65, 0.8); // Ship starting position and speed
  wave = new Wave(4, 0.02, 0.005); // Wave properties
  stars = new ArrayList<Star>(); // Create the list of stars

  // Initialize star positions and sizes
  for (int i = 0; i < starCount; i++) {
    stars.add(new Star(random(width), random(height / 2), random(1, 3))); // Random star attributes
  }
}

void draw() {
  // Update and display sky
  sky.update(); // Update sky color
  sky.display(); // Render sky

  // Draw stars only at night
  if (sky.currentColor != sky.dayColor) {
    for (Star star : stars) {
      star.display(); // Render each star
    }
  }

  // Draw ocean waves
  wave.update(); // Update wave movement
  wave.display(); // Render waves

  // Draw cruise ship
  ship.update(); // Update ship position
  ship.display(); // Render ship
}
