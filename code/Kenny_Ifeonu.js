let heighttree = 0, lengthbranch = 0, sunhori = 0, sunvert = 100;
let birdSpeed = 1.5, birdSize = 8;
const maxheighttree = 300, maxlengthbranch = 97, thickbranch = 3, sunRadius = 50, leafSize = 10;

let branchesStarted = false, plantsGrown = false;

let leafPositionshori = [], leafPositionsvert = [];
let planthori = [], plantvert = [], plantTrunkHeight = [], plantcanopysize = [];

let birdhori = [-50, -100, -150, -200], birdvert = [200, 150, 100, 250];
let cloudhori = [], cloudvert = [], cloudsize = [];
let butterflyhori = [-50, -100, -150, -200], butterflyvert = [300, 350, 250, 200];
let butterflyquick = 1.5, wingflapquick = 0.1, wingflapmotion = 10;

function setup() {
  createCanvas(800, 600);
  noStroke();

  for (let i = 0; i < 5; i++) {
    cloudhori.push(random(-100, 800));
    cloudvert.push(random(50, 150));
    cloudsize.push(random(50, 150));
  }
}

function draw() {
  let backgColorR = map(sunhori, 0, width, 20, 70);
  let backgColorG = map(sunhori, 0, width, 50, 100);
  let backgColorB = map(sunhori, 0, width, 100, 180);

  if (sunhori > width) {
    backgColorR = 70;
    backgColorG = 100;
    backgColorB = 180;
  }

  background(backgColorR, backgColorG, backgColorB);

  moveClouds();
  for (let i = 0; i < cloudhori.length; i++) {
    drawCloud(cloudhori[i], cloudvert[i], cloudsize[i]);
  }

  sunhori += 1.5;
  if (sunhori > width + sunRadius) sunhori = -sunRadius;
  drawSun(sunhori, sunvert, sunRadius);

  drawTree(width / 2, height - 100, heighttree);
  if (heighttree < maxheighttree) heighttree += 2;
  else if (!branchesStarted) { branchesStarted = true; lengthbranch += 1; }
  if (branchesStarted && lengthbranch < maxlengthbranch) {
    drawBranches(width / 2, height - 100, lengthbranch, PI / 4, 5);
  }

  moveBirds();
  for (let i = 0; i < birdhori.length; i++) drawBird(birdhori[i], birdvert[i]);

  moveButterflies();
  for (let i = 0; i < butterflyhori.length; i++) {
    drawButterfly(butterflyhori[i], butterflyvert[i]);
  }

  if (sunhori > width / 2 && !plantsGrown) {
    plantsGrown = true;
    addPlants();
  }

  if (plantsGrown) {
    for (let i = 0; i < planthori.length; i++) {
      fill(137, 64, 20);
      rect(planthori[i] - 5, plantvert[i], 10, plantTrunkHeight[i]);

      fill(30, 137, 38);
      ellipse(planthori[i], plantvert[i] - plantTrunkHeight[i], plantcanopysize[i], plantcanopysize[i]);
      if (plantcanopysize[i] < 40) plantcanopysize[i] += 0.3;
      if (plantTrunkHeight[i] < 25) plantTrunkHeight[i] += 0.2;
    }
  }
}

function moveButterflies() {
  for (let i = 0; i < butterflyhori.length; i++) {
    butterflyhori[i] += butterflyquick;
    if (butterflyhori[i] > width) butterflyhori[i] = -50 - (i * 50);
    butterflyvert[i] = 300 + 30 * sin(radians(butterflyhori[i] * 2));
  }
}

function drawButterfly(hori, vert) {
  push();
  translate(hori, vert);
  rotate(radians(45));

  let wingflap = sin(frameCount * wingflapquick) * wingflapmotion;

  fill(255, 200, 100, 180);
  ellipse(0, -5, 20 + wingflap, 10 + wingflap / 2);
  fill(255, 150, 100, 180);
  ellipse(0, 5, 20 + wingflap, 10 + wingflap / 2);

  fill(0);
  ellipse(0, 0, 5, 15);

  pop();
}

function drawTree(hori, vert, HH) {
  fill(34, 139, 34);
  ellipse(hori, vert - HH, 100, 100);
  fill(139, 69, 19);
  rect(hori - 10, vert, 20, -HH);
}

function drawBranches(hori, vert, len, angle, dpth) {
  if (dpth === 0) return;

  let branchEndhori = hori + len * cos(angle);
  let branchEndvert = vert - len * sin(angle);

  fill(139, 69, 19);
  ellipse(branchEndhori, branchEndvert, 10, 10);

  drawBranches(branchEndhori, branchEndvert, len * 0.7, angle - PI / 6, dpth - 1);
  drawBranches(branchEndhori, branchEndvert, len * 0.7, angle + PI / 6, dpth - 1);
}

function drawSun(hori, vert, rad) {
  fill(255, 255, 0);
  ellipse(hori, vert, rad * 2, rad * 2);
}

function moveBirds() {
  for (let i = 0; i < birdhori.length; i++) {
    birdhori[i] += birdSpeed;
    if (birdhori[i] > width) birdhori[i] = -50 - (i * 50);
    birdvert[i] = 200 + 50 * sin(radians(birdhori[i]));
  }
}

function drawBird(hori, vert) {
  push();
  translate(hori, vert);
  rotate(radians(45));

  fill(255, 250, 200);
  triangle(0, -10, 10, 10, -10, 10);

  pop();
}

function addPlants() {
  for (let i = 0; i < 10; i++) {
    let xPos = random(50, width - 50);
    let yPos = height - 50 + random(10, 20);
    planthori.push(xPos);
    plantvert.push(yPos);
    plantTrunkHeight.push(0.0);
    plantcanopysize.push(10.0);
  }
}

function moveClouds() {
  for (let i = 0; i < cloudhori.length; i++) {
    cloudhori[i] += 0.2;
    if (cloudhori[i] > width + cloudsize[i] / 2) {
      cloudhori[i] = -cloudsize[i] / 2;
    }
  }
}

function drawCloud(hori, vert, size) {
  fill(255, 255, 255, 200);
  ellipse(hori, vert, size, size / 1.5);
  ellipse(hori - size / 3, vert, size, size / 1.5);
  ellipse(hori + size / 3, vert, size, size / 1.5);
}
