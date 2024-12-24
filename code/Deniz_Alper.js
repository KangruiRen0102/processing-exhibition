class Particle {
  constructor(x, y, velocityX, velocityY, size, alpha) {
    this.x = x;
    this.y = y;
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    this.size = size;
    this.alpha = alpha;
    this.creationTime = millis();

    // Assign particle color: UAlberta colors (dark green and golden yellow)
    this.particleColor = random(1) < 0.5 ? color(0, 100, 0) : color(255, 255, 0);
  }

  update() {
    this.x += this.velocityX;
    this.y += this.velocityY;

    // Calculate elapsed time and reduce alpha for fade-out effect
    let elapsedTime = millis() - this.creationTime;
    this.alpha = map(elapsedTime, 0, 3000, 255, 0);
  }

  display() {
    noStroke();
    fill(this.particleColor, this.alpha);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

let particles = [];
let lastMouseX = -1;
let lastMouseY = -1;

function setup() {
  createCanvas(800, 600);
  background(0);
}

function draw() {
  background(0, 10); // Add fading trail effect

  // Update and display all particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    if (p.alpha <= 0) {
      particles.splice(i, 1);
    }
  }

  // Generate particles if mouse is moving
  if (mouseX !== lastMouseX || mouseY !== lastMouseY) {
    let numParticles = 10;
    let size = random(5, 10);

    for (let i = 0; i < numParticles; i++) {
      let angle = random(TWO_PI);
      let speed = random(2, 4);
      let velocityX = cos(angle) * speed + (mouseX - pmouseX) * 0.1;
      let velocityY = sin(angle) * speed + (mouseY - pmouseY) * 0.1;

      let alpha = random(100, 255);
      particles.push(new Particle(mouseX, mouseY, velocityX, velocityY, size, alpha));
    }

    lastMouseX = mouseX;
    lastMouseY = mouseY;
  }
}

function mousePressed() {
  let numParticles = 300;
  let size = random(5, 10);

  for (let i = 0; i < numParticles; i++) {
    let angle = random(TWO_PI);
    let speed = random(2, 5);
    let velocityX = cos(angle) * speed;
    let velocityY = sin(angle) * speed;

    let alpha = random(100, 255);
    particles.push(new Particle(mouseX, mouseY, velocityX, velocityY, size, alpha));
  }
}
