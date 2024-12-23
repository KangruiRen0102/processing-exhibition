let camera;
let auroraLights = [];

// CellPhoneCamera class representing the camera
class CellPhoneCamera {
  constructor(x, y, width, height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  display() {
    // Draw the camera rectangle with rounded corners
    fill(50, 50, 50); // Camera body color
    rect(this.x, this.y, this.width, this.height, 20); // Rounded rectangle

    // Camera features: recording text and a small circle
    fill(255, 0, 0); // Red color for "Recording..."
    textSize(16);
    text("Recording...", this.x + 10, this.y + 20);

    fill(250); // Small circle on the camera body
    circle(this.x + this.width - 15, this.y + this.height / 2, 10);
  }
}

// AuroraLight class representing individual light segments
class AuroraLight {
  constructor(x, y, thickness, speed) {
    this.x = x;
    this.y = y;
    this.thickness = thickness;
    this.speed = speed;
    this.waveOffset = random(0, TWO_PI);
  }

  move() {
    // Move the aurora light to the right and reset if it goes off-screen
    this.x += this.speed;
    if (this.x > width) {
      this.x = -300;
      this.waveOffset = random(0, TWO_PI);
    }
  }

  display() {
    // Display the aurora light as a curvy green line
    stroke(0, 255, 0, 50); // Green color with transparency
    strokeWeight(this.thickness);
    noFill();
    beginShape();
    for (let i = 0; i < 300; i += 5) {
      // Parametric wave effect
      let waveY = this.y + 10 * sin((this.x + i) * 0.05 + this.waveOffset);
      vertex(this.x + i, waveY);
    }
    endShape();
  }
}

function setup() {
  console.log("Setting up canvas...");
  createCanvas(1000, 600);
  background(0);

  // Initialize the camera (cell phone shape)
  camera = new CellPhoneCamera(100, 100, 400, 200);

  // Initialize the aurora lights
  for (let i = 0; i < 5; i++) {
    let startX = random(0, width);
    let startY = random(0, height);
    let thickness = random(2, 5);
    let speed = random(0.1, 0.5);
    auroraLights.push(new AuroraLight(startX, startY, thickness, speed));
  }

  console.log("Setup complete.");
}

function draw() {
  background(0); // Dark background

  // Log mouse position
  console.log(`MouseX: ${mouseX}, MouseY: ${mouseY}`);

  // Update camera position to follow the mouse
  camera.x = constrain(mouseX - camera.width / 2, 0, width - camera.width);
  camera.y = constrain(mouseY - camera.height / 2, 0, height - camera.height);

  // Log camera position
  console.log(`CameraX: ${camera.x}, CameraY: ${camera.y}`);

  camera.display(); // Display the camera

  // Display and move the aurora lights
  for (let light of auroraLights) {
    light.move();
    light.display();
  }
}
