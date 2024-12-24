let auroraAlpha = 0;  // Alpha transparency for aurora
let chaosFactor = 1.0;  // Factor that controls the intensity of chaos effect
let auroraSpeed = 0.05; // Speed of aurora flickering effect
let auroraSize = 200; // Base size of the aurora
let auroraColors = [0, 0, 0];  // RGB color values for aurora colors
let lastChangeTime = 0;  // Tracks the last time chaos intensity changed
let auroraEffectType = 0; // Type of aurora effect (0: standard, 1: pulse)
let chaosEffectType = 0; // Type of chaos effect (0: standard, 1: wave)

let instructionDuration = 5000; // Duration to show instructions (5 seconds)
let instructionStartTime = -1; // Time when instructions started to display

function setup() {
  createCanvas(800, 600);  // Set canvas size
  noStroke();  // Disable stroke for shapes
}

function draw() {
  // Twilight sky gradient representing a calm yet intense atmosphere
  background(40, 60, 100);  // Set the background color to represent twilight

  // Generate the aurora effect with chaotic fluctuations
  generateAuroraEffect();  // Call to generate aurora based on current effect type

  // Display chaos effect (lines or waves)
  displayChaosEffect();  // Display either random lines or swirling waves to represent chaos

  // Draw aurora trails that flicker and move across the screen
  displayAuroraTrails();  // Render aurora trails to create a flowing, ethereal effect

  // Adjust chaos intensity over time or based on mouse position
  updateChaos();  // Update the chaos effect based on the time and mouse input

  // Display instructions for a few seconds
  if (instructionStartTime !== -1 && millis() - instructionStartTime < instructionDuration) {
    displayInstructions();  // Show on-screen instructions for user interaction
  }
}

// Function to generate the aurora effect with colors changing over time
function generateAuroraEffect() {
  // Map sine wave functions to create dynamic aurora color shifts
  auroraColors[0] = map(sin(frameCount * 0.01), -1, 1, 100, 255);  // Red color
  auroraColors[1] = map(sin(frameCount * 0.02), -1, 1, 100, 255);  // Green color
  auroraColors[2] = map(sin(frameCount * 0.03), -1, 1, 100, 255);  // Blue color

  fill(auroraColors[0], auroraColors[1], auroraColors[2], auroraAlpha);  // Set aurora color with alpha for transparency
  noStroke();  // Remove outlines for smooth filling

  if (auroraEffectType === 0) {
    ellipse(width / 2, height / 3, auroraSize, auroraSize / 2); 
  } else if (auroraEffectType === 1) {
    let pulseSize = sin(frameCount * auroraSpeed) * 50 + auroraSize;
    ellipse(width / 2, height / 3, pulseSize, pulseSize / 2);  // Draw pulsing aurora
  }

  auroraAlpha = map(sin(frameCount * 0.1), -1, 1, 50, 200);  // Adjust transparency to create flicker effect
}

// Function to display chaotic effects (random lines or wave-like patterns)
function displayChaosEffect() {
  let chaosTime = millis();  // Get the current time for creating time-based chaos

  if (chaosEffectType === 0) {
    for (let i = 0; i < 10; i++) {
      let chaosX = random(width);
      let chaosY = random(height);
      let chaosSize = random(20, 50);
      let chaosRotation = sin(chaosTime * 0.002) * random(PI);
      stroke(255, 255, 255, 150);
      strokeWeight(2);
      line(
        chaosX + chaosSize * cos(chaosRotation),
        chaosY + chaosSize * sin(chaosRotation),
        chaosX + chaosSize * cos(chaosRotation + PI),
        chaosY + chaosSize * sin(chaosRotation + PI)
      );
    }
  } else if (chaosEffectType === 1) {
    for (let i = 0; i < 10; i++) {
      let chaosX = width * 0.5 + sin(chaosTime * 0.01 + i) * chaosFactor;
      let chaosY = height * 0.5 + cos(chaosTime * 0.01 + i) * chaosFactor;
      let chaosSize = random(20, 40);
      ellipse(chaosX, chaosY, chaosSize, chaosSize);
    }
  }
}

// Function to display aurora trails that shift and fade over time
function displayAuroraTrails() {
  let trailLength = 30;  // Number of aurora trails to display
  for (let i = 0; i < trailLength; i++) {
    let trailX = width * 0.5 + random(-200, 200);
    let trailY = height / 3 + random(-50, 50);
    let trailAlpha = map(i, 0, trailLength, 50, 255);
    fill(auroraColors[0], auroraColors[1], auroraColors[2], trailAlpha);
    ellipse(trailX, trailY, random(20, 50), random(10, 40));
  }
}

// Function to update the chaos effect intensity
function updateChaos() {
  let currentTime = millis();
  if (currentTime - lastChangeTime > random(1000, 5000)) {
    chaosFactor = random(1, 5);
    lastChangeTime = currentTime;
  }
  chaosFactor = map(mouseX, 0, width, 1, 5);
}

// Function to display instructions on screen for a few seconds
function displayInstructions() {
  fill(255, 255, 255, 200);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Press 'R' to toggle aurora effects", width / 2, height / 2 - 50);
  text("Press 'C' to toggle chaos effects", width / 2, height / 2);
  text("Press '1', '2', or '3' to change aurora color", width / 2, height / 2 + 50);
  text("Click to reset chaos intensity", width / 2, height / 2 + 100);
}

// Function to handle key press events
function keyPressed() {
  if (key === 'r' || key === 'R') {
    auroraEffectType = (auroraEffectType + 1) % 2;
  } else if (key === 'c' || key === 'C') {
    chaosEffectType = (chaosEffectType + 1) % 2;
  } else if (key === '1') {
    auroraColors = [255, 0, 0];
  } else if (key === '2') {
    auroraColors = [0, 255, 0];
  } else if (key === '3') {
    auroraColors = [0, 0, 255];
  }
}

// Function to handle mouse press events
function mousePressed() {
  auroraSpeed = random(0.02, 0.1);
  chaosFactor = random(1, 10);
  if (instructionStartTime === -1) {
    instructionStartTime = millis();
  }
}
