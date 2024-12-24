let numStars = 800; // Number of stars

// Arrays for star attributes
let starX = new Array(numStars);
let starY = new Array(numStars);
let starSpeed = new Array(numStars);
let starSize = new Array(numStars);
let R = new Array(numStars);
let G = new Array(numStars);
let B = new Array(numStars);

let angle = 0; // Initial rotation of the hourglass
let rotationSpeed = 0; // Initial speed of hourglass rotation

function setup() {
  createCanvas(800, 800);

  // Initialize star positions, speeds, and colors
  for (let i = 0; i < numStars; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
    starSpeed[i] = random(1, 10); // Initial star speed
    starSize[i] = random(2, 5); // Randomize size of stars

    // Randomize the color components for each star
    R[i] = random(255);
    G[i] = random(255);
    B[i] = random(255);
  }
}

function draw() {
  background(0); // Black background for space effect

  // Map the X location of the mouse to control both the speed of stars and the rotation of the hourglass
  rotationSpeed = map(mouseX, 0, width, -0.08, 0.08); // Negative for reverse rotation
  let speedFactor = map(mouseX, 0, width, -3, 3); // Speed of stars based on mouseX

  // Update and draw stars
  for (let i = 0; i < numStars; i++) {
    // Adjust the star's speed based on the cursor position (mouseX)
    starX[i] += starSpeed[i] * speedFactor;
    starY[i] += starSpeed[i] * speedFactor;

    // Wrap stars around the screen and randomize their colors
    if (starX[i] > width) starX[i] = 0;
    if (starX[i] < 0) starX[i] = width;
    if (starY[i] > height) starY[i] = 0;
    if (starY[i] < 0) starY[i] = height;

    // Randomize star colors when they wrap
    if (starX[i] === 0 || starX[i] === width || starY[i] === 0 || starY[i] === height) {
      R[i] = random(255);
      G[i] = random(255);
      B[i] = random(255);
    }

    // Draw the star
    stroke(R[i], G[i], B[i]);
    fill(R[i], G[i], B[i]);
    ellipse(starX[i], starY[i], starSize[i], starSize[i]);
  }

  // Coordinates for the hourglass triangles
  let topTriangle = [
    { x: 400, y: 400 },
    { x: 300, y: 600 },
    { x: 500, y: 600 },
  ];

  let bottomTriangle = [
    { x: 400, y: 400 },
    { x: 300, y: 200 },
    { x: 500, y: 200 },
  ];

  // Rotate the canvas around the center
  push();
  translate(400, 400); // Center of rotation
  rotate(angle);
  translate(-400, -400);

  // Draw the top triangle (upper part of the hourglass)
  fill(127, 107, 0, 150); // Faint gold color for the top triangle
  stroke(255); // White outline
  triangle(
    topTriangle[0].x,
    topTriangle[0].y,
    topTriangle[1].x,
    topTriangle[1].y,
    topTriangle[2].x,
    topTriangle[2].y
  );

  // Draw the bottom triangle (lower part of the hourglass)
  fill(40, 40, 40, 150); // Gray color for the bottom triangle
  triangle(
    bottomTriangle[0].x,
    bottomTriangle[0].y,
    bottomTriangle[1].x,
    bottomTriangle[1].y,
    bottomTriangle[2].x,
    bottomTriangle[2].y
  );

  pop();

  // Increment the rotation angle based on mouseX position
  angle += rotationSpeed;
}
