// Number of snowflakes, stars, and buildings
let snowflakesCount = 500;
let starCount = 100;
let buildingCount = 4; // Now 4 buildings in total

let snowflakes = [];
let stars = [];
let buildings = [];
let clicked = false; // Track whether the screen has been clicked

function setup() {
  createCanvas(800, 600);
  noStroke();

  // Initialize snowflakes
  for (let i = 0; i < snowflakesCount; i++) {
    snowflakes.push(new Snowflake());
  }

  // Initialize stars
  for (let i = 0; i < starCount; i++) {
    stars.push(new Star());
  }

  // Initialize buildings with specific heights
  for (let i = 0; i < buildingCount; i++) {
    buildings.push(new Building(i));
  }
}

function draw() {
  // Set background for a winter's night
  background(20, 24, 54); // Dark blue sky

  // Draw buildings
  drawBuildings();

  // Draw moon
  drawMoon();

  // Draw street
  drawStreet();

  // Draw stars
  for (let i = 0; i < starCount; i++) {
    stars[i].update();
    stars[i].display();
  }

  // Draw streetlights
  drawStreetLights();

  // Draw snowflakes
  for (let i = 0; i < snowflakesCount; i++) {
    snowflakes[i].update();
    snowflakes[i].display();
  }

  // If the screen has been clicked, animate building height change
  if (clicked) {
    animateBuildingHeightChange();
  }
}

// Snowflake class
class Snowflake {
  constructor() {
    this.x = random(width);
    this.y = random(-100, height);
    this.speed = random(0.5, 2);
    this.size = random(2, 6);
  }

  update() {
    this.y += this.speed;
    // Reset snowflake when it goes off the screen
    if (this.y > height) {
      this.y = random(-100, -10);
      this.x = random(width);
    }
  }

  display() {
    fill(255, 255, 255, 150); // White color with slight transparency
    ellipse(this.x, this.y, this.size, this.size);
  }
}

// Star class
class Star {
  constructor() {
    this.x = random(width);
    this.y = random(height / 2); // Stars above the horizon
    this.size = random(1, 3);
    this.alpha = random(100, 255); // Random initial opacity
  }

  update() {
    // Slow down the twinkling effect by gradually changing alpha
    this.alpha += random(-1, 1);
    this.alpha = constrain(this.alpha, 100, 255);
  }

  display() {
    fill(255, 255, 255, this.alpha); // White color with dynamic opacity
    ellipse(this.x, this.y, this.size, this.size);
  }
}

// Building class for specific buildings in the background
class Building {
  constructor(index) {
    // Predefined positions and heights for specific buildings
    this.y = height - 50; // All buildings will connect to the street

    if (index === 0) {
      // Building 1 (short)
      this.x = random(0, width - 100);
      this.w = 150;
      this.h = 150;
    } else if (index === 1) {
      // Building 2 (medium height)
      this.x = random(0, width - 100);
      this.w = 200;
      this.h = 250;
    } else if (index === 2) {
      // Building 3 (tall)
      this.x = random(0, width - 100);
      this.w = 175;
      this.h = 350;
    } else {
      // Final Building on the left side
      this.x = 0; // Positioned at the far left
      this.w = 100;
      this.h = 200; // Height is medium size for variety
    }
  }

  display() {
    fill(0); // Black color for buildings
    rect(this.x, this.y - this.h, this.w, this.h); // Adjust y so the building connects with the street
  }

  // Method to randomly change the height of the building
  randomizeHeight() {
    this.h = int(random(150, 400)); // Randomize height between 150 and 400 pixels
  }
}

// Draw moon in the top right
function drawMoon() {
  fill(255, 255, 255, 200); // White color with slight transparency
  ellipse(width - 100, 100, 80, 80); // Moon positioned at top right corner
}

// Draw street (horizontal street along the base)
function drawStreet() {
  fill(100, 100, 100); // Dark gray for the street
  rect(0, height - 50, width, 50); // Street is a rectangle at the bottom
}

// Draw streetlights
function drawStreetLights() {
  let streetlightSpacing = width / 7; // 6 streetlights spaced evenly across the street

  for (let i = 0; i < 6; i++) {
    let lightX = streetlightSpacing * (i + 1);
    let lightY = height - 50;

    // Light pole
    fill(100, 100, 100); // Dark gray for the pole
    rect(lightX - 5, lightY - 45, 10, 50);

    // Streetlight bulb
    fill(255, 255, 100); // Yellowish light
    ellipse(lightX, lightY - 60, 30, 30);

    // Glow effect around the light
    fill(255, 255, 150, 100);
    ellipse(lightX, lightY - 60, 70, 70);
  }
}

// Draw buildings in the background
function drawBuildings() {
  for (let i = 0; i < buildingCount; i++) {
    buildings[i].display();
  }
}

// Animate building height change
function animateBuildingHeightChange() {
  // Randomly change the height of the buildings
  for (let i = 0; i < buildingCount; i++) {
    buildings[i].randomizeHeight();
  }
  clicked = false; // Reset clicked state to avoid constant change
}

// Handle mouse click event
function mousePressed() {
  clicked = true; // Set the clicked flag to true when the mouse is pressed
}
