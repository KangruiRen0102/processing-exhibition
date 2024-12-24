let boat;
let monster;
let goldVisible = false;
let gameOver = false;
let goldX, goldY;

function setup() {
  createCanvas(800, 600);
  boat = new Boat(50, 300, 2, 5);
  monster = new Monster(width, height / 2, 1, 60);
}

function draw() {
  if (gameOver) {
    displayGameOver();
    return;
  }

  drawScene();
  boat.update().display();
  handleMonster();
  handleGold();
}

function displayGameOver() {
  textSize(50);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text("TRY AGAIN", width / 2, height / 2);
}

function drawScene() {
  background(23, 32, 87);
  fill(0, 105, 148);
  rect(0, height / 2, width, height / 2);
  stroke(0);
  strokeWeight(4);
  line(width - 50, height / 2, width - 50, height);
}

function handleMonster() {
  monster.update(boat.x, boat.y).display();
  if (dist(boat.x + 50, boat.y, monster.x, monster.y) < 50 + monster.monsterSize / 2) 
    gameOver = true;
}

function handleGold() {
  if (!goldVisible && boat.x >= width) {
    goldVisible = true;
    goldX = random(100, width - 100);
    goldY = random(height / 2, height - 40);
    boat.resetPosition();
  }

  if (goldVisible) {
    fill(255, 215, 0);
    ellipse(goldX, goldY, 30, 30);
    if (dist(boat.x + 50, boat.y, goldX, goldY) < 50) goldVisible = false;
  }
}

class Boat {
  constructor(startX, startY, slowerRightSpeed, boatSpeed) {
    this.x = startX;
    this.y = startY;
    this.rightSpeed = slowerRightSpeed;
    this.speed = boatSpeed;
    this.moveRight = false;
    this.moveLeft = false;
    this.moveUp = false;
    this.moveDown = false;
  }

  update() {
    if (this.moveRight) this.x += this.rightSpeed;
    if (this.moveLeft && this.x > 0) this.x -= this.speed;
    if (this.moveUp) this.y -= this.speed;
    if (this.moveDown) this.y += this.speed;
    this.y = constrain(this.y, height / 2, height - 40);
    return this;
  }

  resetPosition() {
    this.x = -100;
  }

  display() {
    fill(139, 69, 19);
    rect(this.x, this.y, 100, 20);
    stroke(0);
    line(this.x + 50, this.y, this.x + 50, this.y - 50);
    fill(255);
    triangle(this.x + 50, this.y - 50, this.x + 50, this.y, this.x + 100, this.y - 25);
  }

  handleKeyPress(keyCode) {
    if (keyCode === RIGHT_ARROW) this.moveRight = true;
    if (keyCode === LEFT_ARROW) this.moveLeft = true;
    if (keyCode === UP_ARROW) this.moveUp = true;
    if (keyCode === DOWN_ARROW) this.moveDown = true;
  }

  handleKeyRelease(keyCode) {
    if (keyCode === RIGHT_ARROW) this.moveRight = false;
    if (keyCode === LEFT_ARROW) this.moveLeft = false;
    if (keyCode === UP_ARROW) this.moveUp = false;
    if (keyCode === DOWN_ARROW) this.moveDown = false;
  }
}

class Monster {
  constructor(startX, startY, monsterSpeed, size) {
    this.x = startX;
    this.y = startY;
    this.speed = monsterSpeed;
    this.monsterSize = size;
  }

  update(targetX, targetY) {
    this.x += (this.x < targetX) ? this.speed : (this.x > targetX) ? -this.speed : 0;
    this.y += (this.y < targetY) ? this.speed : (this.y > targetY) ? -this.speed : 0;
    return this;
  }

  display() {
    fill(255, 0, 0);
    ellipse(this.x, this.y, this.monsterSize, this.monsterSize);
  }
}

function keyPressed() {
  boat.handleKeyPress(keyCode);
}

function keyReleased() {
  boat.handleKeyRelease(keyCode);
}
