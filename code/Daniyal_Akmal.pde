ArrayList<Explorer> explorers;
int totalExplorers = 200; //Number of explorers displued during the animation
float auroraWave = 0.0;

// Setting up the foundation for a dark background
void setup() {
  size(800, 800);
  background(10, 15, 50);
  explorers = new ArrayList<Explorer>();
  for (int i = 0; i < totalExplorers; i++) {
    explorers.add(new Explorer(random(width), random(height)));
  }
}

//Drawing the dark background which will act as the base
void draw() {
  background(10, 15, 50, 50); 

  // Drawing an aurora
  drawAurora();

  // Constanly updating the explorers for the theme of infinity
  for (Explorer e : explorers) {
    e.move();
    e.display();
  }
}

//Drawing of the Aurora and defining its wave length, measurments and wave pattern
void drawAurora() {
  noStroke();
  for (int i = 0; i < height; i += 10) {
    float colorShift = map(sin(auroraWave + i * 0.05), -1, 1, 100, 255);
    fill(50, colorShift, 255, 100);
    rect(0, i, width, 10);
  }
  auroraWave += 0.1;
}

// Creating an explorer class which are the balls/objects flying through the screen
class Explorer {
  PVector position, velocity;
  color trailColor;

  Explorer(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D().mult(random(1, 3));
    trailColor = color(random(200, 255), random(100, 200), random(150, 255), 150);
  }

  void move() {
    position.add(velocity);

    // Allowing for an infinite journey of the explorers 
    if (position.x > width) position.x = 0;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 0;
    if (position.y < 0) position.y = height;
  }

  void display() {
    noStroke();
    fill(trailColor);
    ellipse(position.x, position.y, 6, 6);
  }
}
