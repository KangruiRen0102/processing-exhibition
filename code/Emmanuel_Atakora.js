// Theme: "A state of metamorphosis enacts new change, creating infinite bloom like a blossoming flower like a rose."

let roses = []; // Holds all the 3D roses in the scene
let caterpillars = []; // Holds all caterpillars (including transformed butterflies)
let infiniteMode = true; // Controls whether roses grow infinitely or pause

// Camera control variables
let cameraX = 0, cameraY = 0, cameraZ = 500; // Initial camera position in 3D space
let rotationX = 0, rotationY = 0; // Camera rotation angles for orbiting around the scene
let zoom = 500; // Zoom level (distance of the camera from the origin)
let prevMouseX, prevMouseY; // Stores the previous mouse positions for drag-based camera control

function setup() {
  createCanvas(800, 600, WEBGL); // Set up the canvas with 3D rendering enabled (WEBGL mode)

  // Create a few roses placed randomly in the 3D scene
  for (let i = 0; i < 5; i++) {
    let x = random(-300, 300); // Random X position in a range
    let y = random(-150, 150); // Random Y position
    let z = random(-200, 200); // Random Z position
    let size = random(30, 50); // Initial size of the rose
    let growthRate = random(0.2, 0.5); // Speed of growth
    let petals = int(random(3, 8)); // Randomize number of petals for each rose
    roses.push(new Rose(x, y, z, size, growthRate, petals)); // Add the rose to the list
  }

  // Add an initial caterpillar
  caterpillars.push(new Caterpillar(createVector(0, 200, 0))); // Position it above the roses
}

function draw() {
  background(20); // Set a dark background to make the roses and caterpillars stand out

  // Set up the camera with rotation and zoom (orbit-style view around the origin)
  camera(
    zoom * sin(rotationY) * cos(rotationX), // X position: Camera rotates horizontally
    zoom * sin(rotationX), // Y position: Camera rotates vertically
    zoom * cos(rotationY) * cos(rotationX), // Z position: Camera distance
    0, 0, 0, // Camera looks at the origin (0, 0, 0)
    0, 1, 0 // "Up" vector for the camera
  );

  // Draw and grow each rose
  for (let rose of roses) {
    rose.grow(); // Update growth based on infiniteMode
    rose.display(); // Render the rose in 3D space
  }

  // Animate and display each caterpillar or butterfly
  for (let caterpillar of caterpillars) {
    caterpillar.animate(); // Animate the caterpillar's movement or butterfly's flight
    caterpillar.display(); // Render the caterpillar or butterfly
  }
}

function mouseDragged() {
  let deltaX = mouseX - prevMouseX; // Calculate horizontal drag distance
  let deltaY = mouseY - prevMouseY; // Calculate vertical drag distance
  rotationY += deltaX * 0.01; // Adjust horizontal rotation
  rotationX -= deltaY * 0.01; // Adjust vertical rotation
  prevMouseX = mouseX; // Update previous mouse X position
  prevMouseY = mouseY; // Update previous mouse Y position
}

function mouseWheel(event) {
  let e = event.delta; // Detect scroll amount
  zoom += e * 0.05; // Adjust zoom level proportionally
  zoom = constrain(zoom, 200, 1500); // Limit zoom range for usability
}

function mousePressed() {
  // Add a new rose at a random 3D position when the user clicks
  let x = random(-300, 300);
  let y = random(-150, 150);
  let z = random(-200, 200);
  let size = random(30, 50);
  let growthRate = random(0.2, 0.5);
  let petals = int(random(3, 8));
  roses.push(new Rose(x, y, z, size, growthRate, petals)); // Add the new rose
}

function keyPressed() {
  if (key === 'i' || key === 'I') {
    infiniteMode = !infiniteMode; // Toggle the infinite bloom mode for roses
    for (let rose of roses) {
      rose.infiniteBloom = infiniteMode; // Apply the mode to all roses
    }
  }

  if (key === 'c' || key === 'C') {
    // Add a new caterpillar at a random position when the 'C' key is pressed
    caterpillars.push(new Caterpillar(createVector(random(-300, 300), 200, random(-300, 300))));
  }
}

