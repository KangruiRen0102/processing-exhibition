// ArrayList to store all the particles (treated as plants and grass)
ArrayList<Shape> particles;

// Flags to manage interaction modes
boolean regrowthEnabled = true; // Controls if regrowth is enabled
float dayProgress = 0; // Tracks the transition from gloomy to sunny

// Setup function runs once at the beginning
void setup() {
  size(1200, 800); // Set the canvas size
  particles = new ArrayList<Shape>(); // Initialize the ArrayList
  noStroke(); // Disable the stroke for shapes

  // Create initial plants and grass
  for (int i = 0; i < 300; i++) {
    addPlant(random(width), random(height)); // Add plants at random positions
  }

  frameRate(60); // Set frame rate to 60 frames per second for smoother animation
}

// The draw function runs continuously to create animation
void draw() {
  // Background transition from gloomy to sunny
  color gloomySky = color(50, 50, 100); // Dark gloomy color
  color sunnySky = color(135, 206, 250); // Bright sunny color
  background(lerpColor(gloomySky, sunnySky, dayProgress));

  // Update day progress gradually
  dayProgress += 0.001;
  if (dayProgress > 1) dayProgress = 1; // Clamp to 1 for sunny day

  // Draw the sun
  float sunX = width / 2;
  float sunY = map(dayProgress, 0, 1, height + 100, height / 4); // Sun rises as day progresses
  float sunSize = 100;
  fill(255, 223, 0, map(dayProgress, 0, 1, 0, 255)); // Sun becomes brighter
  ellipse(sunX, sunY, sunSize, sunSize);

  // Update and display each plant or grass particle
  for (int i = particles.size() - 1; i >= 0; i--) {
    Shape p = particles.get(i);
    p.update(); // Update particle position and state
    p.display(); // Display the particle

    // Remove dead particles and enable regrowth
    if (p instanceof Plant) {
      Plant plant = (Plant)p;
      if (plant.isDead()) {
        particles.remove(i);
        if (regrowthEnabled) {
          addPlant(random(width), height - random(50, 100)); // Regrow a new plant at the bottom
        }
      }
    }
  }
}

// Base class representing a generic shape
abstract class Shape {
  float x, y; // Position of the shape
  color fillColor; // Fill color of the shape

  // Constructor
  Shape(float x, float y, color fillColor) {
    this.x = x; // Set x-coordinate
    this.y = y; // Set y-coordinate
    this.fillColor = fillColor; // Set fill color
  }

  // Abstract methods to be implemented by subclasses
  abstract void update(); 
  abstract void display(); 
}

// Plant class extending Shape
class Plant extends Shape {
  float size;       // Size of the plant
  float growthRate; // Growth rate of the plant
  float lifespan;   // Lifespan of the plant

  // Constructor for Plant
  Plant(float x, float y) {
    super(x, y, color(34, 139, 34)); // Initial green color
    size = random(5, 10); // Initial size
    growthRate = random(0.1, 0.3); // Random growth rate
    lifespan = random(300, 500); // Assign a random lifespan
  }

  // Update the plant's state
  void update() {
    size += growthRate; // Increase size over time
    lifespan -= 1; // Decrease lifespan over time

    // Gradually change color to brown as the plant dies
    float progress = map(lifespan, 0, 500, 1, 0);
    fillColor = lerpColor(color(34, 139, 34), color(139, 69, 19), progress);
  }

  // Display the plant as a growing and fading rectangle
  void display() {
    noStroke();
    fill(fillColor, map(lifespan, 0, 500, 0, 255)); // Adjust transparency based on lifespan
    rect(x, y - size, size / 2, size); // Draw the plant
  }

  // Check if the plant is dead
  boolean isDead() {
    return lifespan < 0;
  }
}

// Function to add a new plant to the list
void addPlant(float x, float y) {
  particles.add(new Plant(x, y));
}
