Boat boat;  
Monster monster;  
boolean goldVisible = false, gameOver = false;
float goldX, goldY;

void setup() { //Makes the canvas, boat and monster
  size(800, 600);  
  boat = new Boat(50, 300, 2, 5);  
  monster = new Monster(width, height / 2, 1, 60);  
}

void draw() { //Checks when if the game is done
  if (gameOver) {
    displayGameOver();
    return;
  }

  drawScene();
  boat.update().display();
  handleMonster();
  handleGold();
}

void displayGameOver() { //Shows the try again text
  textSize(50);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text("TRY AGAIN", width / 2, height / 2);
}

void drawScene() { //Sets the background
  background(23, 32, 87);  
  fill(0, 105, 148);
  rect(0, height / 2, width, height / 2);
  stroke(0, 0, 0);
  strokeWeight(4);
  line(width - 50, height / 2, width - 50, height);
}

void handleMonster() { //Sea monster collision with boat
  monster.update(boat.x, boat.y).display();
  if (dist(boat.x + 50, boat.y, monster.x, monster.y) < 50 + monster.monsterSize / 2) 
    gameOver = true;
}

void handleGold() { //Gold random appearance
  if (!goldVisible && boat.x >= width) {
    goldVisible = true;
    goldX = random(100, width - 100);
    goldY = random(height / 2, height - 40);
    boat.resetPosition();
  }
  
  if (goldVisible) { //makes the gold
    fill(255, 215, 0);  
    ellipse(goldX, goldY, 30, 30);  
    if (dist(boat.x + 50, boat.y, goldX, goldY) < 50) goldVisible = false;
  }
}

class Boat {
  float x, y, rightSpeed, speed;
  boolean moveRight, moveLeft, moveUp, moveDown;

  Boat(float startX, float startY, float slowerRightSpeed, float boatSpeed) {
    x = startX; y = startY; rightSpeed = slowerRightSpeed; speed = boatSpeed;
  }

  Boat update() { //Boat movement
    if (moveRight) x += rightSpeed;
    if (moveLeft && x > 0) x -= speed;
    if (moveUp) y -= speed;
    if (moveDown) y += speed;
    y = constrain(y, height / 2, height - 40);
    return this;
  }

  void resetPosition() { //Sets back the boat when it reaches the end
    x = -100;
  }

  void display() { //Boat drawing
    fill(139, 69, 19);
    rect(x, y, 100, 20);
    stroke(0);
    line(x + 50, y, x + 50, y - 50);
    fill(255);
    triangle(x + 50, y - 50, x + 50, y, x + 100, y - 25);
  }

  void handleKeyPress(int keyCode) { //User input
    moveRight = keyCode == RIGHT || moveRight;
    moveLeft = keyCode == LEFT || moveLeft;
    moveUp = keyCode == UP || moveUp;
    moveDown = keyCode == DOWN || moveDown;
  }

  void handleKeyRelease(int keyCode) { //User input to move diagonally
    moveRight = keyCode != RIGHT && moveRight;
    moveLeft = keyCode != LEFT && moveLeft;
    moveUp = keyCode != UP && moveUp;
    moveDown = keyCode != DOWN && moveDown;
  }
}

class Monster {
  float x, y, speed, monsterSize;
  
  Monster(float startX, float startY, float monsterSpeed, float size) {
    x = startX; y = startY; speed = monsterSpeed; monsterSize = size;
  }

  Monster update(float targetX, float targetY) { //Sea monster moving towards boat
    x += (x < targetX) ? speed : (x > targetX) ? -speed : 0;
    y += (y < targetY) ? speed : (y > targetY) ? -speed : 0;
    return this;
  }

  void display() { //Draws the Sea monster
    fill(255, 0, 0);
    ellipse(x, y, monsterSize, monsterSize);
  }
}

void keyPressed() {
  boat.handleKeyPress(keyCode);
}

void keyReleased() {
  boat.handleKeyRelease(keyCode);
}
