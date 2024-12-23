let numFlowers = 0; // Initial number of flowers
let flowers = []; // Flowers
let stars = []; // Tracks amount of stars
let time = 0; // Time variable to track night-to-day transition
let groundSegments = []; // Ground segment array
let clouds = []; // Clouds array

function setup() {
  createCanvas(800, 800);
  colorMode(HSB, 360, 100, 100);
  generateGround(); // Creates the ground
  generateStars(); // Adds stars to the sky
  generateClouds(); // Adds clouds to the sky
}

function draw() {
  // Time-based transition from night to day
  time += 0.003;
  let dayProgress = (sin(time) + 1) / 2; // Oscillates between 0 (night) and 1 (day)

  // Background gradient
  let nightColor = color(240, 20, 20); // Creates dark night sky
  let dayColor = color(199, 206, 250); // Creates bright day sky
  background(lerpColor(nightColor, dayColor, dayProgress));

  // Draw stars (visible more at night)
  for (let star of stars) {
    star.display(1 - dayProgress); // Brightness decreases as dayProgress increases
  }

  // Display the ground with varying shades of green
  for (let segment of groundSegments) {
    segment.display();
  }

  // Draw clouds
  for (let cloud of clouds) {
    cloud.display(dayProgress);
    cloud.move();
  }

  // Iterate over the flowers list and add glow at night
  for (let i = flowers.length - 1; i >= 0; i--) {
    let f = flowers[i];
    f.display(dayProgress);
    if (f.isDead()) {
      flowers.splice(i, 1); // Remove flowers that have completely faded
    }
  }
}

function mousePressed() {
  // Add a new flower at the mouse's position
  flowers.push(new FadingFlower(mouseX, mouseY));
}

// Class for Fading Flower with Night Glow
class FadingFlower {
  constructor(x, y) {
    this.position = createVector(x, y);
    this.flower = new Flower();
    this.startTime = millis();
  }

  display(dayProgress) {
    let elapsedTime = (millis() - this.startTime) / 1000.0; // Time in seconds
    let alpha = map(elapsedTime, 0, 4, 255, 0); // Fade out over 4 seconds
    alpha = constrain(alpha, 0, 255);

    push();
    translate(this.position.x, this.position.y);

    // Glowing effect at night
    if (dayProgress < 0.5) {
      fill(60, 100, 100, 100 * (1 - dayProgress));
      noStroke();
      ellipse(0, 0, 100 * (2 - dayProgress), 100 * (2 - dayProgress)); // Glow size adjusts with dayProgress
    }

    tint(255, alpha); // Apply alpha time variable to the flower
    this.flower.display();
    pop();
  }

  isDead() {
    return millis() - this.startTime > 4000; // Check if the flower has faded out
  }
}

// Class for flowers
class Flower {
  constructor() {
    this.hue = random(0, 360); // creates flower colours
    this.petalCount = int(random(2, 8)) * 4; // creates petals
    this.len = random(30, 60); // length of petals
    this.wid = random(0.2, 0.5); // width of petals
    this.rowCount = int(random(4, 10)); // rows of petals
    this.rotate = random(0.5, 2.0); // different angles for rows of petals
  }

  display() {
    stroke(0);
    strokeWeight(1);
    let deltaA = (2 * PI) / this.petalCount; // creates angle for rotation
    let petalLen = this.len; // creates base petal length
    push();
    for (let r = 0; r < this.rowCount; r++) { // adds rows
      for (let angle = 0; angle < 2 * PI; angle += deltaA) {
        rotate(deltaA); // rotates subsequent rows
        fill(this.hue - r * 20, 100, 100); // creates different colours for next row
        ellipse(petalLen * 0.75, 0, petalLen, petalLen * this.wid); // changes size of next row petals
      }
      rotate(this.rotate); // rotates rows
      petalLen = petalLen * (1 - 3.0 / this.rowCount); // makes inner rows have smaller petals
    }
    pop();
  }
}

function generateGround() {
  groundSegments = [];
  for (let x = 0; x < width; x += 20) {
    let y = height / 2 + noise(x * 0.05) * 100; // Perlin noise for uneven ground
    let nextY = height / 2 + noise((x + 20) * 0.05) * 100;
    let segmentColor = color(random(70, 120), random(139, 200), random(34, 85)); // Random green shades
    groundSegments.push(new GroundSegment(x, y, x + 20, nextY, segmentColor));
  }
}

function generateStars() {
  for (let i = 0; i < 100; i++) {
    stars.push(new Star(random(width), random(height / 2))); // Randomly position stars
  }
}

function generateClouds() {
  for (let i = 0; i < 5; i++) {
    clouds.push(new Cloud(random(width), random(height / 2.5), random(50, 100))); // Random cloud size
  }
}

// Class for stars
class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.brightness = random(100, 255); // Initial brightness
  }

  display(visibility) {
    this.brightness += random(-5, 5); // Flickering effect
    this.brightness = constrain(this.brightness, 100, 255); // Limit brightness range
    fill(60, 255, 255, this.brightness * visibility); // Adjust brightness by visibility (night)
    noStroke();
    ellipse(this.x, this.y, 3, 3); // Star size
  }
}

// Class for Ground Segment
class GroundSegment {
  constructor(x1, y1, x2, y2, segmentColor) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.segmentColor = segmentColor;
  }

  display() {
    fill(this.segmentColor);
    noStroke();
    beginShape(); // create rectangular grounds segments
    vertex(this.x1, this.y1);
    vertex(this.x2, this.y2);
    vertex(this.x2, height);
    vertex(this.x1, height);
    endShape(CLOSE);
  }
}

// Class for Clouds
class Cloud {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  display(dayProgress) {
    if (dayProgress > 0) {
      fill(0, 2, 80 * dayProgress); // clouds are bright in the day
    } else {
      fill(0, 2, 80); // clouds are dark at night
    }
    noStroke();
    ellipse(this.x, this.y, this.size, this.size * 0.6); // Main cloud body
    ellipse(this.x - this.size * 0.4, this.y + this.size * 0.2, this.size * 0.6, this.size * 0.4); // Small puffs
    ellipse(this.x + this.size * 0.4, this.y + this.size * 0.2, this.size * 0.6, this.size * 0.4); // Small puffs
  }

  move() {
    this.x += 0.5; // Move the cloud slowly
    if (this.x > width + this.size) {
      this.x = -this.size; // Wrap around the screen
    }
  }
}
