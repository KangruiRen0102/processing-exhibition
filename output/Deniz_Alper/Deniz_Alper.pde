class Particle {  //creating class for the light particles
  float x, y;     // position of particle
  float velocityX, velocityY;  // velocity of particle
  float size;     // particle size
  float alpha;    // particle opacity
  float creationTime;  //  time particle was generated
  color particleColor; // particle colour
  
  Particle(float x, float y, float velocityX, float velocityY, float size, float alpha) {
    this.x = x; //aligning class parameters with corresponding variables
    this.y = y;
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    this.size = size;
    this.alpha = alpha;
    this.creationTime = millis();  // record time of particle creation
    
    // particle colours alternate between UAlberta colours, dark green and golden yellow
    if (random(1) < 0.5) {
      this.particleColor = color(0, 100, 0);  // dark green
    } else {
      this.particleColor = color(255, 255, 0);  // golden yellow
    }
  }

  void update() {
    // update position using velocity
    x += velocityX;
    y += velocityY;
    
    // make sure particles disappear after set time
    float elapsedTime = millis() - creationTime;
    alpha = map(elapsedTime, 0, 3000, 255, 0);  // disappear after 3 second
  }

  void display() {
    // colour shape size of particle
    noStroke();
    fill(particleColor, alpha);  // fill particle with chosen colour
    ellipse(x, y, size, size);  // set particle shape as small circle
  }
}

ArrayList<Particle> particles = new ArrayList<Particle>();  // list storing active particles

float lastMouseX = -1;  // last cursor X position
float lastMouseY = -1;  // last cursor Y position

void setup() {
  size(800, 600);
  background(0);  // setting black background
}

void draw() {
  // use fade effect when clearing background so it looks like the trail is fading away
  background(0, 10);  //  transparency to create a fading trail effect

  // update and display all particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();  // update particle position
    p.display(); // display particle
    
    // if particle has disappeared remove it from list of active particles
    if (p.alpha <= 0) {
      particles.remove(i);
    }
  }

  // particles are only generated if mouse is moving
  if (mouseX != lastMouseX || mouseY != lastMouseY) {
    int numParticles = 10;  //  particles following cursor per frame
    float size = random(5, 10);  // randomized size for each particle
    
    for (int i = 0; i < numParticles; i++) {
      // randomize angle for particle to fly away from mouse at based on movement
      float angle = random(TWO_PI);
      
      // calculate velocity of particle using mouse movement, adding randomness so it isnt too linear
      float speed = random(2, 4);
      float velocityX = cos(angle) * speed + (mouseX - pmouseX) * 0.1;  
      float velocityY = sin(angle) * speed + (mouseY - pmouseY) * 0.1;  
      
      // creating new particles at current mouse position
      float alpha = random(100, 255);  // randomize opacity which is just light intensity
      Particle newParticle = new Particle(mouseX, mouseY, velocityX, velocityY, size, alpha);
      
      // add newly created particle to active particle list
      particles.add(newParticle);
    }

    // update mouse position
    lastMouseX = mouseX;
    lastMouseY = mouseY;
  }
}

void mousePressed() {
  // create fireworks when mouse is clicked
  int numParticles = 300;  // number of particles shooting outwards from click
  float size = random(5, 10);  // random size for each fireworks particle
  
  for (int i = 0; i < numParticles; i++) {
    //generating a random angle between 0 and TWO_PI (360 degrees)for particle
    float angle = random(TWO_PI);
    
    // generating a random speed for each particle
    float speed = random(2, 5);
    
    // using generated angle and speed to calculate velocity of each particle
    float velocityX = cos(angle) * speed;
    float velocityY = sin(angle) * speed;
    
    // create a new particle with random velocity and opacity (intensity of light)
    float alpha = random(100, 255);  // random opacity (intensity of light)
    Particle newParticle = new Particle(mouseX, mouseY, velocityX, velocityY, size, alpha);
    
    // add new particle to the list of active particles
    particles.add(newParticle);
  }
}
