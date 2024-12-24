let ps; // Particle system
let can; // Watering can
let flower; // Flower instance

function setup() {
  createCanvas(1200, 800);
  ps = new ParticleSystem(createVector(mouseX, mouseY));
  can = new WateringCan(createVector(300, 150));
  spawnFlower();
}

function draw() {
  background(135, 206, 235); // Sky blue background
  drawClouds();
  drawGround();
  can.update(mouseX, mouseY);

  if (mouseIsPressed) {
    can.tilt(true);
    ps.setOrigin(can.x + can.canWidth / 2, can.y + 10);
    for (let i = 0; i < 7; i++) {
      ps.addParticle();
    }
  } else {
    can.tilt(false);
  }

  can.display();
  ps.run();

  if (flower) {
    flower.display();
    flower.grow(ps);
  }
}

// Spawns a new flower
function spawnFlower() {
  let flowerX = random(0, width - 150);
  let flowerY = height - 100;
  flower = new Flower(flowerX, flowerY);
}

// Draws clouds in the sky
function drawClouds() {
  fill(255, 255, 255, 200);
  noStroke();

  ellipse(200, 100, 120, 60);
  ellipse(170, 80, 100, 50);
  ellipse(230, 90, 90, 45);
  ellipse(250, 110, 70, 35);

  ellipse(500, 70, 100, 50);
  ellipse(800, 130, 70, 35);
  ellipse(770, 120, 60, 30);
  ellipse(830, 120, 50, 25);
}

// Draws the ground
function drawGround() {
  fill(34, 139, 34); // Green ground
  rect(0, height - 100, width, 100);
}

// Flower class
class Flower {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = 0; // Stem height
    this.petalSize = 5; // Petal size
    this.maxSize = 200;
    this.growthRateStem = 2;
    this.growthRatePetals = 1;
    this.isAlive = true;
    this.petalCount = 12;
    this.growthThreshold = 5;
    this.isSeed = true;
  }

  display() {
    if (this.isSeed) {
      // Seed
      fill(150, 75, 25);
      noStroke();
      circle(this.x, this.y, 10);
    } else {
      // Stem
      stroke(34, 139, 34);
      strokeWeight(5);
      line(this.x, this.y, this.x, this.y - this.size);

      // Center of flower
      fill(255, 204, 0);
      noStroke();
      ellipse(this.x, this.y - this.size, this.petalSize / 2, this.petalSize / 2);

      // Petals
      fill(255, 255, 255);
      for (let i = 0; i < this.petalCount; i++) {
        let angle = TWO_PI / this.petalCount * i;
        let petalX = this.x + cos(angle) * this.petalSize * 0.5;
        let petalY = this.y - this.size + sin(angle) * this.petalSize * 0.5;

        push();
        translate(petalX, petalY);
        rotate(angle);
        ellipse(0, 0, this.petalSize * 0.6, this.petalSize * 0.3);
        pop();
      }
    }
  }

  grow(ps) {
    if (this.isAlive) {
      let waterHits = 0;

      // Count particles near the flower
      for (let p of ps.particles) {
        if (dist(p.position.x, p.position.y, this.x, this.y) < 30) {
          waterHits++;
        }
      }

      if (this.isSeed && waterHits >= this.growthThreshold) {
        this.isSeed = false;
      }

      if (!this.isSeed && waterHits >= this.growthThreshold) {
        if (this.size < this.maxSize) {
          this.size += this.growthRateStem;
        }

        if (this.petalSize < this.size * 0.75) {
          this.petalSize += this.growthRatePetals;
        }
      }
    }

    if (this.size >= this.maxSize) {
      this.die();
    }
  }

  die() {
    this.isAlive = false;
    spawnFlower();
  }
}

// Particle class
class Particle {
  constructor(l) {
    this.acceleration = createVector(0, 0.05);
    this.velocity = createVector(random(-1, 1), random(2, 3));
    this.position = l.copy();
    this.lifespan = 255.0;
  }

  run() {
    this.update();
    this.display();
  }

  update() {
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);

    if (this.position.y >= height - 100) {
      this.lifespan = 0;
    }

    this.lifespan -= 2.0;
  }

  display() {
    fill(0, 0, 255, this.lifespan);
    ellipse(this.position.x, this.position.y, 4, 6);
    noStroke();
  }

  isDead() {
    return this.lifespan <= 0.0;
  }
}

// Particle system class
class ParticleSystem {
  constructor(position) {
    this.particles = [];
    this.origin = position.copy();
  }

  setOrigin(x, y) {
    this.origin.set(x - 157, y + 40);
  }

  addParticle() {
    let offsetX = random(-1, 1);
    let offsetY = random(-10, 10);
    let offsetOrigin = createVector(this.origin.x + offsetX, this.origin.y + offsetY);
    this.particles.push(new Particle(offsetOrigin));
  }

  run() {
    for (let i = this.particles.length - 1; i >= 0; i--) {
      let p = this.particles[i];
      p.run();
      if (p.isDead()) {
        this.particles.splice(i, 1);
      }
    }
  }
}

// Watering can class
class WateringCan {
  constructor(position) {
    this.x = position.x;
    this.y = position.y;
    this.canWidth = 100;
    this.canHeight = 80;
    this.spoutWidth = 70;
    this.spoutHeight = 20;
    this.topHeight = 40;
    this.handleArcWidth = 100;
    this.handleArcHeight = 100;
    this.spoutAngle = PI / 6;
    this.angle = 0;
  }

  update(mx, my) {
    this.x = mx;
    this.y = my;
  }

  display() {
    push();
    translate(this.x, this.y);
    rotate(this.angle);

    fill(150, 150, 255);
    rectMode(CENTER);
    rect(0, 0, this.canWidth, this.canHeight);

    fill(100, 100, 200);
    ellipse(0, -this.topHeight, this.canWidth, this.topHeight);

    fill(0);
    ellipse(0, -this.topHeight, 50, 20);

    push();
    translate(-45, 0);
    rotate(this.spoutAngle);
    fill(150, 150, 255);
    rect(-this.spoutWidth / 2, 0, this.spoutWidth, this.spoutHeight);
    pop();

    noFill();
    stroke(0);
    strokeWeight(3);
    arc(0, -40, this.handleArcWidth, this.handleArcHeight, PI, TWO_PI);
    pop();
  }

  tilt(isTilting) {
    this.angle = isTilting ? -PI / 4 : 0;
  }
}
