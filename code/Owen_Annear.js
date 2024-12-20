class Rectangle { // Create rectangles
  constructor(x, y, w, h, fillColor) { // Constructor for Rectangle class
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fillColor = fillColor;
  }

  display() { // Method to draw rectangles on screen
    fill(this.fillColor);
    rect(this.x, this.y, this.w, this.h);
  }

  isInside(mx, my) { // Check if point mx and my are inside the rectangle
    return (
      mx >= this.x - this.w / 2 &&
      mx <= this.x + this.w / 2 &&
      my >= this.y - this.h / 2 &&
      my <= this.y + this.h / 2
    );
  }
}

// Lists to store the drawn rectangles
let Floors = [];
let Doors = [];
let Windows = [];

// List to store background colors and index 'Time' used to access indices
let Backgrounds = [];
let Time = 0;

function setup() {
  createCanvas(500, 500);
  rectMode(CENTER);
  Backgrounds.push(color(135, 205, 235));
  Backgrounds.push(color(50, 50, 50));
}

function draw() { // Draw shapes on the screen
  background(Backgrounds[Time]);

  // Draw sun or moon depending on the chosen time
  if (Time === 0) {
    fill(255, 255, 0);
  } else {
    fill(255, 255, 255);
  }
  ellipse(500, 0, 100, 100);

  fill(200);
  rect(mouseX, 500 - (50 * Floors.length + 25), 150, 50); // Light gray rectangle follows the mouse and
                                                          // sits on top of the previous floor
  for (let floor of Floors) {
    floor.display();
  }

  for (let door of Doors) {
    door.display();
  }

  for (let window of Windows) {
    window.display();
  }
}

function mousePressed() { // Draw floors using the mouse
  if (Floors.length === 0) { // Draw the first floor, which includes a door
    Floors.push(new Rectangle(mouseX, 500 - (50 * Floors.length + 25), 150, 50, color(100)));
    Doors.push(new Rectangle(mouseX, 500 - 25 / 2, 10, 25, color(150, 75, 0)));
  } else {
    let floor = Floors[Floors.length - 1]; // Ensure that subsequent floors are on top of previous floors
    if (floor.isInside(mouseX + 75, floor.y) || floor.isInside(mouseX - 75, floor.y)) {
      Floors.push(new Rectangle(mouseX, 500 - (50 * Floors.length + 25), 150, 50, color(100)));
    }
  }
}

function keyPressed() {
  if (key === 'r') { // Clear all floors, windows when 'r' is pressed
    Floors = [];
    Doors = [];
    Windows = [];
  }

  if (key === 'w' && Floors.length >= 1) { // Create windows over mouse cursor if 'w' is pressed
    for (let floor of Floors) { // Ensure windows can only be placed on floors
      if (
        floor.isInside(mouseX + 5, mouseY + 5) &&
        floor.isInside(mouseX - 5, mouseY - 5)
      ) {
        Windows.push(new Rectangle(mouseX, mouseY, 10, 10, color(0, 0, 255)));
      }
    }
  }

  if (key === 't') { // Change the background color
    if (Time < Backgrounds.length - 1) {
      Time += 1;
    } else {
      Time = 0;
    }
  }
}
