// Inspired by "Bloom", "Chaos", "Flow" + Ripple Effect

ArrayList<Petal> petals;
ArrayList<Ripple> ripples;
float angleOffset;

void setup() {
  size(800, 800);
  petals = new ArrayList<Petal>();
  ripples = new ArrayList<Ripple>();
  
  // Create initial petals
  for (int i = 0; i < 200; i++) {
    petals.add(new Petal(random(width), random(height)));
  }
  angleOffset = 0;
}

void draw() {
  background(20, 20, 40, 20); // Background with fade effect
  translate(width / 2, height / 2); // Center canvas

  float time = millis() * 0.001; // Time variable for dynamic effects
  
  // Update and display petals
  for (Petal p : petals) {
    p.update();
    p.display();
  }
  
  // Update and display ripple effects
  for (int i = ripples.size() - 1; i >= 0; i--) {
    Ripple r = ripples.get(i);
    r.update();
    r.display();
    if (r.lifespan <= 0) {
      ripples.remove(i); // Remove faded ripples
    }
  }
  
  // Draw blooming pattern
  noFill();
  for (float r = 20; r < 300; r += 15) {
    float angleStep = map(sin(time + r * 0.01), -1, 1, PI / 4, TWO_PI / 8);
    stroke(lerpColor(color(255, 180, 200), color(100, 180, 255), sin(r * 0.01)));
    beginShape();
    for (float a = 0; a < TWO_PI; a += angleStep) {
      float x = cos(a) * r;
      float y = sin(a) * r;
      vertex(x, y);
    }
    endShape(CLOSE);
  }
  
  angleOffset += 0.01; // Increment angle offset for smooth changes
}

void mousePressed() {
  // Generate a wave of ripples around the mouse click
  float radius = 30; // Distance between ripples
  for (int i = 0; i < 9; i++) {
    float angle = TWO_PI / 9 * i; // Angle of each ripple
    float delay = i * 5; // Delay for each ripple
    ripples.add(new Ripple(mouseX - width / 2, mouseY - height / 2, angle, delay));
  }
}

// Class for individual petals
class Petal {
  PVector pos, vel, acc; // Position, velocity, acceleration
  float maxSpeed = 2;    // Maximum speed
  float maxForce = 0.05; // Maximum steering force
  float size;            // Petal size
  float angle;           // Rotation angle

  Petal(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector();
    size = random(10, 20);
    angle = random(TWO_PI);
  }

  void update() {
    // Flow field using Perlin noise
    PVector flow = PVector.fromAngle(noise(pos.x * 0.01, pos.y * 0.01, frameCount * 0.01) * TWO_PI);
    flow.mult(maxSpeed);
    PVector steer = PVector.sub(flow, vel);
    steer.limit(maxForce);
    acc.add(steer);
    
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    
    // Wrap around edges
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
    
    angle += 0.05; // Rotate gently
  }

  void display() {
    pushMatrix();
    translate(pos.x - width / 2, pos.y - height / 2);
    rotate(angle);
    noStroke();
    fill(255, 100, 150, 150);
    beginShape();
    vertex(0, -size / 2);
    bezierVertex(size / 2, -size, size / 2, size, 0, size / 2);
    bezierVertex(-size / 2, size, -size / 2, -size, 0, -size / 2);
    endShape(CLOSE);
    popMatrix();
  }
}

// Class for ripple effects
class Ripple {
  float x, y;       // Center position of the ripple
  float angle;      // Angle of the ripple in the circular wave
  float radius;     // Current radius of the ripple
  float delay;      // Time delay before the ripple starts
  float lifespan;   // Lifespan of the ripple

  Ripple(float x, float y, float angle, float delay) {
    this.x = x + cos(angle) * 30; // Offset by initial angle
    this.y = y + sin(angle) * 30;
    this.angle = angle;
    this.radius = 0;      // Start with a radius of 0
    this.delay = delay;   // Delay before the ripple starts expanding
    this.lifespan = 255;  // Start with full opacity
  }

  void update() {
    if (delay > 0) {
      delay -= 1; // Wait for the delay to expire
      return;
    }
    radius += 5;     // Increase radius to expand the ripple
    lifespan -= 5;   // Decrease lifespan to fade the ripple
  }

  void display() {
    if (delay > 0) return; // Don't display until the delay has expired
    noFill();
    stroke(100, 150, 255, lifespan); // Blue with fading opacity
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2); // Draw expanding circle
  }
}
