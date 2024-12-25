//variables
//Graphics/rendering context for Processing
PGraphics pg;
float r=20;
float t;
float theta;

//class level constant 
static final int num1 = 500;

//instance of the class Particle
Particle myParticle;

class Particle {
  float x, y; // Position of the particle
  float t;    // Time variable to control the motion
  // Constructor to initialize the particle
  Particle(float startX, float startY) {
    x = startX;
    y = startY;
    t = 0; // Initial time
  }
  // Method to update the position of the particle in a figure-8 motion
  void move() {
    t+=0.03; // Increment time to move the particle
    // Parametric equations for figure-8 motion
    x = 230 * cos(t);
    y = 230 * sin(2*t)/2;
    if (mousePressed) {
    t+=0.03+0.04;
    }
  }
  // Method to display the particle on the screen
  void display() {
  // Change background color based on key
    if (key == 'r' || key == 'R') {// 'R' key changes colour to red
      fill(#CA0718);
    } else if (key == 'g' || key == 'G') {// 'G' key changes colour to green
      fill(#43E034);
    } else if (key == 'b' || key == 'B') {// 'B' key changes colour to blue
      fill(#2596BE);
    } else if (key == 'w' || key == 'W') {// 'W' key changes colour to white
      fill(#FFFFFF);
    } else if (key == 'y' || key == 'Y') {// 'Y' key changes colour to yellow
      fill(#EBEB36);
    } else if (key == ' ') {// spacebar changes colour to random 
      fill(random(255),random(255),random(255));
    }
    ellipse(x+width/2, y+height/2, 3, 3); // Centering the particle on the screen
  }
}

//inital parameters/condtitions
void setup() {
  size(600, 500);
  //function that utilizes PGraphics
  pg = createGraphics(400, 200);
  myParticle = new Particle(0, 0);
}

//parameters that change infinitly
void draw() {
  myParticle.move();  
  myParticle.display();
  fill(0, 12);
  //draws a rectangle
  rect(0,0,width,height);
  noStroke();
  translate(width/2,height/2);
  fill(100);
  for (int i=0; i < num1; i++) {
    stroke(40);
    float x1=x1(theta+i);
    float y1=y1(theta+i);
    //points positions dependent on t and i
    point(x1,y1);
  }
  //motion of particles/points in figure 8 tragectory
  theta+=10;
  //increases the speed of the particles momentarily
}

//parametic equations mapping inifinity/figure-8 motion 
float x1 (float t){
  return 230*cos(t);
}
float y1 (float t){
  return 230*sin(2*t)/2;
}
