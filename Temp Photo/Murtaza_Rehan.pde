// Advanced Aurora, Twilight, and Sea Visual Art
// Theme: "A mesmerizing twilight sky illuminated by the aurora, reflecting over a serene sea."

// Global variables for controlling animation and object creation
float twilightFactor = 0; // Variable to animate the twilight sky gradient
ArrayList<AuroraWave> auroras = new ArrayList<>(); // Stores aurora waves
ArrayList<Star> stars = new ArrayList<>(); // Stores star objects
ArrayList<ShootingStar> shootingStars = new ArrayList<>(); // Stores shooting stars
ArrayList<Wave> waves = new ArrayList<>(); // Stores sea wave objects
float moonX, moonY; // Variables for moon position

// Angles and amplitudes for the wave calculations and movement
float angle = 0;
float angle1 = 90;
float angle2 = 180;
float amplitude = 4; // Wave size for the first layer
float amplitude1 = 7; // Wave size for the second layer
float amplitude2 = 5; // Wave size for the third layer

// Color definitions for the sea gradient
color seaColor1 = color(16, 3, 57); // Dark blue sea color
color seaColor2 = color(22, 4, 67); // Slightly lighter blue for sea waves
color seaColor3 = color(25, 5, 75); // Even lighter blue for upper waves

void setup() {
    size(800, 600); // Set canvas size
    frameRate(30); // Set frame rate for animation

    // Initialize aurora waves with random properties
    for (int i = 0; i < 5; i++) {
        auroras.add(new AuroraWave(random(width), random(50, 150), random(2, 5), random(100, 300)));
    }

    // Create stars at random positions in the top half of the screen
    for (int i = 0; i < 200; i++) {
        stars.add(new Star(random(width), random(height / 2)));
    }

    // Create a few shooting stars with random speeds and positions
    for (int i = 0; i < 3; i++) {
        shootingStars.add(new ShootingStar(random(width), random(height / 2), random(3, 5)));
    }

    // Generate waves with random amplitudes and speeds
    for (int i = 0; i < 3; i++) {
        waves.add(new Wave(random(0, width), height - 80, random(100, 200), random(0.0025, 0.01)));
    }

    // Position the moon at the center-top of the screen
    moonX = width / 2;
    moonY = height / 4;
}

void draw() {
    drawTwilight(); // Draw the twilight sky gradient animation
    // Animate each star, making them twinkle
    for (Star star : stars) {
        star.twinkle();
    }
    // Update and display each shooting star's position and trail
    for (ShootingStar shootingStar : shootingStars) {
        shootingStar.update();
        shootingStar.display();
    }
    // Update and display each aurora wave
    for (AuroraWave wave : auroras) {
        wave.update();
        wave.display();
    }
    drawMountains(); // Draw the background mountains
    drawMoon(); // Draw the moon
    drawWater1(); // Draw the first layer of sea waves
    drawWater2(); // Draw the second layer of sea waves
    drawWater3(); // Draw the third layer of sea waves
    drawTrees(); // Draw trees in the foreground
}

// Mouse pressed event to interactively change aurora wave amplitude
void mousePressed() {
    for (AuroraWave aurora : auroras) {
        aurora.amplitude = random(50, 200); // Randomly change amplitude when clicked
    }
}

void drawTwilight() {
    // Create the gradient sky transition from warm to cool colors
    for (int y = 0; y < height; y++) {
        float inter = map(y, 0, height, 0, 1);
        color c1 = lerpColor(color(255, 150, 150), color(50, 50, 150), inter); // Warm to cool
        color c2 = lerpColor(color(50, 50, 150), color(0, 0, 0), inter); // Cool to black
        stroke(lerpColor(c1, c2, twilightFactor));
        line(0, y, width, y); // Draw the gradient effect line by line
    }
    twilightFactor += 0.0003; // Gradual change in twilight animation
    if (twilightFactor > 1) twilightFactor = 0; // Reset when fully completed
}

// AuroraWave class to represent individual aurora waves
class AuroraWave {
    float xOffset, y, speed, amplitude, hue;

    AuroraWave(float xOffset, float y, float speed, float amplitude) {
        this.xOffset = xOffset;
        this.y = y;
        this.speed = speed;
        this.amplitude = amplitude;
        this.hue = random(150, 250); // Random color for aurora
    }

    void update() {
        xOffset -= speed; // Move aurora wave horizontally
        if (xOffset < -width) xOffset = width; // Loop aurora wave position
        hue += 0.1; // Gradually change color
        if (hue > 300) hue = 150; // Reset color hue when it exceeds limit
    }

