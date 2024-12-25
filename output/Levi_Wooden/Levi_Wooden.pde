// Random Line generation
float noiseX1 = 0;
float noiseY1 = 1000;
float noiseX2 = 0;
float noiseY2 = 1000;
ArrayList<Vine> vines;

// Trapezoid Dimensions
float topWidth = 150;   // Width of the top side
float baseWidth = 100;  // Width of the base side
float Height = 250;     // Height of the shape
float angle1 = 0;       // Current rotation angle
float targetAngle = radians(61); // Target angle to stop rotation
boolean isRotating = false; // Flag to track if rotation is active
boolean showChaoticLines = true; // Flag to toggle chaotic lines

Button rotateButton;

void setup() {
  size(1200, 800);
  rotateButton = new Button("Rotate", width / 2 - 50, height - 60, 100, 40);
  vines = new ArrayList<Vine>();
  vines.add(new Vine(width / 10, height / 2)); // Start a vine near the left
}

void draw() {
 //gradient colors
  color c1 = color(0, 0, 0); // Start color (red)
  color c2 = color(0, 0, 150); // End color (blue)

  drawGradient(0, 0, width, height, c1, c2);
  
  //more Dimensions for the cup
  float centerX = width / 2;
  float centerY = height - Height / 2 - 100;

  float topLeftX = centerX - topWidth / 2;
  float topRightX = centerX + topWidth / 2;
  float baseLeftX = centerX - baseWidth / 2;
  float baseRightX = centerX + baseWidth / 2;
  float topY = centerY - Height / 2;
  float baseY = centerY + Height / 2;


//background
  fill(0);
  noStroke();
  quad(0, baseY, width, baseY, width, height, 0, height);

  // Draw button
  rotateButton.display();
  
  //Rotating the Cup
  if (isRotating && angle1 < targetAngle) {
    angle1 += radians(1.5);
    if (angle1 >= targetAngle) {
      angle1 = targetAngle; // Ensure it stops exactly at the target angle
      isRotating = false; // Stop rotating
    }
  }

  // Apply rotation around the base point
  translate(baseRightX, baseY);
  rotate(angle1);
  translate(-baseRightX, -baseY);
  

  // Disable chaotic lines when rotating
  if (showChaoticLines && !isRotating && mousePressed) {
    drawChaoticLines(centerX, centerY, topY);
   
  }
  
//draw cup
  drawCup(topLeftX, topRightX, baseLeftX, baseRightX, topY, baseY, centerX, centerY);

//draw vines over the cup
    if (!showChaoticLines && !isRotating) {
        for (int i = vines.size() - 1; i >= 0; i--) {
    Vine v = vines.get(i);
    v.grow();

    if (v.shouldBranch()) {
      vines.add(v.branch()); // Add a new vine branch
    }

    if (v.isDead()) {
      vines.remove(i); // Remove dead vines
    } else {
      v.display();
    }
  } 
   
  }
}

void mousePressed() {
  if (rotateButton.isMouseOver()) {
    isRotating = true;         // Start rotation
    showChaoticLines = false;  // Disable chaotic lines
    angle1 = 0;                // Reset rotation angle
  }
}

// defines the corners of the cups and uses eclipses for the handles
void drawCup(float topLeftX, float topRightX, float baseLeftX, float baseRightX, float topY, float baseY, float centerX, float centerY) {
  stroke(153, 76, 0);
  fill(153, 76, 0);
  ellipse(centerX, centerY - 25, 250, 150);
  fill(51, 0, 102);
  ellipse(centerX, centerY - 25, 200, 100);
  fill(153, 76, 0);
  // Draw the trapezoid  
  quad(topLeftX, topY, topRightX, topY, baseRightX, baseY, baseLeftX, baseY);
  quad(topLeftX - 20, topY - 20, topRightX + 20, topY - 20, topRightX, topY, topLeftX, topY);
}

