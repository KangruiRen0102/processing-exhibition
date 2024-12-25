
Cow combinedShape; // this declares an instance of the combined shape class and defines some initial float values used in the code
float n=1;
float pi=3.14159;
float L=pi/2;


//this block sets the size and colour of the canvas, and initializes the size and colour of the cow
void setup() {
  size(3141/2,1000);
  noStroke();
  combinedShape = new Cow(50, 
  color(0, 0, 0), 
  color(255, 255, 255), 
  color(102, 051, 0), 
  color(7, 8, 50), 
  color(25, 30, 70),
  color(255, 103, 153),
  color(100, 100, 100));
}

//this block has all the components that will need to be drawn
void draw() {
  background(10);

//increases the value of "n" which governs the behavior of the planets. if the scene runs too long the "n" value resets
  n += 2;
  if (n > 100000) {
    n = 1;
 }

   // this updates the position of the combined shape to lag behind the mouse
  combinedShape.update(mouseX, mouseY, 0.1); // 0.1 is the easing factor, which scales the intensity of the lag

  // this displays the cow combined shape
  combinedShape.display();
}

// this block defines the Cow class with size, colours, and other variables
class Cow {
  float size; 
  color brown;
  color helm1;
  color nose;
  color grey;
  color helm2;
  color black; 
  color white; 
  float x, y;     
  float angle;       
  Cow(float size, color black, color white, color brown, color helm1, color helm2, color nose, color grey) {
    this.size = size;
    this.brown = brown;
    this.nose = nose;
    this.grey = grey;
    this.helm1 = helm1;
    this.helm2 = helm2;
    this.black = black;
    this.white = white;
    this.x = 0;
    this.y = 0;
    this.angle = 0;

  }

  // this block calculates the lag of the cow behind the mouse and the cow's rotation, based on the speed of the mouse
  void update(float targetX, float targetY, float easing) {
    // this calculates the lag (distance between current position and mouse position)
    float lag = dist(x, y, targetX - size / 2, targetY - size / 2);

    // updates position of the cow with easing factor applied
    this.x += (targetX - this.x - size / 2) * easing;
    this.y += (targetY - this.y - size / 2) * easing;

    // the rotation speed increases proportional to the lag. if the cow's position = mouse position, rotation speed = 0
    if(targetX != this.x) {
      angle -= lag * 0.05;
    }
  }


