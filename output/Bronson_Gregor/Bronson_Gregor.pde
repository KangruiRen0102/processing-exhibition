int numParticles = 10000;  // Number of particles in the system
ArrayList<Particle> particles;  // List to hold all particles

void setup() { //Setup of the void
  size(800, 800);  
  particles = new ArrayList<Particle>();  
  for (int i = 0; i < numParticles; i++) {
    
    particles.add(new Particle(random(width), random(height))); // Add particles to the list at random positions
  }
}

void draw() {
  background(20, 20);  
  drawAnalogClock(); // Draw the translucent analog clock in the background
  for (Particle p : particles) { // Update the particles position based on it speed then draw it 
    p.display();  
  }
}

void drawAnalogClock() {  // Dimensions and posititioning of clock
  float clockCenterX = width / 2;  
  float clockCenterY = height / 2;  
  float clockRadius = 300;  
  stroke(255, 255, 255, 75);   // Setting color for the clock face and hands
  fill(255, 255, 255, 75);    
  noFill();  
  strokeWeight(4);   
  ellipse(clockCenterX, clockCenterY, clockRadius * 2, clockRadius * 2);  

  // Time for the clock face, with hour, minute and second hands
  float hourAngle = map(hour() % 12, 0, 12, -PI / 2, 3 * PI / 2);  
  float minuteAngle = map(minute(), 0, 60, -PI / 2, 3 * PI / 2);  
  float secondAngle = map(second(), 0, 60, -PI / 2, 3 * PI / 2);  

  // Draw the hour hand
  strokeWeight(8);  
  line(clockCenterX, clockCenterY, clockCenterX + cos(hourAngle) * 100, clockCenterY + sin(hourAngle) * 100);

  // Draw the minute hand
  strokeWeight(6);  
  line(clockCenterX, clockCenterY, clockCenterX + cos(minuteAngle) * 150, clockCenterY + sin(minuteAngle) * 150);

  // Draw the second hand
  strokeWeight(4);  
  line(clockCenterX, clockCenterY, clockCenterX + cos(secondAngle) * 180, clockCenterY + sin(secondAngle) * 180);
  
  // Draw the clock center with transparency
  noStroke();  
  ellipse(clockCenterX, clockCenterY, 20, 20); 
}

class Particle { // Particle's position, speed in the X and Y direction, and color
  float x, y;  
  float speedX, speedY;  
  color col;  

  Particle(float x, float y) { // position, random x/y speed, and color
    this.x = x;  
    this.y = y;  
    this.speedX = random(-2, 2);  
    this.speedY = random(-2, 2);  
    this.col = color(random(0, 255), random(0, 255), random(0, 255), 255);
  }

  void update() { // Update position of the particle based on its individual speed
    
    x += speedX;
    y += speedY;
    
    // Creating an infinite flow 
    if (x > width) x = 0;  
    if (x < 0) x = width;  
    if (y > height) y = 0; 
    if (y < 0) y = height;  
  }

  void display() { // Draw the particle with its specific color, and thickness, and position
    stroke(col);
    strokeWeight(4);
    point(x, y);  
  }
}
