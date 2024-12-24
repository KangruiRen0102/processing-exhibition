let flowers = [];
let grassBackground;

function setup() {
  createCanvas(800, 800);
  noStroke();

  // Create the grassy background
  grassBackground = createGraphics(width, height);
  grassBackground.background(34, 139, 34); // Base grassy green color

  // Draw random grass blades
  grassBackground.stroke(29, 115, 29); // Darker green for blades
  for (let i = 0; i < 500; i++) {
    let x = random(width);
    let y = random(height);
    let length = random(10, 30);
    grassBackground.line(x, y, x, y - length);
  }
  grassBackground.noStroke();

  // Add patches of grass
  grassBackground.fill(0, 100, 0, 150); // Darker green with transparency
  for (let i = 0; i < 20; i++) {
    grassBackground.ellipse(random(width), random(height), random(20, 60), random(10, 30));
  }
}

function draw() {
  // Draw the static grassy background
  image(grassBackground, 0, 0);

  // Update and display all flowers
  for (let i = flowers.length - 1; i >= 0; i--) {
    let flower = flowers[i];
    flower.update();
    flower.display();
    // Remove flower if it has fully withered and faded out
    if (flower.isFadedOut()) {
      flowers.splice(i, 1);
    }
  }

  // Draw clock in the upper-right corner
  drawClock(width - 100, 100, 50); // Position and size of the clock
}

function mousePressed() {
  flowers.push(new BloomingFlower(mouseX, mouseY, random(30, 60), millis()));
}

function drawClock(x, y, radius) {
  push();
  translate(x, y);

  // Clock face
  fill(255); // White face
  ellipse(0, 0, radius * 2, radius * 2);
  stroke(0);
  strokeWeight(2);

  let elapsedTime = millis() / 1000.0; // Total elapsed time in seconds
  let fastSecondAngle = TWO_PI * elapsedTime * 2; // 2 rotations per second

  // Hour hand
  let hourAngle = fastSecondAngle / 12; // 12x slower
  strokeWeight(6);
  line(0, 0, radius * 0.4 * cos(hourAngle - HALF_PI), radius * 0.4 * sin(hourAngle - HALF_PI));

  // Minute hand
  let minuteAngle = fastSecondAngle; // Matches the fast spin
  strokeWeight(4);
  line(0, 0, radius * 0.6 * cos(minuteAngle - HALF_PI), radius * 0.6 * sin(minuteAngle - HALF_PI));

  // Second hand
  strokeWeight(2);
  stroke(255, 0, 0); // Red second hand
  line(0, 0, radius * 0.8 * cos(minuteAngle - HALF_PI), radius * 0.8 * sin(minuteAngle - HALF_PI));

  // Clock center
  fill(0);
  noStroke();
  ellipse(0, 0, 8, 8);

  pop();
}

class BloomingFlower {
  constructor(x, y, maxRadius, startTime) {
    this.x = x;
    this.y = y;
    this.maxRadius = maxRadius;
    this.radius = 0;
    this.growSpeed = random(0.1, 0.3);
    this.bloomStartTime = startTime;
    this.lifespan = random(10000, 15000);
    this.petals = [];
    this.withering = false;
    this.witherStartTime = 0;
    this.alpha = 255;
    this.blackTransition = 0;
    this.baseColor = this.randomColor();

    let petalCount = int(random(6, 12));
    for (let i = 0; i < petalCount; i++) {
      this.petals.push(new Petal(random(50, 150), random(10, 50), random(0.05, 0.1)));
    }
  }

  randomColor() {
    let colors = [
      color(0, 0, 255), // Blue
      color(255, 0, 0), // Red
      color(128, 0, 128), // Purple
      color(255, 255, 0), // Yellow
      color(255, 165, 0), // Orange
    ];
    return colors[int(random(colors.length))];
  }

  update() {
    if (!this.withering && this.radius < this.maxRadius) {
      this.radius += this.growSpeed;
    }

    if (!this.withering && millis() - this.bloomStartTime > this.lifespan) {
      this.withering = true;
      this.witherStartTime = millis();
    }

    if (!this.withering) {
      for (let petal of this.petals) {
        petal.update();
      }
    } else {
      let witherElapsed = millis() - this.witherStartTime;
      if (witherElapsed <= 3000) {
        this.blackTransition = map(witherElapsed, 0, 3000, 0, 1);
      } else {
        this.alpha -= 2;
      }
    }
  }

  display() {
    if (this.alpha <= 0) return;

    if (!this.withering) {
      fill(255, 200, 0, this.alpha);
      ellipse(this.x, this.y, this.radius * 0.2, this.radius * 0.2);
      for (let i = 0; i < this.petals.length; i++) {
        let angle = TWO_PI / this.petals.length * i;
        this.petals[i].display(this.x, this.y, angle, this.radius, false, this.alpha, this.blackTransition, this.baseColor);
      }
    } else {
      fill(lerpColor(color(255, 200, 0), color(0), this.blackTransition), this.alpha);
      ellipse(this.x, this.y, this.radius * 0.2, this.radius * 0.2);
      for (let i = 0; i < this.petals.length; i++) {
        let angle = TWO_PI / this.petals.length * i;
        this.petals[i].display(this.x, this.y, angle, this.radius, true, this.alpha, this.blackTransition, this.baseColor);
      }
    }
  }

  isFadedOut() {
    return this.alpha <= 0;
  }
}

class Petal {
  constructor(length, width, waveSpeed) {
    this.length = length;
    this.width = width;
    this.waveSpeed = waveSpeed;
    this.angleOffset = 0;
  }

  update() {
    this.angleOffset += this.waveSpeed;
  }

  display(centerX, centerY, angle, flowerRadius, isWithering, alpha, blackTransition, baseColor) {
    push();
    translate(centerX, centerY);
    rotate(angle + (isWithering ? 0 : sin(this.angleOffset) * 0.2));
    let currentColor = isWithering
      ? lerpColor(baseColor, color(0), blackTransition)
      : lerpColor(baseColor, this.darkenColor(baseColor), (sin(this.angleOffset) + 1) / 2);
    fill(currentColor, alpha);
    ellipse(flowerRadius, 0, this.width, this.length);
    pop();
  }

  darkenColor(c) {
    return color(red(c) * 0.5, green(c) * 0.5, blue(c) * 0.5);
  }
}