  // this block displays the background planets and shapes making up the cow
  void display() {
    //float n = mouseX; 
    // this block is for planet 1 (green planet). all planets operate on the parameter "n", with their location, size, and colour being on a cycle. 
    // i only describe planet 1, as it is the most complex and all the other planets function the same, only with different transformations to "n"
    float x1=1000+200*cos(n*0.005); //the x location of planet 1. the planet goes in an ellipse around the sun
    float y1=500+300*sin(n*0.005);  //the y location of planet 1
    float s1=1+abs(90*cos(n*0.0025));   //the size of planet 1. it shrinks and grows to simulate perspective
    fill(0,70*cos(n*0.005),100*cos(n*0.005)); // the colour of planet 1
    circle(x1,y1,s1);
    //these two circles provide a colour gradient for planet 1
    fill(0,150*cos(n*0.005),100*cos(n*0.005));
    circle(x1,y1,1+abs(80*cos(n*0.0025)));
    fill(0,255*cos(n*0.005),100*cos(n*0.005));
    circle(x1,y1,1+abs(60*cos(n*0.0025)));
    
    //moon 1 of planet 1
    float mx1=x1-100*cos(n*0.08)*cos(n*0.0025); //the x location of moon 1 of planet 1
    float my1=y1+150*cos(n*0.08)*cos(n*0.0025); //the y location of moon 1 of planet 1
    float ms1=1+abs(20*cos(n*0.0025)); //the size of moon 1 of planet 1
    fill(150*cos(n*0.005),50*cos(n*0.005),50*cos(n*0.005)); //the colour of moon 1 of planet 1
    circle(mx1,my1,ms1);
    //moon 2 of planet 1
    fill(75*cos(n*0.005),56*cos(n*0.005),75*cos(n*0.005));
    circle(x1-50*cos(n*0.06)*cos(n*0.0025),y1+150*cos(n*0.06)*cos(n*0.0025), 1+abs(15*cos(n*0.0025)));
    
    //planet 2 (small orange planet)
    fill(100*sin(n*0.025-pi/4),60*sin(n*0.025-pi/4),0);
    circle(700+300*cos(n*0.025),525+100*sin(n*0.025),1+abs(35*sin(n*0.0125)));
    fill(150*sin(n*0.025-pi/4),100*sin(n*0.025-pi/4),0);
    circle(700+300*cos(n*0.025),525+100*sin(n*0.025),1+abs(30*sin(n*0.0125)));
  
    //sun
    fill(250,100+abs(30*cos(n*0.0033)),0);
    circle(950,500,50+2*abs(cos(n*0.0033)));
    fill(250,170,100);
    circle(950,500,30+5*abs(cos(n*0.0033)));
    fill(250,240,100);
    circle(950,500,5+10*abs(cos(n*0.0033)));
    
    //planet 4 (red planet)
    fill(200*sin(n*0.007-pi/5),10*sin(n*0.007-pi/5),10*sin(n*0.007-pi/5));
    circle(800+200*cos(n*0.007),500+300*sin(n*0.007), 1+70*sin(n*0.0035));    
    fill(250*sin(n*0.007-pi/5),20*sin(n*0.007-pi/5),20*sin(n*0.007-pi/5));
    circle(800+200*cos(n*0.007),500+300*sin(n*0.007), 1+60*sin(n*0.0035));
    
    //circle(800+200*cos(n*0.007)+100*cos(n*0.07)*cos(n*0.007/(pi/1.5)-pi/2),500+300*sin(n*0.007)+150*sin(n*0.07)*cos(n*0.007/(pi/1.5)-pi/2), 1+20*sin(n*0.0035));
    
    // glare of planet 3
    fill(20+255*sin(n*0.05+L),20+255*sin(n*0.05+L),20+255*sin(n*0.05+L));
    circle(950+200*cos(n*0.0025)+5,500+3000*sin(n*0.0025),1+abs(400*sin(n*0.00125)));
    
    //planet 3 (large dark planet)
    fill(10*sin(n*0.05-L),25*sin(n*0.05-L),50*sin(n*0.05-L));
    circle(950+200*cos(n*0.0025),500+3000*sin(n*0.0025),1+abs(400*sin(n*0.00125)));
    fill(10*sin(n*0.05-L),23*sin(n*0.05-L),35*sin(n*0.05-L));
    circle(950+200*cos(n*0.0025),500+3000*sin(n*0.0025),1+abs(390*sin(n*0.00125)));
    fill(10*sin(n*0.05-L),18*sin(n*0.05-L),20*sin(n*0.05-L));
    circle(950+200*cos(n*0.0025),500+3000*sin(n*0.0025),1+abs(373*sin(n*0.00125)));
    fill(13*sin(n*0.05-L),5*sin(n*0.05-L),10*sin(n*0.05-L));
    circle(950+200*cos(n*0.0025),500+3000*sin(n*0.0025),1+abs(350*sin(n*0.00125)));
     
    pushMatrix(); // save the current transformation state of the cow
    translate(x + size / 2, y + size / 2); // this moves the origin to the center of the shape
    rotate(radians(angle)); // this rotates the cow shape
    
    //these are the shapes that make up the cow
    // backlegleg1
    fill(grey); // sets the colour of the body part
    ellipse(size * 0.5, -size * 0.5, size * 0.35, size * 0.8); // draws the body part. all dimentions scale with "size", leaving the proportions the same if "size" is changed
    
    // backlegleg2
    fill(grey); 
    ellipse(-size * 0.55, -size * 0.5, size * 0.35, size * 0.8);
    
    //helmet rim
    fill(helm1);
    ellipse(size, size*0.2, size * 1.5, size * 1.5); 
    
    //helmet
    fill(helm2);
    ellipse(size, size*0.2, size * 1.4, size * 1.4); 
    
    // frontleg1
    fill(white);
    ellipse(size * 0.4, -size * 0.5, size * 0.35, size * 0.8);
    
    // frontleg2
    fill(white); 
    ellipse(-size * 0.65, -size * 0.5, size * 0.35, size * 0.8); 
    
    // body
    fill(white);     
    rectMode(CENTER); 
    rect(0, 0, size*0.9, size*0.8); 
    
    // butt
    fill(white);
    ellipse(-size * 0.4, 0, size * 0.8, size * 0.8);

    // neck
    fill(white); 
    ellipse(size * 0.5, 0, size * 0.8, size * 0.8); 
    
    // spot1
    fill(black); 
    ellipse(-size * 0.5, size * 0.2, size * 0.4, size * 0.4); 
    
    // spot2
    fill(black); 
    ellipse(-size * 0.2, 0, size * 0.6, size * 0.6); 
    
    // spot3
    fill(white); 
    ellipse(0, size*0.1, size * 0.3, size * 0.3); 
    
    // ear1
    fill(white); 
    ellipse(size*1.25, size*0.45, size*0.3, size * 0.3); 
    
    // ear2
    fill(white); 
    ellipse(size*0.77, size*0.45, size*0.3, size * 0.3); 
    
    // head
    fill(white);
    ellipse(size, size * 0.3, size * 0.7, size * 0.7);
    
    // nose
    fill(nose); 
    ellipse(size, 0, size*0.6, size * 0.4); 
    
    // nost1
    fill(black); 
    ellipse(size*1.2, -size*0.1, size*0.2, size * 0.1); 
    
    // nost2
    fill(black); 
    ellipse(size*0.85, -size*0.1, size*0.2, size * 0.1); 
    
    // horn1
    fill(brown); 
    ellipse(size*1.2, size*0.65, size*0.1, size * 0.3); 
    
    // horn2
    fill(brown); 
    ellipse(size*0.85, size*0.65, size*0.1, size * 0.3); 
    
    // eye1
    fill(black); 
    ellipse(size*1.2, size*0.4, size*0.1, size * 0.1); 
    
    // eye2
    fill(black);
    ellipse(size*0.85, size*0.4, size*0.1, size * 0.1); 
        
    popMatrix(); // this restores the original transformation state
  }
}   
    
 
  
  