// Class to represent a 3D caterpillar that transforms into a butterfly
class Caterpillar {
  constructor(startPosition) {
    this.position = startPosition.copy();
    this.isButterfly = false; // Indicates whether the caterpillar has transformed
    this.wingAngle = 0; // Used to animate the butterfly's wing flapping
    this.time = 0; // Animation timer for controlling movement patterns
    this.segments = 6; // Number of caterpillar segments
  }

  animate() {
    this.time += 0.02; // Increment time for animation

    // Caterpillar wiggles forward until it transforms
    if (!this.isButterfly) {
      this.position.y -= 0.5; // Move upwards
      if (this.position.y < 50) {
        this.isButterfly = true; // Trigger transformation
      }
    } else {
      // Butterfly flies in a looping pattern
      this.position.x += sin(this.time * 2) * 2; // Horizontal swaying motion
      this.position.z += cos(this.time * 2) * 2; // Circular flight
      this.wingAngle = sin(this.time * 10) * PI / 8; // Wing flapping
    }
  }

  display() {
    push();
    translate(this.position.x, this.position.y, this.position.z); // Move to the current 3D position

    if (!this.isButterfly) {
      // Draw caterpillar as a series of connected spheres
      noStroke();
      fill(50, 200, 50); // Green color for body
      for (let i = 0; i < this.segments; i++) {
        translate(0, 12, 0); // Offset for each segment
        sphere(8); // Render a sphere for each body segment
      }
    } else {
      // Draw butterfly with wings
      noStroke(); // No outline for the wings
      fill(255, 100, 150); // Pink wing color
      push();
      rotateY(this.wingAngle); // Rotate the left wing based on wingAngle
      ellipse(-20, 0, 50, 80); // Draw an ellipse for the left wing
      pop();
      push();
      rotateY(-this.wingAngle); // Rotate the right wing based on wingAngle
      ellipse(20, 0, 50, 80); // Draw an ellipse for the right wing
      pop();

      // Body
      fill(50, 50, 50); // Gray body color
      cylinder(5, 20); // Use a custom function to render the cylinder
    }

    pop();
  }
}

// Class to represent a 3D rose
class Rose {
  constructor(x, y, z, size, growthRate, petals) {
    this.position = createVector(x, y, z); // Set the initial 3D position of the rose
    this.size = size; // Set the initial size of the rose
    this.growthRate = growthRate; // Set the rate at which the rose grows
    this.petals = petals; // Define the number of petals
    this.hueValue = random(0, 1); // Initialize hueValue with a random starting point in the gradient
    this.infiniteBloom = true; // By default, the rose grows infinitely
  }

  grow() {
    if (this.infiniteBloom) this.size += this.growthRate; // Increase the size if infinite bloom is enabled
    this.hueValue += 0.001; // Smoothly transition the hueValue to cycle through colors
    if (this.hueValue > 1) this.hueValue = 0; // Loop the hueValue back to 0 when it exceeds 1

    // Reset the rose's size and properties if it grows too large
    if (this.size > 150) {
      this.size = random(30, 50); // Reset to a random smaller size
      this.petals = int(random(3, 8)); // Randomize the number of petals for variation
      this.growthRate = random(0.2, 0.5); // Randomize the growth rate
    }
  }

  display() {
    push();
    translate(this.position.x, this.position.y, this.position.z); // Move to the rose's 3D position
    noFill();
    stroke(lerpColor(color(255, 0, 0), color(138, 43, 226), this.hueValue)); // Calculate the rose's color
    strokeWeight(1.5);

    beginShape();
    for (let theta = 0; theta < TWO_PI * 6; theta += 0.01) {
      let r = this.size * cos(this.petals * theta); // Rose curve equation
      let x = r * cos(theta); // X-coordinate in polar to Cartesian conversion
      let y = r * sin(theta); // Y-coordinate
      let z = r * sin(theta / 2); // Z-coordinate adds 3D depth
      vertex(x, y, z); // Add a point to the shape
    }
    endShape(CLOSE); // Close the rose curve

    pop();
  }
}
