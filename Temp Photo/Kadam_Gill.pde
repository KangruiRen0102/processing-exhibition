int numShards = 100; // Number of shards
Shard[] shards; // Array to store shard instances
PImage[] memoryImages = new PImage[5]; // Array to store memory images

void setup() {
  size(800, 800, P3D);
  noStroke();
  hint(ENABLE_DEPTH_SORT);

  // Load memory-like images
  memoryImages[0] = loadImage("memory1.jpg");
  memoryImages[1] = loadImage("memory2.jpg");
  memoryImages[2] = loadImage("memory3.jpg");
  memoryImages[3] = loadImage("memory4.jpg");
  memoryImages[4] = loadImage("memory5.jpg");

  // Initialize shards
  shards = new Shard[numShards];
  for (int i = 0; i < numShards; i++) {
    float angle = random(TWO_PI); // Random angle around the vertical axis
    float radius = random(300, 500); // Distance from the vertical axis
    float height = random(-500, 500); // Vertical position
    shards[i] = new Shard(
      new PVector(radius * cos(angle), height, radius * sin(angle)), // Cylindrical position
      random(TWO_PI), // Rotation
      random(50, 75), // Size range
      memoryImages[floor(random(memoryImages.length))] // Random memory image
    );
  }
}

void draw() {
  background(0);
  lights();

  translate(width / 2, height / 2, 0); // Center the scene
  rotateY(frameCount * 0.01); // Rotate for the cylindrical revolving effect

  // Update and draw all shards
  for (Shard shard : shards) {
    shard.update();
    shard.display();
  }
}

// Add keyboard controls for zoom
void keyPressed() {
  if (key == 'w') translate(0, 0, 50); // Zoom in
  if (key == 's') translate(0, 0, -50); // Zoom out
}

// Shard class
class Shard {
  PVector position;
  float rotation;
  float size;
  PImage memoryImage;
  PVector[] vertices; // Store precomputed vertices

  Shard(PVector position, float rotation, float size, PImage memoryImage) {
    this.position = position;
    this.rotation = rotation;
    this.size = size;
    this.memoryImage = memoryImage;
    this.vertices = new PVector[5]; // Create an array to store the shard's vertices

    // Generate random vertices once during initialization
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = new PVector(
        random(-size, size),
        random(-size, size),
        random(-size / 5, size / 5)
      );
    }
  }

  // Update shard position and rotation
  void update() {
    rotation += 0.01; // Increment rotation for spinning effect
  }

  // Display the shard
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateX(rotation);
    rotateY(rotation * 0.5);
    rotateZ(rotation * 0.3);

    // Draw shard
    fill(200, 200, 255, 150); // Glass-like transparency
    beginShape();
    for (PVector v : vertices) {
      vertex(v.x, v.y, v.z); // Use precomputed vertices
    }
    endShape(CLOSE);

    // Draw memory image reflection
    beginShape(QUADS);
    texture(memoryImage);
    vertex(-size / 2, -size / 2, 0, 0, 0);
    vertex(size / 2, -size / 2, 0, memoryImage.width, 0);
    vertex(size / 2, size / 2, 0, memoryImage.width, memoryImage.height);
    vertex(-size / 2, size / 2, 0, 0, memoryImage.height);
    endShape();
    popMatrix();
  }
}
