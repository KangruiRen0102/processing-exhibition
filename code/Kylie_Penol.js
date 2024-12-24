let spots;
let arm;

let bgGray = 204; // Initial background gray color
let bigDim = 90.0; // Initial size for the big spot
let smallDim = 30.0; // Initial size for the small spot
let dimChangeRate = 0.3; // Slower size change rate for smoother transition
let bgFadeRate = 0.3; // Slower background fade rate for smoother transition

// Fade variable for big ball (to slowly disappear)
let bigBallFade = 255; // Initially fully visible
let bigBallFading = false; // Flag to start the fade effect

// Store the time when the background transition starts
let transitionStartTime;
let backgroundTransitionStarted = false; // Flag to start the background transition
let backgroundLighteningStarted = false; // Flag to start lightening the background

function setup() {
  createCanvas(640, 360);
  arm = new SpinArm(width / 2, height / 2, 0.01);
  spots = new SpinSpots(width / 2, height / 2, -0.02, bigDim, smallDim);

  // Record the time when the transition starts
  transitionStartTime = millis();
}

function draw() {
  // Calculate how much time has passed since the transition started
  let elapsedTime = millis() - transitionStartTime;

  // Smoothly transition background color from light gray to black
  if (!backgroundLighteningStarted) {
    bgGray = lerp(bgGray, 0, bgFadeRate * 0.01); // Transition to black
  }

  // Start fading the big ball after 3 seconds
  if (elapsedTime > 3000 && !bigBallFading) {
    bigBallFading = true; // Start fading the big ball
  }

  // Fade the big ball if it's time
  if (bigBallFading) {
    bigBallFade = lerp(bigBallFade, 0, 0.01); // Gradually fade the big ball
  }

  // Check if the big ball has fully faded and start the background transition after 3 seconds
  if (bigBallFade <= 0 && !backgroundTransitionStarted) {
    if (elapsedTime > 6000) { // 3 seconds for ball fade + 3 seconds delay
      backgroundTransitionStarted = true;
      backgroundLighteningStarted = true;
      transitionStartTime = millis(); // Reset the transition start time for background change
    }
  }

  // Smoothly transition background color from black to lighter white after 3 seconds
  if (backgroundLighteningStarted) {
    let backgroundElapsedTime = millis() - transitionStartTime;
    bgGray = lerp(0, 204, backgroundElapsedTime * 0.0001); // Transition to lighter white
  }

  background(bgGray); // Set background color

  arm.update(); // Update arm position
  arm.display(); // Display arm

  spots.update(); // Update spots' rotation and size
  spots.display(); // Display spots
}

class Spin {
  constructor(xpos, ypos, s) {
    this.x = xpos;
    this.y = ypos;
    this.speed = s;
    this.angle = 0.0;
  }

  update() {
    this.angle += this.speed; // Infinite rotation
  }
}

class SpinArm extends Spin {
  constructor(x, y, s) {
    super(x, y, s);
  }

  display() {
    strokeWeight(1);
    stroke(0);
    push();
    translate(this.x, this.y);
    this.angle += this.speed;
    rotate(this.angle);
    line(0, 0, 165, 0); // Rotating arm
    pop();
  }
}

class SpinSpots extends Spin {
  constructor(x, y, s, bigD, smallD) {
    super(x, y, s);
    this.bigDim = bigD;
    this.smallDim = smallD;
  }

  display() {
    noStroke();
    fill(255); // White spots

    // Smoothly transition sizes of the big and small spots
    this.bigDim = lerp(this.bigDim, 30, dimChangeRate * 0.02); // Smoothly shrink the big spot
    this.smallDim = lerp(this.smallDim, 90, dimChangeRate * 0.02); // Smoothly grow the small spot

    // Draw the spots with the fading effect on the big ball
    push();
    translate(this.x, this.y);
    this.angle += this.speed;
    rotate(this.angle);

    // Draw the big spot (shrinking and fading)
    fill(255, bigBallFade); // Apply fading effect to the big ball
    ellipse(-this.bigDim / 2, 0, this.bigDim, this.bigDim); // Big spot (now shrinking)

    // Draw the small spot (growing)
    fill(255); // No fading effect on the small ball
    ellipse(this.smallDim / 2, 0, this.smallDim, this.smallDim); // Small spot (now growing)

    // If the big ball is fully faded, make it shrink to zero size and "disappear"
    if (bigBallFade <= 0) {
      this.bigDim = 0; // Make the big ball disappear completely
    }

    pop();
  }
}
