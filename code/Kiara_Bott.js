let theta; // Declare theta as a global variable

function setup() {
  createCanvas(windowWidth, windowHeight); // Create a full-screen canvas
}

function draw() {
  background(255, 204, 51); // Set the background to a yellow-orange color
  frameRate(30);
  stroke(0); // Set the stroke color to black
  circle(width / 2, height / 2, 200); // Create the white circle in the middle of the screen

  // Calculate the angle based on the mouse position
  let a = (mouseX / width) * 90;
  theta = radians(a); // Convert the angle to radians

  // Start the tree from the bottom center of the screen
  translate(width / 2, height);
  line(0, 0, 0, -120);
  translate(0, -120);
  branch(120); // Start drawing the tree branches
}

function branch(h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;

  if (h > 2) {
    push(); // Save the current transformation matrix
    rotate(theta); // Rotate to the right
    line(0, 0, 0, -h); // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h); // Recursively draw the next branch
    pop(); // Restore the previous transformation matrix

    push(); // Save the current transformation matrix
    rotate(-theta); // Rotate to the left
    line(0, 0, 0, -h); // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h); // Recursively draw the next branch
    pop(); // Restore the previous transformation matrix
  }
}
