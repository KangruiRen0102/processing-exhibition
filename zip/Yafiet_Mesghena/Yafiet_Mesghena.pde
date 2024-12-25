// Theme: "From Edmonton's ice to the ultimate goal, the journey to chasing the cup is a dream fueled by passion and hometown pride."

ArrayList<Puck> pucks; // List to manage all active pucks in the game, symbolizing the journey of players toward scoring goals.
Goal goal;             // The target goal located at the top of the rink, representing the ultimate objective in gameplay.
ArrayList<Confetti> confettis; // Collection of confetti particles that trigger celebratory animations upon scoring.
ArrayList<Defender> defenders; // List of defenders who dynamically move to block pucks, adding challenge to the game.
ArrayList<Player> players;     // Edmonton Oilers players represented by their names and jersey numbers, providing interactive shooting mechanics.
boolean showTrophy = false; // A flag to indicate when the trophy animation should be displayed after a goal.
int maxPucks = 7; // Limit on the maximum number of active pucks in the game to balance gameplay.

void setup() {
  size(800, 600);
  pucks = new ArrayList<Puck>();
  confettis = new ArrayList<Confetti>();
  defenders = new ArrayList<Defender>();
  players = new ArrayList<Player>();
  goal = new Goal(width / 2, 50); // Initializes the goal at the center-top position of the rink.

  // Add Edmonton Oilers players with unique positions and jersey details
  players.add(new Player(width / 4, height - 50, "97", "McDavid"));
  players.add(new Player(width / 2, height - 50, "29", "Draisaitl"));
  players.add(new Player(3 * width / 4, height - 50, "18", "Hyman"));

  // Add defenders strategically placed between the players and the goal
  for (int i = 0; i < 2; i++) { // Only two defenders for balanced difficulty.
    defenders.add(new Defender(random(width / 4, 3 * width / 4), random(height / 4, height / 2)));
  }
}

void draw() {
  // Render the hockey rink with its markings and the Oilers logo.
  drawRink();

  // Display the goal at its designated position.
  goal.display();

  // Render and animate the defenders dynamically.
  for (Defender defender : defenders) {
    defender.display();
    defender.move();
  }

  // Render the players and manage their puck-shooting interactions.
  for (Player player : players) {
    player.display();
  }

  // Manage the active pucks, including movement and collision detection.
  for (int i = pucks.size() - 1; i >= 0; i--) {
    Puck puck = pucks.get(i);
    puck.display();
    puck.move();

    // Check if the puck collides with any defender.
    for (Defender defender : defenders) {
      if (defender.isBlocking(puck)) {
        puck.deflect(); // Reverse the puck's direction upon collision.
      }
    }

    // Check if the puck successfully reaches the goal.
    if (goal.isReached(puck)) {
      pucks.remove(i); // Remove the puck after a successful goal.
      showTrophy = true;
      for (int j = 0; j < 100; j++) {
        confettis.add(new Confetti(goal.x, goal.y)); // Trigger celebratory confetti animation.
      }
    }
  }

  // Render and update the confetti particles for celebrations.
  for (int i = confettis.size() - 1; i >= 0; i--) {
    Confetti c = confettis.get(i);
    c.display();
    c.update();
    if (c.isOffScreen()) {
      confettis.remove(i); // Remove confetti once it moves off-screen.
    }
  }

  // Display the trophy animation if a goal was scored.
  if (showTrophy) {
    drawTrophy(width / 2, height / 2);
    if (frameCount % 120 == 0) {
      showTrophy = false; // Reset trophy display after a set duration.
    }
  }

  // Display a motivational message at the bottom of the screen.
  fill(255);
  textSize(16);
  textAlign(CENTER);
  text("Hometown Pride", width / 2, height - 10);
}

void mousePressed() {
  // Detect clicks on players and shoot a puck if conditions allow.
  for (Player player : players) {
    if (player.isClicked(mouseX, mouseY)) {
      if (pucks.size() < maxPucks) {
        pucks.add(new Puck(player.x, player.y - 20)); // Generate a new puck from the player's position.
      }
      break;
    }
  }
}

// Draw hockey rink with Oilers logo drawn
void drawRink() {
  background(200, 200, 255); // Ice color representing the rink surface.
  stroke(255, 0, 0);
  strokeWeight(4);
  line(width / 2, 0, width / 2, height); // Center red line dividing the rink.
  stroke(0, 0, 255);
  ellipse(width / 2, height / 2, 150, 150); // Center blue circle for faceoffs.

  // Draw a simplified Edmonton Oilers logo
  fill(255, 140, 0); // Orange circle representing the team color.
  ellipse(width / 2, height / 2, 100, 100);
  fill(255);
  ellipse(width / 2, height / 2, 80, 80); // White inner circle for contrast.
  fill(0, 50, 255); // Blue text for the team name.
  textAlign(CENTER, CENTER);
  textSize(20);
  text("OILERS", width / 2, height / 2);
}

