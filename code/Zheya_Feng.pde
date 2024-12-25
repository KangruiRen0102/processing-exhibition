int cols, rows;
int scl = 20; // Scale of each grid
float zoff = 0; // Z-offset for 3D Perlin noise
Particle[] particles; // Array to store particles
PVector[] flowfield; // Store flow vectors
float i = 0;

void setup() {
  size(600, 800); // Size of the canvas
  cols = floor(width / scl); // Calculate number of columns based on canvas width and scale
  rows = floor(height / scl); // Calculate number of rows based on canvas height and scale
  flowfield = new PVector[cols * rows]; // Initialize the flow array with one vector per cell

  particles = new Particle[2000]; // An array that stores 2000 particles
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  background(243, 234, 226); // Color of the background is soft beige
}

void draw() {
  float yoff = 0; // Initialize
  for (int y = 0; y < rows; y++) { // Loop through rows
    float xoff = 0; // Initialize
    for (int x = 0; x < cols; x++) { // Loop through columns
      int index = x + y * cols; // Index
      float angle = noise(xoff, yoff, zoff) * TWO_PI * 2; // Angle
      PVector v = PVector.fromAngle(angle); // create a vector from the angle
      v.setMag(1);
      flowfield[index] = v;
      xoff += 0.1; // Increment increase for x
    }
    yoff += 0.1; // Increment increase for y
  }
  zoff += 0.01; // Increment increase for z to animate flow vector over time

  // Update and display particles
  for (int i = 0; i < particles.length; i++) {
    particles[i].follow(flowfield);
    particles[i].update();
    particles[i].edges();
    particles[i].show();
  }

  // Draw a radial gradient and an expanding white circle
  radialGradient(width / 2, height / 2, 0, 
                 width / 2, height / 2, 130, 
                 color(232, 123, 116), 
                 color(255));
  noStroke();
  i = i + 0.1; 
  fill(255); // Set the fill color to white for the circle
  if (i < 80) {
    ellipse(width / 2, height / 2, i, i); // Draw circle
  } else {
    ellipse(width / 2, height / 2, 80, 80); // Circle size is maxed out at 80
  }
}

// class particle will simulate particle flow on the canvas
class Particle {
  PVector pos;    // Position vector
  PVector vel;    // Velocity vector
  PVector acc;    // Acceleration vector
  float maxspeed; // Maximum speed 
  color col;      

  // Constructor to initialize the particle's properties
  Particle() {
    pos = new PVector(random(width), random(height)); // Random starting position within the canvas.
    vel = new PVector(); // Initial velocity is zero.
    acc = new PVector(); // Initial acceleration is zero.
    maxspeed = 2; // maximum speed is set to 2
    col = color(68, 105, 161, 5);
  }

  // Apply the flow field's influence on the particle
  void follow(PVector[] flowfield) {
    int x = floor(pos.x / scl); // Determine the column in the flow field.
    int y = floor(pos.y / scl); // Determine the row in the flow field.
    int index = x + y * cols;   // Calculate the index in the flow field array.
    if (index >= 0 && index < flowfield.length) { // Ensure the index is within bounds.
      PVector force = flowfield[index]; // Get the corresponding vector from the flow field.
      applyForce(force); // Apply the force to the particle.
    }
  }

  // Update the particle's position and velocity
  void update() {
    vel.add(acc); 
    vel.limit(maxspeed); 
    pos.add(vel); // Update position based on velocity.
    acc.mult(0); // Reset acceleration after applying it.
  }

  //Apply a force to the particle
  void applyForce(PVector force) {
    acc.add(force); // Add the force to the acceleration.
  }

  // particle's behavior at the edges of the canvas.
  void edges() {
    if (pos.x > width) pos.x = 0; // Wrap around the left edge
    if (pos.x < 0) pos.x = width; // Wrap around the right edge
    if (pos.y > height) pos.y = 0; // Wrap around the top edge
    if (pos.y < 0) pos.y = height; // Wrap around the bottom edge
  }

  // Displaying particles on canvas
  void show() {
    float d = dist(pos.x, pos.y, mouseX, mouseY); // Calculate distance from the mouse cursor
    if (d < 50) {
      col = color(128, 0, 128, 5); // Change color if it's within 50 pixels of the mouse cursor
    } else {
      col = color(68, 105, 161, 5); // Default color
    }
    strokeWeight(2); // brush/drawing thickness

    if (random(1) < 0.01) {
      stroke(255, 255, 255, 200);
      strokeWeight(1);
    } else {
      stroke(col);
    }
    point(pos.x, pos.y); 
  }
}

//creating of a smooth radial gradient effect by blending colors across concentric circles.
void radialGradient(float sX, float sY, float sR, float eX, float eY, float eR, color colorS, color colorE) {
  PGraphics gradient = createGraphics(width, height);
  gradient.beginDraw();
  gradient.noFill();
  for (float r = sR; r < eR; r += 1) { // A loop through radii to create concentric circles
    float inter = map(r, sR, eR, 0, 1); // Calculate interpolation factor
    gradient.stroke(lerpColor(colorS, colorE, inter));
    gradient.ellipse(sX, sY, r * 2, r * 2); // Draw the white circle
  }
  gradient.endDraw();
  image(gradient, 0, 0); // Display gradient
}
