let maxCircles = 300;  // The maximum number of circles that the code will add
let circleCount = 0;  // The number of circles drawn, starts at zero and will increase to 300

function setup() {
  createCanvas(600, 600);  // Creates a blank canvas for all the circles to go on
}

function draw() {
  if (circleCount < maxCircles) {
    let x = random(width);  // A random X position for the circle
    let y = random(height);  // A random Y position for the circle
    let d = random(30, 120);  // A random diameter for the circle

    fill(random(255), random(255), random(255));  // Random color to fill the circle
    noStroke();  // Optional: Remove stroke for cleaner circles
    circle(x, y, d);  // Draws a circle with (x, y) as the position and d as the diameter

    circleCount++;  // Increment the circle count by 1
  }
}
