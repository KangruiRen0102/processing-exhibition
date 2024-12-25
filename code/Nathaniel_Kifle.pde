// Tree growth media art
int maxGrowth = 200; // Maximum size for tree growth
ArrayList<TreeSegment> tree;
float growthRate = 0.1; // Sets the rate of growth
float time = 0;
int activeBranches = 3; // Ensures a limit of 1-3 branches growing at a time to show how slow growth can be at times

// Setup function
void setup() {
  size(800, 600);
  tree = new ArrayList<TreeSegment>();
  tree.add(new TreeSegment(width / 2, height, width / 2, height - 50, true)); // This line of code sets the trunk initially
}

// Draw loop
void draw() {
  
  drawBackground(); // Adds the sun and stars in the background based on the time of day

  // This set of code sets the growth of the tree/ branches
  for (TreeSegment segment : tree) {
    segment.display();
  }


  growTree(); // This line of code adds new branches/parts of the tree

  
  time += 0.01; // The increment of time for the background(night and day)
}

// The function below is to incorporate the sun and stars with the changing background
void drawBackground() {
  // Changes the color of the sky(night(dark blue) and day(light blue))
  float r = map(sin(time), -1, 1, 10, 135); // Some dark red color for the night
  float g = map(sin(time), -1, 1, 10, 190); // Allows for the transition from the night(dark green) into the day(light green)
  float b = map(sin(time), -1, 1, 30, 255); // Blue color for the sky
  background(r, g, b);

  // This set of code makes the sun more and more brighter/visible as it goes from night to day(sin(time) > 0)
  if (sin(time) > 0) {
    float sunX = width * 0.8;
    float sunY = height * 0.2;
    float sunSize = 100 + 50 * sin(time); // Size of the sun increases as the background gets closer to day
    fill(255, 255, 0, 150); // Adds some Yellow color to the sun
    noStroke();
    ellipse(sunX, sunY, sunSize, sunSize);
  }

  // This set of code makes the stars appear as time goes to night
  if (sin(time) < 0) {
    fill(255, 255, 255, map(sin(time), -1, 0, 200, 0)); // Stars become more visible as it the darker it gets
    noStroke();
    for (int i = 0; i < 200; i++) {
      float starX = random(width);
      float starY = random(height);
      ellipse(starX, starY, 2, 2); // Small stars
    }
  }
}

// This function also grows the tree
void growTree() {
  ArrayList<TreeSegment> newSegments = new ArrayList<TreeSegment>();
  int growingCount = 0;

  for (TreeSegment segment : tree) {
    if (segment.growing && segment.length < maxGrowth) {
      segment.grow();
      growingCount++;
      if (segment.length > maxGrowth / 4 && random(1) < 0.05 && growingCount <= activeBranches) { // This randomizes where the tree will grow
        newSegments.add(segment.spawn(random(-PI / 4, PI / 4)));
      }
    } else {
      segment.growing = false;
    }
  }

  tree.addAll(newSegments);
}


class TreeSegment { // The Tree Segment class
  float x1, y1, x2, y2;
  float angle;
  float length;
  boolean growing;

  TreeSegment(float x1, float y1, float x2, float y2, boolean growing) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.length = dist(x1, y1, x2, y2);
    this.angle = atan2(y2 - y1, x2 - x1);
    this.growing = growing;
  }

  void display() {
    // Ensures the color of the trunk stays brown
    if (y1 == height) {
      stroke(100, 50, 0);
      strokeWeight(12); // Makes the trunk thicker
    } else if (growing) {
      // Following set of code changes the color of the branches from brown to make them green and more tree-like, but still some brown
      float greenRatio = map(length, maxGrowth / 4, maxGrowth, 0, 0.8);
      stroke(lerpColor(color(100, 50, 0), color(34, 139, 34), greenRatio));
      strokeWeight(map(length, 10, maxGrowth, 8, 2));
    } else {
      stroke(34, 139, 34); // This code executes the brown of the brances transitioning to fully green
      strokeWeight(map(length, 10, maxGrowth, 8, 2));
    }

    line(x1, y1, x2, y2);

    if (!growing) {
      fill(34, 139, 34, 150);
      noStroke();
      ellipse(x2, y2, 10, 10); // Attempt in adding leaves, not very visible
    }
  }
// Code continues to execute
  void grow() {
    float dx = cos(angle) * growthRate;
    float dy = sin(angle) * growthRate;
    x2 += dx;
    y2 += dy;
    length += growthRate;
  }

  TreeSegment spawn(float branchAngle) {
    float newAngle = angle + branchAngle;
    float newLength = length * random(0.6, 0.8);
    float newX2 = x2 + cos(newAngle) * newLength;
    float newY2 = y2 + sin(newAngle) * newLength;
    return new TreeSegment(x2, y2, newX2, newY2, true);
  }
}
