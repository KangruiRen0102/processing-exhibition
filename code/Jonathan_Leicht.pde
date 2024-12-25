int hours = 1;
int counter = 1;
int lineNum = 1;

// Global variables are assingned their inital values. //


public void setup() {
  size(1920, 1080, P2D);
  frameRate(10);
  colorMode(RGB, 255, 255, 255, 255);
  background(0);
}

// Setup establishes the running parameters of the program and sets the intial background colour. //
  
public void draw() {

  
 if ((counter % 2 == 0) && (hours == 9)) {
     background(255*sin(millis()));
 }
 else {
   background(0);
 }
  
// If hours is 9 the screen flashes. If not, the backgorund remains black.//  
   
   stroke(252, 15, 192, 40);
  for (int i = 0; i < lineNum; i++) {
    float x0 = random(width);
    float y0 = random(height);
    float z0 = random(-100, 100);
    float x1 = random(width);
    float y1 = random(height);
    float z1 = random(-100, 100);    
    
    line(x0, y0, z0, x1, y1, z1);

// This code is taken from one of the processing examples. This code creates random lines in random locations. //
// I modified the code to change the number of lines and the colour of the lines. //
    
    if (counter % 2 == 0) {
       stroke(255, 255, 255, 255);
        fill(0,255);

// If the screen is clicked it the menu changes from the home screen to the image of the student. //        
        
        if ((hours < 9) && (hours > 0)) {
          fill(255,255); 
          text("Hours spent:", 40, 120);
          text(hours, 400, 120);
        }
        
         if (hours == 9){
          fill(255,255); 
          text("Hours spent:", 40, 120);
          text("9+", 400, 120);
        }
        
// This displays the number of hours (the number picked by the user) on the screen. //        
        
     fill(0,255);
     rect((1920/2)-150, 1080/2, 300, 1500);
     ellipse((1920/2), (1080/2)-150, 300, 300);
     
     fill(hours*(255/9),255);
     circle((1920/2)-75,(1080/2)-200, 50);
     circle((1920/2)+75,(1080/2)-200, 50);
     
// This creates the image of the student, and the eye brightness changes based on the number picked by the user. // 
     
    }else{
       lineNum = 20;
         textSize(64);
       fill(255,255); 
       text("Click the mouse to see how it feels working on assignments", 40, 120);
       text("Then press a number from 1 to 9", 40, 200);
       
// This is the code for the home screen. //
       
    }  
    }
  }   

  
void mouseClicked() {
  counter = counter + 1;
  redraw();
}

// If the mouse is counter variable updates which changes between the menu screen and the image of the student. //

void keyPressed() {

  if (key == '1' || key == '2'||key == '3' || key == '4'||key == '5' || key == '6'||key == '7' || key == '8'||key == '9') {
   
  hours = int(key) - 48;
  }
   lineNum = hours*50; 
redraw();
}

// If the user clicks on a key that is a number from one to nine, it changes the hours variable. //
// This changes the text displayed, the eye brightness of the student, and the number of lines generated. //
// The drawing is then updated. //
