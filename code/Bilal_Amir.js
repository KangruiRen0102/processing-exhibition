let stars = []; // Array for stars
let plants = []; // Array for plants
let auroraOffset = 0; // Offset for aurora animation
let timeOfDay = 0.0; // Slider for time of day

function setup() {
  createCanvas(1200, 700);
  noStroke();

  // Create stars with random positions and brightness
  for (let i = 0; i < 800; i++) {
    let x = random(width);
    let y = random(height / 2);
    let brightness = random(100, 255);
    stars.push(new Star(x, y, brightness));
  }

  // Create plants with random positions and heights
  for (let i = 0; i < 15; i++) {
    let x = random(50, width - 50);
    let height = random(50, 150);
    plants.push(new Plant(x, height - 50, height));
  }
}

function draw() {
  // Sky background with transition effect
  let skyColor = lerpColor(color(10, 10, 50), color(255, 180, 100), constrain((timeOfDay - 0.7) * 3, 0, 1));
  background(skyColor);

  // Stars fading based on timeOfDay
  let alpha = 1 - constrain(timeOfDay, 0, 1);
  drawAurora(alpha);

  // Display stars
  for (let star of stars) {
    star.display(alpha);
  }

  drawMoon();
  drawSea();

  // Display plants
  for (let plant of plants) {
    plant.display();
  }

  drawSlider();
}

class Star {
  constructor(x, y, brightness) {
    this.x = x;
    this.y = y;
    this.brightness = brightness;
  }

  display(alpha) {
    fill(255, 255, 255, this.brightness * alpha);
    ellipse(this.x, this.y, 3, 3);
  }
}

class Plant {
  constructor(x, y, height) {
    this.x = x;
    this.y = y;
    this.height = height;
  }

  display() {
    stroke(34, 139, 34);
    strokeWeight(3);
    line(this.x, this.y, this.x, this.y - this.height);

    noStroke();
    fill(34, 139, 34);
    for (let i = 0; i < this.height; i += 20) {
      ellipse(this.x - 5, this.y - i, 10, 5);
      ellipse(this.x + 5, this.y - i, 10, 5);
    }
  }
}

function drawMoon() {
  let moonX = map(timeOfDay, 0, 1, 50, width - 50);
  let moonY = height / 2.54 - sin(timeOfDay * 3) * (height / 6);

  fill(255, 255, 200);
  ellipse(moonX, moonY, 80, 80);

  fill(10, 10, 10);
  ellipse(moonX + 25, moonY, 80, 80);
}

function drawAurora(alpha) {
  let colors = [
    color(0, 255, 150, 150),
    color(50, 200, 255, 100),
    color(200, 100, 255, 80)
  ];

  let streakCount = 500;
  let streakWidth = width / streakCount;

  for (let i = 0; i < streakCount; i++) {
    let x = map(i, 0, streakCount, 0, width);
    let noiseValue = noise(i * 0.05, auroraOffset);
    let streakHeight = map(noiseValue, 0, 1, height / 6, height / 3);
    fill(colors[i % colors.length], alpha * 255);
    rect(x, 0, streakWidth, streakHeight);
  }

  auroraOffset += 0.002;
}

function drawSea() {
  fill(0, 0, 100, 180);
  rect(0, height / 2, width, height / 2);

  fill(139, 69, 19);
  rect(0, height - 50, width, 50);
}

function drawSlider() {
  fill(200);
  rect(20, height - 40, width - 40, 20, 10);

  fill(50);
  let sliderX = map(timeOfDay, 0, 1, 20, width - 20);
  ellipse(sliderX, height - 30, 20, 20);
}

function mouseDragged() {
  if (mouseY > height - 50 && mouseY < height - 20) {
    timeOfDay = map(mouseX, 20, width - 20, 0, 1);
    timeOfDay = constrain(timeOfDay, 0, 1);
  }
}
