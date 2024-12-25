int studyTime = 0;  // Counter to represent time passing (studying)
boolean studying = true; // The student is studying

float candleHeight = 100;  // Initial height of the candle
float candleWaxRate = 0.1;  // Rate at which the candle burns down (how much it shrinks each frame)
float flameHeight = 10;  // Height of the flame
boolean isFlameFlickering = true;  // Controls flame flickering

void setup() {
  size(800, 800);  // Set canvas size to 800x800
  frameRate(60); // Set frame rate to 60 frames per second (smooth animation)
}

void draw() {
  background(255); // White background to simulate a study environment
  
  // Draw the clock in the corner to represent time passing
  drawClock(700, 50);
  
  // Draw the student sitting and studying in the center
  drawStudent(width / 2, height / 2 + 50);
  
  // Draw the candle, placed at (100, height - 150) for a reasonable position
  drawCandle(100, height - 150);
  
  // Simulate the study time (increasing over time)
  studyTime++;  // Increase studyTime by 1 every frame
  
  // Add the studying animation effect (e.g., student turning pages or writing)
  if (studyTime % 60 == 0) {  // Every 60 frames (1 second), add a page turn effect
    drawBookPageTurn(width / 2 - 30, height / 2 + 50);
  }
  
  // Display the message of studying forever at the bottom of the screen
  fill(0);  // Set text color to black
  textSize(32);  // Set text size to 32 pixels
  textAlign(CENTER);  // Align text in the center
  text("Studying forever...", width / 2, height - 100);  // Display text
}

// Function to draw the student (stick figure)
void drawStudent(float x, float y) {
  // Draw head (circle shape)
  fill(255, 224, 189); // Skin color for the head
  ellipse(x, y - 60, 40, 40); // Head: Draw circle at position (x, y - 60)

  // Draw body and limbs (stick figure)
  stroke(0); // Set stroke color to black
  line(x, y - 40, x, y + 40); // Body: Vertical line from head to bottom
  line(x, y, x - 30, y + 40); // Left leg
  line(x, y, x + 30, y + 40); // Right leg
  line(x, y - 20, x - 30, y - 40); // Left arm
  line(x, y - 20, x + 30, y - 40); // Right arm
  
  // Draw book in front of the student
  fill(200, 150, 100); // Brown color for the book
  rect(x - 30, y - 40, 60, 20); // Draw book as a rectangle
  
  // Draw eyes
  fill(0); // Set eye color to black
  ellipse(x - 10, y - 65, 5, 5); // Left eye
  ellipse(x + 10, y - 65, 5, 5); // Right eye
}

// Function to simulate the book turning effect
void drawBookPageTurn(float x, float y) {
  // Simulate a page turning by animating a transparent white shape
  stroke(0); // Set stroke color to black
  fill(255, 255, 255, 200); // Transparent white color for page turn effect
  beginShape();  // Start the shape
  vertex(x, y);  // Bottom-left corner of the page
  vertex(x + 30, y - 10); // Top-right corner of the page
  vertex(x + 30, y + 10); // Bottom-right corner of the page
  vertex(x, y + 20); // Bottom-left corner of the page
  endShape(CLOSE);  // Close the shape to create a polygon
}

// Function to draw the clock
void drawClock(int x, int y) {
  // Draw a bigger clock to represent the passage of time
  stroke(0);  // Set stroke color to black
  noFill();  // Don't fill the circle, just draw the border
  ellipse(x, y, 100, 100); // Bigger clock face with radius 50 (100x100 size)
  
  // Calculate the angles for the clock hands
  float secondAngle = map(studyTime % 60, 0, 60, 0, TWO_PI);  // Angle for second hand
  float minuteAngle = map((studyTime / 60) % 60, 0, 60, 0, TWO_PI);  // Angle for minute hand
  float hourAngle = map((studyTime / 3600) % 12, 0, 12, 0, TWO_PI);  // Angle for hour hand
  
  // Draw the second hand (red)
  stroke(255, 0, 0);  // Red color for the second hand
  line(x, y, x + cos(secondAngle) * 40, y + sin(secondAngle) * 40); // Draw second hand
  
  // Draw the minute hand (blue)
  stroke(0, 0, 255);  // Blue color for the minute hand
  line(x, y, x + cos(minuteAngle) * 30, y + sin(minuteAngle) * 30); // Draw minute hand
  
  // Draw the hour hand (black)
  stroke(0);  // Black color for the hour hand
  line(x, y, x + cos(hourAngle) * 20, y + sin(hourAngle) * 20); // Draw hour hand
  
  // Draw the clock center (small black circle)
  fill(0);  // Set fill color to black
  ellipse(x, y, 10, 10);  // Draw a small center circle
}

// Function to draw the candle and wax
void drawCandle(float x, float y) {
  // Draw the wax body of the candle
  fill(255, 255, 0); // Yellow color for the wax
  rect(x - 10, y - candleHeight, 20, candleHeight);  // Draw candle body (rectangle)
  
  // Decrease the candle height to simulate burning down over time
  candleHeight -= candleWaxRate;  // Reduce candle height each frame
  if (candleHeight < 0) candleHeight = 0; // Prevent the candle height from going negative (it can't burn forever)
  
  // Draw the flame at the top of the candle
  drawFlame(x, y - candleHeight);  // Position the flame based on the candle height
}

// Function to draw the flickering flame on top of the candle
void drawFlame(float x, float y) {
  // Flickering flame effect: Change flame size based on time (randomize)
  if (isFlameFlickering) {
    flameHeight = random(8, 15);  // Random flicker effect between 8 and 15 pixels
  } else {
    flameHeight = 12;  // Steady flame height
  }
  
  // Flame color (orange-yellow)
  fill(255, 69, 0);  // Flame color: Red-Orange (Flame color)
  
  // Draw the flame as a triangle
  triangle(x - 5, y - flameHeight, x + 5, y - flameHeight, x, y - flameHeight - 20);  // Flame shape
  
  // Switch flame flickering effect every 20 frames
  if (studyTime % 20 == 0) {
    isFlameFlickering = !isFlameFlickering;  // Toggle flickering state
  }
}
