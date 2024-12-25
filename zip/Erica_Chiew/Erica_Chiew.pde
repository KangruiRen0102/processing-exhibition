int numSnowflakes = 100;
Snowflake[] snowflakes = new Snowflake[numSnowflakes];
float treeX = 150;
float treeY = 450; // Tree trunk's starting position
float snowmanX = 600;
float snowmanY = 500;
float windDirection = 0; // Wind direction, 0 for no wind, negative for left, positive for right
boolean isWaving = false;
boolean isWinter = true; // Boolean to switch between winter and summer scenes

// Ice cream truck variables
float iceCreamTruckX = -200; // Starting position of the ice cream truck (off-screen)
float iceCreamTruckSpeed = 3; // Speed at which the ice cream truck moves
boolean isTruckMoving = true; // Flag to control if the truck is moving
float sunX = 700; // X position of the sun
float sunY = 100; // Y position of the sun
float sunSize = 80; // Size of the sun
boolean kidAppeared = false; // Flag to check if the kid is visible
float kidX = -200; // Position of the kid (off-screen initially)
float kidY = 400; // Y position of the kid (same as the ice cream truck's Y)

void setup() {
  size(800, 600);
  
  // Initialize snowflakes for winter scene
  for (int i = 0; i < numSnowflakes; i++) {
    snowflakes[i] = new Snowflake();
  }
}

void draw() {
  if (isWinter) {
    drawWinterScene(); // Draw the winter scene with snowflakes and snowman
  } else {
    drawSummerScene(); // Draw the summer scene with the ice cream truck
  }
}

void drawWinterScene() {
  background(173, 216, 230); // Light blue background (winter)
  
  // Update wind direction based on mouse movement
  windDirection = (mouseX - width / 2) / float(width / 2); // Range from -1 (left) to 1 (right)

  // Draw ground (snow)
  fill(255); // White ground (snow)
  noStroke();
  rect(0, height - 100, width, 100); // Ground

  // Draw snowflakes
  for (Snowflake s : snowflakes) {
    s.update();
    s.display();
  }

  // Draw Tree
  drawTree(treeX, treeY);

  // Draw Snowman
  drawSnowman(snowmanX, snowmanY);

  // Check if mouse is pressed to make the snowman wave
  if (mousePressed) {
    isWaving = true;
  } else {
    isWaving = false;
  }
}

void drawSummerScene() {
  background(135, 206, 250); // Sky blue background (summer)
  
  // Draw grass at the bottom
  fill(34, 139, 34); // Green grass
  noStroke();
  rect(0, height - 100, width, 100); // Grass
  
  // Draw the sun and its rays
  drawSun(sunX, sunY, sunSize);

  // Stop the ice cream truck and draw it
  if (isTruckMoving) {
    iceCreamTruckX += iceCreamTruckSpeed;
    if (iceCreamTruckX > width) {
      iceCreamTruckX = -200;
    }
  }
  drawIceCreamTruck(iceCreamTruckX, height - 150);
  
  // Draw the kid if the truck has stopped
  if (kidAppeared) {
    kidY = height - 100; // Position the kid standing on the ground
    drawKid(kidX, kidY); // Kid appears next to the truck
  }
}

void drawTree(float x, float y) {
  // Tree trunk (connected properly)
  fill(139, 69, 19); // Brown color for the trunk
  rect(x - 15, y, 30, 90); // Tree trunk touches the ground
  
  // Tree leaves (triangle layers) with correct alignment
  fill(34, 139, 34); // Green for leaves
  triangle(x - 70, y - 0, x + 70, y - 0, x, y - 150); // Bottom layer
  triangle(x - 60, y - 50, x + 60, y - 50, x, y - 180);  // Middle layer
  triangle(x - 50, y - 100, x + 50, y - 100, x, y - 210);  // Top layer
}

void drawSnowman(float x, float y) {
  // Body
  fill(255); // Snowman is white
  ellipse(x, y, 120, 120); // Bottom body
  ellipse(x, y - 80, 100, 100); // Middle body
  ellipse(x, y - 140, 80, 80); // Head
  
  // Eyes
  fill(0); // Black eyes
  ellipse(x - 20, y - 150, 10, 10);
  ellipse(x + 20, y - 150, 10, 10);
  
  // Buttons
  ellipse(x, y - 80, 10, 10);
  ellipse(x, y - 60, 10, 10);
  ellipse(x, y - 40, 10, 10);
  
  // Nose (Carrot)
  fill(255, 69, 0); // Carrot orange color
  triangle(x, y - 145, x + 15, y - 140, x, y - 135);
  
  // Arms
  stroke(139, 69, 19); // Brown color for arms
  strokeWeight(8);
  
  if (isWaving) {
    line(x + 40, y - 100, x + 100, y - 120); // Right arm waving
  } else {
    line(x + 40, y - 100, x + 80, y - 60); // Right arm normal
  }
  
  line(x - 40, y - 100, x - 80, y - 60); // Left arm
  
  // Hat
  fill(0); // Black hat
  rect(x - 30, y - 180, 60, 10); // Brim part 
  rect(x - 20, y - 210, 40, 30); // Top part 
}

