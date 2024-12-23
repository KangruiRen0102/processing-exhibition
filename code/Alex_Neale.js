let isSnow = false;  // Track whether the ground is snow or grass
let isCowClicked = false; // Track whether the cow has been clicked (changed to black cow with white spots)

// these are all the cows attributes
let cowX = 300, cowY = 250; // start spot for the cow 
let cowSize = 50; // size of the cow
let hornLength = 20; // Length of the horns
// where my clouds will start off
let cloud1X = 100;
let cloud2X = 450;

function setup() {
  createCanvas(600, 400); // size of drawing 
  noStroke(); // No outline 
}

function draw() {
  background(135, 206, 235); 

  // draw the sun
  fill(255, 223, 0); // Yellow color
  ellipse(500, 80, 100, 100); // puts the sun in the top right

  // draw the clouds
  drawCloud(cloud1X, 100);
  drawCloud(cloud2X, 120);
  
  if (cloud1X > width) {
    cloud1X = -100;  // reset the first cloud to start from the left
  }
  if (cloud2X > width) {
    cloud2X = -100;  // reset the second cloud to start from the left
  }
  
  cloud1X += 1;  // moves first cloud to the right
  cloud2X += 1;  // moves second cloud to the right
  
  // drawing the ground
  if (isSnow) {
    fill(255); // white
  } else {
    fill(34, 139, 34); //green
  }
  rect(0, 300, width, 100); // ground (grass or snow)

  // cow
  if (isCowClicked) {
    drawWhiteCow(cowX, cowY, cowSize); // bigger cow
  } else {
    drawBrownCow(cowX, cowY, cowSize); // Smaller cow
  }
}

// little cow
function drawBrownCow(x, y, size) {
  fill(139, 69, 19); 
  ellipse(x, y, size, size); // Main body 
  fill(255); 
  ellipse(x, y - size / 2, size / 2, size / 2); // Head
  fill(0); 
  ellipse(x - 10, y - size / 2, 10, 10); // left eye
  ellipse(x + 10, y - size / 2, 10, 10); // right eye
  
  // horns for smaller cow
  fill(255); 
  ellipse(x - 15, y - size / 2 - 10, 15, 5); // Left ear
  ellipse(x + 15, y - size / 2 - 10, 15, 5); // Right ear
  
  // legs
  fill(139, 69, 19); 
  rect(x - 10, y + 20, size / 8, size / 2); // Left leg
  rect(x + 8, y + 20, size / 8, size / 2); // Right leg

  // adding hooves
  fill(0); 
  rect(x - 10, y + 45, size / 8, size / 8); // Bottom of the left leg
  rect(x + 8, y + 45, size / 8, size / 8); // Bottom of the right leg
}

// drawing white cow now 
function drawWhiteCow(x, y, size) {
  fill(255); 
 
  let bodyWidth = size;  
  let bodyHeight = size * 1.05; // Slightly increase height for a more natural shape
  ellipse(x, y, bodyWidth, bodyHeight); // Main oval body of the cow

  fill(255); 
  ellipse(x, y - bodyHeight / 2, size / 2, size / 2); // Head
  
  fill(255, 105, 180); // Pink color for the mouth
  ellipse(x, y - bodyHeight / 3, 20, 15); // Mouth 
  
  fill(0); 
  ellipse(x - 3, y - bodyHeight / 2.8, 1.5, 3); // Nostril
  ellipse(x + 3, y - bodyHeight / 2.8, 1.5, 3); // Nostril

  fill(0); 
  ellipse(x - 10, y - bodyHeight / 2, 10, 10); // Left eye
  ellipse(x + 10, y - bodyHeight / 2, 10, 10); // Right eye

  // ears
  push();
  translate(x - 25, y - bodyHeight / 2 - 5);
  rotate(-PI / 6); 
  ellipse(0, 0, 20, 5);
  pop();

  push(); 
  translate(x + 25, y - bodyHeight / 2 - 5); 
  rotate(PI / 6); 
  ellipse(0, 0, 20, 5); 
  pop();
 
  // horns 
  fill(61, 48, 0);
  push(); 
  translate(x - 25, y - bodyHeight / 2 - 10);
  rotate(PI / 4); 
  ellipse(0, -15, -10, 5); 
  pop();

  push();
  translate(x + 25, y - bodyHeight / 2 - 10);
  rotate(-PI / 4); 
  ellipse(0, -15, 10, 5); 
  pop();
 
  // legs
  let legHeight = size * 0.4; // Height of leg
  let legWidth = size * 0.1; // Width 
  let legSpacing = size * 0.25; // Space between the legs
  let legYOffset = size / 2.5; 
  rect(x - legSpacing - legWidth / 2, y + legYOffset, legWidth, legHeight); // Left middle leg 
  rect(x + legSpacing - legWidth / 2, y + legYOffset, legWidth, legHeight); // Right middle leg 

  // Adds spots to the cow's body
  fill(0); 
  ellipse(x - 20, y + 10, 20, 20); // Spot 1
  ellipse(x + 20, y + 20, 20, 20); 
  ellipse(x + 22, y - 15, 20, 20); 
  ellipse(x - 10, y + 10, 20, 20); 

  // hooves
  fill(139, 69, 19); 
  let squareSize = legWidth; // Hoove size matches the leg width
  rect(x - legSpacing - legWidth / 2, y + legYOffset + legHeight, squareSize, squareSize); // Left leg
  rect(x + legSpacing - legWidth / 2, y + legYOffset + legHeight, squareSize, squareSize); // Right leg 

  // Add two smaller legs 
  let smallerLegHeight = size * 0.3; 
  let smallerLegSpacing = size * 0.1; 
  rect(x - smallerLegSpacing - legWidth / 2, y + legYOffset, legWidth, smallerLegHeight); // Left back leg
  rect(x + smallerLegSpacing - legWidth / 2, y + legYOffset, legWidth, smallerLegHeight); // Right back leg

  // Hooves for back legs
  rect(x - smallerLegSpacing - legWidth / 2, y + legYOffset + smallerLegHeight, squareSize, squareSize); // Left 
  rect(x + smallerLegSpacing - legWidth / 2, y + legYOffset + smallerLegHeight, squareSize, squareSize); // Right 
}

function drawCloud(x, y) {
  fill(255); 
  ellipse(x, y, 60, 60); // Cloud body
  ellipse(x + 30, y - 20, 60, 60); // Extra part of the cloud
  ellipse(x - 30, y - 20, 60, 60); // Extra part of the cloud
}

function mousePressed() {
  // Toggle between snow and grass on the ground when clicked anywhere on the screen
  isSnow = !isSnow;
  
  let distance = dist(mouseX, mouseY, cowX, cowY);
  
  if (distance < cowSize / 2) {
    // When the cow is clicked, change to bigger cow 
    isCowClicked = true;
    cowSize = 80; // Increase the size of the cow
  }
}
