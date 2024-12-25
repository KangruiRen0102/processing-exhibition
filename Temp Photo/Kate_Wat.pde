int numParticles = 169; // # of particles
ArrayList<Particle> particles; // list to store particles
PVector center;
boolean chaosMode = false;
float time = 0;

void setup() {
  size(699, 699);
  particles = new ArrayList<Particle>();
  center = new PVector(width / 2, height / 2);

  // initialize particles at random places on screen
  for (int i = 0; i < numParticles; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}

void draw() {
  background(20, 34, 69, 25); // ocean coloured background 

  // update and display particles
  for (Particle p : particles) {
    p.update(); //update position and behaviour
    p.display(); // render particles on screen
  }

  // infinity symbol!!!!!
  drawInfinitySymbol();

  // increment time for animation stuff
  time += 0.01;
}

void drawInfinitySymbol() {
  noFill();
  stroke(100, 150, 255, 150);
  strokeWeight(2);
  float a = 150; // size 
  float b = 100; // height of loops
  beginShape(); // i love trig functions
  for (float t = 0; t < TWO_PI; t += 0.01) {
    float x = center.x + a * cos(t) / (1 + sin(t) * sin(t));
    float y = center.y + b * sin(t) * cos(t) / (1 + sin(t) * sin(t));
    vertex(x, y);
  }
  endShape(CLOSE);
}

void mousePressed() {
  chaosMode = !chaosMode; // toggle CHAOS MODE from pressing mouse
}

class Particle {
  PVector position;
  PVector velocity;
  float lifespan; // for fading so it looks cool

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    lifespan = 269;
  }

  void update() {
    // update position
    position.add(velocity);

    // CHAOSSSS apply forces to the particle based on whether chaos mode is on
    PVector force = chaosMode ? position.copy().sub(center) : center.copy().sub(position);
    force.normalize(); // consistent magnitude
    force.mult(0.2);
    velocity.add(force);

    // fading lifespan cus it looks cool
    lifespan -= 0.5;

    // wrap around screen edges cus it looks cool
    if (position.x < 0) position.x = width;
    if (position.x > width) position.x = 0;
    if (position.y < 0) position.y = height;
    if (position.y > height) position.y = 0;

    // reset the particle if lifespan gets to zero
    if (lifespan <= 0) {
      position = new PVector(random(width), random(height));
      lifespan = 255;
    }
  }

  void display() {
    float hue = map(position.x, 0, width, 180, 240); // colours for particles
    stroke(hue, 200, 269, lifespan);
    fill(hue, 200, 269, lifespan / 2);
    ellipse(position.x, position.y, 6, 6);
  }
}
