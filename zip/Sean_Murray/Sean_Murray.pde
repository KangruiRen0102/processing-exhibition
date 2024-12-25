int cols, rows;
int scl=20;
int w=2000;
int h=1600;
boolean a=true;
float move=0;
float[][] t;
PShape Rp,Gp,Yp;
void setup() {
//setups size of display when code is run
  size(1000,1000,P3D); 
//these lines set up the rows and coloums for my "sea" terrain effect
  cols=w/scl;        
  rows=h/scl;
  t=new float[cols][rows];
//make the outlines for my planets and details how many lines go into making the sphere
  stroke(100);        
  sphereDetail(25);
//these lines create the shape for the planets and their size, as well as sets colours for each of them, being red green and yellow respectivley
  Rp=createShape(SPHERE,250);    
  Rp.setFill(color(255,0,0)); 
  Gp=createShape(SPHERE,150);
  Gp.setFill(color(0,255,0)); 
  Yp=createShape(SPHERE,70);
  Yp.setFill(color(0-0-255));
}
void draw() {  
//these lines make my "sea" effect move, and how fast it moves and makes ridges, giving the illusion of moving waves
  move+=0.01;
  float yoff=move; 
//this line of code uses perlin noise, its basically gives random numbers that are near to each other so something moves 
//fluidly. instead of having a random z number for each triangular vertix, it has random numbers that are similar to those 
//arouund it. this is shown in the map noise section of the code, the x and y offset is also stated so that gradations 
//arent too irregular
  for (int y=0; y<rows; y++) { 
    float xoff=0; 
    for (int x=0; x<cols; x++) { 
      t[x][y]=map(noise(xoff,yoff),0,1,-60,60); 
      xoff+=0.2; 
    }
    yoff+=0.2; 
  } 
//these lines make the background of the art, being black, and then the outline and colour of my "sea" animation
  background(0);          
  stroke(255,255,255); 
  fill(51,153,255);
//this line rotates the triangular strips to be "3D" and sets the orgin of rotation to be the center of the window
  translate(width/2,height/2);     
  rotateX(PI/3);
  translate(-w/2,-h/2); 
//this line of code draws out the triangular strips that make up the sea effect, it also sets the vertex points for 
//these triangles z points, so where they are on the z axis up and down
  for (int y=0; y<rows-1; y++) { 
    beginShape(TRIANGLE_STRIP); 
    for (int x=0; x<cols; x++) { 
      vertex(x*scl,(y+12)*scl,t[x][y]); 
      vertex(x*scl,(y+13)*scl,t[x][y+1]); 
    }
    endShape(); 
  } 

//this code rotates the planets so they are seen from a different angle
  translate(0,230,-460); 
  rotateX(PI/3);
  //these lines from 64-100 are doing two different things, first i made code for the planets for where they are on 
  //screen, how they rotate (direction and how fast) as well as the shape of the planet previously coded. I made these 
  //for all 3 planets changing their position and direction of rotation. I then used a boolean operater so i could make my code 
  //interactive so when you press your mouse the middle red planets stops spinning. this boolean operater basically just 
  //states "a" is true and then if "a" run the normal planet code i wrote and if else or in other words not "a" then i 
  //used the previuos planet code but took out the roating function for the red planet. so basically in simple terms if "a" 
  //is happening all my planets are normal and rotating but if "a" is not happening then it runs the other code where the 
  //red planet is not spinning. This "a" or not "a" is disccued in later lines of code.  
  if (a) {
    pushMatrix();
    translate(0.95*width,0.7*height,-20);  
    rotateY(PI*frameCount/500);  
    shape(Rp);  
    popMatrix();
    pushMatrix();
    rotateY(-PI*frameCount/1000);  
    translate(0.5*width,0.5*height,100);  
    shape(Gp); 
    popMatrix();
    pushMatrix();
    rotateY(PI*frameCount/1000);  
    translate(1*width, 1*height,100);  
    shape(Yp); 
    popMatrix();
  }
  else {
    pushMatrix();
    translate(0.95*width,0.7*height,-20);  
    shape(Rp);  
    popMatrix();
    pushMatrix();
    rotateY(-PI*frameCount/1000); 
    translate(0.5*width,0.5*height,100);  
    shape(Gp);  
    popMatrix();
    pushMatrix();
    rotateY(PI*frameCount/1000); 
    translate(1*width,1*height,100); 
    shape(Yp);  
    popMatrix();
  }
}
//this line is what makes the red planet stop rotating. like i previously mentioned, if "a" my code where planets 
//rotate is played and if not "a" code is played where my red planet stops rotating. so this line of code is for when 
//mouse is pressed "a" is not "a" so the code is now not "a" meaning its runs the else code 
void mousePressed() {
  a=!a;                
}
