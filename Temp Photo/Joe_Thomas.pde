ArrayList<Particle> particles; // List to hold particles
Galaxy galaxy; // Object to represent the galaxy
ArrayList<Planet> planets; // List of planets

void setup() {
  size(800, 600);
  particles = new ArrayList<Particle>();
  galaxy = new Galaxy();
  planets = new ArrayList<Planet>();

  // Initialize some particles for chaos
  for (int i = 0; i < 100; i++) {
    particles.add(new Particle(random(width), random(height), randomColor(), random(2, 10)));
  }

  // Create planets with random colors
  for (int i = 0; i < 5; i++) {
    planets.add(new Planet(random(width), random(height), random(30, 80)));
  }
}

void draw() {
  // Draw a semi-transparent black rectangle for trails effect
  fill(0, 20);
  rect(0, 0, width, height);

  // Display galaxy
  galaxy.display();

  // Display and handle planets
  for (Planet p : planets) {
    p.display();
  }

  // Update and display particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);

    // Move particle
    p.move();

    // Attract particles to the galaxy center
    p.attractToGalaxy(galaxy);

    // Check attraction to planets
    for (Planet planet : planets) {
      p.attractTo(planet);

      // If the particle overlaps a planet, remove it
      if (planet.isInside(p.x, p.y)) {
        particles.remove(i);
        break;
      }
    }

    // Display particle
    p.display();
  }

  // Simulate growth by adding more particles over time
  if (frameCount % 20 == 0 && particles.size() < 200) {
    particles.add(new Particle(random(width), random(height), randomColor(), random(2, 10)));
  }
}

// Mouse interaction: Create a burst of particles at the mouse position
void mousePressed() {
  for (int i = 0; i < 50; i++) { // Create 50 particles for the burst
    particles.add(new Particle(mouseX, mouseY, randomColor(), random(2, 10)));
  }
}

// Helper to generate random colors
color randomColor() {
  return color(random(255), random(255), random(255));
}

// Class representing a particle
class Particle {
  float x, y; // Position
  float dx, dy; // Direction of movement
  float size; // Size of the particle
  color c; // Color of the particle
  ArrayList<PVector> trail; // To store trail positions

  Particle(float x, float y, color c, float size) {
    this.x = x;
    this.y = y;
    this.c = c;
    this.size = size;
    this.dx = random(-2, 2);
    this.dy = random(-2, 2);
    trail = new ArrayList<PVector>();
  }

  // Move the particle
  void move() {
    x += dx;
    y += dy;

    // Bounce off edges
    if (x < 0 || x > width) dx *= -1;
    if (y < 0 || y > height) dy *= -1;

    // Add position to trail
    trail.add(new PVector(x, y));

    // Limit the length of the trail
    if (trail.size() > 50) {
      trail.remove(0);
    }
  }

  // Attract the particle to the galaxy (effectively, the center of the galaxy)
  void attractToGalaxy(Galaxy g) {
    float strength = 0.01; // Attraction strength
    float angle = atan2(g.y - y, g.x - x);
    dx += cos(angle) * strength;
    dy += sin(angle) * strength;
  }

  // Attract the particle to a planet
  void attractTo(Planet planet) {
    float strength = 0.01; // Attraction strength
    float angle = atan2(planet.y - y, planet.x - x);
    dx += cos(angle) * strength;
    dy += sin(angle) * strength;
  }

  // Display the particle and its trail
  void display() {
    // Draw the trail
    for (int i = 0; i < trail.size() - 1; i++) {
      PVector v1 = trail.get(i);
      PVector v2 = trail.get(i + 1);
      float alpha = map(i, 0, trail.size(), 50, 255);
      stroke(c, alpha);
      line(v1.x, v1.y, v2.x, v2.y);
    }

    // Draw the particle
    fill(c);
    noStroke();
    ellipse(x, y, size, size);
  }
}

// Class representing a planet
class Planet {
  float x, y; // Position
  float radius; // Radius of the planet
  color c; // Color of the planet

  Planet(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.c = randomColor(); // Planets now have a random color
  }

  // Display the planet with a shadow to make it look more 3D
  void display() {
    // Create a shadow effect
    fill(0, 100);
    ellipse(x + 5, y + 5, radius * 2, radius * 2); // Shadow offset

    // Display the planet
    fill(c);
    noStroke();
    ellipse(x, y, radius * 2, radius * 2);
  }

  // Check if a point is inside the planet
  boolean isInside(float px, float py) {
    return dist(px, py, x, y) < radius;
  }
}

// Class representing the galaxy
class Galaxy {
  float x, y; // Position of the galaxy center

  Galaxy() {
    x = width / 2;
    y = height / 2; // Position the galaxy in the center
  }

  // Display the galaxy with spiral arms
  void display() {
    noFill();
    // Create concentric circles with varying colors to mimic a galaxy
    for (int i = 0; i < 10; i++) {
      float radius = i * 40;
      float alpha = map(i, 0, 10, 50, 255); // Fade out the color
      stroke(100 + i * 10, 100 + i * 15, 255 - i * 15, alpha); // Galaxy-like color (greenish-blue to purple)
      strokeWeight(2);
      ellipse(x, y, radius * 2, radius * 2);
    }
    
    // Add some random particles around the galaxy center to make it more realistic
    for (int i = 0; i < 5; i++) {
      float angle = random(TWO_PI);
      float distance = random(30, 100);
      float px = x + cos(angle) * distance;
      float py = y + sin(angle) * distance;
      fill(255, random(100, 255), random(100, 255), 150); // Faint stars
      noStroke();
      ellipse(px, py, random(2, 5), random(2, 5));
    }
  }
}