    void display() {
        noFill(); // No fill for aurora wave lines
        strokeWeight(2); // Set stroke thickness
        for (int i = 0; i < 30; i++) {
            stroke(color(hue, 200, 255, 100 - i * 3)); // Aurora color with fading transparency
            beginShape();
            for (float x = 0; x < width; x += 10) {
                float offset = xOffset + x;
                float yPos = y + sin(offset * 0.01) * amplitude;
                vertex(x, yPos - i * 2); // Draw wavy lines for aurora effect
            }
            endShape();
        }
    }
}

// Class for stars that twinkle in the sky
class Star {
    float x, y, brightness, blinkSpeed;

    Star(float x, float y) {
        this.x = x;
        this.y = y;
        this.brightness = random(150, 255); // Random initial brightness
        this.blinkSpeed = random(0.01, 0.03); // Random blink speed
    }

    void twinkle() {
        brightness += sin(frameCount * blinkSpeed) * 5; // Brightness varies with time
        fill(brightness, brightness, 255); // White/blue color for stars
        noStroke();
        ellipse(x, y, 3, 3); // Draw a small ellipse to represent the star
    }
}

// ShootingStar class for the shooting stars effect
class ShootingStar {
    float x, y, speed;

    ShootingStar(float x, float y, float speed) {
        this.x = x;
        this.y = y;
        this.speed = speed;
    }

    void update() {
        x -= speed; // Shooting star moves horizontally
        y += speed * 0.5; // Shooting star moves diagonally
        // Reset position when it moves off-screen
        if (x < 0 || y > height) {
            x = random(width, width * 1.5); // Reappear from the right
            y = random(height / 2); // Reappear in the upper half of the screen
        }
    }

    void display() {
        stroke(255, 255, 150); // Yellow color for the shooting star
        strokeWeight(2); // Line thickness
        line(x, y, x + 10, y - 5); // Draw the shooting star
    }
}

void drawMoon() {
    noStroke();
    for (int i = 50; i > 0; i--) {
        fill(255, 240, 150, map(i, 50, 0, 50, 0));
        ellipse(moonX, moonY, 100 + i, 100 + i);
    }
    fill(255, 240, 150, 200);
    ellipse(moonX, moonY, 100, 100);
}

class Wave {
    float xPos, yPos, amplitude, speed, waveOffset;

    Wave(float xPos, float yPos, float amplitude, float speed) {
        this.xPos = xPos;
        this.yPos = yPos;
        this.amplitude = amplitude;
        this.speed = speed;
        this.waveOffset = random(0, 100);
    }

    void update() {
        waveOffset += speed;
    }

    void display() {
        fill(lerpColor(seaColor1, seaColor3, random(0.5, 0.8)));
        beginShape();
        for (float x = 0; x < width; x += 10) {
            float yWave = yPos + sin(waveOffset + x * 0.02) * amplitude;
            vertex(x, yWave);
        }
        vertex(width, height);
        vertex(0, height);
        endShape(CLOSE);
    }
}

void drawWater1() {
    push();
    translate(0, amplitude * sin(angle));
    angle += 0.25;

    fill(seaColor1);
    beginShape();
    vertex(0, height - 60);
    vertex(width, height - 60);
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    pop();
}

void drawWater2() {
    push();
    translate(0, amplitude1 * sin(angle1));
    angle1 += 0.5;

    fill(seaColor2);
    beginShape();
    vertex(0, height - 40);
    vertex(width, height - 40);
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    pop();
}

void drawWater3() {
    push();
    translate(0, amplitude2 * sin(angle2));
    angle2 += 0.75;

    fill(seaColor3);
    beginShape();
    vertex(0, height - 15);
    vertex(width, height - 15);
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    pop();
}


// ------------- MOUNTAINS -------------

