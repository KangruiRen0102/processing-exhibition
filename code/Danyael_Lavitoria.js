let petals = [];
let ripples = [];
let angleOffset = 0;

function setup() {
  createCanvas(800, 800);

  // Create initial petals
  for (let i = 0; i < 200; i++) {
    petals.push(new Petal(random(width), random(height)));
  }
}

function draw() {
  background(20, 20, 40, 20); // Background with fade effect
  translate(width / 2, height / 2); // Center canvas

  let time = millis() * 0.001; // Time variable for dynamic effects

  // Update and display petals
  for (let p of petals) {
    p.update();
    p.display();
  }

  // Update and display ripple effects
  for (let i = ripples.length - 1; i >= 0; i--) {
    let r = ripples[i];
    r.update();
    r.display();
    if (r.lifespan <= 0) {
      ripples.splice(i, 1); // Remove faded ripples
    }
  }

  // Draw blooming pattern
  noFill();
  for (let r = 20; r < 300; r += 15) {
    let angleStep = map(sin(time + r * 0.01), -1, 1, PI / 4, TWO_PI / 8);
    stroke(lerpColor(color(255, 180, 200), color(100, 180, 255), sin(r * 0.01)));
    beginShape();
    for (let a = 0; a < TWO_PI; a += angleStep) {
      let x = cos(a) * r;
      let y = sin(a) * r;
      vertex(x, y);
    }
    endShape(CLOSE);
  }

  angleOffset += 0.01; // Increment angle offset for smooth changes
}

function mousePressed() {
  // Generate a wave of ripples around the mouse click
  let radius = 30; // Distance between ripples
  for (let i = 0; i < 9; i++) {
    let angle = TWO_PI / 9 * i; // Angle of each ripple
    let delay = i * 5; // Delay for each ripple
    ripples.push(new Ripple(mouseX - width / 2, mouseY - height / 2, angle, delay));
  }
}

class Petal {
  constructor(x, y) {
    this.pos = createVector(x, y);
    this.vel = p5.Vector.random2D();
    this.acc = createVector();
    this.maxSpeed = 2; // Maximum speed
    this.maxForce = 0.05; // Maximum steering force
    this.size = random(10, 20); // Petal size
    this.angle = random(TWO_PI); // Rotation angle
  }

  update() {
    // Flow field using Perlin noise
    let flow = p5.Vector.fromAngle(noise(this.pos.x * 0.01, this.pos.y * 0.01, frameCount * 0.01) * TWO_PI);
    flow.mult(this.maxSpeed);
    let steer = p5.Vector.sub(flow, this.vel);
    steer.limit(this.maxForce);
    this.acc.add(steer);

    this.vel.add(this.acc);
    this.vel.limit(this.maxSpeed);
    this.pos.add(this.vel);
    this.acc.mult(0);

    // Wrap around edges
    if (this.pos.x > width) this.pos.x = 0;
    if (this.pos.x < 0) this.pos.x = width;
    if (this.pos.y > height) this.pos.y = 0;
    if (this.pos.y < 0) this.pos.y = height;

    this.angle += 0.05; // Rotate gently
  }

  display() {
    push();
    translate(this.pos.x - width / 2, this.pos.y - height / 2);
    rotate(this.angle);
    noStroke();
    fill(255, 100, 150, 150);
    beginShape();
    vertex(0, -this.size / 2);
    bezierVertex(this.size / 2, -this.size, this.size / 2, this.size, 0, this.size / 2);
    bezierVertex(-this.size / 2, this.size, -this.size / 2, -this.size, 0, -this.size / 2);
    endShape(CLOSE);
    pop();
  }
}

class Ripple {
  constructor(x, y, angle, delay) {
    this.x = x + cos(angle) * 30; // Offset by initial angle
    this.y = y + sin(angle) * 30;
    this.angle = angle;
    this.radius = 0; // Start with a radius of 0
    this.delay = delay; // Delay before the ripple starts expanding
    this.lifespan = 255; // Start with full opacity
  }

  update() {
    if (this.delay > 0) {
      this.delay -= 1; // Wait for the delay to expire
      return;
    }
    this.radius += 5; // Increase radius to expand the ripple
    this.lifespan -= 5; // Decrease lifespan to fade the ripple
  }

  display() {
    if (this.delay > 0) return; // Don't display until the delay has expired
    noFill();
    stroke(100, 150, 255, this.lifespan); // Blue with fading opacity
    strokeWeight(2);
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2); // Draw expanding circle
  }
}
