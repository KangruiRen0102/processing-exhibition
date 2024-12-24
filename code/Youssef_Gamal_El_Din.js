// Processing sketch for "Discovery, Infinity, and Flow"
// Represents discovery through dynamic shapes, infinity with looping motion, and flow with seamless transitions.

// Global variables
let numCircles = 50; // Number of circles
let angle = 0; // Angle for rotation
let palette = ['#1E90FF', '#00FF7F', '#FF4500', '#FFD700']; // Colors for flow

function setup() {
  createCanvas(800, 800);
  noStroke();
  frameRate(30);
}

function draw() {
  background(0);

  // Draw flowing background
  for (let i = 0; i < height; i++) {
    let inter = map(i, 0, height, 0, 1);
    let c = lerpColor(color(palette[0]), color(palette[1]), inter);
    stroke(c);
    line(0, i, width, i);
  }

  // Draw rotating infinite loops
  translate(width / 2, height / 2);
  for (let i = 0; i < numCircles; i++) {
    let radius = map(i, 0, numCircles, 50, 300);
    let x = radius * cos(angle + i * TWO_PI / numCircles);
    let y = radius * sin(angle + i * TWO_PI / numCircles);

    fill(color(palette[i % palette.length]));
    ellipse(x, y, 20, 20);
  }

  // Dynamic element for discovery
  let discoveryX = width / 2 + 200 * cos(angle * 2);
  let discoveryY = height / 2 + 200 * sin(angle * 2);
  fill(color(palette[2]));
  ellipse(discoveryX - width / 2, discoveryY - height / 2, 50, 50);

  angle += 0.02;
}
