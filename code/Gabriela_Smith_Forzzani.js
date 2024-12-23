const PARTICLE_COUNT = 1000;
const GEOMETRY_COUNT = 550;

let pt = []; // Geometry parameters
let style = []; // Geometry styles
let progress = []; // Animation progress
let particles = []; // Particle system

let attractMode = false;
let mouseInteractionEnabled = false;
let attractionStrength = 0.05;
let burstCountdown;
let minBurstInterval = 100;
let maxBurstInterval = 200;
let minBurstSize = 200;
let maxBurstSize = 500;

function setup() {
  createCanvas(1400, 800, WEBGL);

  // Initialize geometry
  for (let i = 0; i < GEOMETRY_COUNT; i++) {
    progress[i] = 0;
    let index = i * 6;

    if (i % 5 === 0) {
      pt[index] = 0;
      pt[index + 1] = 0;
      pt[index + 2] = random(30, 50);
    } else {
      pt[index] = random(TWO_PI);
      pt[index + 1] = random(TWO_PI);
      pt[index + 2] = random(60, 120);
    }

    let prob = random(100);
    if (prob < 40) {
      style.push(color(250, 100, 250, 210));
    } else if (prob < 70) {
      style.push(color(255, 100, 0, 210));
    } else if (prob < 90) {
      style.push(color(100, 50, 255, 210));
    } else {
      style.push(color(50, 255, 50, 210));
    }

    style.push(floor(random(3)));
  }

  // Initialize particles
  for (let i = 0; i < PARTICLE_COUNT; i++) {
    addParticle(random(width), random(height));
  }

  burstCountdown = getRandomBurstInterval();
}

function draw() {
  background(0);

  // Update geometry progress
  for (let i = 0; i < GEOMETRY_COUNT; i++) {
    progress[i] += 0.005;
    if (progress[i] > 1) {
      progress[i] = 0;
    }
  }

  // Draw geometry
  push();
  translate(0, 0, 0);
  scale(8);
  rotateX(PI / 4);
  rotateY(PI / 6);

  let index = 0;
  for (let i = 0; i < GEOMETRY_COUNT; i++) {
    push();
    if (style[i * 2 + 1] === 2) {
      let p = progress[i];
      let radius = lerp(20, pt[index++], p);
      let innerRadius = radius / 3;
      let outerRadius = radius;
      fill(style[i * 2]);
      noStroke();
      drawStar(0, 0, innerRadius, outerRadius, 5);
    } else {
      rotateX(pt[index++]);
      rotateY(pt[index++]);
      let p = progress[i];
      let radius = lerp(20, pt[index++], p);
      let startAngle = lerp(0, pt[index++], p);
      let endAngle = lerp(TWO_PI, pt[index++], p);

      if (style[i * 2 + 1] === 0) {
        stroke(style[i * 2]);
        noFill();
        strokeWeight(2);
        arcLine(0, 0, radius, startAngle, endAngle);
      } else if (style[i * 2 + 1] === 1) {
        fill(style[i * 2]);
        noStroke();
        arcLineBars(0, 0, radius, startAngle, endAngle);
      }
    }
    pop();
  }
  pop();

  // Handle particle bursts
  burstCountdown--;
  if (burstCountdown <= 0) {
    triggerBurst();
    burstCountdown = getRandomBurstInterval();
  }

  // Update and display particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    if (mouseInteractionEnabled) {
      p.applyForce(mouseX - width / 2, mouseY - height / 2, attractionStrength, attractMode);
    }

    if (p.isDead()) {
      particles.splice(i, 1);
    }
  }
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = p5.Vector.random2D().mult(random(3, 9));
    this.lifespan = random(200, 400);
  }

  update() {
    this.x += this.velocity.x;
    this.y += this.velocity.y;
    this.lifespan -= 1.5;
  }

  display() {
    noStroke();
    fill(255, this.lifespan);
    let size = map(this.lifespan, 0, 400, 1, 8);
    ellipse(this.x, this.y, size);
  }

  applyForce(targetX, targetY, strength, isAttract) {
    let force = createVector(targetX - this.x, targetY - this.y).normalize();
    force.mult(isAttract ? strength : -strength);
    this.velocity.add(force);
  }

  isDead() {
    return this.lifespan < 0;
  }
}

function addParticle(x, y) {
  particles.push(new Particle(x, y));
}

function triggerBurst() {
  let burstSize = int(random(minBurstSize, maxBurstSize));
  for (let i = 0; i < burstSize; i++) {
    addParticle(random(width), random(height));
  }
}

function getRandomBurstInterval() {
  return int(random(minBurstInterval, maxBurstInterval));
}

function drawStar(x, y, innerRadius, outerRadius, points) {
  beginShape();
  let angleStep = TWO_PI / points;
  for (let a = 0; a < TWO_PI; a += angleStep) {
    let sx = x + cos(a) * outerRadius;
    let sy = y + sin(a) * outerRadius;
    vertex(sx, sy);
    sx = x + cos(a + angleStep / 2) * innerRadius;
    sy = y + sin(a + angleStep / 2) * innerRadius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

function arcLine(x, y, radius, startAngle, endAngle) {
  beginShape();
  for (let angle = startAngle; angle < endAngle; angle += radians(1)) {
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
  }
  endShape();
}

function arcLineBars(x, y, radius, startAngle, endAngle) {
  beginShape();
  for (let angle = startAngle; angle < endAngle; angle += radians(4)) {
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius + 10), y + sin(angle) * (radius + 10));
  }
  endShape(CLOSE);
}