void drawMountains() {
  noStroke();
  
  // 1st set of mountains (farthest back)
    fill(65, 22, 65);
  beginShape();
  vertex(0, height / 1.3);
  vertex(50, height / 1.7);
  vertex(100, height / 1.8);
  vertex(150, height / 1.7);
  vertex(200, height / 1.9);
  vertex(250, height / 2.1);
  vertex(300, height / 2.3);
  vertex(350, height / 2.1);
  vertex(400, height / 2.0);
  vertex(450, height / 1.8);
  vertex(500, height / 1.7);
  vertex(550, height / 1.8);
  vertex(600, height / 2.0);
  vertex(650, height / 1.8);
  vertex(700, height / 1.7);
  vertex(750, height / 1.8);
  vertex(800, height / 1.7);
  vertex(width, height);
  endShape(CLOSE);
  
  // 2nd set of mountains (slightly closer)
  fill(46, 16, 46);
  beginShape();
  vertex(0, height / 1.4);
  vertex(50, height / 1.7);
  vertex(100, height / 1.6);
  vertex(150, height / 1.5);
  vertex(200, height / 1.5);
  vertex(250, height / 1.7);
  vertex(300, height / 2.0);
  vertex(350, height / 1.8);
  vertex(400, height / 1.7);
  vertex(450, height / 1.6);
  vertex(500, height / 1.6);
  vertex(550, height / 1.5);
  vertex(600, height / 1.7);
  vertex(650, height / 1.6);
  vertex(700, height / 1.5);
  vertex(750, height / 1.6);
  vertex(800, height / 1.7);
  vertex(width, height);
  endShape(CLOSE);
  
  // 3rd set of mountains (closer)
  fill(39, 13,39);
  beginShape();
  vertex(0, height / 1.4);
  vertex(50, height / 1.6);
  vertex(100, height / 1.5);
  vertex(150, height / 1.4);
  vertex(200, height / 1.4);
  vertex(250, height / 1.5);
  vertex(300, height / 1.7);
  vertex(350, height / 1.6);
  vertex(400, height / 1.5);
  vertex(450, height / 1.4);
  vertex(500, height / 1.4);
  vertex(550, height / 1.5);
  vertex(600, height / 1.4);
  vertex(650, height / 1.3);
  vertex(700, height / 1.2);
  vertex(750, height / 1.3);
  vertex(800, height / 1.3);
  vertex(width, height);
  endShape(CLOSE);
  
  // 4th set of mountains (even closer)
  beginShape();
  fill(23 ,7,23);
  vertex(0, height / 1.3);
  vertex(50, height / 1.6);
  vertex(100, height / 1.4);
  vertex(150, height / 1.3);
  vertex(200, height / 1.3);
  vertex(250, height / 1.4);
  vertex(300, height / 1.6);
  vertex(350, height / 1.5);
  vertex(400, height / 1.4);
  vertex(450, height / 1.3);
  vertex(500, height / 1.3);
  vertex(550, height / 1.3);
  vertex(600, height / 1.4);
  vertex(650, height / 1.3);
  vertex(700, height / 1.2);
  vertex(750, height / 1.4);
  vertex(800, height / 1.3);
  vertex(width, height);
  endShape(CLOSE);
  
  // 5th set of mountains (closest)
  fill(26,7,26);
   beginShape();
  vertex(0, height / 1.2);
  vertex(50, height / 1.6);
  vertex(100, height / 1.4);
  vertex(150, height / 1.3);
  vertex(200, height / 1.2);
  vertex(250, height / 1.4);
  vertex(300, height / 1.6);
  vertex(350, height / 1.5);
  vertex(400, height / 1.4);
  vertex(450, height / 1.2);
  vertex(500, height / 1.3);
  vertex(550, height / 1.2);
  vertex(600, height / 1.4);
  vertex(650, height / 1.3);
  vertex(700, height / 1.2);
  vertex(750, height / 1.4);
  vertex(800, height / 1.3);
  vertex(width, height);
  endShape(CLOSE);
}



// ------------- TREES -------------
void drawTrees() {
  
  // First row of trees
    fill(19,1,15);                                  
  for (int x = 0; x < width; x += 30) {
    float treeHeight = map(abs(x - width / 2), 0, width / 2.5, 30, 150); // Adjusted height range
    drawTree(x, height - 100, treeHeight); // Use adjusted height for each tree
  }
  
   //Second row of trees (shifted downward)
  fill(11, 0,10);  // Dark grey color for the second row
  for (int x = 0; x < width; x += 30) {
    float treeHeight = map(abs(x - width / 2), 0, width / 2, 10, 130); // Same adjusted height for the second row
    drawTree(x, height - 70, treeHeight); // Use adjusted height for each tree
  }
  
  // third row of trees (shifted downward)
  fill(4,0,4);  // Dark grey color for the second row
  for (int x = 0; x < width; x += 30) {
    float treeHeight = map(abs(x - width / 2), 0, width / 2, 5, 70); // Same adjusted height for the second row
    drawTree(x, height - 50, treeHeight); // Use adjusted height for each tree
  }
}

void drawTree(float x, float y, float size) {
  triangle(x, y, x - size / 2, y + size, x + size / 2, y + size); // Bottom part
  triangle(x, y - size / 3, x - size / 3, y + size / 3, x + size / 3, y + size / 3); // Middle part
  triangle(x, y - size * 2 / 3, x - size / 4, y, x + size / 4, y); // Top part
  rect(x - size / 10, y + size, size / 5, size / 4); // Trunk
}
