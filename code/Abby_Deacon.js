function setup() {
  createCanvas(800, 600); // Set canvas size
  noStroke(); // Removes borders
}

function draw() {
  // Creating ocean for half of canvas
  fill(0, 50, 100); // Set colour to deep blue
  rect(0, height / 2, width, height / 2); // Draw a rectangle

  // Create an ombre of colours for half of canvas
  for (let y = 0; y < height / 2; y++) {
    let r = map(y, height / 2, 0, 255, 0); // Setting tones of colours and positions
    let g = map(y, height / 2, 0, 120, 50);
    let b = map(y, height / 2, 0, 100, 150);

    fill(r, g, b); // Setting colours for rows
    rect(0, y, width, 1); // Create small rectangle to mimic "ombre"
  }

  // Create stars
  if (frameCount % 1 === 0) { // How frequent the stars show depending on amount of frames
    let starX = int(random(width)); // Defining random width and height, but just above the horizon line
    let starY = int(random(height / 2));
    fill(255, 255, 255);
    ellipse(starX, starY, 3, 3); // Size of stars
  }

  // Creating boat
  drawBoat(350, height / 2 - 20); // Placing boat just below the horizon line
}

function drawBoat(x, y) {
  // Base of boat
  fill(0, 0, 0); // Black fill color
  quad(x, y, x + 25, y + 25, x + 75, y + 25, x + 100, y); // Mapping out the coordinates of hull

  // Drawing the sail
  fill(0, 0, 0); // Black fill color
  triangle(x + 35, y - 15, x + 70, y - 50, x + 70, y - 15); // Mapping out coordinates of sail

  // Drawing mast
  fill(0, 0, 0); // Black fill color
  rect(x + 70, y - 50, 10, 65); // Mapping out coordinates of mast
}
