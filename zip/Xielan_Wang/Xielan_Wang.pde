// Sets up the window and space background
void setup(){
  size(1450,800);
  background(0);
  strokeWeight(5);
  int i = 0;
  while (i < 70){
  i = (i+1);
  circle(random(0,1450),random(0,800),random(1,2)); 
  }
}

// Local Variables Needed for Loops
int y = 0;
int i = 0;
int c = 0;

// Drawing the Lines and Letting them Oscillate Between Colours
void draw(){
  frameRate(120);
  line(mouseX,(mouseY - 150),mouseX,(mouseY + 150));
  if (y < 254){
    y = y + 1;
    i = i + 1;
    if (i >= 250){
      y = y - 2;
      if (y < 0){
        i = 0;
      }
    }
  }
  stroke(0,100,y);
}
