ArrayList<Hand> hands = new ArrayList<Hand>();
ArrayList<Particle> particles = new ArrayList<Particle>(); // Particles for explosion effect
Hand activeHand;
int maxHands = 5;
boolean isExploding = false; // Flag for explosion animation
float scaleFactor = 1.0; // Scale factor for the explosion animation
boolean particlesReleased = false; // Tracks if particles have been released

void setup() {
  size(600, 600);
  resetDrawing();
}

void draw() {
  background(255);

  if (isExploding) {
    if (scaleFactor < 5) {
      // Double the scaling speed
      scaleFactor += 0.04;
      translate(width / 2, height / 2);
      scale(scaleFactor);
      drawScene();
    } else {
      // Release particles when fully scaled
      if (!particlesReleased) {
        releaseParticles();
        particlesReleased = true;
      }

      // Update and display particles
      for (int i = particles.size() - 1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.update();
        p.display();
        if (p.isDead()) {
          particles.remove(i);
        }
      }

      // Reset when all particles are gone
      if (particles.isEmpty()) {
        resetDrawing();
      }
    }
  } else {
    // Normal drawing mode
    translate(width / 2, height / 2 - 50); // Adjust for hands above "CHAOS"
    drawScene();
  }

  // Update the active hand if it is moving
  if (!isExploding && activeHand.isMoving) {
    activeHand.angle = atan2(mouseY - height / 2 + 50, mouseX - width / 2);
  }
}

void drawScene() {
  // Black circle with radius 180
  fill(0);
  noStroke();
  ellipse(0, 0, 180 * 2, 180 * 2);

  // Write "INFINITY" 6 times along the circle
  fill(255);
  textSize(14);
  float textRadius = 140;
  int repetitions = 6;
  float totalArc = TWO_PI / repetitions;

  for (int j = 0; j < repetitions; j++) {
    float startAngle = j * totalArc;

    for (int i = 0; i < 8; i++) {
      char letter = "INFINITY".charAt(i);
      float letterAngle = startAngle + i * (totalArc / 8);
      float x = cos(letterAngle) * textRadius;
      float y = sin(letterAngle) * textRadius;

      pushMatrix();
      translate(x, y);
      rotate(letterAngle + HALF_PI);
      text(letter, 0, 0);
      popMatrix();
    }
  }

  // Infinity symbol (∞)
  textSize(36);
  fill(255);
  textAlign(CENTER, CENTER);
  text("∞", 0, -130); // Top center
  text("∞", 0, 130);  // Bottom center

  // Number 8s on sides
  textSize(36);
  text("8", -130, 0); // Left side
  text("8", 130, 0);  // Right side

  // Draw all hands
  for (Hand h : hands) {
    h.drawHand();
  }

  // Draw active hand
  activeHand.drawHand();

  // CHAOS text with dynamic visibility
  int visibleLetters = min(hands.size() + 1, "CHAOS".length());
  textSize(48);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  translate(0, 50); // Move down to position "CHAOS" below the hands
  text("CHAOS".substring(0, visibleLetters), 0, 0);

  // Trigger explosion if all letters are visible
  if (!isExploding && visibleLetters == "CHAOS".length()) {
    startExplosion();
  }
}

void mousePressed() {
  if (isExploding) return; // Ignore interactions during explosion

  if (activeHand.isMoving) {
    activeHand.isMoving = false;
    hands.add(activeHand);

    if (hands.size() > maxHands) {
      hands.clear();
    }

    activeHand = new Hand(-HALF_PI, random(20, 100), color(random(255), random(255), random(255)));
  } else if (activeHand.isClicked(mouseX - width / 2, mouseY - height / 2 + 50)) {
    activeHand.isMoving = true;
  }
}

void resetDrawing() {
  hands.clear();
  particles.clear();
  activeHand = new Hand(-HALF_PI, 100, color(255));
  isExploding = false;
  scaleFactor = 1.0;
  particlesReleased = false;
}

void startExplosion() {
  isExploding = true;
  scaleFactor = 1.0;
}

void releaseParticles() {
  // Create particles that will follow the infinity curve
  for (int i = 0; i < 900; i++) {
    float t = random(TWO_PI); // Random starting position along the curve
    float speed = random(0.01, 0.05); // Small step size for smooth motion
    float size = random(3, 8);
    color c = color(random(100, 255), random(100, 255), random(100, 255));
    particles.add(new Particle(width / 2, height / 2, t, speed, c, size));
  }
}

class Hand {
  float angle;
  float length;
  color col;
  boolean isMoving;

  Hand(float angle, float length, color col) {
    this.angle = angle;
    this.length = length;
    this.col = col;
    this.isMoving = true;
  }

  void drawHand() {
    stroke(col);
    strokeWeight(6);
    float x = cos(angle) * length;
    float y = sin(angle) * length;
    line(0, 0, x, y);
  }

  boolean isClicked(float mouseX, float mouseY) {
    float handX = cos(angle) * length;
    float handY = sin(angle) * length;
    float d = dist(mouseX, mouseY, handX, handY);
    return d < 10;
  }
}

class Particle {
  float originX, originY; // Start position
  float t; // Parametric time variable for infinity path
  float speed; // Speed along the curve
  color col;
  float size;
  float life = 255; // Particle life

  Particle(float x, float y, float t, float speed, color col, float size) {
    this.originX = x;
    this.originY = y;
    this.t = t;
    this.speed = speed;
    this.col = col;
    this.size = size;
  }

  void update() {
    // Move along the infinity symbol curve
    t += speed;
    float a = 100; // Scaling factor for the infinity curve
    float x = a * cos(t);
    float y = a * sin(2 * t) / 2;

    // Update position relative to the center
    originX = width / 2 + x;
    originY = height / 2 + y;

    life -= 2; // Gradually fade out
  }

  void display() {
    fill(col, life);
    noStroke();
    ellipse(originX, originY, size, size);
  }

  boolean isDead() {
    return life <= 0;
  }
}
