ArrayList<Dot> dots = new ArrayList<Dot>();
Dot disruptor;
boolean formingCircle = false; 
boolean disrupted = false; 
boolean snakeMode = false; 
boolean formingInfinity = false; 
boolean draggingDisruptor = false; 
boolean ruptureComplete = false; 
boolean changedToPurple = false; 
boolean changedToGreen = false; 
boolean changedToYellow = false; 
float t = 0; 
// This line portion includes all the imports and setups needed for my sketch.
// I will have yellow dots which are then ruptured by a red dot.
// All yellow dots will transform into purple dots symbolizing death and afterward regenerate.
// Into green symbolizing rebirth and finally, with a final click, turn back to yellow as mass can neither be created nor destroyed, only transferred.

void setup() {
  size(800, 600);
  background(0); // Black background for contrast
  initializeDots(50); // Initialize dots (50) needed for the yellow circle generated
}
// Needed once in the program and initializes the canvas with a rectangle 800 pixels wide and 600 pixels tall.

void draw() {
  background(0); // Screen starts being black

  // Update and display all dots
  for (int i = 0; i < dots.size(); i++) {
    Dot dot = dots.get(i);
    if (!formingCircle && !disrupted && !formingInfinity) {
      dot.moveToLineToCircle(); 
    } else if (formingCircle && !disrupted) {
      dot.moveInCircle(); 
    } else if (disrupted && !ruptureComplete) {
      if (!changedToPurple) { 
        changeDotsColor(color(75, 0, 130)); // Change dots to dark purple after rupture
        changedToPurple = true;
        // This segment ensures the dots move in a circular path and change color after rupture to purple.
      }
      dot.fallToFloor(); 
    } else if (ruptureComplete && !snakeMode) {
      dot.restOnFloor(); 
    } else if (snakeMode && !formingInfinity) {
      if (!changedToGreen) { 
        changeDotsColor(color(57, 255, 20)); // Change dots to neon green in snake mode
        changedToGreen = true;
        // Transforms the dots from falling and resting on the floor to then move dynamically in "snake mode" with a new color being neon green.
      }
      dot.followMouse(i); 
    } else if (formingInfinity) {
      if (!changedToYellow) { 
        changeDotsColor(color(255, 255, 0)); // Change dots back to yellow in infinity mode
        changedToYellow = true;
      }
      dot.moveToInfinity(t); 
    }
    dot.display();
  }

  // Tells the computer to follow the mouse in a snake mode arrangement and to ultimately form an infinity pattern, changing the color once again to yellow.

  if (formingInfinity) {
    t += 0.02; // Increment shared time parameter for infinity motion
  }

  if (disruptor != null) {
    disruptor.display();

    if (draggingDisruptor) {
      for (Dot dot : dots) {
        if (dist(disruptor.x, disruptor.y, dot.x, dot.y) < disruptor.size / 2) {
          disrupted = true; 
          break;
          // Generates the infinity sign and checks for disruptor and dots to generate disruption. 
        }
      }
    }
  }
}

void mousePressed() {
  if (disruptor == null) {
    disruptor = new Dot(mouseX, mouseY, color(255, 0, 0), 20); // Spawn a red disruptor dot
  } else if (dist(mouseX, mouseY, disruptor.x, disruptor.y) < disruptor.size) {
    draggingDisruptor = true; // Allow dragging of the red disruptor
  } else if (ruptureComplete && !snakeMode) {
    snakeMode = true; // Activate snake mode after rupture
  } else if (snakeMode && !formingInfinity) {
    formingInfinity = true; 
    // Spawns a red disruptor dot and allows activation of snake mode after the rupture.
    // Finally, transitions into infinity shape after snake mode is clicked.
  }
}

void mouseDragged() {
  if (draggingDisruptor && disruptor != null) {
    disruptor.x = mouseX;
    disruptor.y = mouseY; // Allows the red disruptor dot to follow the mouse's location when being dragged in x & y coordinates.
  }
}

