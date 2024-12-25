// setting up canvas
void setup(){
  size(800, 600); // set canvas size
  noStroke(); // removes borders
}

// creating ocean for half of canvas
void draw() {
  fill(0,50,100); // set colour to deep blue
  rect(0, height/2, width, height/2); // draw a rectangle
  
// create an ombre of colours for half of canvas
  for(int y=0; y< height/2; y++){ 
    float r = map(y, height/2, 0, 255, 0); // setting tones of colours and positions
    float g = map(y, height/2, 0, 120, 50);
    float b = map(y, height/2, 0, 100, 150);
  
    fill(r,g,b); // setting colours for rows
    rect(0,y, width, 1); // create small rectangle to mimic "ombre"
  }
// create stars
  if (frameCount % 1 == 0){ // how frequent the stars show depending on amount of frames
    int starX = int(random(width)); // defining random width and height, but just above the horizon line
    int starY = int(random(height/2));
    fill(255, 255, 255);
    ellipse(starX, starY, 3, 3); // size of stars
  } 

// creating boat
  drawBoat(350, height/2 - 20); // placing boat just below the horizon line
}

void drawBoat(int x, int y) { 
  // base of boat
  fill(0,0,0); // black fill color
  quad(x, y, x+25, y+25, x+75, y+25, x+100,y); // mapping out the coordinates of hull
  
  // drawing the sail
  fill(0,0,0); // black fill color
  triangle(x+35, y-15, x+70, y-50, x+70, y-15); // mapping out coordinates of sail
  
  // drawing mast
  fill(0,0,0); // black fill color
  rect(x+70, y-50, 10, 65); // mapping out coordinates of mast
}
