// A Processing sketch to represent chaos within the journey of growth
int nParticles = 300; // Number of particles
Particle[] particles;

void setup() {
  size(800, 800, P2D);
  smooth(8);
  background(20);

  particles = new Particle[nParticles];
  for (int i = 0; i < nParticles; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  fill(20, 20, 30, 20); // Fading background for motion trails
  rect(0, 0, width, height);

  translate(width / 2, height / 2);

  for (Particle p : particles) {
    p.update();
    p.display();
  }

  // Central focal point representing growth and structure
  fill(255, 100, 100, 200);
  noStroke();
  ellipse(0, 0, 50, 50);
}

class Particle {
  PVector position;
  PVector velocity;
  color col;

  Particle() {
    position = PVector.random2D().mult(random(100, width / 2));
    velocity = PVector.random2D().mult(random(1, 3));
    col = color(random(100, 255), random(100, 255), random(100, 255), 200);
  }

  void update() {
    // Update position and add randomness for chaos
    position.add(velocity);
    velocity.add(PVector.random2D().mult(0.5));

    // Gradually pull towards the center (growth)
    PVector center = new PVector(0, 0);
    PVector force = PVector.sub(center, position);
    force.mult(0.01); // Strength of pull
    velocity.add(force);

    // Constrain particles within the canvas bounds
    position.x = constrain(position.x, -width / 2, width / 2);
    position.y = constrain(position.y, -height / 2, height / 2);
  }

  void display() {
    stroke(col);
    strokeWeight(2);
    point(position.x, position.y);
  }
}
