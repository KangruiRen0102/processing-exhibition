// Global variables for detailed aurora and interactivity
color[] auroraColors;
float waveOffset = 0;
int currentAuroraColor = 0;
PGraphics auroraLayer;
ArrayList<PVector> stars;

void setup() {
  size(1000, 600);
  auroraColors = new color[] {
    color(0, 255, 255, 255), // Brighter cyan
    color(255, 0, 255, 255), // Brighter magenta
    color(0, 255, 100, 255), // Brighter green
    color(255, 200, 50, 255) // Brighter yellow-orange
  };
  auroraLayer = createGraphics(width, height);
  stars = new ArrayList<>();
  generateStars();
}

void draw() {
  drawBackground();
  drawDetailedAurora();
  drawStars();
  drawBigTwilightStar();
  drawSea();
}

// Draw a twilight gradient background
void drawBackground() {
  for (int y = 0; y < height; y++) {
    float t = map(y, 0, height, 0, 1);
    color skyColor = lerpColor(color(25, 25, 112), color(72, 61, 139), t);
    stroke(skyColor);
    line(0, y, width, y);
  }
}

// Draw the detailed aurora
void drawDetailedAurora() {
  auroraLayer.beginDraw();
  auroraLayer.background(0, 0); // Transparent background
  auroraLayer.noFill();
  
  // Create multiple layers of aurora for depth
  for (int layer = 0; layer < 12; layer++) { // 12 layers
    auroraLayer.stroke(lerpColor(auroraColors[(currentAuroraColor + layer) % auroraColors.length], 
                                 color(0), 0.1)); // Subtle transparency for better blending
    auroraLayer.strokeWeight(3 + layer * 0.5); // Slightly thicker for prominence
    auroraLayer.beginShape();
    
    for (float x = 0; x < width; x += 3) { // Reduced step size for finer detail
      float y = height / 2 - layer * 15 + // Lowered closer to the center
                noise((x + mouseX) * 0.01, waveOffset + layer * 0.2) * 150 + // Aurora moves with mouseX
                40 * sin((x + mouseX) * 0.05 + waveOffset); // Enhanced wave effect
      auroraLayer.curveVertex(x, y);
    }
    auroraLayer.endShape();
  }
  
  auroraLayer.endDraw();
  image(auroraLayer, 0, 0);
  waveOffset += 0.01; // Animate aurora
}

// Draw the moving sea at the bottom
void drawSea() {
  noStroke();
  for (int y = height - 100; y < height; y++) {
    float t = map(y, height - 100, height, 0, 1);
    fill(lerpColor(color(0, 0, 139), color(0, 191, 255), t)); // Gradient sea colors
    beginShape();
    for (float x = 0; x <= width; x += 10) {
      float waveHeight = 10 * sin((x + waveOffset * 100) * 0.02 + t * 5);
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// Draw twinkling stars
void drawStars() {
  for (PVector star : stars) {
    fill(255, random(200, 255));
    noStroke();
    ellipse(star.x, star.y, random(3, 5), random(3, 5));
  }
}

// Draw a single large twilight star in the top-right corner
void drawBigTwilightStar() {
  float x = width - 100;
  float y = 100;
  fill(255, 220, 150, 200);
  noStroke();

  // Draw glowing layers for the star
  for (int i = 40; i > 0; i -= 10) {
    fill(255, 220 + i, 150 + i, 150 - i * 3);
    ellipse(x, y, i * 2, i * 2);
  }

  // Draw the diamond shape
  fill(255, 255, 255, 255);
  beginShape();
  vertex(x, y - 20); // Top point
  vertex(x + 15, y); // Right point
  vertex(x, y + 20); // Bottom point
  vertex(x - 15, y); // Left point
  endShape(CLOSE);
}

// Generate random stars
void generateStars() {
  for (int i = 0; i < 600; i++) { // Increased concentration of stars
    stars.add(new PVector(random(width), random(height)));
  }
}

// Change aurora colors on mouse click
void mousePressed() {
  currentAuroraColor = (currentAuroraColor + 1) % auroraColors.length;
  // Add more stars for extra sparkle effect
  generateStars();
}
