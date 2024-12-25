ArrayList<FlowingParticle> particles;
InfinityShape infinityShape;

void setup() {
  size(800, 800);
  frameRate(60);
  noStroke();
  
  // Initialize infinity shape and flowing particles
  infinityShape = new InfinityShape(width / 2, height / 2, 200);
  particles = new ArrayList<FlowingParticle>();
  for (int i = 0; i < 200; i++) {
    particles.add(new FlowingParticle());
  }
}

void draw() {
  // Dynamic background glow
  fill(0, 20);
  rect(0, 0, width, height);

  // Update and draw infinity shape
  infinityShape.update();
  infinityShape.display();

  // Update and draw flowing particles
  for (FlowingParticle p : particles) {
    p.update(infinityShape.getTime());
    p.display(infinityShape.getTime());
  }
}

// Class for the parametric infinity shape
class InfinityShape {
  float x, y;            // Position of the shape
  float baseRadius;      // Base radius for the shape
  int layers;            // Number of layers
  float speedFactor;     // Speed factor for animation
  float baseTime;        // Base time for smooth transitions
  float lastMillis;      // Time tracking for smooth animation

  InfinityShape(float x, float y, float baseRadius) {
    this.x = x;
    this.y = y;
    this.baseRadius = baseRadius;
    this.layers = 13;
    this.speedFactor = 1.0;
    this.baseTime = 0;
    this.lastMillis = millis();
  }

  void update() {
    // Calculate elapsed time
    float currentMillis = millis();
    float deltaTime = (currentMillis - lastMillis) * 0.001;
    lastMillis = currentMillis;

    // Update base time based on speed factor
    baseTime += deltaTime * speedFactor;

    // Adjust speed factor for smooth transitions
    if (mousePressed && mouseButton == RIGHT) {
      speedFactor = max(0.2, lerp(speedFactor, 0.2, 0.05)); // Gradually slow down
    } else {
      speedFactor = min(1.0, lerp(speedFactor, 1.0, 0.05)); // Gradually speed up
    }
  }

  void display() {
    float angleStep = TWO_PI / 200; // Smoothness of each layer
    float growthRate = 6;          // Increaasing growth per layer
    float depthFactor = 40;        // Simulated Z-axis amplitude
    float verticalSpin = sin(baseTime * 0.7); // Sinusoidal vertical tilt

    for (int i = 0; i < layers; i++) {
      float radius = baseRadius + i * growthRate; // Expanding outward
      float rotationSpeed = 0.3 + i * 0.05;      // Each layer rotates faster
      float layerAngleOffset = baseTime * rotationSpeed; // Layer-specific rotation
      float z = sin(baseTime * 2 + i * 0.3) * depthFactor; // Z-axis depth

      beginShape();
      for (float angle = 0; angle < TWO_PI; angle += angleStep) {
        float distortion = sin(angle * 5 + baseTime * 2) * 20; // Add flowing distortion
        float px = x + (radius + distortion) * cos(angle + layerAngleOffset);
        float py = y + (radius + distortion) * sin(angle + layerAngleOffset);

        // Apply vertical spin perspective
        py += verticalSpin * (radius + distortion) * sin(angle);

        vertex(px, py);
      }
      endShape(CLOSE);

      // Simulate depth using stroke weight and brightness
      float thickness = map(z, -depthFactor, depthFactor, 1, 6); // Adjust thickness

      // Color time based change
      float baseHue = (baseTime * 40 + i * 15) % 255;
      stroke(color(baseHue, 200, 255 - i * 10, 200));
      strokeWeight(thickness);
      noFill();
    }
  }

  float getTime() {
    return baseTime;
  }
}

// Class for flowing particles
class FlowingParticle {
  PVector position;
  float angleOffset;
  float lifespan;
  boolean gathering;

  FlowingParticle() {
    position = new PVector(random(width), random(height));
    angleOffset = random(1000); // Unique Perlin noise offset for each particle
    lifespan = random(150, 255);
    gathering = false;
  }

  void update(float time) {
    if (gathering) {
      // Move towards mouse when gathering
      PVector target = new PVector(mouseX, mouseY);
      PVector direction = PVector.sub(target, position).normalize().mult(2);
      position.add(direction);
    } else {
      // Random movement
      float angle = noise(position.x * 0.01, position.y * 0.01, time + angleOffset) * TWO_PI * 2;
      PVector velocity = PVector.fromAngle(angle).mult(0.5); // Slower movement
      position.add(velocity);
    }

    // Wrap-around screen edges
    if (position.x > width) position.x = 0;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 0;
    if (position.y < 0) position.y = height;

    lifespan -= 0.2; // Fade particles slower
    if (lifespan < 0) lifespan = random(150, 255); // Reset lifespan
  }

  void display(float time) {
    // Smoothly changing color (different from infinity symbol)
    float r = sin(time * 0.3 + angleOffset) * 127 + 128;
    float g = sin(time * 0.4 + angleOffset + PI / 3) * 127 + 128;
    float b = sin(time * 0.5 + angleOffset + PI / 2) * 127 + 128;
    fill(r, g, b, lifespan);

    ellipse(position.x, position.y, 8, 8);
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    for (FlowingParticle p : particles) {
      p.gathering = true; // Gather particles
    }
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    for (FlowingParticle p : particles) {
      p.gathering = false; // Stop gathering particles
    }
  }
}
