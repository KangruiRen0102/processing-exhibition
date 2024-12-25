
boolean isSnow = false;  // Track whether the ground is snow or grass
boolean isCowClicked = false; // Track whether the cow has been clicked (changed to black cow with white spots)

// these are all the cows attributes
float cowX = 300, cowY = 250; // start spot for the cow 
float cowSize = 50; // size of the cow
float hornLength = 20; // Length of the horns
// where my clods will start off
float cloud1X = 100;
float cloud2X = 450;

void setup() {
  size(600, 400); // siz of drawing 
  noStroke(); // No outline 
}

void draw() {
  background(135, 206, 235); 

  // draw the sun
  fill(255, 223, 0); // Yellow color
  ellipse(500, 80, 100, 100); // puts the sun in the top right

  // draw the clouds
  drawCloud(cloud1X, 100);
  drawCloud(cloud2X, 120);
  
   if (cloud1X > width) {
    cloud1X = -100;  // reset the first cloud to star from the left
  }
   if (cloud2X > width) {
    cloud2X = -100;  // reset the second cloud to start from the left
  }
  
  cloud1X += 1;  // movesfirst cloud to the right
  cloud2X += 1;  //moves second cloud to the right
  
  // drawing the ground
  if (isSnow) {
    fill(255); // white
  } else {
    fill(34, 139, 34); //green
  }
  rect(0, 300, width, 100); // ground (grass or snow)

  // cow
  if (isCowClicked) {
    drawWhiteCow(cowX, cowY, cowSize); // bigger cow
  } else {
    drawBrownCow(cowX, cowY, cowSize); // Smaller cow
  }
}
// little cow
void drawBrownCow(float x, float y, float size) {
  fill(139, 69, 19); 
  ellipse(x, y, size, size); // Main body 
  fill(255); 
  ellipse(x, y - size / 2, size / 2, size / 2); // Head
  fill(0); 
  ellipse(x - 10, y - size / 2, 10, 10); // legt eye
  ellipse(x + 10, y - size / 2, 10, 10); // right eye
  
  //horns for smlaler cow
  fill(255); 
  ellipse(x - 15, y - size / 2 - 10, 15, 5); // Left ear
  ellipse(x + 15, y - size / 2 - 10, 15, 5); // Right ear
  
  // legs
  fill(139, 69, 19); 
  
  // left leg
  rect(x - 10, y + 20, size / 8, size / 2); // Position 
  
  // right leg
  rect(x + 8, y + 20  , size / 8, size / 2); // Position 
   //adding hooves
  fill(0); 
 
  rect(x - 10, y + 45 , size / 8, size / 8); // bottom of the left leg
  
  // Right front hoof
  rect(x + 8, y + 45 , size / 8, size / 8); // bottom of the rightleg
}

