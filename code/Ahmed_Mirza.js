let c1, c2;

function setup() {
  createCanvas(800, 600);
  noStroke();

  // Frozen Lake
  fill(200, 220, 255);
  rect(0, height * 0.25, width, height * 0.75);

  // Creating colors for the sky
  c1 = color(173, 216, 230);
  c2 = color(240, 255, 255);
}

function draw() {
  // Sky Gradient
  setGradient(0, 0, width, height * 0.25, c1, c2);

  // Ice Cracks
  stroke(170, 190, 210);
  strokeWeight(2);

  for (let i = 0; i < 12; i++) {
    let startX = random(width); // horizontal start point of ice crack
    let startY = random(height * 0.25, height); // vertical start point of ice crack
    let endX = startX + random(-75, 75); // horizontal end point of ice crack
    let endY = startY + random(-40, 40); // vertical end point of ice crack
    line(startX, startY, endX, endY);
  }

  noLoop(); // prevents infinite number of ice cracks generating
}

function setGradient(x, y, w, h, c1, c2) {
  noFill();
  for (let i = y; i <= y + h; i++) {
    let inter = map(i, y, y + h, 0, 1); // re-maps i to go from 0 to 1 (makes it a fraction)
    let c = lerpColor(c1, c2, inter); // interpolate other colors between these 2 colors
    stroke(c); // sets stroke color to new interpolated color
    line(x, i, x + w, i); // draws a line, then begins the loop again
  }
}
