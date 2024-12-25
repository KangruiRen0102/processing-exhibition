float heighttree=0, lengthbranch=0, sunhori=0, sunvert=100,birdSpeed=1.5, birdSize = 8;

int maxheighttree=300, maxlengthbranch=97, thickbranch=3, sunRadius =50, leafSize=10;

boolean branchesStarted=false,leavesGrown=false,plantsGrown=false;

ArrayList<Float>leafPositionshori=new ArrayList<Float>(),leafPositionsvert=new ArrayList<Float>();

ArrayList<Float>planthori=new ArrayList<Float>(),plantvert=new ArrayList<Float>(),plantTrunkHeight=new ArrayList<Float>();

ArrayList<Float>plantcanopysize=new ArrayList<Float>();

float[]birdhori={-50, -100, -150, -200},birdvert={200, 150, 100, 250};

ArrayList<Float>cloudhori=new ArrayList<Float>(),cloudvert=new ArrayList<Float>(),cloudsize=new ArrayList<Float>();

float[]butterflyhori={-50, -100, -150, -200};

float[]butterflyvert={300, 350, 250, 200};

float butterflyquick=1.5;

float wingflapquick=0.1;

float wingflapmotion=10; 

void setup() { 
  size(800, 600); 
  noStroke(); 
  
 
  for (int i = 0; i < 5; i++) {
    cloudhori.add(random(-100, 800));  
    cloudvert.add(random(50, 150));    
    cloudsize.add(random(50, 150)); 
  }
}

void draw() {
  
  float backgColorR =map(sunhori, 0, width, 20, 70);  
  float backgColorG =map(sunhori, 0, width, 50, 100);  
  float backgColorB =map(sunhori, 0, width, 100, 180);  
  
  
  if (sunhori > width) {
    backgColorR = 70;
    backgColorG = 100;
    backgColorB = 180;  
  }
  
 
  background(backgColorR, backgColorG, backgColorB);
  
  
  moveClouds();
  for (int i = 0; i < cloudhori.size(); i++) {
    drawCloud(cloudhori.get(i), cloudvert.get(i), cloudsize.get(i));
  }
  
  
  sunhori += 1.5; 
  if (sunhori>width+sunRadius)sunhori =-sunRadius;
  drawSun(sunhori,sunvert,sunRadius);
  
  
  drawTree(width/2,height-100,heighttree);
  if (heighttree < maxheighttree) heighttree += 2;
  else if (!branchesStarted) { branchesStarted = true; lengthbranch += 1; }
  if (branchesStarted && lengthbranch < maxlengthbranch) {
    drawBranches(width / 2, height - 100, lengthbranch, PI / 4, 5);  
  }
  
  
  moveBirds();
  for (int i = 0; i < birdhori.length; i++) drawBird(birdhori[i], birdvert[i]);
  
  
  moveButterflies();
  for (int i = 0; i < butterflyhori.length; i++) {
    drawButterfly(butterflyhori[i], butterflyvert[i]);
  }
  
  
  if (sunhori > width / 2 && !plantsGrown) {
    plantsGrown = true;
    addPlants();  
  }
  
  
  if (plantsGrown) {
    for (int i=0; i < planthori.size(); i++) {
      
      fill(137, 64, 20); 
      rect(planthori.get(i) - 5, plantvert.get(i), 10, plantTrunkHeight.get(i));  
      
      fill(30, 137, 38);
      ellipse(planthori.get(i), plantvert.get(i) - plantTrunkHeight.get(i), plantcanopysize.get(i), plantcanopysize.get(i));  
      if (plantcanopysize.get(i) < 40) { 
        plantcanopysize.set(i, plantcanopysize.get(i) + 0.3);  
      }
      if (plantTrunkHeight.get(i) < 25) {
        plantTrunkHeight.set(i, plantTrunkHeight.get(i) + 0.2);  
      }
    }
  }
}

void moveButterflies() {
  for (int i = 0; i < butterflyhori.length; i++) {
    butterflyhori[i] += butterflyquick;
    if (butterflyhori[i] > width) butterflyhori[i] = -50 - (i * 50);  
    butterflyvert[i] = 300 + 30 * sin(radians(butterflyhori[i] * 2));  
  }
}

void drawButterfly(float hori, float vert) {
  pushMatrix();
  translate(hori, vert);
  rotate(radians(45));
  
  
  float wingflap = sin(frameCount*wingflapquick) * wingflapmotion; 
  
  
  fill(255, 200, 100, 180);  
  ellipse(0, -5, 20 + wingflap, 10 + wingflap / 2);
  fill(255, 150, 100, 180);  
  ellipse(0, 5, 20 + wingflap, 10 + wingflap / 2);
  
  
  fill(0);  
  ellipse(0, 0, 5, 15);    
  
  popMatrix();
}

void drawTree(float hori, float vert, float HH) {
  fill(34, 139, 34); ellipse(hori, vert - HH, 100, 100);  
  fill(139, 69, 19); rect(hori - 10, vert, 20, -HH);  
}

void drawBranches(float hori, float vert, float len, float angle, int dpth) {
  if (dpth == 0) return;  

  float branchEndhori = hori + len * cos(angle);
  float branchEndvert = vert - len * sin(angle);

  
  fill(139, 69, 19);  
  ellipse(branchEndhori, branchEndvert, 10, 10);  

  
  drawBranches(branchEndhori, branchEndvert, len * 0.7, angle - PI / 6, dpth - 1);  
  drawBranches(branchEndhori, branchEndvert, len * 0.7, angle + PI / 6, dpth - 1);  
}

void drawSun(float hori, float vert, float rad) {
  fill(255, 255, 0); ellipse(hori, vert, rad * 2, rad * 2);  
}

void moveBirds() {
  for (int i = 0; i < birdhori.length; i++) {
    birdhori[i] += birdSpeed;
    if (birdhori[i] > width) birdhori[i] = -50 - (i * 50);  
    birdvert[i] = 200 + 50 * sin(radians(birdhori[i]));  
  }
}

void drawBird(float hori, float vert) {
  pushMatrix(); 
  translate(hori, vert); 
  rotate(radians(45)); 
  
  
  fill(255, 250, 200);  
  
  
  triangle(0, -10, 10, 10, -10, 10); 
  
  popMatrix();  
}


void addPlants() {
  for (int i = 0; i < 10; i++) {
    float xPos = random(50, width - 50);
    float yPos = height - 50 + random(10, 20); 
    planthori.add(xPos);
    plantvert.add(yPos);
    plantTrunkHeight.add(0.0);  
    plantcanopysize.add(10.0);  
  }
}

void moveClouds() {
  
  for (int i = 0; i < cloudhori.size(); i++) {
    cloudhori.set(i, cloudhori.get(i) + 0.2);  
    if (cloudhori.get(i) > width + cloudsize.get(i) / 2) {
      cloudhori.set(i, -cloudsize.get(i) / 2);  
    }
  }
}

void drawCloud(float hori, float vert, float Size) {
  fill(255, 255, 255, 200);  
  ellipse(hori, vert, Size, Size / 1.5);  
  ellipse(hori-Size/3,vert,Size,Size / 1.5);  
  ellipse(hori + Size / 3, vert, Size, Size / 1.5);  
} 
