let bridgeAngle = 0; // Angle of the drawbridge
let numSegments = 100; // Number of segments for the river
let waveSpeed = 0.01; // Speed of turbulence
let boatX = -100; // Boat's initial position (offscreen)
let boatSpeed = 2; // Boat speed

function setup() {
  createCanvas(800, 600);
  noStroke();
}

function draw() {
  background(135, 206, 250); // Sky blue
  drawGround();
  drawRiver();
  drawBridgeSupports();
  drawDrawbridge();
  drawBoat();
}

function drawGround() {
  fill(34, 139, 34); // Grass green
  rect(0, height / 2 + 100, width, height / 2 - 100);
}

function drawRiver() {
  fill(0, 190, 250); // Water color

  beginShape();
  let segmentWidth = width / numSegments;

  for (let i = 0; i < numSegments; i++) {
    let x = i * segmentWidth;
    let noiseVal = noise(i * 0.1, frameCount * waveSpeed); // Turbulence with Perlin noise
    let y = height / 2 + 150 + sin(frameCount * 0.02 + i * 0.3) * 10 + noiseVal * 20; // Sine wave + turbulence
    vertex(x, y);
  }

  vertex(width, height); // Bottom-right corner
  vertex(0, height);     // Bottom-left corner
  endShape(CLOSE);
}

function drawDrawbridge() {
  bridgeAngle = map(mouseY, 0, height, -PI / 3, 0); // Bridge angle changes with mouseY

  // Left bridge half
  push();
  translate(width / 4, height / 2 + 100);
  rotate(bridgeAngle);
  fill(50);
  rect(0, -10, width / 4, 20);
  pop();

  // Right bridge half
  push();
  translate(3 * width / 4, height / 2 + 100);
  rotate(-bridgeAngle);
  fill(50);
  rect(-width / 4, -10, width / 4, 20);
  pop();
}

function drawBridgeSupports() {
  fill(105, 105, 105); // Gray
  rect(width / 4 - 20, height / 2 + 100, 40, 50); // Left support
  rect(3 * width / 4 - 20, height / 2 + 100, 40, 50); // Right support
}

function drawBoat() {
  if (bridgeAngle <= -PI / 6 && boatX >= width / 4 - 80 && boatX <= 3 * width / 4 + 20) {
    boatX += boatSpeed; // Move boat forward if under the bridge
  } else if (boatX < width) {
    boatX += boatSpeed; // Move the boat forward if not under the bridge
  }

  if (boatX > width) {
    boatX = -100; // Reset to the left side
  }

  // Drawing the boat
  fill(139, 69, 19); // Brown color
  beginShape();
  vertex(boatX, height / 2 + 150);
  vertex(boatX + 100, height / 2 + 150);
  vertex(boatX + 80, height / 2 + 170);
  vertex(boatX + 20, height / 2 + 170);
  endShape(CLOSE);

  // Boat sail
  fill(255, 255, 255); // White sail
  triangle(boatX + 30, height / 2 + 150, boatX + 30, height / 2 + 100, boatX + 80, height / 2 + 150);
}
