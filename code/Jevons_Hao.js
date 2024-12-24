let particles = []; // Array to store all the particles
let stars = []; // Array to store all the stars

// Flags to manage interaction modes
let attractMode = true; // Determines whether particles are attracted or repelled by the mouse
let mouseInteractionEnabled = true; // Controls if mouse interaction is enabled
let attractionStrength = 0.010;

function setup() {
  createCanvas(1000, 750); // Set the canvas size
  noStroke(); // Remove borders from shapes
  for (let j = 0; j < 300; j++) {
    stars.push(new Star(random(width), random(height)));
  }
}

function draw() {
  fill(0, 30); // Set a semi-transparent black fill to create a trailing effect
  rect(0, 0, width, height); // Draw a rectangle over the canvas for the trailing effect

  // Draw the moon
  fill(255);
  stroke(255);
  ellipse(200, 100, 75, 75); // White circle for the moon
  fill(0);
  stroke(0);
  ellipse(230, 92, 60, 60); // Black circle for the moon

  // Update and display each star
  for (let s of stars) {
    s.update();
    s.display();
  }

  // Update and display each particle
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    // Apply mouse interactions if enabled
    if (mouseInteractionEnabled && p instanceof Particle) {
      p.applyForce(mouseX, mouseY, attractionStrength, attractMode);

      // Remove dead particles
      if (p.isDead()) {
        particles.splice(i, 1);
      }
    }
  }

  // Maintain particle count at a maximum of 500
  while (particles.length < 500) {
    addParticle(random(width), random(height));
  }

  // Draw the other shapes for the bridge after updating particles
  fill(189, 191, 210);
  rect(195, 490, 10, 180);
  rect(345, 420, 10, 230);
  rect(495, 390, 10, 260);
  rect(645, 420, 10, 230);
  rect(800, 490, 10, 180);
  fill(171, 171, 171);
  rect(75, 675, 50, 150);
  rect(875, 675, 50, 150);
  fill(147, 157, 177);
  rect(0, 650, 1000, 25);

  // Create the arc for the bridge
  noFill();
  strokeWeight(20);
  stroke(189, 191, 210);
  arc(500, 825, 950, 850, PI + 0.2, TWO_PI - 0.2);

  // Second arc for the lights attached to the bridge
  strokeWeight(7);
  stroke(115, 255, 225);
  arc(500, 765, 885, 710, PI + 0.33, TWO_PI - 0.33);
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.fillColor = color(255);
    this.velocity = createVector(0, random(0.5, 2));
    this.lifespan = random(200, 400);
  }

  update() {
    this.x += this.velocity.x;
    this.y += this.velocity.y;
    this.lifespan -= 1.5;
  }

  applyForce(targetX, targetY, strength, isAttract) {
    let force = createVector(targetX - this.x, targetY - this.y);
    force.normalize();
    force.mult(isAttract ? strength : -strength);
    this.velocity.add(force);
  }

  display() {
    noStroke();
    fill(this.fillColor, map(this.lifespan, 0, 400, 0, 255));
    ellipse(this.x, this.y, map(this.lifespan, 0, 400, 1, 8), map(this.lifespan, 0, 400, 1, 8));
  }

  isDead() {
    return this.lifespan < 0;
  }
}

class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.brightness = random(25, 255);
    this.size = random(2, 5);
    this.speed = random(10, 50);
  }

  update() {
    this.brightness += this.speed;
    if (this.brightness > 255 || this.brightness < 25) {
      this.speed *= -1;
    }
  }

  display() {
    noStroke();
    fill(255, 235, 144, this.brightness);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

function keyPressed() {
  switch (key.toLowerCase()) {
    case 'o':
      mouseInteractionEnabled = !mouseInteractionEnabled;
      break;

    case 'm':
      for (let i = 0; i < 50; i++) {
        addParticle(random(width), random(height));
      }
      break;

    case 'g':
      particles = [];
      break;

    case 'f':
      for (let p of particles) {
        p.velocity.mult(random(0.5, 1.5));
      }
      break;

    case 's':
      attractionStrength += 0.005;
      break;

    case 'w':
      attractionStrength -= 0.005;
      break;
  }
}
