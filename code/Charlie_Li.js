let twilightTop, twilightBottom, auroraTop, auroraBottom;
let transitionSpeed = 0.01;
let transition = 0;
let twilightToAurora = true;

let snowflakeCount = 300;
let snowflakes = [];

function setup() {
  createCanvas(800, 600);
  twilightTop = color(120, 80, 180);
  twilightBottom = color(255, 120, 80);
  auroraTop = color(0, 100, 255);
  auroraBottom = color(0, 255, 150);

  for (let i = 0; i < snowflakeCount; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  // Transition between twilight and aurora
  if (twilightToAurora) {
    transition += transitionSpeed;
    if (transition > 1) {
      transition = 1;
      twilightToAurora = false;
    }
  } else {
    transition -= transitionSpeed;
    if (transition < 0) {
      transition = 0;
      twilightToAurora = true;
    }
  }

  // Calculate background colors
  let topColor = lerpColor(twilightTop, auroraTop, transition);
  let bottomColor = lerpColor(twilightBottom, auroraBottom, transition);

  // Draw gradient background
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1);
    stroke(lerpColor(topColor, bottomColor, inter));
    line(0, y, width, y);
  }

  // Draw saddle-shaped mountain with white top
  noStroke();
  fill(50, 30, 20);

  beginShape();
  vertex(0, height);
  for (let x = 0; x <= width; x++) {
    let y = height * 0.6 + 100 * sin(TWO_PI * (x / width)) * sin(TWO_PI * (x / width));

    // Interpolate the color based on height (white at the top)
    let mountainColor = lerpColor(color(255), color(50, 30, 20), map(y, height * 0.6, height * 0.6 - 100, 0, 1));
    fill(mountainColor);

    vertex(x, y);
  }
  vertex(width, height);
  endShape(CLOSE);

  // Draw snowflakes
  for (let snowflake of snowflakes) {
    snowflake.update();
    snowflake.display();
  }
}

class Snowflake {
  constructor() {
    this.x = random(width);
    this.y = random(-height, 0);
    this.speed = random(1, 3);
    this.size = random(2, 6);
  }

  update() {
    this.y += this.speed;

    if (this.y > height) {
      this.y = random(-height, 0);
      this.x = random(width);
    }
  }

  display() {
    noStroke();
    fill(255, 255, 255, 200);
    ellipse(this.x, this.y, this.size, this.size);
  }
}
