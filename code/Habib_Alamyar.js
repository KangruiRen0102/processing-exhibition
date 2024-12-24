let stars = []; // Precomputed star positions
let auroraOffset = 0; // Offset for aurora animation

function setup() {
  createCanvas(800, 800); // Canvas size
  // Precompute star positions
  for (let i = 0; i < 100; i++) {
    stars.push(createVector(random(width), random(height / 2)));
  }
}

function draw() {
  background(10, 15, 30); // Twilight background

  // Draw Aurora
  for (let i = 0; i < 15; i++) { // Increased thickness
    noFill();
    strokeWeight(10);
    // Three-color gradient: green to blue to purple
    let col1 = lerpColor(color(0, 255, 0, 150), color(0, 128, 255, 150), i / 15.0);
    let col2 = lerpColor(color(0, 128, 255, 150), color(128, 0, 255, 150), i / 15.0);
    stroke(lerpColor(col1, col2, i / 15.0));
    beginShape();
    for (let x = 0; x < width; x += 10) {
      let y = 200 + 150 * noise(i * 10, x * 0.01 + auroraOffset);
      vertex(x, y);
    }
    endShape();
  }
  auroraOffset += 0.005;

  // Draw Moon
  fill(200);
  noStroke();
  ellipse(650, 150, 80, 80);
  fill(10, 15, 30);
  ellipse(660, 140, 60, 60);

  // Draw Stars
  for (let star of stars) {
    let starSize = random(2, 5);
    fill(255, 255, 200, random(150, 255));
    noStroke();
    ellipse(star.x, star.y, starSize, starSize);
  }

  // Draw Skyline Silhouette
  drawSkyline();

  // Draw Ground Elements
  drawGround();
}

function drawGround() {
  // Draw Grass
  fill(50, 200, 50);
  rect(0, height - 150, width, 150);

  // Add static snow patches
  addSnowPatches();

  // Draw Street
  fill(60);
  rect(0, height - 180, width, 30);

  // Draw Street Lines
  stroke(255, 255, 0);
  strokeWeight(2);
  for (let i = 0; i < width; i += 40) {
    line(i, height - 165, i + 20, height - 165);
  }

  // Draw Sidewalk
  fill(200);
  rect(0, height - 200, width, 20);

  // Draw Faculty of Engineering Arch
  let archX = width / 3 - 60;
  let archY = height - 300;

  fill(20);
  rect(archX, archY, 20, 100); // Left pillar
  rect(archX + 100, archY, 20, 100); // Right pillar
  rect(archX, archY - 20, 120, 20); // Top beam

  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER);
  text("Faculty of Engineering", archX + 60, archY - 10);

  // Add Yellow I-Beam Tree
  fill(255, 200, 0);
  rect(550, height - 300, 20, 100);
  rect(520, height - 250, 80, 20);
  rect(535, height - 270, 50, 20);
  rect(545, height - 290, 30, 20);
}

function addSnowPatches() {
  fill(255);
  noStroke();

  // Create snow patches
  ellipse(150, height - 50, 70, 50);
  ellipse(300, height - 100, 85, 85);
  ellipse(500, height - 80, 100, 75);
  ellipse(650, height - 60, 95, 95);
  ellipse(700, height - 20, 110, 85);
  ellipse(100, height - 60, 80, 80);
  ellipse(400, height - 100, 95, 50);
  ellipse(550, height - 125, 80, 100);
}

function drawSkyline() {
  fill(30, 30, 60);
  noStroke();
  let numBuildings = 3;
  let buildingWidth = width / numBuildings;

  // Center building
  let buildingHeightCenter = 300;
  let buildingWidthCenter = buildingWidth * 1.5;
  rect(buildingWidth - buildingWidth / 4, height - 150 - buildingHeightCenter, buildingWidthCenter, buildingHeightCenter);

  // Left building
  let buildingHeightLeft = 200;
  let buildingWidthLeft = buildingWidth * 0.6;
  rect(0, height - 150 - buildingHeightLeft, buildingWidthLeft, buildingHeightLeft);

  // Right building
  let buildingHeightRight1 = 250;
  let buildingWidthRight1 = buildingWidth * 0.8;
  let rightBuildingX1 = buildingWidth + buildingWidthCenter;
  rect(rightBuildingX1, height - 150 - buildingHeightRight1, buildingWidthRight1, buildingHeightRight1);

  // For Names of Buildings
  fill(255, 255, 0);
  textSize(20);
  textAlign(CENTER, CENTER);

  // Left building label: "NREF"
  text("NREF", buildingWidthLeft / 2, height - 150 - buildingHeightLeft + 20);

  // Center building label: "DICE"
  text("DICE", buildingWidth + buildingWidthCenter / 2, height - 150 - buildingHeightCenter + 20);

  // Right building label: "ETLC"
  text("ETLC", rightBuildingX1 + buildingWidthRight1 / 2, height - 150 - buildingHeightRight1 + 20);
}
