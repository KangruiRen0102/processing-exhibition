let particles = []; // Array to hold particles
let galaxy; // Object to represent the galaxy
let planets = []; // Array of planets

function setup() {
  createCanvas(800, 600);
  galaxy = new Galaxy();

  // Initialize particles
  for (let i = 0; i < 100; i++) {
    particles.push(new Particle(random(width), random(height), randomColor(), random(2, 10)));
  }

  // Initialize planets
  for (let i = 0; i < 5; i++) {
    planets.push(new Planet(random(width), random(height), random(30, 80)));
  }
}

function draw() {
  // Draw a semi-transparent black rectangle for trails effect
  fill(0, 20);
  rect(0, 0, width, height);

  // Display galaxy
  galaxy.display();

  // Display and handle planets
  for (let planet of planets) {
    planet.display();
  }

  // Update and display particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];

    // Move particle
    p.move();

    // Attract particles to the galaxy center
    p.attractToGalaxy(galaxy);

    // Check attraction to planets
    for (let planet of planets) {
      p.attractTo(planet);

      // Remove particle if it overlaps a planet
      if (planet.isInside(p.x, p.y)) {
        particles.splice(i, 1);
        break;
      }
    }

    // Display particle
    p.display();
  }

  // Simulate growth by adding more particles over time
  if (frameCount % 20 === 0 && particles.length < 200) {
    particles.push(new Particle(random(width), random(height), randomColor(), random(2, 10)));
  }
}

function mousePressed() {
  // Create a burst of particles at the mouse position
  for (let i = 0; i < 50; i++) {
    particles.push(new Particle(mouseX, mouseY, randomColor(), random(2, 10)));
  }
}

function randomColor() {
  return color(random(255), random(255), random(255));
}

// Class representing a particle
class Particle {
  constructor(x, y, c, size) {
    this.x = x;
    this.y = y;
    this.c = c;
    this.size = size;
    this.dx = random(-2, 2);
    this.dy = random(-2, 2);
    this.trail = [];
  }

  move() {
    this.x += this.dx;
    this.y += this.dy;

    // Bounce off edges
    if (this.x < 0 || this.x > width) this.dx *= -1;
    if (this.y < 0 || this.y > height) this.dy *= -1;

    // Add position to trail
    this.trail.push(createVector(this.x, this.y));

    // Limit trail length
    if (this.trail.length > 50) {
      this.trail.shift();
    }
  }

  attractToGalaxy(galaxy) {
    let strength = 0.01;
    let angle = atan2(galaxy.y - this.y, galaxy.x - this.x);
    this.dx += cos(angle) * strength;
    this.dy += sin(angle) * strength;
  }

  attractTo(planet) {
    let strength = 0.01;
    let angle = atan2(planet.y - this.y, planet.x - this.x);
    this.dx += cos(angle) * strength;
    this.dy += sin(angle) * strength;
  }

  display() {
    // Draw trail
    for (let i = 0; i < this.trail.length - 1; i++) {
      let v1 = this.trail[i];
      let v2 = this.trail[i + 1];
      let alpha = map(i, 0, this.trail.length, 50, 255);
      stroke(red(this.c), green(this.c), blue(this.c), alpha);
      line(v1.x, v1.y, v2.x, v2.y);
    }

    // Draw particle
    fill(this.c);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}

// Class representing a planet
class Planet {
  constructor(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.c = randomColor();
  }

  display() {
    // Shadow effect
    fill(0, 100);
    ellipse(this.x + 5, this.y + 5, this.radius * 2);

    // Planet
    fill(this.c);
    noStroke();
    ellipse(this.x, this.y, this.radius * 2);
  }

  isInside(px, py) {
    return dist(px, py, this.x, this.y) < this.radius;
  }
}

// Class representing the galaxy
class Galaxy {
  constructor() {
    this.x = width / 2;
    this.y = height / 2;
  }

  display() {
    noFill();

    // Concentric circles
    for (let i = 0; i < 10; i++) {
      let radius = i * 40;
      let alpha = map(i, 0, 10, 50, 255);
      stroke(100 + i * 10, 100 + i * 15, 255 - i * 15, alpha);
      strokeWeight(2);
      ellipse(this.x, this.y, radius * 2);
    }

    // Random particles around center
    for (let i = 0; i < 5; i++) {
      let angle = random(TWO_PI);
      let distance = random(30, 100);
      let px = this.x + cos(angle) * distance;
      let py = this.y + sin(angle) * distance;
      fill(255, random(100, 255), random(100, 255), 150);
      noStroke();
      ellipse(px, py, random(2, 5));
    }
  }
}