// A bunch of drawings for the chaotic lines. Its a noise generator and then manipulated a couple different ways to create more lines. 
//Hindsight I wouldve done it closer to how the vines are
void drawChaoticLines(float centerX,float centerY,float topY) {
        noFill(); //Line Look
      stroke(0);
      strokeWeight(3);
      //adding Randomness
      int numLines = 8;

  // Draw multiple lines from random points to the specified point
  for (int i = 0; i < numLines; i++) {  
    //creating noise variation in the points
      float targetX1 = mouseX + map(noise(noiseX1+i*3), 0, 1, -150, 150);
      float targetY1 = mouseY + map(noise(noiseY1+i*3), 0, 1, -150, 150); 
      
      float targetX2 = mouseX + map(noise(noiseX2+i*i/5), 0, 1, -300, 300);
      float targetY2 = mouseY + map(noise(noiseY2+i*i/5), 0, 1, -300, 300); 
    // Start drawing the shape, Line 1
    strokeWeight(5);
    beginShape();
    // Define multiple points for the line to go through
    vertex(targetX1, targetY1);   // First point
    vertex(targetX1+45, targetX1+100);   // Second point
    vertex(targetY1, targetX1);   // Third point
    vertex(400+targetX1*0.5, 300-targetY1/10);   // Fourth point
    vertex(centerX-i*10,topY-20);    // Center of Cup
    // End the shape, drawing the line through all the points
    endShape();
    strokeWeight(1);
    //color of line 2
    stroke(i*50,i*20,i*20);
    beginShape();
    // Define multiple points for the second line to go through
    vertex(targetY1-i*100, targetY1+targetX1/10);   // First point
    vertex(targetY1+45, targetY2);   // Second point
    vertex(targetY2, targetX2);   // Third point
    vertex(400+targetX2*0.5*i, 30-targetY2*0.35/10);   // Fourth point
    vertex(centerX+i*10, topY-20);    // Center of Cup
    // End the shape, drawing the line through all the points
    endShape();
    strokeWeight(2);
    //3rd type of line
    beginShape();
    // Define multiple points for the line to go through
    vertex(targetX1, targetY1);   // First point
    vertex(targetX1+457, targetX1+100);   // Second point
    vertex(targetY1+150, targetX1);   // Third point
    vertex(400+targetX1*0.5, 30-targetY1/10);   // Fourth point
    vertex(centerX-i*10, topY-20);    // Center of Cup
    // End the shape, drawing the line through all the points
    endShape();
    strokeWeight(3);
    //4th line
    stroke(i*70,i*20,i*20);
    beginShape();
    // Define multiple points for the line to go through
    vertex(-targetY1-i*100, targetY1+targetX1/10);   // First point
    vertex(-targetY1+45, targetY2/10);   // Second point
    vertex(-targetY2, targetX2/10);   // Third point
    vertex(-400+targetX2*0.5*i, 300-targetY2*0.35);   // Fourth point
    vertex(centerX+i*10, topY-20);    // Center of Cup
    // End the shape, drawing the line through all the points
    endShape();

  }
    // incrementing randomness
      noiseX1 += 0.05;
      noiseY1 += 0.05;
      noiseX2 += 0.07;
      noiseY2 += 0.02;
    
}

// Simple Button Class
class Button {
  String label;
  float x, y, w, h;

  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(200);
    rect(x, y, w, h, 5);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2);
  }

  boolean isMouseOver() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}

//background color gradient
void drawGradient(float x, float y, float w, float h, color c1, color c2) {
  for (int i = 0; i < h; i++) {
    float inter = map(i, 0, h, 0, 1); // Interpolation factor
    color c = lerpColor(c1, c2, inter); // Interpolate between colors
    stroke(c);
    line(x, y + i, x + w, y + i); // Draw a horizontal line
  }
}
//creating a class for the vines
class Vine {
  ArrayList<PVector> segments; // Store the points of the vine
  color vineColor;
  float thickness;
  float curlFactor; // Determines the curliness
  float waveOffset; // Offset for sinusoidal growth
  int age;          // Tracks the vine's age
  int maxAge;       // Maximum age before the vine "dies"
  boolean looping;  // Whether the vine loops around
  float  baseAngle = random(0, TWO_PI);

  Vine(float startX, float startY) {
      startX = width / 2; // Start from the center horizontally
  startY = height/1.5; // Start from the middle vertically
    
    segments = new ArrayList<PVector>();
    segments.add(new PVector(startX, startY));
    vineColor = color(34, 139, 34); // Green color for the vine
    thickness = random(4, 8); // Random thickness for organic feel
    curlFactor = random(2, 6); // Larger curlFactor = curlier vine
    waveOffset = random(TWO_PI); // Randomize initial wave offset
    age = 50;
    maxAge = int(random(200, 300)); // Random maximum age
    looping = random(1) < 0.3; // 30% chance of looping

  }
//defining how the vines grow
void grow() {
  if (segments.size() > 100) return;

  PVector last = segments.get(segments.size() - 1);

  // Adjust the angle based on wave offset and curl factor
  float angle = baseAngle + sin(waveOffset) * curlFactor;
  waveOffset += random(0.1, 0.3); // Change over time

  float stepSize = random(5, 10); // Length of each growth step
  float newX = last.x + stepSize * cos(angle);
  float newY = last.y + stepSize * sin(angle);

  if (looping) {
    // Add some looping effect to the angle
    float loopAngle = cos(waveOffset) * curlFactor;
    newX += stepSize * cos(loopAngle);
    newY += stepSize * sin(loopAngle);
  }

  newX = constrain(newX, 0, width);
  newY = constrain(newY, 0, height);

  segments.add(new PVector(newX, newY));
  age++;
}

  void display() {
    noFill();
    stroke(vineColor);
    strokeWeight(thickness);

    beginShape();
    for (PVector point : segments) {
      curveVertex(point.x, point.y);
    }
    endShape();
  }

  boolean shouldBranch() {
    // Random chance to branch, decreases as the vine grows older
    return random(1) < 0.02 && age > 20 && segments.size() < maxAge;
  }

  Vine branch() {
    // Create a new branch with similar properties but a new starting direction
    PVector last = segments.get(segments.size() - 1);
    Vine branch = new Vine(last.x, last.y);
    branch.curlFactor = curlFactor + random(-1, 1); // Slight variation in curliness
    branch.looping = random(1) < 0.3; // Random chance of looping for the branch
    return branch;
  }

  boolean isDead() {
    return age > maxAge;
  }
}
