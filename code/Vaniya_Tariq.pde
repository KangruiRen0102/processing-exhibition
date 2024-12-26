// lets create a list of fish ! we choose 50 fish in total
ArrayList<Fish> fishSchool = new ArrayList<Fish>();
int numFish = 50;
PVector seaFlow;   
float noiseFactor = 0.01; 

// set up function, returns nothing 
void setup() {
  size(800, 600);  
  seaFlow = new PVector(1, 0.3); // flow of the sea in vector form 
// for loop to generate the fish and specify colors
  for (int i = 0; i < numFish; i++) {
    
    color fishColor = color(255, 165, 0);  // index for the colour orange 
    
    fishSchool.add(new Fish(random(width), random(height), fishColor, 8)); // add to the array we intialized 
  }

  color uniqueColor = color(0, 0, 255); // index for the colour blue
  fishSchool.add(new Fish(random(width), random(height), uniqueColor, 12)); // add to array
  
  color specialColor = color(255, 223, 0); // index for the colour yellow
  for (int i = 0; i < 5; i++) {  // add multiple yellow fish
    fishSchool.add(new Fish(random(width), random(height), specialColor, 10));
  }
}
// function for the background and sea flow 
void draw() {
  background(30, 144, 255); 

// generate a wave pattern using for loop
  for (int y = 0; y < height; y += 40) {
    stroke(0, 100, 255, 70);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int x = 0; x < width; x += 20) {
      float waveY = y + sin((x + frameCount) * 0.05) * 10;
      vertex(x, waveY);
    }
    endShape();
  }

  // add ocean floor details for the background
  // for loop to add the seaweed
  for (int i = 0; i < width; i += 50) {
    // generate seaweed
    stroke(34, 139, 34);
    strokeWeight(3);
    noFill();
    beginShape();
    // this loop controls the height (so the seaweed are on the floor
    // and the swaying of the weed
    for (int j = height - 40; j < height; j += 10) {
      float swayX = sin((i + frameCount) * 0.02) * 10;
      vertex(i + swayX, j);
    }
    endShape();

    // adding shells to the floor 
    fill(255, 223, 196);
    stroke(210, 180, 140);
    strokeWeight(1);
    ellipse(i, height - 20, 15, 10);
    line(i - 7, height - 20, i + 7, height - 20);  // shell detail line
  }

  // Update and display each fish
  for (Fish fish : fishSchool) {
    fish.followFlow(seaFlow);
    fish.updatePosition();
    fish.display();
  }
}

// check for mouse interaction with the blue fish and yellow fish
void mousePressed() {
  for (Fish fish : fishSchool) { 
    // find the blue fish and check if the mouse is near its position
    if (fish.fishColor == color(0, 0, 255)) {
      float distance = dist(mouseX, mouseY, fish.position.x, fish.position.y);
      if (distance < fish.size * 1.5) {  // checking click proximity
        fish.size *= 2;  // double its size
      }
    }

    // find the yellow fish and check if the mouse is near its position
    if (fish.fishColor == color(255, 223, 0)) {
      float distance = dist(mouseX, mouseY, fish.position.x, fish.position.y);
      if (distance < fish.size * 1.5) {  // checking click proximity
        fish.fishColor = color(255, 0, 0);  // change color to red
      }
    }
  }
}

// Our First class for the Fish school
class Fish {
  PVector position;   // each fish instance will get a position attribute
  PVector velocity;   // each fish instance will get a velocity attribute
  float size;         // each fish instance will have a size attribute
  color fishColor;    // each fish instance will have a color attribute
  
  // function for each instance of the fish
  // so they can have their own x and y coordinates, but floats not ints
  Fish(float x, float y, color c, float s) {
    position = new PVector(x, y);
    velocity = new PVector(random(-1.5, 1.5), random(-0.75, 0.75)); // velocity is slower 
    size = s;
    fishColor = c;
  }

// using velocity we update the location of the fish so the program can continously have the fish moving
  void updatePosition() {
    position.add(velocity);

    
    if (position.x > width) position.x = 0; // position x
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 0; // position y
    if (position.y < 0) position.y = height;
  }

  // now we want the fish to have similiar velocity to the sea
  void followFlow(PVector flow) {
    float angle = noise(position.x * noiseFactor, position.y * noiseFactor, frameCount * 0.01) * TWO_PI;
    PVector flowDirection = flow.copy().rotate(angle).normalize().mult(0.5);
    velocity.add(flowDirection);
    velocity.limit(1.5); // slower fish relative to ocean waves
  }

  // adding scales and eyeballs 
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    float angle = atan2(velocity.y, velocity.x);
    rotate(angle);

    fill(fishColor);
    noStroke();

    // draw the fish body
    beginShape();
    vertex(-size * 1.5, 0);       // back fin
    vertex(-size, size / 2);      // lower back corner
    vertex(0, size / 2);          // bottom curve
    vertex(size, size / 3);       // underside
    vertex(size * 1.5, 0);        // nose tip
    vertex(size, -size / 3);      // upper curve
    vertex(0, -size / 2);         // upper back corner
    vertex(-size, -size / 2);     // top fin
    vertex(-size * 1.5, 0);       // closing back to fin
    endShape(CLOSE);

    // eyeballs
    fill(0);  // black eyes
    ellipse(size * 0.8, -size * 0.2, size * 0.3, size * 0.3);  // position ellipse which is eye

    // fish scales
    stroke(255, 215, 0, 100);  // golden stroke for scales
    noFill();
    for (float i = -size * 1.2; i < size * 0.5; i += size * 0.3) {
      for (float j = -size * 0.6; j < size * 0.6; j += size * 0.3) {
        ellipse(i, j, size * 0.3, size * 0.3);
      }
    }

    popMatrix();
  }
}
