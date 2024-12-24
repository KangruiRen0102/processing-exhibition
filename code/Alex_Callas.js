let boatX; // Horizontal position of the boat
let boatY; // Vertical position of the boat

function setup() {
  createCanvas(800, 600);
  boatX = width / 2 + 100; // Initial horizontal position of the boat
  boatY = height / 2 + 70; // Fixed vertical position of the boat
}

function draw() {
  background(0); // Clear the previous frame
  drawSky();
  drawSun();
  drawOcean();
  drawBoat();
  drawHorizon();
}

function drawSky() {
  for (let y = 0; y < height / 2; y++) {
    let inter = map(y, 0, height / 2, 0, 1);
    let c = lerpColor(color(255, 94, 77), color(32, 58, 103), inter);
    stroke(c);
    line(0, y, width, y);
  }
}

function drawSun() {
  let sunX = width / 2;
  let sunY = height / 2 - 50;
  let sunRadius = 60;

  // Draw the sun with a glowing effect
  for (let r = sunRadius; r > 0; r--) {
    let alpha = map(r, 0, sunRadius, 255, 50);
    fill(255, 204, 102, alpha);
    noStroke();
    ellipse(sunX, sunY, r * 2, r * 2);
  }
}

function drawOcean() {
  for (let y = height / 2; y < height; y++) {
    let inter = map(y, height / 2, height, 0, 1);
    let c = lerpColor(color(32, 58, 103), color(0, 30, 60), inter);
    stroke(c);
    line(0, y, width, y);
  }
  drawWaves();
}

function drawWaves() {
  noFill();
  stroke(255, 255, 255, 50);
  for (let i = 0; i < 10; i++) {
    let offset = random(PI);
    beginShape();
    for (let x = 0; x <= width; x += 10) {
      let y = height / 2 + 50 + sin(x * 0.05 + offset) * 10;
      vertex(x, y + i * 10);
    }
    endShape();
  }
}

function drawBoat() {
  // Draw the hull
  fill(139, 69, 19); // Brown color for the hull
  noStroke();
  beginShape();
  vertex(boatX - 40, boatY);
  vertex(boatX + 40, boatY);
  vertex(boatX + 30, boatY + 20);
  vertex(boatX - 30, boatY + 20);
  endShape(CLOSE);

  // Draw the sail
  fill(255, 255, 255); // White color for the sail
  triangle(boatX, boatY - 60, boatX, boatY, boatX - 30, boatY - 30);
  triangle(boatX, boatY - 60, boatX, boatY, boatX + 30, boatY - 30);
}

function drawHorizon() {
  stroke(255, 200);
  strokeWeight(2);
  line(0, height / 2, width, height / 2);
}

function keyPressed() {
  if (key === 'a' || key === 'A') {
    boatX -= 10; // Move left
  } else if (key === 'd' || key === 'D') {
    boatX += 10; // Move right
  }
}
