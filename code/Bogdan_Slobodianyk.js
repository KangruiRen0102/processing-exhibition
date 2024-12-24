let angleX = 0;
let angleY = 0;
let floorSize = 80000; // Initial floor size

let bgColours = [
  [100, 120, 230],
  [200, 21, 23],
  [134, 0, 0],
  [255, 0, 73],
  [200, 50, 50]
];
let currentColourIndex = 0;
let isSpacePressed = false;
let lastColorChangeTime = 0;
let changeInterval = 200; // Color change interval

function setup() {
  createCanvas(1000, 1000, WEBGL); // Create a 3D canvas
}

function draw() {
  background(...bgColours[currentColourIndex]); // Set background color

  if (isSpacePressed && millis() - lastColorChangeTime > changeInterval) {
    currentColourIndex = (currentColourIndex + 1) % bgColours.length; // Cycle through colors
    lastColorChangeTime = millis();
  }

  lights();

  // Update rotation angles based on mouse movement
  angleX = map(mouseY, 0, height, -PI, PI); // Mouse movement to rotate around X-axis
  angleY = map(mouseX, 0, width, -PI, PI); // Mouse movement to rotate around Y-axis

  // Floor camera collision restriction
  angleX = constrain(angleX, -1, -0.1);

  // Apply rotation
  rotateX(angleX);
  rotateY(angleY);

  // Draw the floor
  push();
  rotateX(HALF_PI);
  fill(0, 180, 0);
  noStroke();
  rectMode(CENTER);
  plane(floorSize, floorSize);
  pop();

  // Create geometry for buildings
  push();
  translate(2000, -500, 2000);
  fill(220, 220, 220);
  stroke(0);
  box(300, 1000, 300);

  translate(100, 100, -600);
  box(300, 800, 900);

  translate(-700, 0, 700);
  box(900, 800, 300);
  pop();

  // Create geometry for roads
  push();
  translate(350, 400, -350);
  fill(100, 100, 100);
  noStroke();
  box(1900, 5, 2900);

  translate(-1150, 0, 0);
  box(400, 5, 80000);

  translate(-220, 0, 0);
  fill(200, 200, 200);
  box(100, 10, 80000);

  translate(440, 0, 20000);
  box(100, 10, 40000);

  translate(0, 0, -41000);
  box(100, 10, 40000);

  translate(-900, 0, 19200);
  fill(194, 178, 128);
  box(1000, 5, 1000);
  pop();

  // Create geometry for swingset
  push();
  strokeWeight(3);

  translate(-100, -100, 200);
  rotateZ(PI / 10);
  fill(160, 160, 250);
  box(20, 400, 20);
  translate(0, 0, -400);
  box(20, 400, 20);

  translate(130, -40, 0);
  rotateZ(-2 * PI / 10);
  box(20, 400, 20);
  translate(0, 0, 400);
  box(20, 400, 20);

  rotateZ(PI / 10);
  rotateY(PI / 2);
  rotateZ(PI / 2);
  translate(-180, -200, -70);
  box(20, 400, 20);

  translate(0, -50, 0);
  rotateZ(PI / 5.5);
  strokeWeight(8);
  line(150, -100, 0, 0);

  translate(60, 100, 0);
  line(150, -100, 0, 0);

  fill(160, 93, 0);
  strokeWeight(3);
  rotateZ(-PI / 5.5);
  translate(180, -60, 0);
  box(10, 120, 50);
  pop();
}

function keyPressed() {
  if (key === ' ') {
    isSpacePressed = true; // Spacebar pressed
  }
}

function keyReleased() {
  if (key === ' ') {
    isSpacePressed = false; // Spacebar released
  }
}
