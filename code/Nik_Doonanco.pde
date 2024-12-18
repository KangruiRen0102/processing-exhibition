int numFlowers = 0; // Initial number of flowers
ArrayList<FadingFlower> flowers; //Flowers
ArrayList<Star> stars = new ArrayList<>(); // Tracks amount of stars
float time = 0; // Time variable to track night-to-day transition
PShape groundShape; // Shape for uneven ground
ArrayList<GroundSegment> groundSegments = new ArrayList<>(); // Ground segment array
ArrayList<Cloud> clouds = new ArrayList<>(); // Clouds array

void setup() { // creates the display
  size(800, 800);
  colorMode(HSB, 360, 100, 100);
  flowers = new ArrayList<FadingFlower>();
  generateGround(); // Creates the ground
  generateStars(); // Adds stars to the sky
  generateClouds(); // Adds clouds to the sky
}

void draw() {
  // Time-based transition from night to day
  time += 0.003;
  float dayProgress = (sin(time) + 1) / 2; // Oscillates between 0 (night) and 1 (day)

  // Background gradient
  int nightColor = color(240, 20, 20); // Creates dark night sky
  int dayColor = color(199, 206, 250); // Creates bright day sky
  background(lerpColor(nightColor, dayColor, dayProgress));

  // Draw stars (visible more at night)
  for (Star star : stars) {
    star.display(1 - dayProgress); // Brightness decreases as dayProgress increases
  }

  // Display the ground with varying shades of green
  for (GroundSegment segment : groundSegments) {
    segment.display();
  }
  
  // Draw clouds
  for (Cloud cloud : clouds) {
     cloud.display(dayProgress);
     cloud.move();
       }
       
    // Iterate over the flowers list and add glow at night
  for (int i = flowers.size() - 1; i >= 0; i--) {
    FadingFlower f = flowers.get(i);
    f.display(dayProgress);
    if (f.isDead()) {
      flowers.remove(i); // Remove flowers that have completely faded
    }
  }
 }

void mousePressed() {
  // Add a new flower at the mouse's position
  flowers.add(new FadingFlower(mouseX, mouseY));
}

// Create class for Fading Flower with Night Glow
class FadingFlower {
  flower f; // A flower object
  PVector position; // The position of the flower
  float startTime; // The time when the flower was created

  FadingFlower(float x, float y) {
    position = new PVector(x, y);
    f = new flower();
    startTime = millis();
  }

  void display(float dayProgress) {
    float elapsedTime = (millis() - startTime) / 1000.0; // Time in seconds
    float alpha = map(elapsedTime, 0, 4, 255, 0); // Fade out over 4 seconds
    alpha = constrain(alpha, 0, 255);

    pushMatrix(); // adds new coordinates to matrix
    translate(position.x, position.y);

    // Glowing effect at night
    if (dayProgress < 0.5) {
      fill(60, 100, 100, 100 * (1-dayProgress));
      noStroke();
      ellipse(0, 0, 100 * (2-dayProgress), 100 *(2-dayProgress)); // Glow size adjusts with dayProgress
    }

    tint(255, alpha); // Apply alpha time variable to the flower
    f.display();
    popMatrix(); // restores matrix
  }

  boolean isDead() {
    return millis() - startTime > 4000; // Check if the flower has faded out
  }
}
// Class for flowers
class flower {
  float hue;
  int petalCount;
  int rowCount;
  float len;
  float wid;
  float rotate;
  
  flower() {
    hue = random(0, 360); // creates flower colours
    petalCount = int(random(2, 8)) * 4; // creates petals
    len = random(30, 60); // length of petals
    wid = random(0.2, 0.5); // width of petals
    rowCount = int(random(4, 10)); // rows of petals
    rotate = random(0.5, 2.0); // different angles for rows of petals
  }
  
  void display() { // Creates the display for flowers
    stroke(0);
    strokeWeight(1);
    float deltaA = (2 * PI) / petalCount; // creates angle for rotation
    float petalLen = len; // creates base petal length
    pushMatrix();
    for (int r = 0; r < rowCount; r++) { // adds rows
      for (float angle = 0; angle < 2 * PI; angle += deltaA) {
        rotate(deltaA); // rotates subsequent rows
        fill(hue - r * 20, 100, 100); // creates different colours for next row
        ellipse(petalLen * 0.75, 0, petalLen, petalLen * wid); // changes size of next row petals
      }
      rotate(rotate); // rotates rows
      petalLen = petalLen * (1 - 3.0 / rowCount); // makes inner rows have smaller petals
    }
    popMatrix();
  }
}

void generateGround() {
  groundSegments.clear();
  for (int x = 0; x < width; x += 20) {
    float y = height / 2 + noise(x * 0.05) * 100; // Perlin noise for uneven ground, ground rectangles cover bottom half of screen
    float nextY = height / 2 + noise((x + 20) * 0.05) * 100;
    color segmentColor = color(random(70, 120), random(139, 200), random(34, 85)); // Random green shades
    groundSegments.add(new GroundSegment(x, y, x + 20, nextY, segmentColor)); // defines the size of the rectangles
  }
}

void generateStars() {
  for (int i = 0; i < 100; i++) {
    stars.add(new Star(random(width), random(height / 2))); // Randomly position stars
  }
}

void generateClouds() {
  for (int i = 0; i < 5; i++) {
    clouds.add(new Cloud(random(width), random(height / 2.5), random(50, 100))); // Random cloud size
  }
}
// Class for stars
class Star {
  float x, y;
  float brightness;

  Star(float x, float y) {
    this.x = x;
    this.y = y;
    this.brightness = random(100, 255); // Initial brightness
  }

  void display(float visibility) {
    brightness += random(-5, 5); // Flickering effect
    brightness = constrain(brightness, 100, 255); // Limit brightness range
    fill(60, 255, 255, brightness * visibility); // Adjust brightness by visibility (night)
    noStroke();
    ellipse(x, y, 3, 3); // Star size
  }
}

// Class for Ground Segment
class GroundSegment {
  float x1, y1, x2, y2;
  color segmentColor;

  GroundSegment(float x1, float y1, float x2, float y2, color segmentColor) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.segmentColor = segmentColor;
  }

  void display() {
    fill(segmentColor);
    noStroke();
    beginShape(); // create rectangular grounds segments
    vertex(x1, y1);
    vertex((x2), y2);
    vertex(x2, height);
    vertex(x1, height);
    endShape(CLOSE); 
  }
}

// Class for Clouds
class Cloud {
  float x, y;
  float size;

  Cloud(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  void display(float dayProgress) {
    if (dayProgress>0) { 
    fill(0, 2, 80 * dayProgress); // clouds are bright in the day
    } else if(dayProgress==0) { 
      fill(0, 2, 80); // clouds are dark at night
    }
    noStroke();
    ellipse(x, y, size, size * 0.6); // Main cloud body
    ellipse(x - size * 0.4, y + size * 0.2, size * 0.6, size * 0.4); // Small puffs
    ellipse(x + size * 0.4, y + size * 0.2, size * 0.6, size * 0.4); // Small puffs
  }

  void move() {
    x += 0.5; // Move the cloud slowly
    if (x > width + size) {
      x = -size; // Wrap around the screen
    }
  }
}
