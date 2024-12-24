// Global variables
let age = 0; // Age of the tree
let weatherStage = 0; // 0: Lightning/rain, 1: Calm sunny, 2: Drought
let transitionProgress = 0; // Smooth transition between weather stages
let weatherCycleCount = 0; // Number of completed weather cycles
let isGrowing = true; // Whether the tree is still growing

function setup() {
  createCanvas(800, 600); // Canvas size
  frameRate(60);
}

function draw() {
  if (weatherCycleCount >= 3) {
    // End simulation after 3 weather cycles
    background(135, 206, 235); // Bright blue sky
    drawGrass(); // Final grass patch
    drawTree(width / 2, height, 1000); // Fully grown tree

    // Display thank-you message
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Thank You for Watching", width / 2, height / 2 - 50);

    noLoop(); // Stop the program
    return;
  }

  background(0); // Clear frame

  // Draw grass
  drawGrass();

  // Simulate weather
  drawWeather(weatherStage, transitionProgress);

  // Draw tree if growing
  if (isGrowing) {
    drawTree(width / 2, height, age);
  }

  // Increment growth and handle weather transitions
  if (frameCount % 4 === 0 && isGrowing) {
    age += 1;
  }
  transitionProgress += 0.005;
  if (transitionProgress > 1) {
    transitionProgress = 0;
    weatherStage = (weatherStage + 1) % 3; // Cycle through weather stages
    if (weatherStage === 0) {
      weatherCycleCount++;
    }
  }

  // Stop tree growth after maturity
  if (age >= 1000) {
    isGrowing = false;
  }
}

function drawWeather(stage, progress) {
  if (stage === 0) {
    drawLightning(progress);
    drawRain();
  } else if (stage === 1) {
    drawSunnySky(progress);
  } else if (stage === 2) {
    drawDroughtSky(progress);
  }
}

function drawGrass() {
  fill(34, 139, 34);
  noStroke();
  rect(0, height - 50, width, 50); // Grass patch

  stroke(0, 100, 0);
  for (let i = 0; i < width; i += 10) {
    let bladeHeight = random(20, 40);
    line(i, height - 50, i, height - 50 - bladeHeight);
  }
}

function drawLightning(progress) {
  let bgColor = lerp(30, 100, progress);
  background(bgColor);

  if (random(1) < 0.1) {
    stroke(255, 255, 255, random(100, 255));
    strokeWeight(3);
    let startX = random(width);
    let startY = 0;
    for (let i = 0; i < 5; i++) {
      let endX = startX + random(-30, 30);
      let endY = startY + random(30, 50);
      line(startX, startY, endX, endY);
      startX = endX;
      startY = endY;
    }
  }
}

function drawRain() {
  stroke(173, 216, 230, 150);
  strokeWeight(2);
  for (let i = 0; i < 200; i++) {
    let x = random(width);
    let y = random(height);
    line(x, y, x, y + 10);
  }
}

function drawSunnySky(progress) {
  for (let y = 0; y < height; y++) {
    let colorLerp = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(135, 206, 235), color(255, 255, 255), colorLerp));
    line(0, y, width, y);
  }

  let sunSize = lerp(50, 80, progress);
  noStroke();
  fill(255, 204, 0);
  ellipse(width - 100, 100, sunSize, sunSize);

  fill(255, 255, 255, 200);
  for (let i = 0; i < 3; i++) {
    let cloudX = lerp(-200, width, progress) + i * 150;
    ellipse(cloudX, 150, 100, 50);
    ellipse(cloudX + 50, 140, 70, 40);
    ellipse(cloudX - 50, 140, 70, 40);
  }
}

function drawDroughtSky(progress) {
  for (let y = 0; y < height; y++) {
    let colorLerp = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(255, 204, 0), color(255, 255, 102), colorLerp));
    line(0, y, width, y);
  }

  let sunSize = lerp(80, 100, progress);
  noStroke();
  fill(255, 255, 102);
  ellipse(width - 100, 100, sunSize, sunSize);
}

function drawTree(x, y, age) {
  let trunkHeight = map(age, 0, 1000, 20, 300);
  let trunkWidth = map(age, 0, 1000, 5, 80);

  fill(139, 69, 19);
  noStroke();
  rect(x - trunkWidth / 2, y - trunkHeight, trunkWidth, trunkHeight);

  let leafSize = map(age, 0, 1000, 20, 250);
  let spread = map(age, 0, 1050, 30, 150);
  let branchStartY = y - trunkHeight;

  stroke(139, 69, 19);
  strokeWeight(map(age, 0, 1000, 1, 25));

  line(x, branchStartY, x - spread, branchStartY - leafSize / 2);
  line(x, branchStartY, x + spread, branchStartY - leafSize / 2);

  noStroke();
  fill(34, 139, 34, 200);
  ellipse(x, branchStartY - leafSize / 2, leafSize, leafSize);
  ellipse(x - spread, branchStartY - leafSize / 2, leafSize / 1.5, leafSize / 1.5);
  ellipse(x + spread, branchStartY - leafSize / 2, leafSize / 1.5, leafSize / 1.5);
}
