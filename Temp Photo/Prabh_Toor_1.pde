ParticleSystem ps;
WateringCan can;
Flower flower;

// setup function
void setup() {
  size(1200, 800);
  ps = new ParticleSystem(new PVector(mouseX, mouseY));
  can = new WateringCan(new PVector(300, 150));
  spawnFlower();
}


// main draw function. 
void draw() {
  background(135, 206, 235);
  drawClouds();
  drawGround();
  can.update(mouseX, mouseY);
  
  if (mousePressed) {
    can.tilt(true);  
  } else {
    can.tilt(false);  
  }
  
  can.display();
  ps.run();
  
  if (mousePressed) {
    ps.setOrigin(can.x + can.canWidth / 2, can.y + 10);  
    for (int i = 0; i < 7; i++) {  // MORE PARTICLESSSSS
      ps.addParticle();      
    }
  }
 
  if (flower != null) {
    flower.display();
    flower.grow(ps);  
  }
}

// used to spawn the seeds and flowers.
void spawnFlower() {
  float flowerX = random(0,width-150);  // Random X position
  float flowerY = height - 100;  
  flower = new Flower(flowerX, flowerY);  // Create a new flower at the random position
}

// draws some clouds
void drawClouds() {
  fill(255, 255, 255, 200);  
  noStroke();

  ellipse(200, 100, 120, 60);
  ellipse(170, 80, 100, 50);
  ellipse(230, 90, 90, 45);
  ellipse(250, 110, 70, 35);

  ellipse(500, 70, 100, 50);
  ellipse(480, 60, 90, 45);
  ellipse(520, 80, 70, 35);
  ellipse(550, 65, 60, 30);

  ellipse(800, 130, 70, 35);
  ellipse(770, 120, 60, 30);
  ellipse(830, 120, 50, 25);
  ellipse(810, 140, 40, 20);

  ellipse(350, 180, 130, 60);
  ellipse(320, 170, 110, 50);
  ellipse(370, 160, 90, 45);
  ellipse(400, 180, 70, 35);

  ellipse(900, 70, 90, 45);
  ellipse(880, 60, 70, 35);
  ellipse(920, 80, 50, 25);
}

// draws the ground
void drawGround() {
  fill(34, 139, 34);  
  rectMode(CORNER);
  rect(0, height - 100, width, 100);
}


// This class is used to create the seed and flower, as well as dectect when water has fallen
// around it and will grow accordingly. 
class Flower {
  float x, y;
  float size;  // Stem height
  float petalSize;  // Petal size
  float maxSize;
  int growthRateStem;
  int growthRatePetals;
  boolean isAlive;
  int petalCount = 12;  // # of petals
  int growthThreshold = 5;  // # of particles for growth
  boolean isSeed = true; 

  Flower(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = 0;  
    this.petalSize = 5;  
    this.maxSize = 200;  
    this.growthRateStem = 2;  
    this.growthRatePetals = 1; 
    this.isAlive = true;
  }
  
  // Display the flower
  void display() {
    if (isSeed) {
      // This is for the seed
      fill(150, 75, 25); 
      noStroke();
      circle(x, y, 10); // Draw seed as cirlce
    } else {
      stroke(34, 139, 34);  
      strokeWeight(5);
      line(x, y, x, y - size); 

      fill(255, 204, 0);  // Yellow color for the center
      noStroke();
      ellipse(x, y - size, petalSize / 2, petalSize / 2);  // center of the flower

      fill(255, 255, 255); 
      for (int i = 0; i < petalCount; i++) {
        float angle = TWO_PI / petalCount * i;
        float petalX = x + cos(angle) * petalSize * 0.50;
        float petalY = y - size + sin(angle) * petalSize * 0.50;

        pushMatrix();
        translate(petalX, petalY);
        rotate(angle);
        ellipse(0, 0, petalSize * 0.6, petalSize * 0.3);  
        popMatrix();
      }
    }
  }

