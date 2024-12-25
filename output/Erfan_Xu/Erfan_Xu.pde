class MovableImage {
  PImage img;
  float x, y, rad;
  float vx, vy;
  float angleX, angleY;
  float speedX, speedY;
  float rotationAngle; // Rotation angle
  float rotationSpeed; // Rotation speed

  MovableImage(String imgPath, float startX, float startY, float radius) {
    img = loadImage(imgPath);
    x = startX;
    y = startY;
    rad = radius;
    angleX = random(TWO_PI);
    angleY = random(TWO_PI);
    speedX = random(0.5, 1.5);
    speedY = random(0.5, 1.5);
    rotationAngle = 0; // Initialize rotation angle
    rotationSpeed = random(0.005, 0.02); // Different rotation speeds
  }

  void update() {
    if (!isDragging) {
      vx = cos(angleX) * 2;
      vy = sin(angleY) * 2;
      x += vx;
      y += vy;
      angleX += speedX * 0.01;
      angleY += speedY * 0.01;
      rotationAngle += rotationSpeed; // Update rotation angle with rotation speed
      handleBoundaryCollision();
    }
  }

  void draw() {
    pushMatrix();
    translate(x + rad, y + rad);
    rotate(rotationAngle);
    imageMode(CENTER);
    image(img, 0, 0, rad * 2, rad * 2);
    popMatrix();
  }

  void handleBoundaryCollision() {
    if (x < 0 || x + rad * 2 > width) {
      angleX += PI;
      x = constrain(x, 0, width - rad * 2);
    }
    if (y < 0 || y + rad * 2 > height) {
      angleY += PI;
      y = constrain(y, 0, height - rad * 2);
    }
  }

  boolean isMouseOver() {
    float distance = dist(mouseX, mouseY, x + rad, y + rad);
    return distance < rad;
  }
}



class Bubble {
  float x, y, rad;
  float vy;
  int alpha;

  Bubble(float startX, float startY, float radius) {
    x = startX;
    y = startY;
    rad = radius;
    vy = random(1, 4); // Increase speed
    alpha = 255;
  }

  void update() {
    y -= vy;
    alpha -= 2;
  }

  void draw() {
    noStroke();
    fill(255, 255, 140, alpha);
    ellipse(x, y, rad * 2, rad * 2);
  }

  boolean isVisible() {
    return alpha > 0;
  }
}

class Star {
  float x, y, rad;
  float vy;
  int alpha;
  float twinkleFactor;

  Star(float startX, float startY, float radius) {
    x = startX;
    y = startY;
    rad = radius;
    vy = random(1, 4); // Similar speed as bubbles
    alpha = 255;
    twinkleFactor = random(0.01, 0.05); // Twinkle speed
  }

  void update() {
    y -= vy;
    alpha -= 2;
    rad += twinkleFactor * sin(frameCount * 0.1); // Twinkle effect
  }

  void draw() {
    noStroke();
    fill(0, 0, 140, alpha); // Blue color for stars
    drawStar(x, y, rad, rad / 2); // Draw the star
  }

  void drawStar(float x, float y, float outerRadius, float innerRadius) {
    float angle = TWO_PI / 5;
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * outerRadius;
      float sy = y + sin(a) * outerRadius;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * innerRadius;
      sy = y + sin(a + halfAngle) * innerRadius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }

  boolean isVisible() {
    return alpha > 0;
  }
}



MovableImage[] images;
ArrayList<Bubble> bubbles;
ArrayList<Star> stars;
boolean isDragging = false;
int draggedIndex = -1;
PImage overlayImage;
float hueValue;

void setup() {
  size(800, 600);
  images = new MovableImage[62]; // Update the array size to hold 62 images (10 of each mouse type + 1 pig + 21 krills)

  for (int i = 0; i < 10; i++) {
    images[i] = new MovableImage("mouse 1.png", width / 2, height / 2, 50);
  }
  for (int i = 10; i < 20; i++) {
    images[i] = new MovableImage("mouse 2.png", width / 2, height / 2, 50);
  }
  for (int i = 20; i < 30; i++) {
    images[i] = new MovableImage("mouse 3.png", width / 2, height / 2, 50);
  }
  for (int i = 30; i < 40; i++) {
    images[i] = new MovableImage("mouse 4.png", width / 2, height / 2, 50);
  }

  images[40] = new MovableImage("pig 1.png", width / 2, height / 2, 100); // Include the pig

  for (int i = 41; i < 62; i++) {
    images[i] = new MovableImage("krill.png", width / 2, height / 2, 50); // Include 21 krills
  }

  bubbles = new ArrayList<Bubble>();
  stars = new ArrayList<Star>();
  
  overlayImage = loadImage("waves.png"); // Load your custom overlay image
  textSize(32); 
  textAlign(CENTER, CENTER);
  colorMode(HSB, 360, 100, 100); // Use HSB color mode for smooth color transitions 
  hueValue = 0;
}




void draw() {
  background(loadImage("ocean.jpg"));
  
  // Draw and update images
  for (MovableImage img : images) {
    img.update();
    img.draw();
  }

  // Add new bubbles randomly
  if (random(1) < 0.1) { // Increase frequency
    bubbles.add(new Bubble(random(width), height, random(10, 30))); // Increase size
  }

  // Draw and update bubbles
  for (int i = bubbles.size() - 1; i >= 0; i--) {
    Bubble b = bubbles.get(i);
    b.update();
    b.draw();
    if (!b.isVisible()) {
      bubbles.remove(i);
    }
  }

  // Add new stars randomly
  if (random(1) < 0.05) {
    stars.add(new Star(random(width), height, random(5, 15)));
  }

  // Draw and update stars
  for (int i = stars.size() - 1; i >= 0; i--) {
    Star s = stars.get(i);
    s.update();
    s.draw();
    if (!s.isVisible()) {
      stars.remove(i);
    }
  }
  image(overlayImage, 400, 300, width,height);
  
  fill(hueValue, 100, 100); // Set the text color // Draw black outline 
  fill(255); text("Welcome to chaotic aquarium", width / 2 - 2, height / 2 - 2); 
  text("Welcome to chaotic aquarium", width / 2 + 2, height / 2 - 2); 
  text("Welcome to chaotic aquarium", width / 2 - 2, height / 2 + 2); 
  text("Welcome to chaotic aquarium", width / 2 + 2, height / 2 + 2); // Draw the colorful text on top 
  fill(hueValue, 100, 100); text("Welcome to chaotic aquarium", width / 2, height / 2); 
  hueValue += 1; // Increment the hue value for color change 
  if (hueValue > 360) { hueValue = 0; // Reset the hue value to loop the colors
  }
}

void mousePressed() {
  for (int i = 0; i < images.length; i++) {
    if (images[i].isMouseOver()) {
      isDragging = true;
      draggedIndex = i;
      break;
    }
  }
}

void mouseReleased() {
  isDragging = false;
  draggedIndex = -1;
}

void mouseDragged() {
  if (isDragging && draggedIndex != -1) {
    images[draggedIndex].x = mouseX - images[draggedIndex].rad;
    images[draggedIndex].y = mouseY - images[draggedIndex].rad;
  }
}
