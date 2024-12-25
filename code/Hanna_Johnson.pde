//initialize the size of window and draw background
void setup(){ 
  size(600,200); 
  
// background /*loop to draws horizontal lines which change RGB values to create the illusion of a gradient. */
//starting drawing horizontal lines at top of window
int x1 = 0; 
int y1 = 0; 
//stop drawing lines at bottom of window
int x2 = 600; 
int y2 = 0; 
//rgb integers to initialize blue sky
int R1 = 45; 
int G1 = 30; 
int B1 = 81; 
stroke(R1,G1,B1); 
// draws 200 horizontal lines to create a gradient effect by increasing blue value each time
for (int x=0; x<=200; x++){ 
stroke(R1,G1,B1); 
line(x1,y1,x2,y2); 
y1++; 
y2++; 
B1++; } 

// draw stars in random locations in the window
//choose random locations for the stars to be
float randomX; 
float randomY; 
stroke(255); //white stars
strokeWeight(2); 
// Creates a loop to draw 50 stars to the background 
for(int i=0;i<50;i++){ 
  randomX = random(0,600); 
  randomY = random(0,200); 
  point(randomX,randomY); 
 } 
}

//draw a circle for the moon with diameter of 15
void drawMoon(){
stroke(200); 
fill(200); 
ellipseMode(CENTER); 
smooth(); 
ellipse(60,30,15,15); 
}

//main draw function -- first draws northern lights, then buildings and moon to have the objects in the correct order
void draw() { 
drawNorthernLights();
drawBuilding(); 
drawMoon();
} 


// uses a curve that begins in the top left and ends in the bottom right to draw the northern lights
void drawNorthernLights(){
  frameRate(8); //slows down the rate of lines drawn
strokeWeight(10); //lines are 10 wide
saturation(100); // maximum saturation for bright colors
noFill();
//the color of the lines is set to a random color with a specific range of values to only have blues, greens, pinks, and purples
stroke(random(51,170),random(51,255),random(170,255),40);
//syntax to draw the curve
beginShape();
vertex(random(0,600),0);
curveVertex(0,0); //begin curve in top left corner of window
curveVertex(0,0);
curveVertex(150,50);
curveVertex(mouseX,mouseY); //mouse location determines the location of curve arc
curveVertex(450,150);
curveVertex(600,200);
curveVertex(600,200); //end curve in bottom right of window
endShape();
}

//function to draw the buildings
void drawBuilding(){
strokeWeight(2); 
smooth(); 

//building 1 
strokeWeight(2); //line thickness
stroke(35,100); //line color
fill(35); // building color 
rect(0,100,30,100); //drawing shapes to represent building

//building 2
stroke(35); 
fill(35); 
rect(35,80,18,120); 

//building 3
stroke(40); 
fill(40); 
rect(110,50,30,150); 

//building 4
stroke(0); 
fill(0); 
rect(15,120,25,80); 

//building 5
stroke(0); 
fill(0); 
rect(50,103,17,97); 
rect(53,100,11,100); 
rect(67,170,16,30); 
rect(83,130,17,70); 
rect(86,127,11,73); 

//muttart 
stroke(0); 
fill(0); 
triangle(90,200,150,200,120,160); 
triangle(125,200,165,200,145,180); 

//legislature 
stroke(0); 
fill(0); 
rect(153,140,164,60); 
rectMode(CENTER); 
rect(235,140,46,8); 
rect(235,140,30,20); 
rect(235,140,24,38); 
ellipseMode(CENTER); 
ellipse(235,121,22,20); 
rect(235,140,5,65); 
ellipse(235,107,5,5); 

//peak residences
stroke(35); 
fill(35); 
rectMode(CORNER); 
rect(320,100,21,100); 
triangle(320,100,320,90,340,100); 

//building 6
stroke(0); 
fill(0); 
rect(340,85,60,115); 
rect(340,100,70,100); 
rect(346,80,47,120); 
rect(350,76,7,123); 
rect(380,76,7,123); 

//building 7
stroke(35); 
fill(35); 
rect(480,90,20,110); 

//bridge 
stroke(0); 
fill(0); 
rect(400,193,200,7); 
noFill();  
arc(450,185,100,40, PI, TWO_PI); //bridge arc 
line(400,185,500,185); //bottom line of bridge deck 
line(450,165,450,185); //center vertical line 
line(443,167,443,185);//second from centre 
line(457,167,457,185); 
line(436,167,436,185);//third from centre 
line(464,167,464,185); 
line(471,168,471,185);//fourth from centre 
line(429,168,429,185); 
line(478,168,478,185);//fifth from centre 
line(422,168,422,185); 
line(485,171,485,185);//sixth from centre 
line(415,171,415,185); 
line(492,173,492,185);//seventh from centre 
line(408,173,408,185); 

//epcor tower 
stroke(0); 
fill(0); 
rect(495,135,45,65); 
quad(496,137,505,130,530,130,539,137); 
triangle(512,130,522,130,517,125); 

//church 
rect(545,165,35,35); 
triangle(545,165,562.5,150,580,165); 
rect(580,120,20,80); 
}