// Snowflake class
class Snowflake {
  float x, y, speed, size, windSpeed;
  
  Snowflake() {
    x = random(width);
    y = random(-500, -50);
    speed = random(1, 3);
    size = random(5, 10);
    windSpeed = random(0.1, 0.5); // Random wind resistance
  }
  
  void update() {
    // Update snowflake's vertical and horizontal movement
    y += speed;
    x += windDirection * windSpeed; // Move the snowflake based on wind direction
    
    // Reset snowflake position if it goes below the ground
    if (y > height) {
      y = random(-500, -50);
      x = random(width);
    }
    
    // Keep the snowflake within the screen bounds horizontally
    if (x < 0) {
      x = width;
    } else if (x > width) {
      x = 0;
    }
  }
  
  void display() {
    noStroke();
    fill(255);
    ellipse(x, y, size, size);
  }
}

void drawSun(float x, float y, float size) {
  // Sun
  fill(255, 223, 0); // Yellow color for the sun
  noStroke();
  ellipse(x, y, size, size);
  
  // Sun rays
  stroke(255, 223, 0); // Yellow rays
  strokeWeight(4);
  for (int i = 0; i < 12; i++) {
    float angle = TWO_PI / 12 * i;
    float rayX = x + cos(angle) * (size / 2 + 20);
    float rayY = y + sin(angle) * (size / 2 + 20);
    line(x, y, rayX, rayY);
  }
}

void moveIceCreamTruck() {
  // Move ice cream truck from left to right
  iceCreamTruckX += iceCreamTruckSpeed;
  
  // Reset position when it goes off the screen
  if (iceCreamTruckX > width) {
    iceCreamTruckX = -200;
  }
}

void drawIceCreamTruck(float x, float y) {
  // Truck body
  fill(250, 0, 0); // Red color for the truck body
  noStroke();
  rect(x, y, 200, -100);
  rect(x, y, 200, 60);
  rect(x + 200, y - 20, 30, 80);
  
  // Truck windows
  fill(211, 211, 211); // Light gray for windows
  rect(x + 20, y - 60, 100, 80); // Left window
  rect(x + 140, y - 60, 40, 40); // Right window
  
  // Ice cream truck roof
  fill(255); // White roof
  rect(x + 60, y - 120, 80, 20);
  
  // Wheels
  fill(0); // Black wheels
  ellipse(x + 30, y + 60, 40, 40); // Left wheel
  ellipse(x + 170, y + 60, 40, 40); // Right wheel
  
  // Ice cream sign on the side
  fill(255, 165, 0); // Orange color for the ice cream
  triangle(x + 70, y - 110, x + 120, y - 110, x + 95, y - 170); // Ice cream cone
  fill(255, 105, 180); // Pink for ice cream scoop
  ellipse(x + 95, y - 110, 45, 45); // Scoop of ice cream
}

void drawKid(float x, float y) {
  // Kid's body
  fill(255, 228, 196); // Skin color
  ellipse(x, y - 80, 40, 40); // Head
  
  // Kid's legs
  fill(0, 0, 255); // Blue jeans
  rect(x - 15, y - 20, 10, 40); // Left leg
  rect(x + 5, y - 20, 10, 40); // Right leg
  
  // Kid's body
  fill(255, 0, 0); // Red t-shirt
  rect(x - 15, y - 60, 30, 40); // Body
  
  // Kid's arms
  fill(255, 228, 196); // Skin color
  rect(x - 25, y - 60, 10, 30); // Left arm
  rect(x + 15, y - 60, 10, 30); // Right arm
  
  // Ice cream cone
  fill(255, 165, 0); // Ice cream cone
  triangle(x + 20, y - 80, x + 50, y - 80, x + 35, y - 40); // Cone part
  fill(255, 105, 180); // Pink ice cream
  ellipse(x + 35, y - 85, 30, 30); // Ice cream scoop
}

void keyPressed() {
  // Toggle between winter and summer scenes when spacebar is pressed
  if (key == ' ') {
    isWinter = !isWinter;
    if (!isWinter) {
      // Stop the truck and place the kid when switching to summer
      iceCreamTruckX = 300; // Stop the truck at a specific position
      kidAppeared = false; // Reset kid appearance status
    }
  }
}

void mousePressed() {
  // When mouse is pressed in summer scene, show the kid with ice cream cone
  if (!isWinter && !kidAppeared) {
    isTruckMoving = false;
    kidAppeared = true;
    kidX = iceCreamTruckX + 300; // Position the kid next to the truck
  }
}
