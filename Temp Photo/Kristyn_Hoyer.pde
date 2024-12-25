float increment = 0.01;
// The noise function's 3rd argument, a global variable that increments once per cycle
float zoff = 0.0;  
// We will increment zoff differently than xoff and yoff
float zincrement = 0.02; 
// Counter for times the mouse has been pressed
int c=0;
//counter for how long the key was pressed
int c2=0;

void setup(){
  size(640, 360,P3D);
  background(0);}

// Displayes scenes after a given que
void draw(){
  //Calls the memory if the mouse is pressed
  if ( mousePressed){
    Memory_Loading();
    c=c+1;}
   // Calls the chaotic memory when the mouse is pressed 9 times
   if(c>10){
      Chaotic_Random_Memory();}
   //Calls the directional hope function when a key is held
   if (keyPressed==true){
        Hope_Directonal();
      c2=c2+1;}
   // Calls the hope spot light function when a key is held for a certain duration
   if (c2>15){
          Hope_Spots ();}
   //Calls the Aurora lights when the spotlights are aligned 
     if ((mouseY<=170)&&(mouseY>=140)){
     background(0,60,125);
     Hope();}
}

//Function made to symbolize a hazy memory 
void Memory_Loading (){
   /* Noise3D. Using 3D noise to create simple animated texture.Here, the third dimension ('z') is treated as time. */
  frameRate(30);
  loadPixels();
  float xoff = 0.0; // Start xoff at 0 
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < height; y++) {
      yoff += increment; // Increment yoff  
      // Calculate noise and scale by 255
      float bright = noise(xoff,yoff,zoff)*255;
      // Try using this line instead
      //float bright = random(0,255);
      // Set each pixel onscreen to a grayscale value
      pixels[x+y*width] = color(bright,bright,bright); }
  }
  updatePixels();
  zoff += zincrement; // Increment zoff
}

//Function made to symbolize a chaotic memory 
void Chaotic_Random_Memory () {
  /* Random. Random numbers create the basis of this image.Each time the program is loaded the result is different. */
  background(0);
  strokeWeight(20);
  frameRate (2);
  for (int i = 0; i < width; i++) {
    float r = random(255);
    stroke(r);
    line(i, 0, i, height); }
}

//Funtion made to symbolize digging deeper into a memory 
void Hope_Directonal(){ 
/* Directional. Move the mouse the change the direction of the light.
 * Directional light comes from one direction and is stronger when hitting a surface squarely and weaker if it hits at a gentle angle. After hitting a surface, a directional lights scatters in all directions. */
  noStroke(); 
  background(0); 
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1); 
  translate(width/2 - 100, height/2, 0); 
  sphere(80); 
  translate(200, 0, 0); 
  sphere(80); 
}

//Function made to symbolize searching for hope 
void Hope_Spots (){
  /*Spot. Move the mouse the change the position and concentation of a blue spot light. */
  noStroke();
  fill(204);
  background(0); 
  sphereDetail(60);
  // Light the bottom of the sphere
  directionalLight(51, 102, 126, 0, -1, 0);
  // Orange light on the upper-right of the sphere
  spotLight(204, 153, 0, 360, 160, 600, 0, 0, -1, PI/2, 600); 
  // Moving spotlight that follows the mouse
  spotLight(102, 153, 204, 360, mouseY, 600, 0, 0, -1, PI/2, 600);
  translate(width/2, height/2, 0);
  sphere(120);
}

//Function made to symbolize hope being found
void Hope (){
// Produces two circles at differnt places on the screens with differnt colours 
color c = color(125, 0, 200);  // Define color 'c'
fill(c);  // Use color variable 'c' as fill color
noStroke();  // Don't draw a stroke around shapes
ellipse(100, 100, 320, 320);  // Draw left circle
// Using only one value with color()
// generates a grayscale value.
c = color(75);  // Update 'c' with grayscale value
fill(c);  // Use updated 'c' as fill color
ellipse(300, 300, 320, 320);  // Draw right circle
}