// Class to define the pucks (symbolizing players/journey elements)
class Puck {
  float x, y;    // Position of the puck.
  float speedX;  // Horizontal speed for dynamic movement.
  float speedY;  // Vertical speed for dynamic movement.
  color col;     // Color to distinguish pucks (blue or orange).

  Puck(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-4, 4); // Increased horizontal speed for fast-paced action.
    this.speedY = random(-2, -6); // Increased vertical speed for fast-paced action.
    this.col = random(1) < 0.5 ? color(0, 50, 255) : color(255, 100, 0); // Assign blue or orange randomly.
  }

  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, 20, 20); // Draw puck as a circle.
  }

  void move() {
    x += speedX;
    y += speedY;

    // Reverse direction if puck hits screen edges.
    if (x < 0 || x > width) speedX *= -1;
    if (y < 0 || y > height) speedY *= -1;
  }

  void deflect() {
    speedX *= -1;
    speedY *= -1; // Change both directions upon deflection.
  }
}

// Class to define the goal
class Goal {
  float x, y; // Position of the goal.
  float size; // Width of the goal.

  Goal(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = 100;
  }

  void display() {
    stroke(255, 0, 0); // Red for goal frame.
    strokeWeight(5);
    fill(255, 255, 255, 50); // Semi-transparent fill for the netting.
    rectMode(CENTER);
    rect(x, y, size, 40); // Draw goal as a rectangle.
    stroke(255);
    for (int i = -4; i <= 4; i++) {
      line(x - size / 2, y + i * 5, x + size / 2, y + i * 5); // Horizontal netting lines.
    }
    for (int i = -4; i <= 4; i++) {
      line(x + i * 10, y - 20, x + i * 10, y + 20); // Vertical netting lines.
    }
  }

  boolean isReached(Puck puck) {
    return dist(puck.x, puck.y, x, y) < size / 2; // Detect if a puck reaches the goal.
  }
}

// Class to define confetti particles for celebrations
class Confetti {
  float x, y; // Position of the confetti particle.
  float speedX, speedY; // Speed of movement for dynamic effect.
  color col; // Color of the confetti particle.

  Confetti(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-2, 2); // Horizontal speed variation.
    this.speedY = random(1, 3); // Vertical speed variation.
    this.col = color(random(255), random(255), random(255)); // Assign a random color.
  }

  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, 5, 5); // Render confetti as small circles.
  }

  void update() {
    x += speedX;
    y += speedY; // Update position for movement.
  }

  boolean isOffScreen() {
    return y > height; // Check if the confetti has fallen off the screen.
  }
}

// Class to define defenders
class Defender {
  float x, y;    // Position of the defender.
  float speedX; // Horizontal speed for movement.

  Defender(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-2, 2);
  }

  void display() {
    // Draw a cartoon hockey player as a defender.
    pushMatrix();
    translate(x, y);

    // Body
    fill(0); // Black for LA Kings jersey.
    rectMode(CENTER);
    rect(0, 10, 20, 40);

    // Head
    fill(255); // White for head.
    ellipse(0, -10, 20, 20);

    // Stick
    stroke(150);
    strokeWeight(3);
    line(-10, 30, 10, 50);

    popMatrix();
  }

  void move() {
    x += speedX; // Move horizontally.

    // Bounce off walls within designated bounds.
    if (x < width / 4 || x > 3 * width / 4) speedX *= -1;
  }

  boolean isBlocking(Puck puck) {
    return dist(x, y, puck.x, puck.y) < 25; // Check if defender blocks a puck.
  }
}

// Class to define Edmonton Oilers players
class Player {
  float x, y; // Position of the player.
  String number, name; // Jersey number and player name.

  Player(float x, float y, String number, String name) {
    this.x = x;
    this
.y = y;
    this.number = number;
    this.name = name;
  }

  void display() {
    // Draw the player as a simple representation (circle for head and rectangle for body).
    pushMatrix();
    translate(x, y);

    // Body
    fill(0, 50, 255); // Blue for Oilers jersey.
    rectMode(CENTER);
    rect(0, 10, 20, 40);

    // Head
    fill(255); // White for head.
    ellipse(0, -10, 20, 20);

    // Display the player's number
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(number, 0, 10);

    // Display the player's name
    textSize(10);
    text(name, 0, 25);

    popMatrix();
  }

  boolean isClicked(float mx, float my) {
    // Check if the player was clicked based on mouse position.
    return dist(mx, my, x, y) < 20; // Radius of player representation.
  }
}

// Function to draw the trophy animation
void drawTrophy(float x, float y) {
  fill(255, 223, 0); // Gold color for the trophy.
  stroke(0);
  strokeWeight(3);

  // Draw a simple trophy shape (cup with a base).
  ellipse(x, y - 20, 80, 80); // Cup part.
  rect(x - 30, y + 10, 60, 20); // Base part.
  line(x - 30, y + 10, x + 30, y + 10); // Top edge of the base.
}
