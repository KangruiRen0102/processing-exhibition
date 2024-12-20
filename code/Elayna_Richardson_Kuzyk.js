let cont = 0;
let sky;
let colorSkyDark, colorSkyLight; // Colors for the sky 
let stars = [];

// Wave
let xspacing = 8;   // Spacing between horizontal locations
let w;              // Width of entire wave
let maxwaves = 4;   // Total number of waves

let theta = 0.0;
let amplitude = []; // Wave heights
let dx = [];        // Increment values for the wave. Incrementing X, to be calculated as a function of period and xspacing
let yvalues;        // Stores wave height values using an array

// Bubbles
let bubbles = [];
let selectedBubble = null;

function setup() {
  createCanvas(1400, 800); // Set the canvas size
  colorMode(HSB, 360, 100, 100); // Color mode

  colorSkyDark = color(261, 58, 9); // Dark sky color
  colorSkyLight = color(270, 72, 21); // Light sky color

  // Create sky gradient
  sky = createGraphics(width, height);
  for (let i = 0; i < height; i++) {
    let col = lerpColor(colorSkyDark, colorSkyLight, map(i, 0, height, 0, 1));
    sky.stroke(col);
    sky.line(0, i, width, i);
  }

  // Initialize stars
  for (let a = 0; a < 256; a++) {
    let x = random(width);
    let y = random(height);
    stars.push(createVector(x, y));
  }

  // Initialize wave
  frameRate(30);
  w = width + 16;

  for (let i = 0; i < maxwaves; i++) {
    amplitude[i] = random(10, 30); // Wave amplitude
    let period = random(100, 300); // How many pixels before the wave repeats (wave period)
    dx[i] = (TWO_PI / period) * xspacing;
  }

  yvalues = new Array(floor(w / xspacing));

  // Initialize bubbles
  for (let i = 0; i < 20; i++) {
    bubbles.push(new Bubble(random(width), random(height), random(30, 60))); // Sets size for each bubble
  }
}

function draw() {
  image(sky, 0, 0); // Display the sky
  background(0); // Background set to black

  // Draw wave
  calcWave();
  renderWave();

  let lineWidth = 3;
  strokeWeight(lineWidth); // Sets line width
  strokeCap(SQUARE); // Sets stroke shape as a square
  for (let i = 0; i < width / lineWidth; i++) {
    let y1 = sin(cont + i * 0.01 * noise(cont)) * noise(cont) * height / 6 + noise(i, millis() * 0.001) * height / 4;
    let y2 = height / 3 * 2 + sin(cont + i * (0.012 * noise(cont))) * (noise(cont) * height / 4) + noise(i, millis() * 0.001) * 20;
    let levels = (y2 - y1) / 20;
    let hue = map(sin((millis() + i) * 0.0001), -1, 1, 0, 130);
    for (let j = y1; j < y2; j += levels) {
      stroke(hue, map(j, y1, y2, 60, 40) + noise(i, millis() * 0.002) * 20, 80 + noise(i, millis() * 0.002) * 20, map(j, y1, y2, 0, 150));
      if (j < y2 - 10) {
        line(i * lineWidth, j, i * lineWidth, j + levels);
      } else {
        line(i * lineWidth, j, i * lineWidth, y2);
      }
    }
    let amp = 30;
    let y3 = y2 - amp * 1.5 * noise(i, millis() * 0.002);
    let y4 = y2 + amp * noise(i, (millis() + 2000) * 0.002);
    let localCont = amp / 3;
    let levels2 = (y4 - y3) / localCont;
    for (let j = y3; j < y4; j += levels2) {
      let alpha = sin(localCont * 0.35 + 2.4) * 255;
      localCont++;
      stroke(hue, map(j, y3, y4, 40, 0) + noise(i, millis() * 0.002) * 20, 80 + noise(i, millis() * 0.002) * 20, alpha);
      line(i * lineWidth, j, i * lineWidth, j + levels2);
    }
  }

  cont += 0.01;

  // Draw bubbles
  for (let bubble of bubbles) {
    bubble.display(); // Displays each bubble
  }
}

function mousePressed() {
  for (let bubble of bubbles) {
    bubble.handleMouseClick();
    if (bubble.isMouseOver()) {
      selectedBubble = bubble;
      break;
    }
  }
}

function mouseDragged() {
  if (selectedBubble !== null) {
    selectedBubble.x = mouseX;
    selectedBubble.y = mouseY;
  }
}

function mouseReleased() {
  selectedBubble = null;
}

function calcWave() {
  theta += 0.02; // Increment theta

  for (let i = 0; i < yvalues.length; i++) {
    yvalues[i] = 0;
  }

  for (let j = 0; j < maxwaves; j++) {
    let x = theta;
    for (let i = 0; i < yvalues.length; i++) {
      yvalues[i] += (j % 2 === 0 ? sin(x) : cos(x)) * amplitude[j];
      x += dx[j];
    }
  }
}

function renderWave() {
  noStroke();
  fill(255, 50); // Fill color
  ellipseMode(CENTER);
  for (let x = 0; x < yvalues.length; x++) {
    ellipse(x * xspacing, height / 2 + yvalues[x], 16, 16); // Creates ellipses throughout sine wave
  }
}

class Bubble {
  constructor(x, y, r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.baseColor = color(random(100, 200), random(100, 200), random(100, 200)); // Creates random colors
    this.hoverColor = color(random(200, 255), random(150, 255), random(150, 255)); // Creates random colors when mouse is hovered over bubble
    this.clickColor = color(random(255), random(255), random(255)); // Creates random colors when mouse clicks bubble
    this.clicked = false;
  }

  display() {
    if (this.clicked) {
      fill(this.clickColor); // Sets the fill color when clicked
    } else if (this.isMouseOver()) {
      fill(this.hoverColor); // Sets the fill color when hovered over
    } else {
      fill(this.baseColor); // Sets a base color
    }
    noStroke();
    ellipse(this.x, this.y, this.r * 2, this.r * 2); // Makes bubbles circular
  }

  isMouseOver() {
    return dist(mouseX, mouseY, this.x, this.y) < this.r;
  }

  handleMouseClick() {
    if (this.isMouseOver()) {
      this.clicked = !this.clicked; // Toggle clicked state
    }
  }
}
