void setup() {
  size(800, 600); // Canvas size
  background(30, 40, 80); // Dark stormy sky
  
  drawClouds();
  drawWaves();
  drawStaticLightning();
  drawShip();
  drawRain();
}

// Function to draw chaotic waves
void drawWaves() {
  fill(10, 20, 50);
  noStroke();
  for (int y = height / 2; y < height; y += 20) {
    beginShape();
    for (int x = 0; x < width; x += 10) {
      float waveHeight = sin(x * 0.05) * 20 + noise(x * 0.01, y * 0.01) * 40;
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// Function to draw the ship
void drawShip() {
  fill(200, 100, 50); // Ship color
  pushMatrix();
  translate(width / 2, height / 2);
  
  // Ship base
  rect(-70, -20, 140, 40); 
  
  // Hull
  fill(150, 80, 40);
  arc(0, 20, 140, 60, 0, PI); 
  
  // Mast (shortened, brown)
  fill(139, 69, 19); 
  rect(-5, -60, 10, 40);
  
  // Black Flag
  fill(0);
  rect(-5, -100, 50, 30);
  
  // Skull and bones on the flag
  fill(255); 
  ellipse(20, -85, 15, 15); 
  ellipse(15, -80, 5, 5); 
  ellipse(25, -80, 5, 5); 
  rect(18, -78, 4, 5); 
  stroke(255);
  strokeWeight(2);
  line(10, -90, 30, -80); 
  line(10, -80, 30, -90);
  noStroke();
  
  // Sail
  fill(50);
  triangle(-5, -90, -70, -40, 60, -40); 
  popMatrix();
}

// Function to draw clouds
void drawClouds() {
  fill(80, 80, 80, 150);
  noStroke();
  for (int i = 0; i < 10; i++) {
    float x = (i * 150) % (width + 200) - 200;
    float y = 50 + i * 20;
    ellipse(x, y, 150, 80);
    ellipse(x + 60, y + 10, 120, 70);
    ellipse(x - 60, y + 10, 120, 70);
  }
}

// Function to draw rain
void drawRain() {
  stroke(100, 150, 255, 150); 
  for (int i = 0; i < 300; i++) {
    float x = random(width);
    float y = random(height);
    line(x, y, x + 2, y + 10);
  }
}

// Function to draw static lightning
void drawStaticLightning() {
  stroke(255); // White color for lightning
  strokeWeight(4);
  
  // Lightning bolts
  line(200, 0, 220, 100); // Bolt 1
  line(220, 100, 200, 200);
  
  line(600, 0, 580, 150); // Bolt 2
  line(580, 150, 600, 250);
  
  strokeWeight(1); // Reset stroke weight
}
