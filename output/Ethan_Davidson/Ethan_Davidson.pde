float a = 5;                // -Amplitude of the petals
float k = 10;               // -Controls the number of petals in parametric function
float petalLength = 0;      // -Length of the petals starts from 0
float maxPetalLength = 150; // -Defines maximum petal length to cap growth
float growthRate = 0.2;     // -Defines rate of growth to be 20% original speed

int numRaindrops = 100;                            // -Number of raindrops
Raindrop[] raindrops = new Raindrop[numRaindrops]; // -Array for raindrops

void setup() {
  size(600, 600);  // -Sets size of art piece

  for (int i = 0; i < numRaindrops; i = i + 1) {
    raindrops[i] = new Raindrop();               // Loop to create the 100 drops
  }
}

void draw() {
  background(90); // makes a grey background to represent theme

  for (int i = 0; i < numRaindrops; i = i + 1) {
    raindrops[i].fallAndShow();          // changes position of drops 
  }                                      // in array from earlier

  Flower();  // - uses flower function

  if (petalLength < maxPetalLength) {
    petalLength = petalLength + growthRate; // -Increase size of petals
    a = petalLength; // -Adjust amplitude to simulate growing petals
  }

  Stem();  // Uses stem function
}

void Flower() {
  noStroke();               // -This section draws the petal
  fill(255, 100, 200);      // -makes petals pink

  beginShape();
  for (float theta = 0; theta <= 2 * 3.14159 * k; theta = theta + 0.01) {
    float r = a * cos(k * theta);    // This parameterization will use concepts
    float x = r * cos(theta) + 405;  // I learned in calculus to draw a flower.
    float y = r * sin(theta) + 400;  // Draws the flower off to the right at about 2/3.
    vertex(x, y);                    //
  }
  endShape(CLOSE);
}

void Stem() 
  { fill(0, 255, 0);         // -Bright green colour for the stem (max green RGB value)
    rect(400, 400, 10, 200); // -Creates the stem rectangle in desired spot
}

class Raindrop {      // creates class for drops
  float x, y, speed;

  Raindrop() {                
    x = random(0,600);        // -Spawns drop randomly across domain
    y = random(-600, -50); // -Spawns drop above screen before falling
    speed = random(2, 5);     // -Makes falling random speed to simulate randomness of rain
  }

  void fallAndShow() {
    y = y + speed;          // -Uses speed value from previous line to move drop
                            // at proper rate
    if (y > height) {       // -Resets height of drops to simulate raining
      y = random(-50, -10); // uses random() to randomly place a drop along the domain
      x = random(0,600);    // -I set y to spawn drops above view for consistency
    }                       // (otherwise it looks weird)
    stroke(0, 0, 255);      // -This will draw a blue line (raindrop)
    line(x, y, x, y + 20);  // -Makes a line 1 pixel thick and 20 pixels tall to 
  }                         // simulate a droplet
}
