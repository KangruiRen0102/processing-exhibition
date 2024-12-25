// This code represents the flow of time and the trajectory of chaos.
// There is a blue sine wave with a red dot following its path, and a stopwatch timer keeping track.
// Once the user clicks the screen, the red dot goes off the sine wave and the stopwatch stops.
// Whenever this ball hits the edge of the screen, it duplicates after each hit infinitely.

ArrayList<Ball> balls;  // List to store all the balls
float startTime;  // The time when the stopwatch started
float elapsedTime;  // The elapsed time since start
boolean running = true;  // Flag to track if the stopwatch is running
float sineOpacity = 255;  // Opacity of the sine wave (starts fully visible)

float waveOffset = 0;  // Horizontal offset for sine wave animation
boolean waveFading = false;  // Flag to track if sine wave is fading out
boolean ballStarted = false;  // Flag to track if the ball has started

// For red dot to ball transition
boolean redDotClicked = false;  // Flag to check if the red dot was clicked
float redDotX, redDotY;  // Position of the red dot

// Stopwatch animation properties
float stopwatchRadius = 20;  // Radius of the stopwatch circle (matches text height)
float lineAngle = -HALF_PI;  // The angle of the rotating line (starts from the top)
float angleIncrement = TWO_PI / 60;  // Angle increment for 1 full period every 1 second (assuming 60 FPS)
boolean stopRotating = false;  // Flag to control whether the line continues rotating

void setup() {
  size(800, 600);  // Set up the canvas size
  balls = new ArrayList<Ball>();  // Initialize the list of balls
  startTime = millis();  // Record the time when the sketch starts
  noStroke();  // Remove stroke for the balls
  textAlign(RIGHT, TOP);  // Align text to the top-right corner
  textSize(32);  // Set the text size for the stopwatch display
}

void draw() {
  background(0, 10);  // Clear the screen with a black background and slight transparency for the trail

  if (running) {
    // Calculate the elapsed time
    elapsedTime = millis() - startTime;
  }

  // Convert elapsed time to minutes, seconds, and milliseconds
  int minutes = int(elapsedTime / 60000);
  int seconds = int((elapsedTime % 60000) / 1000);
  int milliseconds = int(elapsedTime % 1000);

  // Display the stopwatch at the top right corner with formatted time
  fill(255);  // White color for the text
  text(nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(milliseconds, 3), width - 20, 20);

  // Draw the stopwatch animation to the left of the timer
  drawStopwatchAnimation(minutes, seconds, milliseconds);

  // Draw the sine wave as the background (only if it's still visible)
  if (!waveFading) {
    drawSineWave();
  } else {
    // Gradually fade out the sine wave
    sineOpacity -= 2;  // Fade rate (can adjust for smoother/faster fade)
    if (sineOpacity <= 0) {
      sineOpacity = 0;  // Make sure it doesn't go negative
      if (!ballStarted) {
        startBall();  // Start the ball after the wave fades out
      }
    }
    drawSineWave();  // Draw the sine wave with fading opacity
  }

  // Update and display all the balls in the list
  for (int i = 0; i < balls.size(); i++) {
    balls.get(i).update();
    balls.get(i).display();
  }

  // If the red dot has not been clicked, update and display it
  if (!redDotClicked) {
    float amplitude = 100;
    float frequency = 0.02;
  
    // Red dot follows the sine wave path
    redDotX = width / 2;  // Keep red dot in the center horizontally
    redDotY = sin(frequency * (redDotX + waveOffset)) * amplitude + height / 2;  // Get sine wave Y position
  
    fill(255, 0, 0);  // Red color for the dot
    noStroke();  // No stroke for the dot
    ellipse(redDotX, redDotY, 12, 12);  // Draw the red dot with a radius of 12
  }
}

// Ball class to define each ball's properties and behavior
class Ball {
  float x, y;  // Position of the ball
  float dx, dy;  // Speed of the ball in the x and y directions
  float radius;  // Radius of the ball
  color ballColor;  // Color of the ball

