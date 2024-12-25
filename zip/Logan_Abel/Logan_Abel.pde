ArrayList<Particle> particles = new ArrayList<Particle>(); // List of particles
float time = 0; // Time for background and animation

void setup() {
  size(800, 800);
  smooth();
  particles.add(new Particle(width / 2, height / 2)); // Start with one particle
}

void draw() {
   // Time: Background changes from day to night
  float bgR = map(sin(time), -1, 1, 20, 100);
  float bgG = map(sin(time), -1, 1, 30, 120);
  float bgB = map(cos(time), -1, 1, 60, 150);
  background(bgR, bgG, bgB);;

  // Increment time for smooth animation
  time += 0.03 ;
  
    // Update and display all particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();

    // Remove particles if they grow too large or leave the screen
    if (p.isOffScreen() || p.size > 200) {
      particles.remove(i);
    }
  }
}

// Add new particles on mouse click
void mousePressed(){
  particles.add(new Particle(mouseX, mouseY));
}

// Particle class
class Particle {
  float x, y;        // Position
  float size;        // Current size
  float growthRate;  // Rate of growth
  float speedX, speedY; // Movement speed
  color particleColor; // Random color for the particle

  Particle(float startX, float startY) {
    x = startX;
    y = startY;
    size = random(5, 15); // Start small
    growthRate = random(0.3, 0.7); // Random growth rate
    speedX = random(-2, 2); // Random horizontal speed
    speedY = random(-2, 2); // Random vertical speed
    particleColor = color(random(100, 255), random(100, 255), random(100, 255)); // Random color
  }

  // Update particle's position and size
  void update() {
    x += speedX;
    y += speedY;
    size += growthRate; // Grow over time
  }

  // Display the particle
  void display() {
    noStroke();
    fill(particleColor, 200 - size); // Fade as it grows
    ellipse(x, y, size, size);
  }

  // Check if the particle is off-screen
  boolean isOffScreen() {
    return x < -50 || x > width + 50 || y < -50 || y > height + 50;
  }
}
