//Following text determines how many particles will be used
int numParticles = 300;
Particle[] particles;

void setup() {
  size(800, 600); //Sets the size of the canvas for the image
  frameRate(60); // Sets the rate of which frames will appear for the image
  
  // Creates the idea and how the particles will act. The particles will signify hope, memory and discovery
  particles = new Particle[numParticles];
  for (int i = 0; i < numParticles; i++) {
    //Creates the starting point for the particles at the center of the screen
    float angle = random(TWO_PI); 
    float speed = random(1, 3);
    //Enables the particles to travel with random speed and direction
    particles[i] = new Particle(width / 2, height / 2, cos(angle) * speed, sin(angle) * speed, random(255), random(150, 255), random(255));
  }
}

void draw() {
  background(30, 30, 50);  // Creates the black background, putting emphasis on the glow of hope of the particles
  
  // Produces/displays the particles that were previously mentioned, by creating a loop
  for (int i = 0; i < numParticles; i++) {
    particles[i].update(); //Recreates the particle's state and position 
    particles[i].display(); // Used to display the particles
  }
}

class Particle {
  float x, y, dx, dy; //Details the position and movement of the particle
  color c; // Creates the option for color on the particles
  float alpha; // Gives a transparent feel to the particles, as well as a fading effect
  
  //This next block now creates the position, direction and color agruments for the particles
  Particle(float x, float y, float dx, float dy, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.c = color(r, g, b); // Gives color to partcile, bright colors selected to show hope
    this.alpha = 255;  // Makes the particles visible for the starting point
  }
  //This block is used for updating the movement and fading effect of the particles over time
  void update() {
    // Creates a new position for the particles
    x += dx; //Updates the position in the horziontal for the particle, with respect to velocity
    y += dy; //Updates the position in the vertical for the particle, with respect to velocity
    
    // Particles are created to fade away over time, symbolizing memories
    alpha -= 1;  // Process to create a gradual fading/transparency of the particles; resembling memories
    
    //This block commands the particles to reset after fading away
    if (alpha < 0) {
      alpha = 255;  // Resets the full visual of the particles, no transparency
      x = width / 2;  // Particles set to respwan at the center of the image
      y = height / 2;
      dx = random(-2, 2);  // Particles burst out of center in random directions
      dy = random(-2, 2);  // Particles burst out of center in random speeds
    }
  }
  //Final block enables the particles to be displayed with its colors and transparency effect
  void display() {
    noStroke(); //Commands no outline for the particles
    fill(c, alpha);  // Applies the fading aplha to the memory effect along with color
    ellipse(x, y, 10, 10);  // Draw final design and the particles as an ellipse
  }
}
