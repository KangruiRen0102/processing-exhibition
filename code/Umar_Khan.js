let numStars = 100; // Number of stars
let stars = []; // Array of stars
let shootingStar;

function setup() {
  createCanvas(800, 600); // Canvas size

  for (let i = 0; i < numStars; i++) {
    stars.push(new Star());
  }

  shootingStar = new ShootingStar();
}

function draw() {
  background(10, 10, 50); // Night sky color

  drawRoad(); // Draw the road
  drawLand(); // Draw land on the side
  drawHumans(); // Draw stick figures
  drawCar(); // Draw a car on the road

  for (let star of stars) {
    star.update();
    star.display();
  }

  shootingStar.update();
  shootingStar.display();
}

function drawRoad() {
  fill(80, 80, 80); // Grey road color
  noStroke();
  rect(0, height / 2, width, height / 2); // Road covering the bottom half of the canvas

  // Road lines
  stroke(255); // White color for dashed lines
  strokeWeight(4);
  for (let i = 0; i < width; i += 40) {
    line(i, height / 2 + height / 4, i + 20, height / 2 + height / 4);
  }
}

function drawLand() {
  fill(34, 139, 34); // Green land color
  noStroke();
  beginShape();
  vertex(0, height / 2);
  vertex(0, height);
  vertex(150, height);
  vertex(100, height / 2 + 50);
  endShape(CLOSE);

  beginShape();
  vertex(width, height / 2);
  vertex(width, height);
  vertex(width - 150, height);
  vertex(width - 100, height / 2 + 50);
  endShape(CLOSE);
}

function drawHumans() {
  stroke(0); // Black color for stick figures
  strokeWeight(3);

  // First stick figure
  line(50, height / 2 + 40, 50, height / 2 + 80); // Body
  line(50, height / 2 + 40, 40, height / 2 + 60); // Left arm
  line(50, height / 2 + 40, 60, height / 2 + 60); // Right arm
  line(50, height / 2 + 80, 40, height / 2 + 100); // Left leg
  line(50, height / 2 + 80, 60, height / 2 + 100); // Right leg
  ellipse(50, height / 2 + 30, 15, 15); // Head

  // Second stick figure
  line(90, height / 2 + 40, 90, height / 2 + 80); // Body
  line(90, height / 2 + 40, 80, height / 2 + 60); // Left arm
  line(90, height / 2 + 40, 100, height / 2 + 60); // Right arm
  line(90, height / 2 + 80, 80, height / 2 + 100); // Left leg
  line(90, height / 2 + 80, 100, height / 2 + 100); // Right leg
  ellipse(90, height / 2 + 30, 15, 15); // Head
}

function drawCar() {
  fill(200, 0, 0); // Red car body
  rect(300, height / 2 + 50, 100, 40); // Car body
  fill(0); // Black for wheels
  ellipse(320, height / 2 + 90, 20, 20); // Left wheel
  ellipse(380, height / 2 + 90, 20, 20); // Right wheel

  fill(255, 255, 0); // Yellow for headlights
  ellipse(290, height / 2 + 70, 10, 10); // Left headlight
  ellipse(290, height / 2 + 80, 10, 10); // Right headlight
}

class Star {
  constructor() {
    this.reset();
  }

  reset() {
    this.x = random(width);
    this.y = random(height / 2); // Stars only in the sky
    this.speedY = random(0.2, 0.5); // Slow vertical speed
    this.alpha = random(150, 255); // Initial brightness
  }

  update() {
    this.y += this.speedY;
    this.alpha -= 0.5; // Gradual fading

    if (this.alpha <= 0 || this.y > height / 2) {
      this.reset();
    }
  }

  display() {
    noStroke();
    fill(255, 255, 200, this.alpha); // Soft yellow-white glow
    ellipse(this.x, this.y, 5, 5); // Draw the star
  }
}

class ShootingStar {
  constructor() {
    this.reset();
  }

  reset() {
    this.x = random(width / 2, width); // Start near the top-right
    this.y = random(height / 4); // Within the sky area
    this.speedX = -5; // Leftward motion
    this.speedY = 2; // Slight downward motion
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;

    if (this.x < 0 || this.y > height / 2) {
      this.reset();
    }
  }

  display() {
    stroke(255, 255, 0); // Yellow shooting star
    strokeWeight(3);
    line(this.x, this.y, this.x + 10, this.y - 5); // Shooting star trail
  }
}
