class Building {
  float x, y, w, h; //Building Class

  Building(float startX, float startY, float startW, float startH) {
    x = startX;
    y = startY;
    w = startW;
    h = startH;
  }

  void display() {
    fill(80, 80, 100); 
    rect(x, y, w, h); //Buildings
  }
}

Building building1, building2, building3;

float yPos = 50;  // Initial Y position for the Meteor
boolean movingDown = true;  
boolean isNight = false;  // Start with daytime

void setup() {
  size(500, 500); 
  // Building Instances
  building1 = new Building(100, 150, 60, 300);
  building2 = new Building(225, 200, 65, 200);
  building3 = new Building(350, 125, 70, 250);
}

void draw() {
  // Night/day
  if (isNight) {
    background(0); 
    fill(255); // Moon
    ellipse(50, 50, 50, 50); 
  } else {
    background(255); // daytime
  }

  // Display buildings
  building1.display();
  building2.display();
  building3.display();

  // Move meteor and fire trail up and down
  if (movingDown) {
    yPos += 1;  
    if (yPos >= 150) {  
      movingDown = false;  
    }
  } else {
    yPos -= 1;  
    if (yPos <= 50) {  
      movingDown = true;  
    }
  }

  // Ocean
  fill(0, 102, 204); 
  rect(0, 375, 500, 125); 

  // Meteor
  fill(50); 
  ellipse(300, yPos, 50, 50); 

  // Fire Trail
  fill(255, 0, 0); // Red color
  triangle(275, yPos - 20, 325, yPos - 20, 300, yPos - 40); // Fire trail
}

void mousePressed() {
  // Day and Night switch
  isNight = !isNight;
}