  void grow(ParticleSystem ps) {
    if (isAlive) {
      int waterHits = 0;

      // Counts how many particles hit near the flower
      for (Particle p : ps.particles) {
        if (dist(p.position.x, p.position.y, x, y) < 30) {  // Flower water radius
          waterHits++;
        }
      }

      // Seed to flower after watering
      if (isSeed && waterHits >= growthThreshold) {
        isSeed = false;  // Flower is no longer a seed
      }

      // Grow stem
      if (!isSeed && waterHits >= growthThreshold && size < maxSize) {
        size += growthRateStem;  // Increase stem size
      }

      // grow petals
      if (!isSeed && waterHits >= growthThreshold && petalSize < size * 0.75) {
        petalSize += growthRatePetals;  // Increase petal size slower
      }
    }

    // flower dies when max size
    if (size >= maxSize) {
      die();  // Flower dies when it reaches max size
    }
  }

  // as soon as the flower dies, a new one will spawn.
  void die() {
    isAlive = false;
    spawnFlower();  // Respawn the flower at a new random position
  }
}

/** I used this code given by the processing team for my particle system. 
// I edited this code to better suit my case. most importantly, make the particles go straight down rather than going up then down
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity, and fade out over time.
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */// https://processing.org/examples/simpleparticlesystem.html

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(2, 3));
    position = l.copy();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);

    // Remove particle if it hits the ground
    if (position.y >= height - 100) {
      lifespan = 0;
    }

    lifespan -= 2.0;  // Gradually decrease lifespan
  }

  // Method to display
  void display() {
    fill(0, 0, 255, lifespan);
    ellipse(position.x, position.y, 4, 6);
    strokeWeight(0);
  }

  // Is the particle still useful?
  boolean isDead() {
    return lifespan <= 0.0;
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void setOrigin(float x, float y) {
    origin.set(x-157, y+40);
  }

  void addParticle() {
    // Offset the origin slightly for each particle to simulate a small area
    float offsetX = random(-1, 1);  // Random offset for x-coordinate
    float offsetY = random(-10, 10);  // Random offset for y-coordinate
    PVector offsetOrigin = new PVector(origin.x + offsetX, origin.y + offsetY);
    particles.add(new Particle(offsetOrigin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

// end of partcile system code given by the java processing team.


// this class is used to make the watering can image and used to rotate the watering can when clicked.
class WateringCan {
  // wariable settings
  float x, y;
  float canWidth = 100;
  float canHeight = 80;
  float spoutWidth = 70;
  float spoutHeight = 20;
  float topHeight = 40;
  float handleArcWidth = 100;
  float handleArcHeight = 100;
  float spoutAngle = PI / 6; 
  boolean isRefilled = false;
  float angle = 0; 
  
  WateringCan(PVector position) {
    this.x = position.x;
    this.y = position.y;
  }

  void update(float mx, float my) {
    this.x = mx;
    this.y = my;
  }

  // Display the watering can
  void display() {
    pushMatrix(); 
    translate(x, y);
    rotate(angle);

    //Body of watering can
    fill(150, 150, 255);  
    rectMode(CENTER);
    rect(0, 0, canWidth, canHeight); 

    // Top of watering can
    fill(100, 100, 200); 
    ellipse(0, -topHeight, canWidth, topHeight);  
    
    // Opening of watering can
    fill(0);
    ellipse(0, -topHeight, 50, 20);  // Adjust position based on mouse

    // Sprout
    pushMatrix();
    translate(-45, 0); 
    rotate(spoutAngle); 
    fill(150, 150, 255);  
    rect(-spoutWidth / 2, 0, spoutWidth, spoutHeight); 
    popMatrix();

    // Watering can opening
    pushMatrix();  
    translate(-92, -172);  
    rotate(spoutAngle);  
    fill(150, 150, 255); 
    ellipse(50, 125, 20, 40);
    popMatrix(); 

    // Handle
    noFill();
    stroke(0);
    strokeWeight(3);  
    arc(0, -40, handleArcWidth, handleArcHeight, PI, TWO_PI);  

    // Reseting the stroke thicknesses
    strokeWeight(1); 
    popMatrix(); 
  }

  void tilt(boolean isTilting) {
    if (isTilting) {
      angle = -PI / 4;  // Can tilts to 45 degrees
    } else {
      angle = 0;  // can goes back to 0
    }
  }
}
