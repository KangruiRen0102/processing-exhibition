// Simulation parameters and initialization variables
int Particles = 500; // Number of particles to simulate
Particle[] particles = new Particle[Particles]; // Array to hold all particles
float foDura = 400; // time for the lines to fade out
float fiDura = 300; // time for the squares to fade in
float CongregationTime; // Frame when transition starts
boolean iTransition = false; // Flag to determine if transition has started
PVector[] CongregationZones = new PVector[3]; // Define three symmetrical target regions
float lopacity = 255; // Opacity of the random lines
float sopacity = 0; // Opacity of the squares
boolean pCongregation = false; // Flag to trigger particle transition

//initializes canvas and particle settings
void setup() {
  size(1920, 1080); // Set canvas size
  for (int i = 0; i < Particles; i++) {
    particles[i] = new Particle(random(width), random(height)); // particles at random positions
  }

  // Define three symmetrical target regions
  CongregationZones[0] = new PVector(width / 4, height / 3); // Top-left target region
  CongregationZones[1] = new PVector(width / 2, 2 * height / 3); // Bottom-center target region
  CongregationZones[2] = new PVector(3 * width / 4, height / 3); // Top-right target region

}

//renders frames and transitions between phases
void draw() {
  background(10, 70, 125); // Blue background

  if (!iTransition) {
    // Draw chaotic background with random lines
    for (int i = 0; i < 50; i++) {
      stroke(15, 160, 45, lopacity); // Random lines with decreasing opacity
      line(random(width), random(height), random(width), random(height));
    }
    lopacity -= 200 / foDura; // Gradually reduce opacity

    if (lopacity <= 0) {
      iTransition = true;
      CongregationTime = frameCount; // Mark the start of the transition
    }
  } else {
    // Draw squares with increasing opacity
    float progress = (frameCount - CongregationTime) / fiDura;
    if (progress <= 1.0) {
      sopacity = progress * 200;
    }
    drawSquares();

    if (progress >= 1.0 && !pCongregation) {
      pCongregation = true; // Start particle transition after squares are fully visible
      for (Particle p : particles) {
        p.setTargetRegion(CongregationZones); // Assign target regions to particles
        p.startTransition();
      }
    }
  }

  for (Particle p : particles) {
    p.update(); // Update particle positions
    p.display(); // Draw particles on canvas
  }
}

// Function to draw the target squares as the order phase starts
void drawSquares() {
  noFill();
  stroke(255, 200, 100, sopacity); 
  strokeWeight(5);
  for (PVector target : CongregationZones) {
    rect(target.x - 50, target.y - 50, 100, 100); // Draw square around each target region
  }
}

// Class definition for particles, including movement and rendering
class Particle {
  float x, y; 
  float velx, vely; 
  PVector target; 
  boolean iTransition = false; 

//initializes particle position and random velocity
  Particle(float x, float y) {
    this.x = x; 
    this.y = y; 
    velx = random(-4, 4); 
    vely = random(-4, 4); 
  }

  // Assigns a random target region for a particle to move toward
  void setTargetRegion(PVector[] regions) {
    target = regions[(int)random(regions.length)]; 
  }

  // tells the particle to begin transitioning to its target
  void startTransition() {
    iTransition = true; 
  }

  // Updates the particle's position and velocity 
  void update() {
    if (iTransition) { 
      velx = (target.x - x) * 0.01; 
      vely = (target.y - y) * 0.01; 
    }
    //updating coordinates
    x += velx; 
    y += vely; 
  }

  // shows the particle as a circle on the canvas
  void display() {
    fill (200, 150, 100, 150); 
    ellipse(x, y, 15, 15); 
  }
}
