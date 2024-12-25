float theta;   

void setup() {
  fullScreen();
}

void draw() {
  background(255,204,51); //This makes the background a yellow-orange colour
  frameRate(30);
  stroke(0);
  circle(675,400,200); //this creates the white circle in the middel of the screen
  
  // This section of code creates the tree
  float a = (mouseX / (float) width) * 90f;
  // Converts the angle to radians
  theta = radians(a);
  // Starts the tree from the bottom of the screen
  translate(width/2,height);
  line(0,0,0,-120);
  translate(0,-120);
  branch(120);
}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
 
  if (h > 2) {
    pushMatrix();    
    rotate(theta);   
    line(0, 0, 0, -h);  
    translate(0, -h); 
    branch(h);       
    popMatrix();    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}
