// Sets up the window and space background
function setup() {
  createCanvas(1450, 800);
  background(0);
  strokeWeight(5);

  // Draw stars randomly in the background
  for (let i = 0; i < 70; i++) {
    let x = random(0, width);
    let y = random(0, height);
    let size = random(1, 2);
    noStroke();
    fill(255);
    circle(x, y, size);
  }
}

// Local variables needed for loops
let y = 0;
let i = 0;

// Drawing the lines and letting them oscillate between colors
function draw() {
  frameRate(120);

  // Draw a vertical line that follows the mouse position
  stroke(0, 100, y); // Set the stroke color based on y value
  line(mouseX, mouseY - 150, mouseX, mouseY + 150);

  // Adjust the y value for color oscillation
  if (y < 254) {
    y += 1;
    i += 1;
    if (i >= 250) {
      y -= 2;
      if (y < 0) {
        i = 0;
      }
    }
  }
}