void mouseReleased() {
  draggingDisruptor = false; 
  // Stops the dragging action of the red disruptor once the dragging is stopped.
}

void initializeDots(int count) {
  for (int i = 0; i < count; i++) {
    float x = width / count * i + 50;
    float y = height / 2;
    dots.add(new Dot(x, y, color(255, 255, 0), 15)); 
    // Initializes the 50 dots by placing them in a horizontal line and setting the color to yellow and its size (width & height). 
  }
}

void changeDotsColor(color newColor) {
  for (Dot dot : dots) {
    dot.setColor(newColor);
    // Alters the color of the dots and applies the new color. 
  }
}

class Dot {
  float x, y; 
  float targetX, targetY; 
  float velocityX, velocityY; 
  color col; 
  boolean fallen = false; 
  float angle; 
  float radius; 
  float size; 
  // Defines the Dot class and stores the position, target, velocity, etc. Also allows for movement like falling and transitions.

  Dot(float x, float y, color col, float size) {
    this.x = x;
    this.y = y;
    this.col = col;
    this.size = size;
    this.radius = 200; 
    this.velocityX = random(-2, 2); 
    this.velocityY = random(1, 3); 
    // Initializes dot with a position, color, size, radius, and random velocity.
  }

  void moveToLineToCircle() {
    float progress = (dots.indexOf(this) + 1) / float(dots.size());
    float angle = progress * TWO_PI - HALF_PI;
    targetX = width / 2 + cos(angle) * radius;
    targetY = height / 2 + sin(angle) * radius;

    x = lerp(x, targetX, 0.05);
    y = lerp(y, targetY, 0.05);

    if (dist(x, y, targetX, targetY) < 2) {
      formingCircle = true; 
      // Gradually moves a dot from a line to a circular formation and moves each end towards each other.
    }
  }

  void moveInCircle() {
    angle += 0.02;
    x = width / 2 + cos(angle + (dots.indexOf(this) * TWO_PI / dots.size())) * radius;
    y = height / 2 + sin(angle + (dots.indexOf(this) * TWO_PI / dots.size())) * radius;
    // Moves dot in a smooth circular path around the center.
  }

  void fallToFloor() {
    if (!fallen) {
      x += velocityX;
      y += velocityY;
      velocityY += 0.2;

      if (y >= height - 10) {
        y = height - 10;
        velocityY = 0;
        fallen = true;
        // Dot falling to the floor due to gravity.
      }
    }

    if (dots.stream().allMatch(dot -> dot.fallen)) {
      ruptureComplete = true; 
      // Checks if all dots have fallen due to rupture. 
    }
  }

  void restOnFloor() {
    // Dots remain stationary on the floor after falling.
  }

  void followMouse(int index) {
    if (index == 0) {
      targetX = mouseX;
      targetY = mouseY;
    } else { 
      Dot previous = dots.get(index - 1);
      targetX = previous.x;
      targetY = previous.y;
    }

    x = lerp(x, targetX, 0.1);
    y = lerp(y, targetY, 0.1);
    // Moves dots in a snake-like formation, where the first dot follows the mouse.
  }

  void moveToInfinity(float t) {
    float offset = dots.indexOf(this) * 0.2;
    if (dots.indexOf(this) % 2 == 0) {
      targetX = width / 2 + cos(t + offset) * 150; 
      targetY = height / 2 + sin(2 * (t + offset)) * 100; 
    } else {
      targetX = width / 2 + cos(t + offset + PI) * 150; 
      targetY = height / 2 + sin(2 * (t + offset + PI)) * 100; 
    }

    x = lerp(x, targetX, 0.05);
    y = lerp(y, targetY, 0.05);
    // Moves dots to form an infinity sign (∞) in a smooth motion.
  }

  void setColor(color newColor) {
    this.col = newColor; 
    // Updates the color of the dot.
  }

  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, size, size);
    // Displays the dot on the canvas.
  }
}