// drawing white cow now 
void drawWhiteCow(float x, float y, float size) {
  fill(255); 
 
  float bodyWidth = size ;  
  float bodyHeight = size * 1.05; // Slightly increase height for a more natural shape
  ellipse(x, y, bodyWidth, bodyHeight); // Main oval body of the cow

  fill(255); 
  ellipse(x, y - bodyHeight / 2, size / 2, size / 2); // Head
  
  fill(255, 105, 180); // Pink color for the mouth
  ellipse(x, y - bodyHeight / 3, 20, 15); // Mouth 
  
  
  fill(0); 
  ellipse(x-3, y - bodyHeight / 2.8, 1.5, 3); // nostrial
   
  fill(0); 
  ellipse(x+3, y - bodyHeight / 2.8, 1.5, 3); // nostrail
  
  fill(0); 
  ellipse(x - 10, y - bodyHeight / 2, 10, 10); // left eye
  ellipse(x + 10, y - bodyHeight / 2, 10, 10); // tight eye
  
   
  fill(255); 
  //ears
  pushMatrix(); // Saved an older drawing to re use it here (i think i deleted the old one cause i cant tfind it)
translate(x - 25, y - bodyHeight / 2 - 5); // move the origin 
rotate(-PI / 6); // Rotate by -30 degrees 
ellipse(0, 0, 20, 5); // Draw at the new origin
popMatrix(); // restores the previous drawing state
fill(255);
  pushMatrix(); // Save the current drawing state
translate(x + 25, y - bodyHeight / 2 - 5); // Move the origin to the ellipse's position
rotate(PI / 6); // Rotate the ellipse by -45 degrees (downwards to the right)
ellipse(0, 0, 20, 5); // Draw the ellipse at the new origin
popMatrix(); // Restore the previous drawing state
 
  //horns 
   fill(61,48,0);
   pushMatrix(); 
translate(x - 25, y - bodyHeight / 2 - 10);
rotate(PI / 4); // Rotate the ellipse by 45 degrees 
ellipse(0, -15, -10, 5); 
popMatrix();
 fill(61,48,0);
 pushMatrix(); // Save the current drawing state
translate(x + 25, y - bodyHeight / 2 - 10); // Move the origin to the ellipse's position
rotate(-PI / 4); // Rotate the ellipse by -45 degrees (downwards to the right)
ellipse(0, -15, 10, 5); // Draw the ellipse at the new origin
popMatrix(); // Restore the previous drawing state
 
 
 
 
 //legs
  float legHeight = size * 0.4; // Height of leg
  float legWidth = size * 0.1; // Width 
  float legSpacing = size * 0.25; //  space between the legs
  fill(255); 
  // Move the legs up to overlap 
  float legYOffset = size / 2.5; 
  
  rect(x - legSpacing - legWidth / 2, y + legYOffset, legWidth, legHeight); // left middle leg 
  rect(x + legSpacing - legWidth / 2, y + legYOffset, legWidth, legHeight); // right middle leg 
 
 //eyes
 fill(255); 
  ellipse(x- 20, y + 30 , 20, 30); 
  ellipse(x+ 20, y + 30 , 20, 30); 
  ellipse(x + 8, y + bodyHeight / 2, 10, 10); 
 ellipse(x - 8, y + bodyHeight / 2, 10, 10);
 
  // Adds spots to the cow's body
  fill(0); 
  ellipse(x - 20, y + 10, 20, 20); // Spot 1
  ellipse(x + 20, y + 20, 20, 20); // Spot 1
  ellipse(x + 22, y - 15, 20, 20); // Spot 1
  ellipse(x - 10, y + 10, 20, 20); 
  
  
  // hooves
  fill(139, 69, 19); 
  float squareSize = legWidth; // hoove size matches the leg width
  rect(x - legSpacing - legWidth / 2, y + legYOffset + legHeight, squareSize, squareSize); // puts it underLeft leg
  rect(x + legSpacing - legWidth / 2, y + legYOffset + legHeight, squareSize, squareSize); //put it under the right leg 
  
  // Add two smaller legs 
  float smallerLegHeight = size * 0.3; // Smaller legs for in between the other too between
  float smallerLegSpacing = size * 0.1; // Smaller as well 
  
  fill(255); 
  rect(x - smallerLegSpacing - legWidth / 2, y + legYOffset, legWidth, smallerLegHeight); // left back leg
  rect(x + smallerLegSpacing - legWidth / 2, y + legYOffset, legWidth, smallerLegHeight); // right back leg
// hooves for back legs
  fill(139, 69, 19);

  rect(x - smallerLegSpacing - legWidth / 2, y + legYOffset +  smallerLegHeight, squareSize, squareSize); // Left 
  rect(x + smallerLegSpacing - legWidth / 2, y + legYOffset +  smallerLegHeight, squareSize, squareSize); // Right 
}

// Function to draw clouds
void drawCloud(float x, float y) {
  fill(255); 
  ellipse(x, y, 60, 60); // cloud body
  ellipse(x + 30, y - 20, 60, 60); // Extra part of the cloud
  ellipse(x - 30, y - 20, 60, 60); // Extra part of the cloud
}

// when mouse is clicked
void mousePressed() {
  // Toggle between snow and grass on the ground when clicked anywhere on the screen
  isSnow = !isSnow;
  
 
  float distance = dist(mouseX, mouseY, cowX, cowY);
  
  if (distance < cowSize / 2) {
    // When the cow is clicked, change to bigger cow 
    isCowClicked = true;
    cowSize = 80; // Increase the size of the cow
  }
}
