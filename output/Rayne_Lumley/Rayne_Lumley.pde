// defines cocoon and butterfly
color bodyColor = color(0, 0, 0);       
boolean cocoonBroken = false; 

// movement for clouds variables
float cloud1X = 150, cloud2X = 400, cloud3X = 550;
float cloudSpeed = 0.3;

// Color for cocoon
color cocoonColor = color(210, 180, 140);  

// Makes the tree
float treeX = width / 2 - 50;   
float treeHeight = 250;         
float branchLength = 120;       
float branchHeight = -70;      

void setup() {
  size(600, 600);  // Set canvas size
  noStroke();      
}

void draw() {
  background(135, 206, 235);  // makes background blue sky

  // Makes clouds 
  drawClouds();
  
  // Makes Grass
  drawGrass();
  
  // Makes flowers
  drawFlowers();
  
  // Makes the tree
  drawTree();

  // Makes the cocoon as long as not broken yet
  if (!cocoonBroken) {
    drawCocoon();  // Draw the cocoon in tree
  }
  
  // Makes the butterfly when cocoon broken
   if (cocoonBroken) {
    drawButterfly();
  }
}

// Makes tree
void drawTree() {
  // Makes trunk of tree
  fill(139, 69, 19);  // tree trunk colour
  rect(treeX, height - 90 - treeHeight, 50, treeHeight);  // shape of trunk
  
  // Makes top of tree
  fill(34, 139, 34);  // top colour
  ellipse(treeX + 25, height - 90 - treeHeight - 60, 280, 200);  // shape of top of tree
  
  // makes tree branch 
  line(treeX - branchLength, height - 90 - treeHeight + branchHeight, 
       treeX + 50 + branchLength, height - 90 - treeHeight + branchHeight);  

  // Make cocoon if not broken
  if (!cocoonBroken) {
    fill(cocoonColor);  // cocoon colour
    ellipse(treeX + 50, height - 90 - treeHeight + branchHeight, 40, 60);  // cocoon shape
  }
}

// makes cocoon
void drawCocoon() {
  fill(cocoonColor);  
  ellipse(treeX + 50, height - 90 - treeHeight + branchHeight, 40, 60);  
}

// makes butterfly
void drawButterfly() {
  // changes colour of wings with cursor movemnt
  color wingColor = color(map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 0, 255), 255); 
  
  // makes wings of butterfly
  fill(wingColor);
  ellipse(mouseX - 25, mouseY - 20, 60, 80);  
  ellipse(mouseX - 25, mouseY + 20, 60, 80);  
  ellipse(mouseX + 25, mouseY - 20, 60, 80);  
  ellipse(mouseX + 25, mouseY + 20, 60, 80);  

  // makes butterfly body
  bodyColor = color(map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 0, 255), 0);
  fill(bodyColor);  // Set body color
  rect(mouseX - 4, mouseY - 60, 8, 120);  
}

// makes clouds
void drawClouds() {
  fill(255, 255, 255, 200);  // cloud colour
  
  cloud1X += cloudSpeed;
  cloud2X += cloudSpeed;
  cloud3X += cloudSpeed;
  
  // clouds movement repeat
  if (cloud1X > width) cloud1X = -180;
  if (cloud2X > width) cloud2X = -200;
  if (cloud3X > width) cloud3X = -150;
  
  // makes the clouds
  ellipse(cloud1X, 100, 180, 100);  
  ellipse(cloud2X, 120, 200, 120);  
  ellipse(cloud3X, 80, 150, 90);   
}

// makes grass
void drawGrass() {
  fill(34, 139, 34);  // colour of grass
  rect(0, height - 90, width, 90);  // shape of grass
}

// makes flowers
void drawFlowers() {
  fill(255, 0, 0);  // colour of flower petals
  ellipse(100, height - 60, 30, 30);  
  ellipse(200, height - 70, 30, 30);  
  ellipse(300, height - 50, 30, 30);  
  ellipse(400, height - 70, 30, 30);  
  ellipse(500, height - 60, 30, 30);  
  
  fill(255, 255, 0);  // colour of centre of flowers
  ellipse(100, height - 60, 15, 15);  
  ellipse(200, height - 70, 15, 15);  
  ellipse(300, height - 50, 15, 15);  
  ellipse(400, height - 70, 15, 15);  
  ellipse(500, height - 60, 15, 15);  
}

// makes it so its interactive when button pressed
void keyPressed() {
  if (!cocoonBroken) {
    cocoonBroken = true;  // when cocoon broken butterfly is revealed when button pressed
  }
}
