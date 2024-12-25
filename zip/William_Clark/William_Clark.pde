//tree numbers
float xposition= 200;
float yposition= -800;
float randomsize = random(180,200);
float randompos = random(-30,30);

//car number
float ycar = 400;
//line position
float lp= -400;

//just making the screen size
void setup() {
  size(800, 800);
  noFill();
  stroke(0);
}

void draw(){
//Drawing background, make it green
  background(80, 135, 81);
  //draw the road
  drawrect();
  
  // all of these trees have there y position updated to make it look like the car is moving
  // all of the trees have variable sizes
  tree(xposition,yposition,randompos,randomsize);
  tree(xposition-100,yposition-400,randompos,randomsize);
  tree(xposition-50,yposition-700,randompos,randomsize);
  tree(xposition+476,yposition -300,randompos,randomsize);
  tree(xposition+500,yposition+400,randompos,randomsize);
  tree(xposition+600,yposition-900,randompos,randomsize);
  
  stroke(201, 196, 48);
  strokeWeight(2); 
 
  //draw line and reset the postion of it to make it move
  drawline(lp);
  //update the y position of the line
  lp += 4;
  //reset the postion for the line once it hits 0
  //it resets one line up to make it look infite
  if (lp >=0) {
    lp = -60;
  }
  
// draw the car
  drawcar(ycar);
  //this is how I Update the y position for my trees
  //make it move 4 pixels down
  yposition += 4;
  // once the y postion of the trees hits 1800 its reset to the top
  if (yposition >= 1800) {
    yposition = -500;
  }
  
}

// trees are made with the varible positions and randomsize 
// they're simply just made of circles
void tree(float xposition, float yposition, float randompos, float randomsize){
  
  fill(35, 110, 62);
  ellipse(xposition,yposition,randomsize,randomsize);

  stroke(0);
  strokeWeight(1);
  
}
// car drawing
void drawcar(float ycar){
  //this just restricts the car to the road
  float mouseXrestrict = constrain(mouseX, 335, 465);
  // car body
  stroke(0);
  fill(176, 41, 26);
  //rectangle postion updates with mouse and its centered
  rect(mouseXrestrict - 25,ycar,50,80);
  
  stroke(0);
  fill(0);
  
  //wheels follow the same idea as the car body, their position is updated at the same time to make it move as a group
  rect(mouseXrestrict - 32, ycar + 8,7,20);
  rect(mouseXrestrict +25, ycar + 8,7,20);
  rect(mouseXrestrict - 32, ycar + 50,7,20);
  rect(mouseXrestrict + 25, ycar + 50,7,20);
}

//Road is just a large grey rectangle

void drawrect(){
  fill(156, 156, 156);
  stroke(0);
  strokeWeight(1);
  rect(300,0,200,800);
  
}

// the idea behind the line is a bunch of yellow rectangles that all move together
void drawline(float lp){
  //the for loop repeats making a retagle 50 times
  //the start of each rectangle is spaced 60 pixels apart
    for (int i = 0; i < 50; i++){
    float y = lp + i * 60 ;
    fill(201, 196, 48);
    //center the rectangle
    rect(397.5, y ,5,40);
    
    
  }
}
  
