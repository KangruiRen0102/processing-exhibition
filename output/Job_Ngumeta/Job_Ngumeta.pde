int numSwirls = 600; // Increased number of chaotic swirls
int maxNoise = 1000; // Increased noise offset for more chaos

void setup() {
  size(1920, 1080);  // Higher resolution for more detail
  background(0);
  noStroke();
  frameRate(30);
}

void draw() {
  background(0, 10); // Darker background with faint trail effect

  drawChaos();
  drawAnimal();
  drawTormentedFigures();
  drawClouds();

  if (frameCount > 600) noLoop(); // Stop after a while for static effect
}

void drawChaos() {
  for (int i = 0; i < numSwirls; i++) {
    float x = width / 2 + random(-maxNoise, maxNoise);
    float y = height / 2 + random(-maxNoise, maxNoise);
    float r = random(2, 12);
    fill(random(50, 100), random(10, 50), random(10, 50), 60);
    ellipse(x, y, r, r);
  }
}

void drawAnimal() {
  pushMatrix();
  translate(width / 2, height / 2);

  // Shadow layer
  fill(10, 10, 20, 180);
  ellipse(0, 100, 600, 350); // Larger shadow for elongated body

  // Body with more texture
  fill(20, 20, 40, 250);
  ellipse(0, 50, 500, 250); // Larger body

  // Textured fur on body
  for (int i = 0; i < 300; i++) {
    float x = random(-250, 250);
    float y = random(-150, 150);
    fill(30, 30, 50, 150); // Denser fur with higher opacity
    ellipse(x, y + 50, random(8, 20), random(20, 30));
  }

  // Head with more refined shading
  fill(30, 20, 50, 255);
  ellipse(0, -75, 200, 160);

  // Eyes with a more ominous glow
  fill(150, 50, 50, 250);
  ellipse(-60, -100, 40, 55);
  ellipse(60, -100, 40, 55);

  // Pupils as sharp slits
  fill(10, 10, 20);
  ellipse(-60, -100, 10, 20);
  ellipse(60, -100, 10, 20);

  // Glowing effect for eyes
  noFill();
  stroke(150, 50, 50, 150);
  strokeWeight(5);
  ellipse(-60, -100, 60, 70);
  ellipse(60, -100, 60, 70);
  noStroke();

  // Ears angled back like jagged horns
  fill(20, 10, 40, 220);
  triangle(-90, -150, -130, -200, -50, -160);
  triangle(90, -150, 130, -200, 50, -160);

  // Obscured face
  fill(10, 10, 20, 255);
  rect(-100, -150, 200, 100); // Shroud the face in darkness

  // Twisted horns emerging from darkness
  stroke(80, 50, 120);
  strokeWeight(6);
  noFill();
  beginShape();
  for (float angle = 0; angle < TWO_PI; angle += 0.2) {
    float x = -100 + cos(angle) * (100 + angle * 12);
    float y = -250 - sin(angle) * (100 + angle * 12);
    vertex(x, y);
  }
  endShape();

  beginShape();
  for (float angle = 0; angle < TWO_PI; angle += 0.2) {
    float x = 100 + cos(angle) * (100 + angle * 12);
    float y = -250 - sin(angle) * (100 + angle * 12);
    vertex(x, y);
  }
  endShape();

  noStroke();

  // Tail with chaotic, frayed edges
  fill(15, 10, 30, 220);
  ellipse(0, 250, 100, 500); // Extended tail with more depth
  for (int i = 0; i < 100; i++) {
    float x = random(-30, 30);
    float y = random(200, 500);
    fill(10, 10, 20, 180);
    ellipse(x, y, random(8, 20), random(25, 40));
  }

  // Legs with more detail
  fill(20, 20, 40, 250);
  rect(-150, 200, 40, 150, 10);
  rect(120, 200, 40, 150, 10);
  rect(-80, 200, 40, 150, 10);
  rect(80, 200, 40, 150, 10);

  // Faint claw impressions
  for (int i = -160; i <= 160; i += 90) {
    for (int j = 0; j < 4; j++) {
      fill(100, 30, 30, 120);
      ellipse(i + j * 10, 280, 18, 35);
    }
  }

  popMatrix();
}

void drawTormentedFigures() {
  for (int i = 0; i < 100; i++) {
    float x = random(width / 6, 5 * width / 6); // Keep figures near the center
    float y = random(2 * height / 3, height); // Figures lower on the canvas

    // Shrouded robes
    fill(30, 30, 40, 250);
    beginShape();
    vertex(x - 30, y);
    vertex(x + 30, y);
    vertex(x + random(-15, 15), y - 60);
    endShape(CLOSE);

    // Hidden faces
    fill(10, 10, 20, 220);
    ellipse(x, y - 30, 25, 35);

    // Clawing gestures with detailed shadows
    stroke(50, 20, 20, 180);
    strokeWeight(3);
    line(x - 15, y, x - 25, y + 30);
    line(x + 15, y, x + 25, y + 30);
    noStroke();
  }
}

void drawClouds() {
  for (int i = 0; i < 50; i++) {
    float x = random(width);
    float y = random(height);
    float w = random(200, 400);
    float h = random(100, 200);
    fill(20, 20, 30, 120); // Darker and more solid cloud layers
    ellipse(x, y, w, h);
  }
}
