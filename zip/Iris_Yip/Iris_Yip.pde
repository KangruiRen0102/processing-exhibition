// CellPhoneCamera class representing the camera
// Class defines the blueprint for a cellphone camera. Instances represent individual cameras.
class CellPhoneCamera {
  float x, y, width, height; // Properties of the camera: position and size

  // Constructor initializes the position and dimensions of the camera
  CellPhoneCamera(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  void display() {
    // Draw the camera rectangle with rounded corners
    fill(50, 50, 50); // look like highest brightness in cellphone
    rect(x, y, width, height, 20); // rectangle with rounded corners (cell phone)

    // cell phone features (recording notice and small circle)
    fill(255, 0, 0); // Red color word
    textSize(16);
    text("Recording...", x + 10, y + 20); 

    fill(250); // Small circle on the camera body
    circle(x + width - 15, y + (height / 2), 10);
  }
}

// AuroraLight class representing individual light segments
// Class encapsulates behavior of aurora lights using parametric relationships and dynamic updates.
class AuroraLight {
  float x, y, thickness, speed, waveOffset; // Properties of aurora light

  // Constructor to initialize the aurora light's properties
  AuroraLight(float x, float y, float thickness, float speed) {
    this.x = x; 
    this.y = y;
    this.thickness = thickness;
    this.speed = speed; 
    this.waveOffset = random(0, TWO_PI); 
  }

  void move() {
    // Move the aurora light to the right and reset if it goes off-screen
    x = x + speed; 
    if (x > width) { 
      x = -300; 
      waveOffset = random(0, TWO_PI); 
    }
  }

  void display() {
    // Display the aurora light as a curvy green line
    stroke(0, 255, 0, 50); 
    strokeWeight(thickness); 
    noFill(); 
    beginShape(); 
    for (float i = 0; i < 300; i = i + 5) { 
      // Parametric-based relation defining the wave effect
      float waveY = y + 10 * sin((x + i) * 0.05 + waveOffset); 
      vertex(x + i, waveY); 
    }
    endShape(); 
  }
}

// Global variables for the camera and aurora lights
CellPhoneCamera camera; // Instance of CellPhoneCamera class
ArrayList<AuroraLight> auroraLights; // Collection of AuroraLight instances

void setup() {
  size(1000, 600); 
  background(0); 

  // Initialize the camera (cell phone shape)
  camera = new CellPhoneCamera(100, 100, 400, 200); // Create an instance of the CellPhoneCamera class

  // Initialize the aurora lights
  auroraLights = new ArrayList<AuroraLight>(); // Create a list to hold instances of AuroraLight
  for (int i = 0; i < 5; i++) {
    // Parametric definitions for aurora properties
    float startX = random(0, width); 
    float startY = random(0, height); 
    float thickness = random(2, 5); 
    float speed = random(0.1, 0.5); 
    auroraLights.add(new AuroraLight(startX, startY, thickness, speed)); 
  }
}

// What if the mouse moves to the edge of the screen?
// The camera will adjust its position, ensuring it doesn't leave the visible area.
void draw() {
  background(0); // Dark background outside the camera

  camera.x = mouseX - camera.width / 2; 
  camera.y = mouseY - camera.height / 2; 

  camera.display(); // Call the display method of the camera instance

  clip(camera.x, camera.y, camera.width, camera.height); 


  // Display and move the aurora lights
  for (AuroraLight light : auroraLights) { 
    light.move(); 
    light.display(); 
  }


  noClip(); 
}
