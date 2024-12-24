let numPlanets = 5;
let planetRadii = [];
let planetAngles = [];
let planetSpeeds = [];

let numStars = 300;
let starX = [];
let starY = [];
let starSize = [];
let starSpeed = [];
let starLayer = [];

function setup() {
  createCanvas(800, 800);
  noFill();
  frameRate(30);

  // Initialize planets' radii, angles, and speeds
  for (let i = 0; i < numPlanets; i++) {
    planetRadii[i] = random(50, 300); // Random distances from the center
    planetAngles[i] = random(TWO_PI); // Random initial angles
    planetSpeeds[i] = random(0.002, 0.005); // Random orbital speeds
  }

  // Initialize stars
  for (let i = 0; i < numStars; i++) {
    starX[i] = random(-400, 400);
    starY[i] = random(-400, 400);
    starSize[i] = random(1, 3); // Random sizes for the stars
    starSpeed[i] = random(0.1, 0.5); // Random speed for parallax
    starLayer[i] = random(0.5, 2.5); // Layer depth for stars (near or far)
  }
}

function draw() {
  background(10, 10, 30);
  translate(width / 2, height / 2);

  let t = millis() / 6000.0;

  // Stars in the background for effect
  for (let i = 0; i < numStars; i++) {
    let x = starX[i] + starSpeed[i] * t * starLayer[i];
    let y = starY[i] + starSpeed[i] * t * starLayer[i];

    // Wrap stars around screen
    if (x > width) starX[i] = -width;
    if (x < -width) starX[i] = width;
    if (y > height) starY[i] = -height;
    if (y < -height) starY[i] = height;

    let size = starSize[i];
    stroke(255, 255, 255, map(starLayer[i], 0.5, 2.5, 200, 100)); // Fainter stars in background
    strokeWeight(size);
    point(x, y);
  }

  // Glowing line arcs
  for (let i = 0; i < 8; i++) { // Increase the number of arcs
    let angle = map(i, 0, 8, 0, TWO_PI) + t;
    let x1 = 300 * cos(angle);
    let y1 = 300 * sin(angle);
    stroke(255, 100 + 80 * sin(t * 2), 200, 180);
    strokeWeight(3 + sin(t));
    line(0, 0, x1, y1);
    noFill();
    stroke(255, 220, 220, 180);
    arc(0, 0, 320 + 30 * sin(t * 2), 320 + 30 * cos(t * 2), angle, angle + QUARTER_PI);
  }

  // Clock hour markers
  for (let i = 0; i < 12; i++) {
    let angle = map(i, 0, 12, 0, TWO_PI) - HALF_PI;
    let x1 = 300 * cos(angle);
    let y1 = 300 * sin(angle);
    let x2 = 330 * cos(angle);
    let y2 = 330 * sin(angle);
    stroke(180 + 50 * sin(t * 3), 255, 150, 200);
    strokeWeight(4);
    line(x1, y1, x2, y2);
  }

  // Clock hands
  let secondAngle = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  let minuteAngle = map(minute(), 0, 60, 0, TWO_PI) - HALF_PI;
  let hourAngle = map(hour() % 12, 0, 12, 0, TWO_PI) - HALF_PI;

  // Second hand
  stroke(255, 255, 255, 200);
  strokeWeight(3);
  line(0, 0, 200 * cos(secondAngle), 200 * sin(secondAngle));

  // Minute hand
  stroke(255, 255, 255, 220);
  strokeWeight(5);
  line(0, 0, 150 * cos(minuteAngle), 150 * sin(minuteAngle));

  // Hour hand
  stroke(255, 215, 0, 220);
  strokeWeight(7);
  line(0, 0, 100 * cos(hourAngle), 100 * sin(hourAngle));

  // Glowing central orb
  noStroke();
  fill(255, 200, 80, 180 + 60 * sin(t * 4));
  ellipse(0, 0, 40 + 15 * sin(t * 2), 40 + 15 * cos(t * 2));

  // Planets orbiting around the clock with glow
  for (let i = 0; i < numPlanets; i++) {
    planetAngles[i] += planetSpeeds[i];

    // Calculate the planet's current position
    let x = planetRadii[i] * cos(planetAngles[i]);
    let y = planetRadii[i] * sin(planetAngles[i]);

    // Makes planets seem smaller and dimmer as they get farther away
    let sizeFactor = map(planetRadii[i], 50, 400, 1.0, 0.2);
    let alpha = map(planetRadii[i], 50, 400, 255, 100);

    // Planet colors change depending on distance
    let planetColor;
    if (i == 0) {
      planetColor = color(255, 100, 100);
    } else if (i == 1) {
      planetColor = color(100, 200, 255);
    } else if (i == 2) {
      planetColor = color(200, 255, 100);
    } else if (i == 3) {
      planetColor = color(255, 255, 0);
    } else {
      planetColor = color(255, 150, 255);
    }

    // A glowing effect around planets
    noStroke();
    fill(planetColor, alpha - 50);
    ellipse(x, y, 40 * sizeFactor, 40 * sizeFactor);

    // Planets with a glow and size effect
    stroke(planetColor);
    fill(planetColor, alpha);
    ellipse(x, y, 30 * sizeFactor, 30 * sizeFactor);
  }

  // Gradually move the planets further out as time passes
  for (let i = 0; i < numPlanets; i++) {
    planetSpeeds[i] *= 1.0001; // Slowly increase speed for acceleration
    planetRadii[i] += 0.05; // Increase radius slowly to make planets move outward
    if (planetRadii[i] > 400) {
      planetRadii[i] = 50; // Reset radius if it gets too far
    }
  }
}
