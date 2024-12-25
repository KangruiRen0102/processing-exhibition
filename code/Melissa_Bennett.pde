/*
* initializing values
*/
// wave parameters
float[] yvalues; // stores height values for the wave
int xspacing=16; //horizontal spacing
int w; // wave width
float theta=0.0; // starting angle of 0
float amplitude=25.0;// wave height
float dx; //value for incrementing X
float period=300; // pixels before the wave repeats

// circle storage
ArrayList<myCircle> circlesToDraw;

// color params
color waveColor = color(184,22,41); //red
color backgndColor = color(104,12,23); //dark red
color circleColor = color(255); // white

/*
* Circle class
*/
class myCircle {
  float y,x,radius;
  color myCircleColor = circleColor;

  
  myCircle (float y,float x, float radius){
    this.y=y;
    this.x=x;
    this.radius = radius;
  }
  
  void displayCircle(){
   fill(circleColor); 
   ellipse(y,x,radius*2,radius*2); //drawing the circle
  }
  
  void shrink(){
    radius--;
  }
  
  boolean isGone(){
    return radius <= 0;
  }
}


  

void setup() {
  size(640,360); // set display window size
  
  // set up wave params
  w=width+100;
  dx=(TWO_PI /period)*xspacing;
  yvalues=new float[w/xspacing];
  
  // initialize list of circles
  circlesToDraw = new ArrayList<myCircle>();
}

 /*
 * calling functions and drawing them
 */
 void draw() {
   background(backgndColor); // dark purple background
   calcWave(); 
   renderWave(); 
   calcCircles();
   for (myCircle circle: circlesToDraw){
     circle.displayCircle();
   }
  
 
 }
 
 /*
 *calculating the points where the wave will show up
 */
 void calcWave() {
   theta += 0.02;
   float x=theta;
   for (int i=0; i<yvalues.length; i++) {
     yvalues[i]=sin(x)*amplitude;
     x+=dx;
   }
 }
 
 /*
 * circles shrink until they disapear
 */ 
  void calcCircles(){    
    for (int i=0; i<circlesToDraw.size(); i++) {
      myCircle c = circlesToDraw.get(i);
      c.shrink();
      if(c.isGone()){
        circlesToDraw.remove(i);
      }
    }
  }
  
 /*
 *drawing the and making it solid
 */
 void renderWave() {  
  noStroke();
  fill(waveColor);
  beginShape(); //making the wave solid
  for (int x = 0; x < yvalues.length; x++) {
     vertex(x*xspacing, height/2+yvalues[x]);
  }
  vertex(40*xspacing, height/2+yvalues[39]);
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

/*
* adding circle to the drawing when mouse pressed
*/
void mousePressed() {
   circlesToDraw.add(new myCircle(mouseX, mouseY,50));
}
