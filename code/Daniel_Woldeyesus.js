let particles = []; // Array to store all the particles (plants and grass)
let regrowthEnabled = true; // Controls if regrowth is enabled
let dayProgress = 0; // Tracks the transition from gloomy to sunny

function setup() {
  createCanvas(1200, 800); // Set the canvas size
  noStroke();

  // Create initial plants and grass
  for (let i = 0; i < 300; i++) {
    addPlant(random(width), random(height)); // Add plants at random positions
  }

  frameRate(60); // Set frame rate to 60 frames per second for smoother animation
}

function draw() {
  // Background transition from gloomy to sunny
  let gloomySky = color(50, 50, 100); // Dark gloomy color
  let sunnySky = color(135, 206, 250); // Bright sunny color
  background(lerpColor(gloomySky, sunnySky, dayProgress));

  // Update day progress gradually
  dayProgress += 0.001;
  if (dayProgress > 1) dayProgress = 1; // Clamp to 1 for sunny day

  // Draw the sun
  let sunX = width / 2;
  let sunY = map(dayProgress, 0, 1, height + 100, height / 4); // Sun rises as day progresses
  let sunSize = 100;
  fill(255, 223, 0, map(dayProgress, 0, 1, 0, 255)); // Sun becomes brighter
  ellipse(sunX, sunY, sunSize, sunSize);

  // Update and display each plant or grass particle
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update(); // Update particle position and state
    p.display(); // Display the particle

    // Remove dead particles and enable regrowth
    if (p instanceof Plant) {
      if (p.isDead()) {
        particles.splice(i, 1);
        if (regrowthEnabled) {
          addPlant(random(width), height - random(50, 100)); // Regrow a new plant at the bottom
        }
      }
    }
  }
}

// Base class representing a generic shape
class Shape {
  constructor(x, y, fillColor) {
    this.x = x; // Set x-coordinate
    this.y = y; // Set y-coordinate
    this.fillColor = fillColor; // Set fill color
  }

  update() {}
  display() {}
}

// Plant class extending Shape
class Plant extends Shape {
  constructor(x, y) {
    super(x, y, color(34, 139, 34)); // Initial green color
    this.size = random(5, 10); // Initial size
    this.growthRate = random(0.1, 0.3); // Random growth rate
    this.lifespan = random(300, 500); // Assign a random lifespan
  }

  // Update the plant's state
  update() {
    this.size += this.growthRate; // Increase size over time
    this.lifespan -= 1; // Decrease lifespan over time

    // Gradually change color to brown as the plant dies
    let progress = map(this.lifespan, 0, 500, 1, 0);
    this.fillColor = lerpColor(color(34, 139, 34), color(139, 69, 19), progress);
  }

  // Display the plant as a growing and fading rectangle
  display() {
    noStroke();
    fill(this.fillColor, map(this.lifespan, 0, 500, 0, 255)); // Adjust transparency based on lifespan
    rect(this.x, this.y - this.size, this.size / 2, this.size); // Draw the plant
  }

  // Check if the plant is dead
  isDead() {
    return this.lifespan < 0;
  }
}

// Function to add a new plant to the list
function addPlant(x, y) {
  particles.push(new Plant(x, y));
}
