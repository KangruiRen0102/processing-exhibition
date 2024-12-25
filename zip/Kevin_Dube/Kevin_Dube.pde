PVector[] stars;                                               //Declares an array for storing star positions, (going to be used for starry background)
color twilightColor;
ArrayList<Ribbon> auroras;                                     //Creates a list of ribbon objects to represent auroraras moving 
ArrayList<Star> starsList;
boolean showMessage = false;
float messageStartTime;
String message = "We want the Cup!";                           //holds the message displayed during the interaction
ArrayList<PVector> fireworkPositions;
float time;

void setup() {                                                //The setup function initializes the canvas size, aurora ribbons, and stars.
  size(800, 800);
  twilightColor = color(50, 30, 80);                          //Initializes the twilight color to a dark purple shade, representing the evening sky.
  auroras = new ArrayList<Ribbon>();                          //Creates an empty list to store aurora objects, which will animate the auroras in the sky.
  starsList = new ArrayList<Star>();
  fireworkPositions = new ArrayList<PVector>();                // Prepares a list to store positions of the fireworks that will appear during interactions.
  time = 0;

  // Generate initial aurora ribbons. Adds dynamically generated auroras to the auroras list, with random vertical positions and speeds.
  for (int i = 0; i < 5; i++) {
    auroras.add(new Ribbon(random(50, height - 300), random(0.5, 1.5))); 
  }

  // Generate stars with random positions
  for (int i = 0; i < 100; i++) {
    starsList.add(new Star(random(width), random(height / 2), random(2, 4)));
  }
}

void draw() {
  // Gradually change twilight background over time
  twilightColor = lerpColor(color(50, 30, 80), color(20, 10, 50), sin(time) * 0.5 + 0.5);
  background(twilightColor);
  time += 0.01;

  // Draw stars Iterates through the star list to twinkle and display each star, creating a dynamic starry sky.
  for (Star star : starsList) {
    star.twinkle();
    star.display();
  }

  // Draw the moon
  drawMoon();

  // Draw the Edmonton cityscape as a silhouette
  drawCityscape();

  // Draw the interactive Oilers symbol
  drawOilersSymbol();

  // Render auroras
  for (Ribbon aurora : auroras) {
    aurora.update();
    aurora.display();
  }

  // Display the message if triggered
  if (showMessage) {
    displayMessage();
  }
}

void drawMoon() {
  fill(255, 255, 200);
  noStroke();
  ellipse(650, 100, 80, 80);
}

void drawCityscape() {
  fill(20);
  noStroke();
  rect(0, height - 200, width, 200);

  // Add some buildings
  rect(100, height - 300, 50, 100);
  rect(200, height - 250, 80, 150);
  rect(350, height - 350, 100, 200);
  rect(500, height - 280, 60, 80);
  rect(650, height - 300, 70, 150);

  // Add text on the tallest building. Displays the text 'Engineers Rock Inc.' on the tallest building to emphasize the engineering theme.
  fill(255);
  textAlign(CENTER);
  textSize(12);
  text("Engineers Rock Inc.", 400, height - 335);  
}

void drawOilersSymbol() {
  float centerX = 190; // Position above the tallest building
  float centerY = height - 400; // Just above the tallest building
  float radius = 50;

  // Draw glowing background for the Oilers symbol, giving it a beacon-like effect.
  noStroke();
  fill(255, 100, 50, 100);
  ellipse(centerX, centerY, radius * 2.5, radius * 2.5);

  // Draw outer circle (blue border)
  fill(0, 51, 153);
  ellipse(centerX, centerY, radius * 2, radius * 2);

  // Draw inner circle (white background)
  fill(255);
  ellipse(centerX, centerY, radius * 1.8, radius * 1.8);

  // Draw oil drop. Defines the shape of the Oilers' iconic oil drop inside the symbol.
  fill(255, 102, 0);
  beginShape();
  vertex(centerX, centerY - radius * 0.4);
  bezierVertex(centerX - radius * 0.2, centerY - radius * 0.2, centerX - radius * 0.2, centerY + radius * 0.2, centerX, centerY + radius * 0.4);
  bezierVertex(centerX + radius * 0.2, centerY + radius * 0.2, centerX + radius * 0.2, centerY - radius * 0.2, centerX, centerY - radius * 0.4);
  endShape(CLOSE);

  // Draw blue text bar
  fill(0, 51, 153);
  rect(centerX - radius * 0.8, centerY - radius * 0.1, radius * 1.6, radius * 0.2);

  // Add text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(radius * 0.3);
  text("OILERS", centerX, centerY);

  // Check for interaction. Checks if the Oilers symbol is clicked and triggers the fireworks-style message.
  if (mousePressed && dist(mouseX, mouseY, centerX, centerY) < radius) {
    triggerMessage(centerX, centerY); // Trigger the fireworks message
  }
}

void triggerMessage(float x, float y) {
  showMessage = true; // Enable message display
  messageStartTime = millis(); // Record the current time

  // Generate random fireworks positions around the clicked location
  fireworkPositions.clear();
  for (int i = 0; i < 10; i++) {
    float angle = random(TWO_PI);
    float distance = random(50, 100);
    fireworkPositions.add(new PVector(x + cos(angle) * distance, y + sin(angle) * distance));
  }
}

void displayMessage() {
  float elapsedTime = millis() - messageStartTime;

  // Display fireworks effect
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(255, random(100, 255), random(100, 255), 200); // Firework-like colors
  for (PVector pos : fireworkPositions) {
    text(message, pos.x, pos.y);
  }

  // Disable the message after 3 seconds
  if (elapsedTime > 3000) {
    showMessage = false;
  }
}

class Ribbon {                                                                 //Defines the Ribbon class, representing dynamic auroras that move across the sky.
  float y, speed;
  color col;

  Ribbon(float y, float speed) {
    this.y = y;
    this.speed = speed;
    this.col = color(random(100, 255), random(100, 255), random(255));
  }

  void update() {
    y -= speed;
    if (y < 0) {
      y = height - 300;
    }
  }

  void display() {                                                     //Creates a wavy effect for the auroras using sine functions to simulate natural motion.
    stroke(col);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int x = 0; x < width; x += 20) {
      vertex(x, y + sin((x + frameCount) * 0.02) * 30);
    }
    endShape();
  }
}

class Star {                                           //Defines the Star class, representing individual stars that twinkle in the sky.
  float x, y, size;
  color col;

  Star(float x, float y, float size) {                
    this.x = x;
    this.y = y;
    this.size = size;
    this.col = color(255, random(150, 255));
  }

  void twinkle() {
    col = color(255, random(150, 255));
  }

  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, size, size);
  }
}
