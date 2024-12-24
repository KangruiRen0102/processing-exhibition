let maxGrowth = 200; // Maximum size for tree growth
let tree = [];
let growthRate = 0.1; // Sets the rate of growth
let time = 0;
let activeBranches = 3; // Limits the number of active growing branches

function setup() {
  createCanvas(800, 600);
  tree.push(new TreeSegment(width / 2, height, width / 2, height - 50, true)); // Initialize the trunk
}

function draw() {
  drawBackground(); // Handles the sun and stars based on time of day

  // Display all tree segments
  for (let segment of tree) {
    segment.display();
  }

  growTree(); // Add new branches/parts to the tree
  time += 0.01; // Increment time for background transition
}

function drawBackground() {
  // Background color transitions between night and day
  let r = map(sin(time), -1, 1, 10, 135);
  let g = map(sin(time), -1, 1, 10, 190);
  let b = map(sin(time), -1, 1, 30, 255);
  background(r, g, b);

  // Sun becomes brighter as it transitions to day
  if (sin(time) > 0) {
    let sunX = width * 0.8;
    let sunY = height * 0.2;
    let sunSize = 100 + 50 * sin(time);
    fill(255, 255, 0, 150);
    noStroke();
    ellipse(sunX, sunY, sunSize, sunSize);
  }

  // Stars become visible as it transitions to night
  if (sin(time) < 0) {
    fill(255, 255, 255, map(sin(time), -1, 0, 200, 0));
    noStroke();
    for (let i = 0; i < 200; i++) {
      let starX = random(width);
      let starY = random(height);
      ellipse(starX, starY, 2, 2); // Small stars
    }
  }
}

function growTree() {
  let newSegments = [];
  let growingCount = 0;

  for (let segment of tree) {
    if (segment.growing && segment.length < maxGrowth) {
      segment.grow();
      growingCount++;
      if (segment.length > maxGrowth / 4 && random(1) < 0.05 && growingCount <= activeBranches) {
        newSegments.push(segment.spawn(random(-PI / 4, PI / 4))); // Randomize branch growth direction
      }
    } else {
      segment.growing = false;
    }
  }

  tree = tree.concat(newSegments);
}

class TreeSegment {
  constructor(x1, y1, x2, y2, growing) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.length = dist(x1, y1, x2, y2);
    this.angle = atan2(y2 - y1, x2 - x1);
    this.growing = growing;
  }

  display() {
    if (this.y1 === height) {
      stroke(100, 50, 0);
      strokeWeight(12); // Thicker trunk
    } else if (this.growing) {
      let greenRatio = map(this.length, maxGrowth / 4, maxGrowth, 0, 0.8);
      stroke(lerpColor(color(100, 50, 0), color(34, 139, 34), greenRatio));
      strokeWeight(map(this.length, 10, maxGrowth, 8, 2));
    } else {
      stroke(34, 139, 34);
      strokeWeight(map(this.length, 10, maxGrowth, 8, 2));
    }

    line(this.x1, this.y1, this.x2, this.y2);

    // Draw leaves at the ends of fully grown branches
    if (!this.growing) {
      fill(34, 139, 34, 150);
      noStroke();
      ellipse(this.x2, this.y2, 10, 10); // Small leaves
    }
  }

  grow() {
    let dx = cos(this.angle) * growthRate;
    let dy = sin(this.angle) * growthRate;
    this.x2 += dx;
    this.y2 += dy;
    this.length += growthRate;
  }

  spawn(branchAngle) {
    let newAngle = this.angle + branchAngle;
    let newLength = this.length * random(0.6, 0.8);
    let newX2 = this.x2 + cos(newAngle) * newLength;
    let newY2 = this.y2 + sin(newAngle) * newLength;
    return new TreeSegment(this.x2, this.y2, newX2, newY2, true);
  }
}
