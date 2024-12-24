let num = 60;
let shapes = [];
let particles = [];

function setup() {
  createCanvas(640, 360);
  noStroke();

  // Create multiple shapes
  for (let i = 0; i < 5; i++) {
    shapes.push(new Shape(num));
  }
}

function draw() {
  background(4, 26, 64); // Night sky color

  // Display all shapes
  for (let s of shapes) {
    s.update(mouseX, mouseY);
    s.display();
  }

  // Display particles
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
    if (p.isFaded()) {
      particles.splice(i, 1); // Remove faded particles
    }
  }
}

function keyPressed() {
  // Change shape type for all shapes
  for (let s of shapes) {
    s.nextShapeType();
  }
}

function mousePressed() {
  // Spawn particles when mouse is pressed
  for (let i = 0; i < 10; i++) {
    particles.push(new Particle(mouseX, mouseY, color(178, 243, 142)));
  }
}

// Shape Class
class Shape {
  constructor(numPoints) {
    this.num = numPoints;
    this.x = new Array(numPoints).fill(0);
    this.y = new Array(numPoints).fill(0);
    this.shapeType = 0; // Start with ellipse
    this.frameIndex = 0;
  }

  update(mx, my) {
    this.frameIndex = frameCount % this.num;
    this.x[this.frameIndex] = mx;
    this.y[this.frameIndex] = my;
  }

  display() {
    for (let i = 0; i < this.num; i++) {
      let index = (this.frameIndex + 1 + i) % this.num;
      let size = i; // Shape size increases with trail age
      let alpha = map(i, 0, this.num, 80, 180); // Older segments are more transparent
      fill(178, 243, 142, alpha);

      switch (this.shapeType) {
        case 0:
          ellipse(this.x[index], this.y[index], size, size);
          break;
        case 1:
          rect(this.x[index] - size / 2, this.y[index] - size / 2, size, size);
          break;
        case 2:
          this.drawPolygon(this.x[index], this.y[index], size, 3);
          break;
        case 3:
          this.drawPolygon(this.x[index], this.y[index], size, 5);
          break;
        case 4:
          this.drawPolygon(this.x[index], this.y[index], size, 6);
          break;
      }
    }
  }

  nextShapeType() {
    this.shapeType = (this.shapeType + 1) % 5; // Cycle through 5 shapes
  }

  drawPolygon(cx, cy, radius, sides) {
    let angle = TWO_PI / sides;
    beginShape();
    for (let i = 0; i < sides; i++) {
      let px = cx + cos(angle * i) * radius / 2;
      let py = cy + sin(angle * i) * radius / 2;
      vertex(px, py);
    }
    endShape(CLOSE);
  }
}

// Particle Class
class Particle {
  constructor(startX, startY, col) {
    this.x = startX;
    this.y = startY;
    this.col = col;
    this.alpha = 255; // Start fully opaque

    // Random velocity
    this.vx = random(-2, 2);
    this.vy = random(-2, 2);
  }

  update() {
    this.x += this.vx;
    this.y += this.vy;
    this.alpha -= 5; // Gradually fade
  }

  display() {
    fill(red(this.col), green(this.col), blue(this.col), this.alpha);
    ellipse(this.x, this.y, 10, 10); // Particle size
  }

  isFaded() {
    return this.alpha <= 0; // Check if particle is fully faded
  }
}
