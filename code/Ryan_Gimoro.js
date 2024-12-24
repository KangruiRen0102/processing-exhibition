let currentState = 0; // Tracks the current state (0 = Aurora, 1 = Twilight, 2 = Galaxy with color change)
let auroraOffset = 0; // Controls the movement of the aurora
let starlightAlpha = 0; // Controls the fading effect of stars
let stars = []; // List of stars for the starlight effect
let spirals = []; // List to hold multiple spiral objects
let galaxyRotation = 0; // Controls the rotation of the galaxy
let galaxyColorOffset = 0; // Controls the color transition of the galaxy effect
let starCreationRate = 1; // Controls how many stars are created per click
let clickCount = 0; // Track the number of clicks

function setup() {
  createCanvas(800, 600, WEBGL); // Set up 3D canvas
  noStroke();
}

function draw() {
  background(0); // Start with a dark background for contrast

  // Always display the Galaxy effect (spirals) in the background
  drawGalaxy();

  // Twilight effect: overlapping with aurora and bloom
  if (currentState >= 1) {
    drawTwilight();
  }

  // Check for collapse after 20 clicks
  if (clickCount >= 20) {
    collapseEffect();
  }
}

function drawGalaxy() {
  galaxyRotation += 0.01; // Rotate the galaxy effect over time

  // Draw each spiral in the spirals list
  for (let s of spirals) {
    s.display();
  }
}

function drawTwilight() {
  // Gradually increase the starlight effect alpha for a smooth fade-in
  starlightAlpha += 0.01; // Faster appearance of stars in twilight
  starlightAlpha = constrain(starlightAlpha, 0, 1); // Limit alpha to 1 for smooth transition

  // Create new stars over time with a higher rate for faster twilight
  for (let i = 0; i < starCreationRate; i++) {
    stars.push(new Star(random(width), random(height)));
  }

  // Draw the stars
  for (let i = stars.length - 1; i >= 0; i--) {
    let s = stars[i];
    s.update();
    s.display();
  }
}

class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = random(1, 3); // Small stars
    this.alpha = random(100, 255); // Initial alpha for each star
    this.speed = random(0.01, 0.05); // Random speed for twinkling
    this.starColor = color(random(255), random(255), random(255)); // Random star color
  }

  update() {
    this.alpha += sin(frameCount * this.speed) * 10; // Make it twinkle
    this.alpha = constrain(this.alpha, 100, 255); // Keep alpha within bounds
  }

  display() {
    fill(this.starColor.levels[0], this.starColor.levels[1], this.starColor.levels[2], this.alpha * starlightAlpha);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

class GalaxySpiral {
  constructor(offset, spiralColor, rotationSpeed, centerX, centerY, numSpirals) {
    this.offset = offset;
    this.spiralColor = spiralColor;
    this.rotationSpeed = rotationSpeed;
    this.centerX = centerX;
    this.centerY = centerY;
    this.numSpirals = numSpirals;
    this.scaleFactor = 1; // Factor to control the size of the spiral (for collapse effect)
  }

  display() {
    push();
    translate(this.centerX - width / 2, this.centerY - height / 2); // Move the spiral to its center
    rotate(galaxyRotation); // Apply rotation to the spiral

    for (let i = 0; i < this.numSpirals; i++) {
      let angle = radians(i * 5) + this.offset; // Spiral angle
      let r = 2 + i * 0.5 * this.scaleFactor; // Radius increases with each iteration, adjusted for collapse
      let x = r * cos(angle); // X position of the spiral
      let y = r * sin(angle); // Y position of the spiral

      stroke(this.spiralColor);
      line(x, y, x + cos(angle) * 2, y + sin(angle) * 2);
    }
    pop();
  }

  collapse() {
    this.scaleFactor *= 0.95; // Gradually shrink the spiral
  }
}

function collapseEffect() {
  for (let s of stars) {
    s.x = lerp(s.x, width / 2, 0.05); // Move stars towards the center
    s.y = lerp(s.y, height / 2, 0.05);
  }

  for (let s of spirals) {
    s.collapse(); // Shrink each spiral
  }

  if (spirals[spirals.length - 1].scaleFactor < 0.01) {
    background(0);
    stars = [];
    spirals = [];
    currentState = 0;
    clickCount = 0;
  }
}

function mousePressed() {
  clickCount++; // Increment the click count

  if (currentState === 0) {
    spirals.push(new GalaxySpiral(galaxyRotation, generateGalaxyColor(), 0.02, width / 2, height / 2, 200)); // White spiral in the center
    currentState = 1;
  } else if (currentState === 1) {
    currentState = 2;
  } else if (currentState === 2) {
    let numSpirals = spirals[spirals.length - 1].numSpirals + 10; // Increase spiral complexity each time
    spirals.push(new GalaxySpiral(galaxyRotation, generateGalaxyColor(), 0.02, width / 2, height / 2, numSpirals));

    starCreationRate += 1;
  }
}

function generateGalaxyColor() {
  let newColor;
  let isDifferent = false;

  while (!isDifferent) {
    isDifferent = true;
    newColor = color(random(255), random(255), random(255));

    for (let i = stars.length - 1; i >= max(0, stars.length - 10); i--) {
      let s = stars[i];
      if (dist(red(newColor), green(newColor), blue(newColor), red(s.starColor), green(s.starColor), blue(s.starColor)) < 100) {
        isDifferent = false;
        break;
      }
    }
  }
  return newColor;
}
