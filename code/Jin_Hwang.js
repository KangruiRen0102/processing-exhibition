let maxPetals = 20; // Maximum number of petals
let petalCount = 0; // Number of petals currently drawn
let petalRadius = 0; // Radius of petals at start
let petalGrowthRate = 0.6; // Speed of petal growth
let growthStage = 0; // Stage of flower growth (from 0 to 1)
let wiltingStage = 0; // Stage of wilting after full bloom
let timeFactor = 1; // Controls the speed of growth (interactive)
let lightIntensity = 0; // Light intensity for time progression
let oscillationFactor = 0.05; // Subtle oscillation to make petals less shaky
let isGrowing = true; // Flag to track if growth is happening
let isDying = false; // Flag to track if the flower is dying
let particles = []; // Particle system for dynamic effects
let pauseGrowth = false; // Flag to pause flower growth
let fadeFactor = 0; // Factor to control the fading of all elements

function setup() {
  createCanvas(600, 600);
  frameRate(30); // Slow down frame rate to visualize time passing
}

function draw() {
  if (isDying) {
    fadeFactor += 0.02;
    fadeFactor = constrain(fadeFactor, 0, 1);
  }

  let bgColor = lerpColor(color(255, 223, 186), color(50, 50, 100), fadeFactor);
  background(bgColor);

  lightIntensity = map(fadeFactor, 0, 1, 50, 255);

  if (isGrowing && !isDying && !pauseGrowth) {
    growthStage += petalGrowthRate * timeFactor * 0.01;
    growthStage = constrain(growthStage, 0, 1);
  }

  if (growthStage >= 1 && !isDying) {
    wiltingStage += 0.05;
    wiltingStage = constrain(wiltingStage, 0, 1);
  }

  if (petalCount < maxPetals && growthStage > 0.5) {
    petalCount++;
  }

  translate(width / 2, height / 2);

  drawPetalsLayer(1, 50, 120, color(255, 100, 100));
  if (growthStage > 0.6) drawPetalsLayer(2, 60, 140, color(255, 50, 50));
  if (growthStage > 0.8) drawPetalsLayer(3, 70, 160, color(255, 20, 100));

  if (wiltingStage > 0) {
    wiltingPetals();
  }

  if (isDying) {
    dyingProcess();
  }

  fill(255, 200, 0, 180 * (1 - fadeFactor));
  ellipse(0, 0, 70, 70);

  noFill();
  stroke(255, 200, 0, 150 * (1 - fadeFactor));
  strokeWeight(8);
  ellipse(0, 0, 80, 80);

  fill(255, 180 * (1 - fadeFactor));
  textAlign(CENTER, CENTER);
  textSize(18);
  text("Click to control speed, hold to stop growth, press 'r' to reset, press 'd' to make flower die, 'p' to pause growth", width / 2, height - 30);

  updateParticles();
  for (let p of particles) {
    p.display();
  }

  if (growthStage > 0.5) {
    addParticles();
  }
}

function drawPetalsLayer(layer, minSize, maxSize, petalColor) {
  for (let i = 0; i < petalCount; i++) {
    let angle = map(i, 0, petalCount, 0, TWO_PI);
    let x = (petalRadius + layer * 30) * cos(angle);
    let y = (petalRadius + layer * 30) * sin(angle);
    let oscillation = sin(angle * 3 + sin(growthStage * PI)) * oscillationFactor;

    push();
    rotate(angle + radians(30) + oscillation);
    fill(petalColor.levels[0], petalColor.levels[1], petalColor.levels[2], 180 * (1 - fadeFactor));
    noStroke();
    drawCurvedPetal(x, y, minSize, maxSize);
    pop();
  }
}

function drawCurvedPetal(x, y, width, height) {
  beginShape();
  for (let t = 0; t <= 1; t += 0.1) {
    let xt = x + width * sin(PI * t);
    let yt = y + height * cos(PI * t);
    vertex(xt, yt);
  }
  endShape(CLOSE);
}

function wiltingPetals() {
  for (let i = 0; i < petalCount; i++) {
    let angle = map(i, 0, petalCount, 0, TWO_PI);
    let x = (petalRadius + 60) * cos(angle);
    let y = (petalRadius + 60) * sin(angle);

    let wiltingSize = lerp(70, 50, wiltingStage);
    let wiltingHeight = lerp(160, 120, wiltingStage);

    push();
    rotate(angle + radians(15));
    fill(255, 20, 100, 180 * (1 - fadeFactor));
    noStroke();
    ellipse(x, y, wiltingSize, wiltingHeight);
    pop();
  }
}

function dyingProcess() {
  for (let i = 0; i < petalCount; i++) {
    let angle = map(i, 0, petalCount, 0, TWO_PI);
    let x = (petalRadius + 60) * cos(angle);
    let y = (petalRadius + 60) * sin(angle);

    let dyingSize = lerp(70, 0, fadeFactor);
    let dyingHeight = lerp(160, 0, fadeFactor);

    push();
    rotate(angle + radians(15));
    fill(150, 50, 50, 180 * (1 - fadeFactor));
    noStroke();
    ellipse(x, y, dyingSize, dyingHeight);
    pop();
  }

  fill(200, 100, 0, 180 * (1 - fadeFactor));
  ellipse(0, 0, 50, 50);

  stroke(255, 200, 0, 150 * (1 - fadeFactor));
  strokeWeight(8);
  ellipse(0, 0, 80, 80);

  if (fadeFactor >= 1) {
    isDying = false;
  }
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-1, 1);
    this.speedY = random(-1, 1);
    this.lifespan = 255;
    this.c = color(random(100, 255), random(100, 200), random(100, 200), this.lifespan);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    this.lifespan -= 2;
    this.lifespan = max(this.lifespan, 0);
    this.c.setAlpha(this.lifespan * (1 - fadeFactor));
  }

  display() {
    noStroke();
    fill(this.c);
    ellipse(this.x, this.y, 5, 5);
  }
}

function addParticles() {
  for (let i = 0; i < 5; i++) {
    let angle = random(TWO_PI);
    let radius = random(petalRadius, petalRadius + 60);
    let x = radius * cos(angle);
    let y = radius * sin(angle);

    particles.push(new Particle(x, y));
  }
}

function updateParticles() {
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    if (p.lifespan === 0) {
      particles.splice(i, 1);
    }
  }
}

function mousePressed() {
  timeFactor = 2;
  isGrowing = true;
}

function mouseReleased() {
  timeFactor = 0.5;
  isGrowing = false;
}

function keyPressed() {
  if (key === 'r' || key === 'R') {
    petalCount = 0;
    petalRadius = 0;
    growthStage = 0;
    wiltingStage = 0;
    fadeFactor = 0;
    isGrowing = true;
    isDying = false;
    particles = [];
  }

  if (key === 'd' || key === 'D') {
    isDying = true;
    isGrowing = false;
  }

  if (key === 'p' || key === 'P') {
    pauseGrowth = !pauseGrowth;
  }
}
