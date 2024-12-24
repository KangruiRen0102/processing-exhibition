let boats = []; // Array to store all boats
let clickCount = 0;
let shift = 0;

function setup() {
  createCanvas(800, 800);
  strokeWeight(2);
}

function mousePressed() {
  clickCount += 1;
  let boat = new Boat(mouseX, mouseY, clickCount % 2, clickCount % 7);
  boats.push(boat);
}

function draw() {
  background(0, 191, 255); // Set the background color
  textSize(45);
  fill(255);
  text("Click to send the boats on their journey!", 20, 45);

  // Draw waves
  for (let h = 0; h < height; h += 160) {
    stroke(50, 100, 255);
    strokeWeight(4);
    noFill();
    beginShape();
    for (let x = 0; x < width; x += 10) {
      let y = 10 * sin(0.05 * x + shift + h);
      vertex(x, 80 + y + h);
    }
    endShape();
  }

  shift += 0.05;

  // Display boats
  for (let boat of boats) {
    boat.display();
  }
}

class Boat {
  constructor(xPos, yPos, direction, index) {
    this.x = xPos;
    this.y = yPos;
    this.left = direction;
    this.flag;
    this.displacementX = 0;
    this.displacementY = 0;

    // Decide flag color
    switch (index) {
      case 1:
        this.flag = color(255, 0, 0); // Red
        break;
      case 2:
        this.flag = color(252, 127, 3); // Orange
        break;
      case 3:
        this.flag = color(252, 219, 3); // Yellow
        break;
      case 4:
        this.flag = color(0, 199, 20); // Green
        break;
      case 5:
        this.flag = color(8, 92, 201); // Blue
        break;
      case 6:
        this.flag = color(69, 8, 201); // Indigo
        break;
      case 0:
        this.flag = color(160, 8, 201); // Violet
        break;
    }
  }

  display() {
    strokeWeight(2);
    stroke(0);

    if (this.left === 1) {
      fill(139, 69, 19);
      beginShape(); // Hull
      vertex(this.x - 50 + this.displacementX, this.y + 20 + this.displacementY);
      vertex(this.x + 50 + this.displacementX, this.y + 20 + this.displacementY);
      vertex(this.x + 70 + this.displacementX, this.y + this.displacementY);
      vertex(this.x - 70 + this.displacementX, this.y + this.displacementY);
      endShape(CLOSE);

      fill(160, 82, 45); // Upper deck
      rect(this.x - 70 + this.displacementX, this.y - 30 + this.displacementY, 60, 30);

      fill(255); // Sail
      triangle(this.x + this.displacementX, this.y - 90 + this.displacementY, this.x + 20 + this.displacementX, this.y - 30 + this.displacementY, this.x + this.displacementX, this.y + this.displacementY);

      fill(this.flag); // Flag
      triangle(this.x + this.displacementX, this.y - 90 + this.displacementY, this.x - 30 + this.displacementX, this.y - 85 + this.displacementY, this.x + this.displacementX, this.y - 80 + this.displacementY);
    } else {
      fill(139, 69, 19);
      beginShape(); // Hull
      vertex(this.x + 50 - this.displacementX, this.y + 20 + this.displacementY);
      vertex(this.x - 50 - this.displacementX, this.y + 20 + this.displacementY);
      vertex(this.x - 70 - this.displacementX, this.y + this.displacementY);
      vertex(this.x + 70 - this.displacementX, this.y + this.displacementY);
      endShape(CLOSE);

      fill(160, 82, 45); // Upper deck
      rect(this.x + 10 - this.displacementX, this.y - 30 + this.displacementY, 60, 30);

      fill(255); // Sail
      triangle(this.x - this.displacementX, this.y - 90 + this.displacementY, this.x - 20 - this.displacementX, this.y - 30 + this.displacementY, this.x - this.displacementX, this.y + this.displacementY);

      fill(this.flag); // Flag
      triangle(this.x - this.displacementX, this.y - 90 + this.displacementY, this.x + 30 - this.displacementX, this.y - 85 + this.displacementY, this.x - this.displacementX, this.y - 80 + this.displacementY);
    }

    this.displacementX += 1.25;
    this.displacementY = 15 * sin(this.displacementX / 30);
  }
}
