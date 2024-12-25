

class Shape { 
  //Constructor for Shape class
  float x;
  float y;
  float C;
  float Op; //Opacity
  float r1;
  float r2;
  float x1, y1, x2, y2; // used for beak only
  Shape(float x, float y, color C){
    this.x=x;
    this.y=y;
    this.C=C;  
    Op = 1; //initial opacity of 100%

  }
}
Shape iceberg;
Shape penguinb;// defines these shapes as instances of Shape class, lets us call them later
Shape tummy;
Shape beak;

Shape a1;//arms
Shape a2;

Shape f1; //feet
Shape f2;

void setup(){
  size (800,800);
  background(0,0,100);
  iceberg = new Shape (400, 400, color(255)); // calls instance of shape class, placed at (400,400) (initially)
  penguinb = new Shape (400, 400, color(0));
  tummy = new Shape (400, 400, color(255));
  beak = new Shape (400 ,400,color(255));
  a1= new Shape(400,400, color(0));
  a2= new Shape(400,400, color(0));
  f1 =new Shape(400,400,color(0));
  f2 =new Shape(400,400,color(0));
}

void draw() {
  background(0,0,125); //sets background dark blue
  iceberg.Op -= 0.005;
  if (iceberg.Op<0){
    iceberg.Op=0;
    
    penguinb.Op=0; //causes penguin to disappear when iceberg "sinks"
    tummy.Op=0;
    beak.Op=0;
    a1.Op=0;
    a2.Op=0;
    f1.Op=0;
    f2.Op=0;
    
  if (iceberg.Op>0){
      penguinb.Op=1; //fixes error when after an iceberg disappeared, most body parts would be permamnently invisible, even if a new iceberg was created
      tummy.Op=1;
      beak.Op=1;
      a1.Op=1;
      a2.Op=1;
      f1.Op=1;
      f2.Op=1;
  }
    
    
  } //above section makes the iceberg slowly fade, it has to check for opacity less than zero to stop errors

//draws iceberg
  fill(240, 240,255, iceberg.Op * 255);
  ellipse(iceberg.x, iceberg.y,iceberg.r1,iceberg.r2);
  noStroke(); // disabled object border, this code found in example done in class
  // draws outline and fills a circle w random radius
  
  //draws black abdomen on penguin
  fill(0,0,0,penguinb.Op*255);
  ellipse(penguinb.x,penguinb.y,30,30); //places penguin on cursor
  
  //draws tummy :D
  fill(255,255,255,tummy.Op*255);
  ellipse(tummy.x,tummy.y,20,10); //makes an ellipse
  
  //draws beak
  fill(250,100,100,beak.Op*255);
  triangle(beak.x,beak.y,beak.x1,beak.y1,beak.x2,beak.y2);
  
  //draws arms
  fill(0,0,0,a1.Op*255);
  ellipse(a1.x,a1.y,15,15);
  
  fill(0,0,0,a1.Op*255);
  ellipse(a2.x,a2.y,15,15);
  
  //draws feet
  fill(0,0,0,f1.Op*255);
  ellipse(f1.x,f1.y,10,10);
  
  fill(0,0,0,f2.Op*255);
  ellipse(f2.x,f2.y,10,10);
}  

void mousePressed() {
  //iceberg
    iceberg.x = mouseX;
    iceberg.y = mouseY;
    iceberg.C = 255;
    iceberg.Op = 1;
    iceberg.r1 = random(50,400);
    iceberg.r2 = random(50,400);
    
  //penguin black part
    penguinb.x=mouseX +random(-1,1)*1/3*iceberg.r1;
    penguinb.y=mouseY +random(-1,1)*1/3*iceberg.r2;
    penguinb.C=0;
    penguinb.Op=1;
    
        //foot 1
    f1.x =penguinb.x-7;
    f1.y = penguinb.y+15;
    f1.Op=1;
    
    //foot 2
    
    f2.x=penguinb.x+7;
    f2.y=penguinb.y+15;
    f2.Op=1;
    
  //tummy
    tummy.x=penguinb.x;
    tummy.y=penguinb.y+10;
    tummy.Op=1;
    
// penguin beak
    beak.x = penguinb.x;
    beak.y = penguinb.y+17;
    beak.x1 = penguinb.x -4;
    beak.y1 = penguinb.y+10;
    beak.x2 = penguinb.x+4;
    beak.y2 = penguinb.y+10;
    beak.Op=1;
    
    //arm 1
    a1.x = penguinb.x-17;
    a1.y=penguinb.y;
    a1.Op=1;
    
   //arm 2
    a2.x = penguinb.x+17;
    a2.y=penguinb.y; 
    a2.Op=1;
    

}
  
