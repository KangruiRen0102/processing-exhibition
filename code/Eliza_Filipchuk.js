// Store star positions in arrays
let starX = [], starY = []; // X and Y coordinates for stars
let numStars = 100; // draw 100 stars in sky

// Building variables
let barHeights = [], barTargetHeights = []; // set current and target heights for dynamic buildings
let barClicks = 0; // Counter for mouse clicks to cycle building height animation
let barMinHeights = [], barMaxHeights = []; // Max/min heights for buildings

// Tree variables
let treeHeights = []; // store tree heights in arrays
let treeGrowth = 5; // change height by 5 with arrow clicks
let maxTreeHeight = 150; // Max tree heights
let minTreeHeight = 50; // Min tree heights

// student variables
let studentX = [], studentY = []; // X and Y positions for students
let numStudents = 5; // show 5 students

function setup() {
  createCanvas(800, 800); // 800x800 canvas
  background(30, 30, 80); // blue background colour

  // random star positions in top 1/2 of canvas
  for (let i = 0; i < numStars; i++) {
    starX.push(random(width)); // random x position across the width
    starY.push(random(height / 2)); // random y position in upper half
  }

  // use building variables
  let numBars = floor(width / 100); // 1 building per 100 pixels
  for (let i = 0; i < numBars; i++) {
    barMinHeights.push(random(200, 400)); // randomizing minimum height
    barMaxHeights.push(random(500, 700)); // randomizing maximum height
    barHeights.push(random(barMinHeights[i], barMaxHeights[i])); // initial random height
    barTargetHeights.push(barHeights[i]); // initial target = current height
  }

  // random tree heights in allowable range
  let numTrees = 6; // six trees
  for (let i = 0; i < numTrees; i++) {
    treeHeights.push(random(minTreeHeight, maxTreeHeight)); // give each tree random height
  }

  // student positions on ground
  for (let i = 0; i < numStudents; i++) {
    studentX.push(random(50 + i * 150, 100 + i * 150)); // even spacing of students
    studentY.push(height - 80); // student y-axis placement
  }
}

function draw() {
  background(30, 30, 80); // for animating purposes the background is redrawn 

  drawStars(); // draw the stars
  drawSkyline(); // draw buildings
  drawPark(); // ground and trees
  drawStudents(); // students
}

function drawStars() {
  fill(255, 255, 50); // yellow stars
  for (let i = 0; i < numStars; i++) {
    ellipse(starX[i], starY[i], 5, 5); // circular stars
  }
}

function drawSkyline() {
  fill(50, 50, 50); // building colour
  for (let i = 0; i < barHeights.length; i++) {
    barHeights[i] += (barTargetHeights[i] - barHeights[i]) * 0.01; 
    rect(i * 100 + 50, height - barHeights[i], 80, barHeights[i]); // draw buildings
  }
}

function drawPark() {
  // draw the ground
  fill(34, 139, 34);
  rect(0, height - 100, width, 100); 

  // draw trees (trunk and green)
  for (let i = 0; i < treeHeights.length; i++) {
    let x = i * 150 + 50; // tree x-position
    fill(139, 69, 19); // trunk colour
    rect(x, height - 100 - treeHeights[i], 20, treeHeights[i]); // trunk drawn
    fill(34, 139, 34); // leaf colour
    ellipse(x + 10, height - 100 - treeHeights[i] - 20, 60, 60); // circular leaf
  }
}

function drawStudents() {
  for (let i = 0; i < numStudents; i++) {
    let d = dist(mouseX, mouseY, studentX[i], studentY[i]); // distance from mouse to student
    let isHovered = d < 30; // check if the mouse is close enough to the student
    let size = isHovered ? 40 : 30; // student size increases when hovered
    fill(isHovered ? color(255, 255, 0) : color(0, 200, 255)); // colour changes to yellow when hovered

    ellipse(studentX[i], studentY[i], size, size); // head
    stroke(255); // legs and body
    line(studentX[i], studentY[i] + size / 2, studentX[i], studentY[i] + size * 2); // draw body
    line(studentX[i], studentY[i] + size * 1.5, studentX[i] - 10, studentY[i] + size * 2); // left leg
    line(studentX[i], studentY[i] + size * 1.5, studentX[i] + 10, studentY[i] + size * 2); // right leg
  }
}

function mousePressed() {
  barClicks++; // click counter
  if (barClicks > 5) barClicks = 0; // clicks reset after 6

  for (let i = 0; i < barHeights.length; i++) {
    if (barClicks <= 2) {
      // height increases on first three clicks
      barTargetHeights[i] = barMinHeights[i] + barClicks * (barMaxHeights[i] - barMinHeights[i]) / 3;
    } else {
      // height decreases over next three clicks
      barTargetHeights[i] = barMaxHeights[i] - (barClicks - 3) * (barMaxHeights[i] - barMinHeights[i]) / 3;
    }
  }
}

function keyPressed() {
  if (keyCode === UP_ARROW) {
    // tree heights increase with up arrow
    for (let i = 0; i < treeHeights.length; i++) {
      treeHeights[i] = min(treeHeights[i] + treeGrowth, maxTreeHeight); // keep trees below maximum height
    }
  } else if (keyCode === DOWN_ARROW) {
    // tree heights decrease with down arrow
    for (let i = 0; i < treeHeights.length; i++) {
      treeHeights[i] = max(treeHeights[i] - treeGrowth, minTreeHeight); // keep trees above minimum height
    }
  }
}
