float angleX = 0;
float angleY = 0;
float floorSize = 80000; //set initial float values

color[] bgColours = {color(100, 120, 230), color(200, 21, 23), color(134, 0, 0),color(255, 0, 73),color(200, 50, 50)};
int currentColourIndex = 0;  
boolean isSpacePressed = false;  
int lastColorChangeTime = 0;  
int changeInterval =200; //set int and float values, as well as a colour index for the change in background color

void setup() {
  size(1000, 1000, P3D);  // Create a 3D space
}

void draw() {
  
  background(bgColours[currentColourIndex]);  // set background

  if (isSpacePressed && millis() - lastColorChangeTime > changeInterval) {
    currentColourIndex = (currentColourIndex + 1) % bgColours.length;  // Cycle through colors using an if statement
    lastColorChangeTime = millis();
  }
  lights();

  translate(width / 2, height / 2, 0);  // Move to the center of the screen
  
  // Update rotation angles based on mouse movement
  angleX = map(mouseY, 0, height, -PI, PI);  // mouse movement to rotate around X-axis
  angleY = map(mouseX, 0, width, -PI, PI);   // mouse movement to rotate around Y-axis
  
if (angleX > -0.1) { // floor camara collision by restricting x and y coord values
  angleX = -0.1;
}
else if (angleX < -1) {
  angleX = -1;
}
  // Rotation
  rotateX(angleX);  // Apply the rotation on the X-axis
  rotateY(angleY);  // Apply the rotation on the Y-axis
  
  strokeWeight(8); //styilized outline
  // draw a floor
  pushMatrix();
  rotateX(HALF_PI);  // rotate floor correctly
  fill(0, 180, 0);  // Establish colour of the floor
  rectMode(CENTER);
  rect(0, 0, floorSize, floorSize);  // Draw the floor using a plane
  popMatrix();
  
  //create geometry for buildings using translate, box and fill
  translate(2000,-500,2000);
  fill(220, 220, 220);
  stroke(0);
  box(300,1000,300);
    
  translate(100,100,-600);
  stroke(0);
  box(300,800,900);
  
  translate(-700,0,700);
  stroke(0);
  box(900,800,300);
  
  //create geometry for roads
  translate(350,400,-350);
  fill(100,100,100);
  strokeWeight(0);
  stroke(0);
  box(1900,5,2900);
  
  translate(-1150,00,0);
  fill(100,100,100);
  strokeWeight(0);
  stroke(0);
  box(400,5,80000);
  
  translate(-220,00,0);
  fill(200,200,200);
  strokeWeight(0);
  stroke(0);
  box(100,10,80000);
  
  translate(440,00,20000);
  fill(200,200,200);
  strokeWeight(0);
  stroke(0);
  box(100,10,40000);
  
  translate(0,00,-41000);
  fill(200,200,200);
  strokeWeight(0);
  stroke(0);
  box(100,10,40000);
  
  translate(-900,00,19200);
  fill(194,178,128);
  strokeWeight(0);
  stroke(0);
  box(1000,5,1000);
  
  //create geometry for swingset using rotate and line commands
  strokeWeight(3);
  
  translate(-100,-100,200);
  rotateZ(PI/10);
  fill(160,160,250);
  box(20,400,20);
  translate(0,0,-400);
  box(20,400,20);
  
  translate(130,-40,0);
  rotateZ(-2*PI/10);
  box(20,400,20);
  translate(0,0,400);
  box(20,400,20);
  
  rotateZ(PI/10);
  rotateY(PI/2);
  rotateZ(PI/2);
  translate(-180,-200,-70);
  box(20,400,20);
  
  translate(0,-50,0);
  rotateZ(PI/5.5);
  strokeWeight(8);
  line(150,-100,0,0);
  
  translate(60,100,0);
  line(150,-100,0,0);
  
  fill(160,93,0);
  strokeWeight(3);
  rotateZ(-PI/5.5);
  translate(180,-60,0);
  box(10,120,50);
}

void keyPressed(){
  if (key == ' ') {  // If spacebar is pressed change variable to true
    isSpacePressed = true; 
  }
}

void keyReleased() {
  if (key == ' ') {  // // If spacebar is released change variable to false
    isSpacePressed = false; 
  }
}
