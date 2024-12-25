float offset = 0;  // tracks the horizontal movement of sine wave.
float waveDip = 0;  // tracks the vertical dip of the wave
float waveMovementSpeed = 2;  // controls horizontally and vertically wave speed.
ArrayList<Particle> particles;  // ArrayList to store multiple Particle objects

void setup() {
  size(800, 800);  // Sets the size of the canvas to 800 by 800 pixels
  particles = new ArrayList<Particle>();  // starts the particles ArrayList.

  for (int i = 0; i < 2; i++) { // Creates two particle objects with random positions.
    particles.add(new Particle(random(width), random(height)));  
  }
  frameRate(60);  // Sets the frame rate to 60 frames per second.
}
void draw() {
  background(173, 216, 230);
  stroke(waveColor); // Use the updated wave color
  noFill();

  beginShape();
  for (int x = 0; x < width; x++) { // makes background light blue
    float y = sin((x + offset) * 0.02) * height / 4 + height / 2 + waveDip; // calculates y cordinate at each x postion
    vertex(x, y); 
  }
  endShape(); // finishes the shape of wave

  offset += waveMovementSpeed; // moves the side by side by increasing offset
  waveDip -= waveMovementSpeed; // moves the wave downward by reducing wave dip
  if (waveDip < 0) waveDip = 0; // doesnt go below canvas

  for (Particle p : particles) { // updates and displays each particle 
    p.update(); // ubdates its postion
    p.display(); // displays particle

    if (p.interactWithWave()) { // checks if the particle hits the wave
      waveDip = min(waveDip + 30, height / 2); // moves wave down temporary
      p.resetPosition(); // resets particle postion
    }
  }
}
color waveColor = color(0, 0, 255); // Default wave color

void mousePressed() { // changes the waves color when mouse is pressed
  waveColor = color(random(255), random(255), random(255)); // Change to random color
  for (Particle p : particles) { // resets the particle position when i press my mouse
    p.resetPosition();
  }
}
class Particle { // creates class for Particle
  float x, y;  // coordinates representing the position of the particle.
  float speedX, speedY;  // Speed of the particle along both axes.
  float size;  // Size of the particle

  Particle(float x, float y) { // makes particle with a given position and random speeds.
    this.x = x;  // sets initial x-coordinate
    this.y = y;  // sets initial y-coordinate.
    speedX = random(-10, 10);  // assigns a horizontal speed between -10 and 10.
    speedY = random(-10, 10);  // assigns a vertical speed between -10 and 10.
    size = 30;  // sets the size of the particle.
  }
  void update() { // Updates the particle's the positiof particel if it bounces off canvas edges baced on the speed its going at.
    x += speedX;  // moves the particle horizontally.
    y += speedY;  // moves the particle vertically
    
    if (x < 0 || x > width) {  // if it bounces off the horizontal edges of the canvas
      speedX *= -1;  // reverses the horizontal direction
    }
    if (y < 0 || y > height) { // if it bounces off the vertical edges of the canvas
      speedY *= -1;  // reverses the vertical direction.
    }
  }
  void display() {  // shows the particle 
    stroke(255, 0, 0);  // makes the particle color to red 
    strokeWeight(size);  // makes the particle size
    point(x, y);  // Draws the particle as a point at (x, y).
  }
  boolean interactWithWave() {  // checks if the particle hits the wave to interact
    int ix = constrain((int)x, 0, width - 1);  // makes sure  x stays within the canvas.
    float waveY = getWaveY(ix);  // gets the wave's y-coordinate at the particle's x-coordinate.

    return abs(y - waveY) < size;  //returns true if the particle is hits the wave
  }
  float getWaveY(int x) {  // calculates the y-coordinate of the wave at a given x position using the sine formula.
    return sin((x + offset) * 0.02) * height / 4 + height / 2 + waveDip;  
  }
  void resetPosition() { // resets the particle to a new random position 
    x = random(width);  // sets x to a random value within the canvas.
    y = random(height);  // sets y to a random value within the canvas height.
  }
}
