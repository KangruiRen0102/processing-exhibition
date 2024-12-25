float mugCenterX = 400, mugCenterY = 400; // Mug center
float liquidLevel = 330; // height for steam and marshmellow flot reference
ArrayList<SteamParticle> steamParticles = new ArrayList<>(); // Steam particles

int numMarshmallows = 5; // Number of marshmallows
Marshmallow[] marshmallows = new Marshmallow[numMarshmallows];
Marshmallow selectedMarshmallow = null; // Currently dragged marshmallow
float marshmallowSize = 50;

void setup() {
  size(800, 800); // Canvas size
  frameRate(60);  // Set a higher frame rate for smoother animation
  
  for (int i = 0; i < numMarshmallows; i++) {
    float startX = mugCenterX + random( -17, 17)*9; // Random horizontal position within the width of the cup
    float startY = random(0, 400);  // Random vertical position 
    marshmallows[i] = new Marshmallow(startX, startY, marshmallowSize); // have marshmellows spawn at different places, various places
  }
}


void draw() {
  background(135, 206, 235); // Light gray background
  drawTable(); //deaq the table
  drawCup(); // Draw the cup and saucer

  // Display and interact with marshmallows
  for (Marshmallow m : marshmallows) {
    m.update();
    m.display();
  } 
  drawSteam(); // Draw animated steam
}

void drawTable() {
  stroke(0); // Black outline 
  strokeWeight(2);
  fill(255); // White color
  rect(0, 550, 800, 800);
}

void drawCup() {
  
  //saucer
  stroke(0); 
  strokeWeight(2);
  fill(255);
  ellipse(400, 700, 600, 290); // Saucer beneath the cup
  noStroke(); 
  fill(0, 0, 0, 50); // Semi-transparent black for shadow
  ellipse(400, 700, 440, 190); // Shadow beneath the cup
  
  // Draw the cup
  stroke(0); // Black outline 
  strokeWeight(2);
  fill(255); // White color
  rect(380, 355, 340, 205, 30); // handle
  stroke(0); // Black outline 
  strokeWeight(2);
  fill(135, 206, 235); // White color
  stroke(0); // Black outline 
  strokeWeight(2);
  rect(375, 370, 320, 175, 20); // handle/background
  fill(255); // White color
  rect(175, 350, 450, 250); // cup body 
  ellipse(400, 600, 450, 300);// cup bottom
  noStroke();
  fill(255);
  ellipse(400.5, 585, 448, 300);// cup bottom
  stroke(0); // Black outline
  strokeWeight(2);
  fill(255); // white
  ellipse(400, 350, 450, 180); // cup top
  
  
  // Draw the liquid 
  noStroke(); // No outline for the cup body itself
  fill(150, 75, 0); // Brown color for the cup
  ellipse(400, 355, 410, 165); // 
  fill(80, 40, 0); // Dark brown color for liquid (coffee or hot chocolate)
  ellipse(400, 355, 400, 155); // Liquid inside the cup
  
}

// Function to draw the steam particles
void drawSteam() {
  if (frameCount % 10 == 0) {  // Change the interval to add more steam particles
    steamParticles.add(new SteamParticle(mugCenterX, liquidLevel - 30));
  }

  // Update and display all steam particles
  for (int i = steamParticles.size() - 1; i >= 0; i--) {
    SteamParticle p = steamParticles.get(i);
    p.update();
    p.display();

    // Remove particles that fade away
    if (p.lifespan <= 0) {
      steamParticles.remove(i);
    }
  }
}

class SteamParticle {
  float x, y;       // Position
  float vx, vy;     // Velocity
  float lifespan;   // Opacity and life duration
  float noiseOffset; // Offset for squiggly movement

  SteamParticle(float startX, float startY) {
    x = startX + random(-100, 100); // Slight horizontal variation
    y = startY + random(-50, 50);
    vx = random(-0.5, 0.5);       // Small horizontal drift
    vy = random(-1, -5);          // Rising motion
    lifespan = 150;               // Initial opacity
    noiseOffset = random(1000);  // Random offset
  }

