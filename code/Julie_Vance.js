let CircleA, CircleB; // Declare Circle objects
let smallBalls = []; // List to store small balls
let inputText = ""; // Store the input text
let textDisplayed = false; // Flag to track if the first text has been displayed
let resetFlag = false; // Flag to track if reset has occurred
let mousePressedAfterReset = false; // Flag to track mouse press after reset
let circlesMoving = false; // Flag to track if circles should move
let spawnBallFlag = false; // Flag to track ball spawning
let enter2 = false; // Flag to drop balls
let enterPressed = false; // Flag for displaying "NO" onscreen
let wordDisplayed = false; // Flag to ensure one random word is displayed
let customWords = ["no", "nuh uh", "too low", "I don't like it", "different %", "try again", "you're wrong"]; // Random discouraging words
let randomWord = ""; // Random word to display

// Circle class
class Circle {
  constructor(x, y, radius, fillColor, vx, vy) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.fillColor = fillColor;
    this.vx = vx || 0;
    this.vy = vy || 0;
  }

  display() {
    fill(this.fillColor);
    noStroke();
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }

  grow(growthRate) {
    this.radius += growthRate;
  }

  reset(newRadius, newColor) {
    this.radius = newRadius;
    this.fillColor = newColor;
  }

  move() {
    this.x += this.vx;
    this.y += this.vy;
  }

  bounce() {
    if (this.x - this.radius < 0 || this.x + this.radius > width) {
      this.vx *= -1;
    }
    if (this.y - this.radius < 0 || this.y + this.radius > height) {
      this.vy *= -1;
    }
  }
}

function setup() {
  createCanvas(1200, 800);
  frameRate(60);
  CircleA = new Circle(300, 400, 100, color(255, 0, 0), 3, 2);
  CircleB = new Circle(900, 400, 10, color(0, 0, 255), -3, 2);
}

function draw() {
  background(255);
  CircleA.display();
  CircleB.display();

  if (mouseIsPressed && !resetFlag) {
    CircleA.grow(4);
    if (CircleB.radius < 200) {
      CircleB.grow(4);
    }

    if (CircleA.radius > 980 && !textDisplayed) {
      CircleA.fillColor = color(0);
      CircleB.fillColor = color(0);
      textDisplayed = true;
    }
  }

  if (textDisplayed && !resetFlag) {
    textSize(32);
    fill(255);
    textAlign(CENTER);
    text("Syntax is Common Sense", width / 2, 400);
    text("Press enter", width / 2, 600);
  }

  if (resetFlag && mouseIsPressed && !mousePressedAfterReset) {
    mousePressedAfterReset = true;
    circlesMoving = true;
  }

  if (circlesMoving) {
    CircleA.move();
    CircleA.bounce();
    CircleB.move();
    CircleB.bounce();
  }

  if (resetFlag && mousePressedAfterReset) {
    textSize(32);
    fill(0);
    textAlign(CENTER);
    text("Please Enter this Assignment's Grade:", width / 2, 400);
    text(inputText + "%", width / 2, 450);

    if (inputText.length > 0 && inputText !== "100") {
      spawnBallFlag = true;
    }

    if (inputText === "100") {
      textSize(32);
      fill(0);
      text("Oh my Goodness!", width / 2, 200);
      text("Thank you for 100%!", width / 2, 250);

      if (keyIsPressed && keyCode === ENTER) {
        enter2 = true;
      }
    }
  }

  if (spawnBallFlag && !enter2) {
    spawnBalls(10);
  }

  if (inputText.length > 0 && inputText !== "100") {
    if (keyIsPressed && keyCode === ENTER) {
      enterPressed = true;
    } else {
      enterPressed = false;
    }
  }

  updateBalls();

  if (enter2) {
    dropBalls();
  }

  if (enterPressed) {
    if (!wordDisplayed) {
      randomWord = random(customWords);
      wordDisplayed = true;
    }
    textSize(200);
    fill(255, 0, 0);
    text(randomWord, width / 4, height / 2);
  } else {
    wordDisplayed = false;
  }
}

function keyPressed() {
  if (keyCode === ENTER && !resetFlag) {
    CircleA.reset(100, color(255, 0, 0));
    CircleB.reset(10, color(0, 0, 255));
    resetFlag = true;
  }

  if (resetFlag && mousePressedAfterReset) {
    if (keyCode === BACKSPACE) {
      inputText = inputText.slice(0, -1);
    } else if (keyCode !== ENTER) {
      inputText += key;
    }
  }
}

function spawnBalls(numBalls) {
  for (let i = 0; i < numBalls; i++) {
    let radius = random(5, 15);
    let ballColor = color(random(255), random(255), random(255));
    let vx = random(-3, 3);
    let vy = random(-3, 3);
    smallBalls.push(new Circle(width / 2, height / 2, radius, ballColor, vx, vy));
  }
}

function updateBalls() {
  for (let ball of smallBalls) {
    ball.move();
    ball.bounce();
    ball.display();
  }
}

function dropBalls() {
  for (let ball of smallBalls) {
    ball.y += 5;
    if (ball.y > height - ball.radius) {
      ball.y = height - ball.radius;
      ball.vx = 0;
      ball.vy = 0;
    }
  }

  CircleA.y += 5;
  if (CircleA.y > height - CircleA.radius) {
    CircleA.y = height - CircleA.radius;
    CircleA.vx = 0;
    CircleA.vy = 0;
  }

  CircleB.y += 5;
  if (CircleB.y > height - CircleB.radius) {
    CircleB.y = height - CircleB.radius;
    CircleB.vx = 0;
    CircleB.vy = 0;
  }
}