  // Constructor to initialize a ball with random values
  Ball(float startX, float startY) {
    x = startX;
    y = startY;
    radius = 10;  // Draw the ball with a radius of 10
    dx = random(3, 6);  // Set a random speed between 3 and 6 for the ball
    dy = random(3, 6);  // Set a random speed between 3 and 6 for the ball
    ballColor = color(random(255), random(255), random(255));  // Random color for the ball
  }

  // Update the ball's position and check for edge collisions
  void update() {
    x += dx;  // Update the x position
    y += dy;  // Update the y position

    // Check for collisions with the edges of the screen and reverse direction if necessary
    if (x - radius <= 0 || x + radius >= width) {
      dx = -dx;  // Reverse direction on the x-axis
      duplicateBall();  // Duplicate a ball when hitting the left or right edge
      increaseSpeed();  // Increase speed after bouncing
    }

    if (y - radius <= 0 || y + radius >= height) {
      dy = -dy;  // Reverse direction on the y-axis
      duplicateBall();  // Duplicate a ball when hitting the top or bottom edge
      increaseSpeed();  // Increase speed after bouncing
    }
  }

  // Display the ball on the screen
  void display() {
    fill(ballColor, 150);  // Set the ball's color with some transparency (for trail effect)
    ellipse(x, y, radius * 2, radius * 2);  // Draw the ball as a circle
  }

  // Duplicate the ball by creating a new one at a random position
  void duplicateBall() {
    balls.add(new Ball(random(width), random(height)));
  }

  // Increase the ball's speed by a small amount
  void increaseSpeed() {
    dx *= 1.05;  // Increase the speed on the x-axis
    dy *= 1.05;  // Increase the speed on the y-axis
  }
}

// Create a new ball, stop the stopwatch, and start fading the sine wave when the mouse is pressed
void mousePressed() {
  if (!redDotClicked) {
    redDotClicked = true;  // Mark the red dot as clicked
    running = false;  // Stop the stopwatch when clicked
    waveFading = true;  // Start the sine wave fading process
    stopRotating = true;  // Stop the rotating line
    balls.add(new Ball(redDotX, redDotY));  // Add a new ball where the red dot was
  }
}

// Start the ball after the sine wave fades out
void startBall() {
  ballStarted = true;  // Set the flag to prevent multiple balls from starting
}

// Draw the sine wave as the background
void drawSineWave() {
  float amplitude = 100;
  float frequency = 0.02;
  
  // Set visual properties for the sine wave
  stroke(0, 191, 255, sineOpacity);  // A little lighter blue
  strokeWeight(4);  // Thicker sine wave
  
  // Start the sine wave from the very left edge of the screen
  float waveStartX = 0;
  float waveEndX = width;  // End the wave at the far right edge of the screen

  // Draw the sine wave
  for (float x = waveStartX; x < waveEndX; x++) {
    float y = sin(frequency * (x + waveOffset)) * amplitude + height / 2;
    point(x, y);  // Draw the sine wave points
  }

  waveOffset += 1;  // Shift the sine wave to the right for animation
}

// Draw the rotating stopwatch animation (circle with rotating line)
void drawStopwatchAnimation(int minutes, int seconds, int milliseconds) {
  // Position the circle slightly to the left of the stopwatch timer (no overlap)
  float textWidth = textWidth(nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(milliseconds, 3));
  float centerX = width - stopwatchRadius * 2 - 140;  // Horizontal position (left of the timer)
  float centerY = 22 + stopwatchRadius / 2;  // Vertical position (aligned with the timer's text)

  // Draw the circle (stopwatch animation)
  noFill();
  stroke(255);  // White color for the stopwatch circle
  strokeWeight(4);
  ellipse(centerX, centerY, stopwatchRadius * 2, stopwatchRadius * 2);

  // Update the line angle based on the elapsed time (line completes a full rotation every 1s)
  if (!stopRotating) {
    lineAngle += angleIncrement;  // Increment by 2π/60 for 1 full period in 1 second
  }

  // Draw the rotating line (the radius)
  float lineX = centerX + cos(lineAngle) * stopwatchRadius;
  float lineY = centerY + sin(lineAngle) * stopwatchRadius;
  line(centerX, centerY, lineX, lineY);  // Draw the line from the center to the edge
}

// Russell Aquino (1799682) - Term Project #2
