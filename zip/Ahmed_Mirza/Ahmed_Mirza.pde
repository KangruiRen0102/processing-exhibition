color c1, c2;

void setup() {
  size(800, 600);
  noStroke();
  
  // Frozen Lake
  fill(200, 220, 255);
  rect(0, height*0.25, width, height*0.75);
  
  
  // Creating colours for the sky
  c1 = color(173,216,230);
  c2 = color(240,255,255);
  
}

void draw() {
  
  // Sky Gradient
  
  setGradient(0, 0, width, height*0.25, c1, c2);
  
  // Ice Cracks
  
  stroke(170, 190, 210);
  strokeWeight(2);
  
  for (int i = 0; i < 12; i++) {
    float startX = random(width); // horizontal start point of ice crack
    float startY = random(height*0.25, height); // vertical start point of ice crack
    float endX = startX + random(-75, 75); // horizontal end point of ice crack
    float endY = startY + random(-40, 40); // vertical start point of ice crack
    line(startX, startY, endX, endY);
  }
  
  noLoop(); // prevents infinite number of ice cracks generating
  
}

void setGradient(int x, int y, float w, float h, color c1, color c2) { // Creates a gradient using 2 colours

  noFill();
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1); // re-maps i to go from 0 to 1 (makes it a fraction)
    color c = lerpColor(c1, c2, inter); // interpolate other colours between these 2 colours
    stroke(c); // sets stroke colour to new interpolated colour
    line(x, i, x+w, i); // draws a line, then begins the loop again
    }
  }