  void update() {
    x += vx;
    y += vy;
    lifespan -= 1; // Gradually fade out

    // Adding squiggly movement based on offest
    vx = map(noise(noiseOffset), 0, 1, -1, 1); // squiggly motion
    vy = map(noise(noiseOffset + 100), 0, 1, -1, -2); // Slightly different noise for vertical movement
    noiseOffset += 1; // Increment noiseOffset for continuous squiggle effect
  }

  void display() {
    noStroke();
    fill(255, lifespan); // White with fading opacity as steam fades away 
    
    // Draw a squiggly line using small segments
    float squiggleLength = 40;  // Length of each squiggle segment
    for (int i = 0; i < squiggleLength; i++) {
      float sx = x + i * cos(PI / 6)*0.5; // X offset to make it look squiggly
      float sy = y + i * sin(PI / 6)*0.5; // Y offset for the squiggly motion
      ellipse(sx, sy, 6, 12); // Draw the small segments as ellipses
    }
  }
}


void mousePressed() { //function for when the marshmellows are picked up
  for (Marshmallow m : marshmallows) {
    if (m.isHovered(mouseX, mouseY)) { //when mouse is on marshmellow and clicked marshmellow becomes attached to mouse
      selectedMarshmallow = m;
      selectedMarshmallow.isFloating = false; // Stop floating when dragged
      break;
    }
  }
}

void mouseDragged() {
  // Drag marshmallow
  if (selectedMarshmallow != null) {
    selectedMarshmallow.x = mouseX;
    selectedMarshmallow.y = mouseY; //moving mouse with marshmellow
  }
}

void mouseReleased() {
  // Drop marshmallow
  if (selectedMarshmallow != null) {
    selectedMarshmallow.x = constrain(selectedMarshmallow.x, mugCenterX - 130, mugCenterX + 130); //marshmellows will flall back within the cup
    selectedMarshmallow.isFloating = true; // Re-enable floating (bouncing up and down)
  }
}

class Marshmallow {
  float x, y;            // Position
  float vy = 0;          // Vertical velocity
  float size;            // Size of the marshmallow
  boolean isFloating = true; // If floating on liquid
  float randomFloatOffset;  // Vertical offset for settling
  float floatingSpeed;     // Speed at which marshmallow floats
  boolean hasSettled = false; // Flag to determine if marshmallow has settled
  float targetY;            // The final resting Y position

  Marshmallow(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size; // Initialize size
    this.randomFloatOffset = random(-5, 35)*2; // variability in the y as to where the marshmellow sits
    this.floatingSpeed = random(0.05, 0.1);  // Random speed for floating
    this.targetY = liquidLevel + randomFloatOffset; // resting point for each marshmallow with each one having random y values 
  }

  void update() {
    if (isFloating) {
      // Apply gravity until marshmallow reaches the liquid level
      if (y < liquidLevel - size / 2 && !hasSettled) {
        vy += 0.5; // Gravity did not work (didnt want to create a colision mesh to stop gravity and sistince it with it floating on water)
      } else {
        // Once marshmallow reaches liquid level, stop gravity and settle it
        if (!hasSettled) {
          // Settle each marshmallow at a distinct height
          y = targetY; // Set the marshmallow at its distinct resting height
          vy = 0; // Stop vertical velocity when settled
          hasSettled = true; // Marshmallow has settled at its floating height
        }

        // Smooth oscillation around the targetY position
        float drift = sin(frameCount * 0.05) * 5; // Smoother oscillation
        y = targetY + drift; // Apply the smooth drift to the targetY position
      }
      
      // Ensure marshmallow stays near the target Y without jumping
      y += vy; // Update the Y position based on vertical velocity
    }
  }

  void display() {
    stroke(0); // Black outline
    strokeWeight(2);
    fill(255); // White marshmallow color
    ellipse(x, y, size, size * 0.6); // Elliptical shape for 3D effect
  }

  boolean isHovered(float mx, float my) {
    // Check if mouse is hovering over the marshmallow
    return dist(mx, my, x, y) < size / 2;
  }
}
