// Declare ArrayLists
ArrayList<Star> starsList;
ArrayList<Asteroid> asteroidsList;
ArrayList<FightText> textList;

// saves all interactions in program
boolean speedBoost = false;  // Raises speed when 'C' is pressed
float viewMove= 0; // move view side to side
float moveSpeed = 1; // Smoothness factor for movement
boolean moveLeft = false;
boolean moveRight = false;

void setup() {
  size(1080, 1080); // Size of the screen

  // Initialize ArrayLists
  starsList = new ArrayList<Star>();
  asteroidsList = new ArrayList<Asteroid>();
  textList = new ArrayList<FightText>();

  // Create initial stars
  for (int i = 0; i < 500; i++) {
    starsList.add(new Star());
  }
}

void draw() {
  background(0); // Black background for the hyperdrive effect
  translate(width / 2 + viewMove, height / 2); //move the view side to side 

  // Randomly generate asteroids
  if (random(1) > 0.9) {
    asteroidsList.add(new Asteroid());
  }

  // adds new asteroids and show asteroids
  for (Asteroid newAsteroid : asteroidsList) {
    newAsteroid.show();
  }
  
  // adds new stars and show stars
  for (Star newStar : starsList) {
    newStar.update();
    newStar.show();
  }
  
  // adds new "fight" text and show "fight" text
  for (int i = textList.size() - 1; i >= 0; i--) {
    FightText ft = textList.get(i);
    ft.update();
    ft.show();
    }
  }

void keyPressed() {
  // Raise speed if 'C' is pressed
  if (key == 'c') { 
    speedBoost = true;
  }

  // Destroy all asteroids when space is pressed
  if (key == ' ') {
    asteroidsList.clear(); // Remove all asteroids
  }

  // Create fight text when 'V' is pressed
  if (key == 'v') {
    textList.add(new FightText(random(-width / 2, width / 2), random(-height / 2, height / 2)));
  }

  // Move left when LEFT arrow key is pressed
  if (keyCode == LEFT) {
    moveLeft = true; // Set left movement flag
  }
  
  // Move right when RIGHT arrow key is pressed
  if (keyCode == RIGHT) {
    moveRight = true; // Set right movement flag
  }
  
  if (moveLeft) {
    viewMove += 10; // Move view left
  }
  if (moveRight) {
    viewMove -= 10; // Move view right
  }
}

void keyReleased() {
  // slow down when c is not pressed
  if (key == 'c') {
    speedBoost = false;
  }
  // Reset movement flags when keys are released
  if (keyCode == LEFT) {
    moveLeft = false;
  }
  if (keyCode == RIGHT) {
    moveRight = false;
  }
}

// Class for asteroids
class Asteroid {
  float x, y, size;
  color col;

  Asteroid() {
    x = random(-width, width); // Random position for asteroids
    y = random(-height, height);
    size = random(10, 300); // Random size
    col = color(random(0, 255), random(100, 255), random(200, 255)); // Randomized color, slightly constricted for sake of color pallet
  }
  void show() {
    fill(col);
    noStroke();
    ellipse(x, y, size, size); // Draw asteroid
  }
}

// Class for 'fight' text
class FightText {
  float x, y;
  float opacity = 200; // Initial opacity of text
  String message = "FIGHT!!";

  FightText(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() { 
    opacity = max(0, opacity - 4); // Fade over time
  }

  void show() { 
   fill(255, opacity); // Fading opacity effect
   textSize(30);
   text(message, x, y); // Show text
  }
}


// Class for stars
class Star { 
  float x, y, z;
  float previousZ; // Create streaking effect with previous values

  Star() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);
//    previousZ = z;
  }

  void update() {
    float speed = speedBoost ? 40 : 10; // Faster movement if speed boost is on
    z -= speed; // Move star closer
    if (z < 1) { // Reset star position when it passes the screen
      z = width;
      x = random(-width, width);
      y = random(-height, height);
      previousZ = z;
    }
  }

  void show() {
    fill(255);
    float sx = map(x / z, 0, 1, 0, width);
    float sy = map(y / z, 0, 1, 0, height);
    float r = map(z, 0, width, 8, 0);
    ellipse(sx, sy, r, r);

    float px = map(x / previousZ, 0, 1, 0, width);
    float py = map(y / previousZ, 0, 1, 0, height);
    previousZ = z;

    stroke(255);
    line(px, py, sx, sy); // Create streak effect
  }
}
