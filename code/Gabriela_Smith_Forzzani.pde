// Particle and geometry settings
final int PARTICLE_COUNT = 1000; // particles in the system
final int GEOMETRY_COUNT = 550; // stars in the geometry system

// Geometry system arrays and settings
float[] pt;      // Parameters for geometry shapes
int[] style;     // Style settings for shapes
float[] progress; // Animation progress for each shape

// Particle burst settings
ArrayList<Particle> particles = new ArrayList<>();
boolean attractMode = false;
boolean mouseInteractionEnabled = false;
float attractionStrength = 0.05;

// frames between bursts and particles per burst
int minBurstInterval = 100; 
int maxBurstInterval = 200; 
int minBurstSize = 200;     
int maxBurstSize = 500;    
int burstCountdown = getRandomBurstInterval(); 

void setup() {
  size(1400, 800, P3D); // Allows 3D rendering

// geometry arrays
  pt = new float[6 * GEOMETRY_COUNT];
  style = new int[3 * GEOMETRY_COUNT];
  progress = new float[GEOMETRY_COUNT];

  for (int i = 0; i < GEOMETRY_COUNT; i++) {
    progress[i] = 0;
    int index = i * 6;

// States geometry parameters
    if (i % 5 == 0) { // Stars
      pt[index] = 0;
      pt[index + 1] = 0;
      pt[index + 2] = random(30, 50); // Size of stars
    } else { // Arcs
      pt[index] = random(TAU);
      pt[index + 1] = random(TAU);
      pt[index + 2] = random(60, 120);
    }

// Assigns color and type of style
    float prob = random(100);
    if (prob < 40) {
      style[i * 2] = color(250, 100, 250, 210);
    } else if (prob < 70) {
      style[i * 2] = color(255, 100, 0, 210);
    } else if (prob < 90) {
      style[i * 2] = color(100, 50, 255, 210);
    } else {
      style[i * 2] = color(50, 255, 50, 210);
    }
    style[i * 2 + 1] = floor(random(3));
  }

// particles start
  for (int i = 0; i < PARTICLE_COUNT; i++) {
    addParticle(random(width), random(height));
  }
}

void draw() {
  background(0);

  for (int i =0; i< GEOMETRY_COUNT; i++){
    progress[i] += 0.005;
    if (progress[i] > 1) {
      progress[i] = 0;
    }
  }
// Draw geometry system
  pushMatrix();
  translate(width / 2, height / 2, 0);
  scale(8);
  rotateX(PI / 4);
  rotateY(PI / 6);

// draws stars and arcs dynamically, animates the system
  int index = 0;
  for (int i = 0; i < GEOMETRY_COUNT; i++) {
    pushMatrix();
    if (style[i * 2 + 1] == 2) { // Stars
      float p = progress[i];
      float radius = lerp(20, pt[index++], p);
      float innerRadius = radius / 3;
      float outerRadius = radius;
      fill(style[i * 2]);
      noStroke();
      drawStar(0, 0, innerRadius, outerRadius, 5, 0);
    } else { // Arcs
      rotateX(pt[index++]);
      rotateY(pt[index++]);
      float p = progress[i];
      float radius = lerp(20, pt[index++], p);
      float startAngle = lerp(0, pt[index++], p);
      float endAngle = lerp(TAU, pt[index++], p);
      if (style[i * 2 + 1] == 0) { // Arc outline
        stroke(style[i * 2]);
        noFill();
        strokeWeight(2);
        arcLine(0, 0, radius, startAngle, endAngle);
      } else if (style[i * 2 + 1] == 1) { // Arc bars
        fill(style[i * 2]);
        noStroke();
        arcLineBars(0, 0, radius, startAngle, endAngle);
      }
    }
    popMatrix();
  }
  popMatrix();

  // define particle bursts
  burstCountdown--;
  if (burstCountdown <= 0) {
    triggerBurst();
    burstCountdown = getRandomBurstInterval();
  }

// continously update and display particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (mouseInteractionEnabled) {
      p.applyForce(mouseX, mouseY, attractionStrength, attractMode);
    }
    if (p.isDead()) {
      particles.remove(i);
    }
  }
}

// Particle positions and their lifespan on screen
class Particle {
  float x, y;
  PVector velocity;
  float lifespan;
// particle velocity
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.velocity = PVector.random2D().mult(random(3, 9));
    this.lifespan = random(200, 400);
  }

  void update() {
    x += velocity.x;
    y += velocity.y;
    lifespan -= 1.5;
  }
// displays particles as ellipse
  void display() {
    noStroke();
    fill(255, lifespan);
    float size = map(lifespan, 0, 400, 1, 8);
    ellipse(x, y, size, size);
  }

  void applyForce(float targetX, float targetY, float strength, boolean isAttract) {
    PVector force = new PVector(targetX - x, targetY - y).normalize();
    force.mult(isAttract ? strength : -strength);
    velocity.add(force);
  }

  boolean isDead() {
    return lifespan < 0;
  }
}

void addParticle(float x, float y) {
  particles.add(new Particle(x, y));
}

// creates particle burst
void triggerBurst() {
  int burstSize = int(random(minBurstSize, maxBurstSize));
  for (int i = 0; i < burstSize; i++) {
    addParticle(random(width), random(height));
  }
}

// random interval of bursts
int getRandomBurstInterval() {
  return int(random(minBurstInterval, maxBurstInterval));
}

// Draws star to produce symmetrical shape
void drawStar(float x, float y, float innerRadius, float outerRadius, int points, float rotation) {
  beginShape();
  float angleStep = TWO_PI / points;
  for (int i = 0; i < points; i++) {
    float angle = i * angleStep + rotation;
    vertex(x + cos(angle) * outerRadius, y + sin(angle) * outerRadius);
    angle += angleStep / 2;
    vertex(x + cos(angle) * innerRadius, y + sin(angle) * innerRadius);
  }
  endShape(CLOSE);
}

//draws a arc line between two andle on a circle
void arcLine(float x, float y, float radius, float startAngle, float endAngle) {
  beginShape();
  for (float angle = startAngle; angle < endAngle; angle += radians(1)) {
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
  }
  endShape();
}

//bar like segments along the arc are drawn
void arcLineBars(float x, float y, float radius, float startAngle, float endAngle) {
  beginShape(QUADS);
  for (float angle = startAngle; angle < endAngle; angle += radians(4)) {
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius + 10), y + sin(angle) * (radius + 10));
  }
  endShape();
}
