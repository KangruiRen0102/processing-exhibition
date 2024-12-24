let skyline;
let numBands = 15;
let offsets = [];
let particles = [];
let memoryTexts = [
  "Snow crunching in Edmonton's winter...",
  "The colors of Aurora looked like painting in night sky...",
  "A quiet walk in Elk Island...",
  "Warm Lights in a cold night was new to me...",
];
let memoryIndex = 0;
let memoryTimer = 0;

function setup() {
  createCanvas(900, 600);
  skyline = createSkyline();
  for (let i = 0; i < numBands; i++) {
    offsets[i] = random(TWO_PI);
  }
}

function draw() {
  background(0);
  drawAurora();
  drawMoon();
  shape(skyline, 0, height - 150);
  drawParticles();
  drawMemoryText();
}

function drawMoon() {
  let moonX = width - 100;
  let moonY = 100;
  let moonRadius = 80;

  for (let r = moonRadius * 1.5; r > moonRadius; r -= 5) {
    fill(255, 255, 200, map(r, moonRadius, moonRadius * 1.5, 20, 0));
    ellipse(moonX, moonY, r, r);
  }

  fill(255, 255, 200);
  ellipse(moonX, moonY, moonRadius, moonRadius);

  fill(230, 230, 180);
  ellipse(moonX - 15, moonY - 10, 10, 10);
  ellipse(moonX + 10, moonY + 5, 15, 15);
  ellipse(moonX - 20, moonY + 15, 8, 8);
}

function drawAurora() {
  noStroke();
  for (let i = 0; i < numBands; i++) {
    let yOffset = map(noise(i * 0.1, millis() * 0.0001), 0, 1, 80, 180);
    let alpha = map(sin(millis() * 0.0005 + offsets[i]), -1, 1, 40, 100);

    let color1 = color(0, 128, 255);
    let color2 = color(0, 255, 128);
    let color3 = color(255, 64, 64);
    let color4 = color(255, 0, 128);

    let colorNoise = noise(i * 0.1, millis() * 0.0001);
    let blendedColor = lerpColor(
      lerpColor(color1, color2, colorNoise),
      lerpColor(color3, color4, colorNoise),
      sin(millis() * 0.0005)
    );

    fill(blendedColor, alpha);
    beginShape();
    for (let x = 0; x <= width; x += 10) {
      let noiseFactor = noise(x * 0.0001, i * 0.01) * 30;
      let curtainEffect = sin(x * 0.004 + millis() * 0.00007) * 80;
      let y = height / 2 - yOffset + noiseFactor + curtainEffect;
      vertex(x, y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

function createSkyline() {
  let skyline = createGraphics(width, 200);
  skyline.fill(20);
  skyline.stroke(255);

  skyline.beginShape();
  skyline.vertex(0, 150);
  skyline.vertex(80, 100);
  skyline.vertex(120, 120);
  skyline.vertex(200, 90);
  skyline.vertex(240, 110);
  skyline.vertex(320, 70);
  skyline.vertex(400, 140);
  skyline.vertex(500, 80);
  skyline.vertex(600, 120);
  skyline.vertex(750, 100);
  skyline.vertex(900, 150);
  skyline.vertex(900, 200);
  skyline.vertex(0, 200);
  skyline.endShape(CLOSE);

  return skyline;
}

function drawParticles() {
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
    if (p.isFaded()) {
      particles.splice(i, 1);
    }
  }

  if (frameCount % 10 === 0) {
    particles.push(new Particle(random(width), random(height / 2 - 100, height / 2 + 50)));
  }
}

function drawMemoryText() {
  fill(255, 200);
  textSize(22);
  textAlign(CENTER);
  text(memoryTexts[memoryIndex], width / 2, height - 30);

  memoryTimer++;
  if (memoryTimer > 300) {
    memoryIndex = (memoryIndex + 1) % memoryTexts.length;
    memoryTimer = 0;
  }
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.alpha = 255;
    this.speedX = random(-1, 1);
    this.speedY = random(-0.5, -1.5);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    this.alpha -= 2;
  }

  display() {
    noStroke();
    fill(255, this.alpha);
    ellipse(this.x, this.y, 5, 5);
  }

  isFaded() {
    return this.alpha <= 0;
  }
}
