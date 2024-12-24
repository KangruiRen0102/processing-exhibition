let numParticles = 10000; // Number of particles in the system
let particles = []; // Array to hold all particles

function setup() {
  createCanvas(800, 800);
  for (let i = 0; i < numParticles; i++) {
    particles.push(new Particle(random(width), random(height))); // Add particles at random positions
  }
}

function draw() {
  background(20, 20);  
  drawAnalogClock(); // Draw the translucent analog clock in the background
  for (let p of particles) { // Update particle positions and display them
    p.update();
    p.display();
  }
}

function drawAnalogClock() {
  let clockCenterX = width / 2;  
  let clockCenterY = height / 2;  
  let clockRadius = 300;  

  stroke(255, 255, 255, 75); // Clock face
  noFill();
  strokeWeight(4);
  ellipse(clockCenterX, clockCenterY, clockRadius * 2, clockRadius * 2);

  let hourAngle = map(hour() % 12, 0, 12, -HALF_PI, 3 * PI / 2);  
  let minuteAngle = map(minute(), 0, 60, -HALF_PI, 3 * PI / 2);  
  let secondAngle = map(second(), 0, 60, -HALF_PI, 3 * PI / 2);  

  // Hour hand
  strokeWeight(8);
  line(
    clockCenterX, 
    clockCenterY, 
    clockCenterX + cos(hourAngle) * 100, 
    clockCenterY + sin(hourAngle) * 100
  );

  // Minute hand
  strokeWeight(6);
  line(
    clockCenterX, 
    clockCenterY, 
    clockCenterX + cos(minuteAngle) * 150, 
    clockCenterY + sin(minuteAngle) * 150
  );

  // Second hand
  strokeWeight(4);
  line(
    clockCenterX, 
    clockCenterY, 
    clockCenterX + cos(secondAngle) * 180, 
    clockCenterY + sin(secondAngle) * 180
  );

  // Clock center
  noStroke();
  fill(255, 255, 255, 75);
  ellipse(clockCenterX, clockCenterY, 20, 20);
}

class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-2, 2);
    this.speedY = random(-2, 2);
    this.col = color(random(0, 255), random(0, 255), random(0, 255), 255);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;

    // Infinite flow
    if (this.x > width) this.x = 0;
    if (this.x < 0) this.x = width;
    if (this.y > height) this.y = 0;
    if (this.y < 0) this.y = height;
  }

  display() {
    stroke(this.col);
    strokeWeight(4);
    point(this.x, this.y);
  }
}
