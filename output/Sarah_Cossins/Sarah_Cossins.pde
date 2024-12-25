// ArrayList that stores all of the particles (whispers)
ArrayList<Particle> particles;

// color[] stores all of the background colors, which creates a gradient ranging 
// from an orange-pink color at the bottom to an almost black dark blue at the top
color[] gradientColors = {
  color(5, 5, 15),
  color(15, 15, 50),
  color(30, 30, 100),
  color(50, 40, 120),
  color(90, 50, 140),
  color(120, 60, 160),
  color(200, 80, 180),
  color(250, 100, 150),
  color(255, 120, 140)
};

// Star[] is an array that holds the stars, and PShape[] holds the seperate mountain
// ranges that are generated differently each time
Star[] stars;
PShape[] mountainShapes;

// Setup function runs once at the beginning
void setup() {
  size(800, 800);
  noStroke();
  // Initializes the star array with the base amount (125 stars)
  stars = new Star[125];
  // Create the particles (whispers) and initializes the open array
  particles = new ArrayList<Particle>();
  // Creates the initial particles, limiting them to the bottom 2/3 of the frame
  for (int i = 0; i < 50; i++) {
    addParticle(random(width), random(height * 2 / 3, height));
  }
  // Initialize stars with random positions on the upper portion of the frame
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star(random(width), random(height / 1.65), random(2, 4));
  }
  // Generates the mountain layers, and gives them seperate colours depending on the
  // layer it is in
  mountainShapes = new PShape[4];
  for (int i = 0; i < mountainShapes.length; i++) {
    mountainShapes[i] = createMountainLayer(0.45, color(70 - i * 10, 70 - i * 10, 70 - i * 10));
  }
  frameRate(60);
}

// This function runs continuously to create animation, which includes the gradient
// background, the mountain layers, the moon, the stars, the particles (whispers)
// with a trail, which is being updated to continue generation of the whispers after
// removing the particles that have completed there time cycle
void draw() {
  for (int y = 0; y < height; y++) {
    float t = map(y, 0, height, 0, gradientColors.length - 1);
    int index1 = floor(t); 
    int index2 = min(index1 + 1, gradientColors.length - 1);
    float blend = t - index1;
    color col = lerpColor(gradientColors[index1], gradientColors[index2], blend);
    stroke(col);
    line(0, y, width, y);
  }
  for (int i = 0; i < mountainShapes.length; i++) {
    shape(mountainShapes[i], 0, 0);
  }
  drawMoon();
  for (int i = 0; i < stars.length; i++) {
    stars[i].display();
  }
  fill(0, 15);
  rect(0, 0, width, height);
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
  // Maintain particle count at a maximum of 50
  while (particles.size() < 50) {
    addParticle(random(width), random(height * 2 / 3, height));
  }
  // Draw sine waves at the bottom
  drawSineWaves();
}

// This function adds 25 more stars to the specified portion of the frame whenever
// the mouse is pressed
void mousePressed() {
  int newStars = 25;
  Star[] updatedStars = new Star[stars.length + newStars];
  for (int i = 0; i < stars.length; i++) {
    updatedStars[i] = stars[i];
  }
  for (int i = stars.length; i < updatedStars.length; i++) {
    updatedStars[i] = new Star(random(width), random(height / 1.65), random(2, 4));
  }
  stars = updatedStars;
}

// Function to draw sine waves (shadows). A noiseFactor is added to make the sin waves
// appear transparent, adding to the "shadow" effect
void drawSineWaves() {
  noFill();
  stroke(0);
  strokeWeight(5);
  
  float waveHeight = 20;
  float waveSpacing = 30;
  float frequency = 0.004;
  
  for (int j = height - 150; j < height; j += waveSpacing) {
    beginShape();
    for (int x = 0; x <= width; x++) {
      float noiseFactor = noise(x * 0.01, frameCount * 0.01);
      float yOffset = waveHeight * sin(TWO_PI * frequency * x + frameCount * 0.03);
      float y = j + yOffset + noiseFactor * 5;
      float alpha = map(abs(x - width / 2), 0, width / 2, 255, 50);
      stroke(0, alpha);
      vertex(x, y);
    }
    endShape();
  }
}

// This function creates the layers of mountains. A vertical offset is included to
// adjust the height of the mountains, and make them immovable in the animation, 
// ensuring they do not move while the whispers do
PShape createMountainLayer(float heightFactor, color mountainColor) {
  PShape layer = createShape();
  layer.beginShape();
  layer.fill(mountainColor);
  float verticalOffset = 275;  
  for (int x = 0; x <= width; x += 160) {
    float peakHeight = random(height * heightFactor * 0.6, height * heightFactor * 1.0); 
    layer.vertex(x, peakHeight + verticalOffset);
  }
  layer.vertex(width, height + verticalOffset); 
  layer.vertex(0, height + verticalOffset);     
  layer.endShape(CLOSE);
  return layer;
}

// This function draws the moon, dictating the color, size, and position
void drawMoon() {
  float moonX = width - 150;
  float moonY = 150;
  float moonRadius = 80;
  fill(255, 255, 200);
  noStroke();
  ellipse(moonX, moonY, moonRadius * 2, moonRadius * 2);
}

// Star class to represent individual stars, and dictate the location, size, and color
class Star {
  float x, y;
  float size;
  Star(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  void display() {
    fill(255, 255, 255);
    noStroke();
    ellipse(x, y, size, size);
  }
}

// Particle class to represent individual particles (whispers), such as their speed
// position, lifespan, color, and the position of the whispers' tails. All of the
// above are randomly generated within the given parameters. It also allows the
// whispers to rotate, giving them a "dancing" effect, within the given parameters
class Particle {
  float x, y;
  PVector velocity;
  float lifespan;
  color fillColor;
  ArrayList<PVector> trail;
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    velocity = PVector.random2D();
    velocity.mult(random(0.5, 1.5));
    lifespan = random(200, 400);
    fillColor = getGoldOrWhiteColor();
    trail = new ArrayList<PVector>();
  }
  void update() {
    x += velocity.x;
    y += velocity.y;
    lifespan -= 1.5;
    velocity.rotate(0.02);
    trail.add(new PVector(x, y));
    if (trail.size() > 25) {
      trail.remove(0);
    }
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = height;
    if (y < height / 3) y = height / 3;
  }
  void display() {
    fill(fillColor, map(lifespan, 0, 255, 0, 255));
    noStroke();
    ellipse(x, y, 4, 4); 
    for (int i = 0; i < trail.size(); i++) {
      PVector p = trail.get(i);
      float alpha = map(i, 0, trail.size() - 1, 0, 255);
      fill(fillColor, alpha);
      ellipse(p.x, p.y, 3, 3);
    }
  }
  boolean isDead() {
    return lifespan <= 0;
  }
  color getGoldOrWhiteColor() {
    if (random(1) < 0.5) {
      return color(255, 204, 0);
    } else {
      return color(255, 255, 255);
    }
  }
}
void addParticle(float x, float y) {
  particles.add(new Particle(x, y));
}
