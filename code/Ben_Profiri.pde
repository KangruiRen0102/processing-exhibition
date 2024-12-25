int numSnowflakes = 100; //Add 100 snowflakes to the animation
Snowflake[] snowflakes = new Snowflake[numSnowflakes]; //Array for snowflakes
boolean lightning = false; //Indicator for when the lightning should flash

void setup() {
  size(800, 600);
  for (int i = 0; i < numSnowflakes; i++) { // Set up window size
  // Start each snowflake with a randomized position and speed.
    snowflakes[i] = new Snowflake(); 
  }
}

void draw() {
  background(0); // Black background for each frame
  //Trigger lightning with 1% likelyhood
  if (random(1) < 0.01) {
    lightning = true;
  }
  //If lightning is triggerd, display yellow flash taking entire screen
  if (lightning) {
    fill(255, 255, 0); // Fill colour yellow
    rect(0, 0, width, height); //Yellow rectangle covvering entire screen
    lightning = false; // Stop lightning flash in next frame
  }
  //Display each snowflake
  for (Snowflake s : snowflakes) {
    s.update(); //Downward motion of snowflake
    s.display(); // Add snowflake to screen
  }
}

class Snowflake {
  float x, y, speed; // Speed, position of snowflake

//A constructer to start the snowflake with a random value
  Snowflake() {
    x = random(width); //Randomize the horizontal position
    y = random(-100, height); // Randomize the vertical position
    speed = random(1, 3); // Randomize the speed
  }
//Update the new snoflakes position
  void update() {
    y += speed; // Move downward by already determined speed
    if (y > height) {
      y = random(-100, -10); // Reset to position above frame
      x = random(width); // Determine new horizontal position
    }
  }
// Draw snowflake as white dot/circle
  void display() {
    fill(255); // Colour (white)
    noStroke(); // No outline 
    ellipse(x, y, 5, 5); // Draw snowflake!
  }
}
