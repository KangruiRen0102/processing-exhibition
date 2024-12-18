ArrayList<Crack> cracks = new ArrayList<Crack>();  // List to store cracks
int crackMax = 8, crackCount = 0;  // Crack counter and max cracks for when chick spawns
boolean chickSpawned = false;  // Start chick not spawned
float chickX, chickY;  // Position of chick

//Creates the Canvas and sets conditions for drawing settings
void setup() {
  size(400, 400);  
  noFill();  
  noStroke();  
}

//This updates the function by drawing out everything
void draw() {
  background(0, 128, 0); 
  rect(width / 2 - 150, height / 2 + 100, 300, 30);  // Podium
  
  if (!chickSpawned) {
    drawEgg(); 
    addCracks();  
  }

  if (crackCount >= crackMax && !chickSpawned) {
    spawnChick();  // Spawn chick when crack count is reached
    chickSpawned = true;  // Mark chick as spawned
  }
  
  if (chickSpawned) displayChick();  // Display the chick
}


//Adds cracks to the egg
void addCracks() {
  if (frameCount % 40 == 0) {  // Add a new crack every 50 frames
    cracks.add(new Crack());  
    crackCount++;  // crack counter
  }
  
  for (Crack c : cracks) {  // Update and display cracks
    c.update();  // Update crack's growth
    c.display();  // Draw crack
  }
}

//Draws the egg on background
void drawEgg() {
  fill(255);  //egg color
  ellipse(width / 2, height / 2, 150, 200);  // The egg
  
  fill(150, 75, 0);  // Podium color
}

//Draws the chick
void spawnChick() {
  chickX = width / 2;
  chickY = height / 2 + 50;  // Position chick below egg center
}

//Shows the body parts of the chick
void displayChick() {
  fill(255, 255, 0);  
  ellipse(chickX, chickY, 50, 50);


//Chicks eyes
  fill(0);  
  ellipse(chickX - 15, chickY - 10, 8, 8);  
  ellipse(chickX + 15, chickY - 10, 8, 8);  
  
//Chicks beak
  fill(255, 165, 0);  
  triangle(chickX - 5, chickY + 5, chickX + 5, chickY + 5, chickX, chickY + 12);
  
//Chicks Legs 
  stroke(255, 165, 0);  
  strokeWeight(3); 
  line(chickX - 11, chickY + 25, chickX - 23, chickY + 55);  
  line(chickX + 11, chickY + 25, chickX + 23, chickY + 55);  
  
//Chicks arms
  stroke(255, 165, 0); 
  line(chickX - 25, chickY, chickX - 60, chickY - 30);  
  line(chickX + 25, chickY, chickX + 60, chickY - 30); 
  
  
  fill(150, 75, 0);  // Podium color (brown)
}

// Class for cracks forming on egg
class Crack {
  float x1, y1, x2, y2, length, angle;
  color crackColor = color(0);  
  ArrayList<PVector> points = new ArrayList<PVector>();  // List for crack points
  
  //Spawns the cracks randomly within certain x and y range
  Crack() {
    x1 = width / 2 + random(-45, -10);
    y1 = height / 2 + random(-80, 80);
    points.add(new PVector(x1, y1));
    length = 10;  // Initial crack length
  }
  
  //Updates the cracks growth 
  void update() {
    if (length < 20) {
      length += random(1, 2);
      angle = (frameCount % 2 == 0) ? PI / 4 : -PI / 4;  // Zigzag direction
      PVector last = points.get(points.size() - 1);
      points.add(new PVector(last.x + length * cos(angle), last.y + length * sin(angle))); 
      // New point is added to the crack's path according to the last point along with a new length
    }
  }
  //Draws the cracks
  void display() {
    stroke(crackColor);
    strokeWeight(3);
    for (int i = 0; i < points.size() - 1; i++) {
      PVector p1 = points.get(i), p2 = points.get(i + 1);
      line(p1.x, p1.y, p2.x, p2.y); //loops through the list of points and then draws lines
    }
  }
}
