// Declare ArrayLists
let starsList = [];
let asteroidsList = [];
let textList = [];

// Interaction states
let speedBoost = false;
let viewMove = 0; // Move view side to side
let moveLeft = false;
let moveRight = false;

function setup() {
  createCanvas(1080, 1080); // Canvas size

  // Create initial stars
  for (let i = 0; i < 500; i++) {
    starsList.push(new Star());
  }
}

function draw() {
  background(0); // Black background
  translate(width / 2 + viewMove, height / 2); // Move the view side to side

  // Randomly generate asteroids
  if (random(1) > 0.9) {
    asteroidsList.push(new Asteroid());
  }

  // Show asteroids
  for (let asteroid of asteroidsList) {
    asteroid.show();
  }

  // Update and show stars
  for (let star of starsList) {
    star.update();
    star.show();
  }

  // Update and show "FIGHT!!" text
  for (let i = textList.length - 1; i >= 0; i--) {
    let ft = textList[i];
    ft.update();
    ft.show();
    if (ft.opacity <= 0) {
      textList.splice(i, 1);
    }
  }
}

function keyPressed() {
  // Raise speed if 'C' is pressed
  if (key === 'c') {
    speedBoost = true;
  }

  // Destroy all asteroids when space is pressed
  if (key === ' ') {
    asteroidsList = []; // Clear all asteroids
  }

  // Create fight text when 'V' is pressed
  if (key === 'v') {
    textList.push(new FightText(random(-width / 2, width / 2), random(-height / 2, height / 2)));
  }

  // Move left or right when arrow keys are pressed
  if (keyCode === LEFT_ARROW) {
    moveLeft = true;
  } else if (keyCode === RIGHT_ARROW) {
    moveRight = true;
  }

  if (moveLeft) {
    viewMove += 10; // Move view left
  }
  if (moveRight) {
    viewMove -= 10; // Move view right
  }
}

function keyReleased() {
  // Slow down when 'C' is released
  if (key === 'c') {
    speedBoost = false;
  }
  // Reset movement flags
  if (keyCode === LEFT_ARROW) {
    moveLeft = false;
  }
  if (keyCode === RIGHT_ARROW) {
    moveRight = false;
  }
}

// Asteroid class
class Asteroid {
  constructor() {
    this.x = random(-width, width); // Random position
    this.y = random(-height, height);
    this.size = random(10, 300); // Random size
    this.col = color(random(0, 255), random(100, 255), random(200, 255)); // Random color
  }

  show() {
    fill(this.col);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size); // Draw asteroid
  }
}

// FightText class
class FightText {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.opacity = 200; // Initial opacity
    this.message = "FIGHT!!";
  }

  update() {
    this.opacity = max(0, this.opacity - 4); // Fade out over time
  }

  show() {
    fill(255, this.opacity);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(this.message, this.x, this.y); // Display text
  }
}

// Star class
class Star {
  constructor() {
    this.x = random(-width, width);
    this.y = random(-height, height);
    this.z = random(width);
    this.previousZ = this.z; // For streaking effect
  }

  update() {
    let speed = speedBoost ? 40 : 10; // Adjust speed if speed boost is active
    this.z -= speed; // Move star closer
    if (this.z < 1) { // Reset star position when it passes the screen
      this.z = width;
      this.x = random(-width, width);
      this.y = random(-height, height);
      this.previousZ = this.z;
    }
  }

  show() {
    fill(255);
    noStroke();
    let sx = map(this.x / this.z, 0, 1, 0, width);
    let sy = map(this.y / this.z, 0, 1, 0, height);
    let r = map(this.z, 0, width, 8, 0);
    ellipse(sx, sy, r, r);

    let px = map(this.x / this.previousZ, 0, 1, 0, width);
    let py = map(this.y / this.previousZ, 0, 1, 0, height);
    this.previousZ = this.z;

    stroke(255);
    line(px, py, sx, sy); // Draw streak
  }
}
