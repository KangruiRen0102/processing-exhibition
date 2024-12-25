ArrayList<Boat> boats;//arraylist for all boats
int clickCount=0;
float shift=0;
Boat boat1;
void setup() {
  size(800,800);
  strokeWeight(2);
  boats = new ArrayList<Boat>();
}
void mouseClicked(){
    clickCount+=1;
    Boat boat1 = new Boat(mouseX,mouseY,clickCount%2,clickCount%7);
    boats.add(boat1);
}
void draw() {
  background(0,191,255); // Set the background color
  textSize(45);
  fill(255);
  text("Click to send the boats on their journey!",20,45);
  
  for(float h=0; h<height; h+=160){//loop for creating multiple instances of wave sha[e
    stroke(50, 100, 255);
    strokeWeight(4);
    noFill();
    beginShape();//creation of wave
    for(float x = 0; x < width; x += 10) {//loop for creating wave shape
      float y = 10 * sin(0.05 * x+shift+h);
      vertex(x,80+y+h);
    }
    endShape();
  }
  shift+=0.05;
  for(Boat c: boats){//draws boats
    c.display();
  } 
}
class Boat {
  int x, y, left, colour;
  color flag;
  float displacementX=0;
  float displacementY=0;
  Boat(int xPos, int yPos, int direction, int index){//boat constructor
    x=xPos;
    y=yPos;
    left=direction;
    switch(index){//decides flag colour
      case 1:
        flag = color(255,0,0);//red
        break;
      case 2:
        flag = color(252,127,3);//orange
        break;
      case 3:
        flag = color(252,219,3);//yellow
        break;
      case 4:
        flag = color(0,199,20);//green
        break;
      case 5:
        flag = color(8,92,201);//blue
        break;
      case 6:
        flag = color(69,8,201);//indigo
        break;
      case 0:
        flag = color(160,8,201);//violet
        break;
    }

  }

  void display() {//method to show the boat
  strokeWeight(2);
  stroke(0);
    if(left==1){      
      fill(139, 69, 19);
      beginShape();//hull
      vertex(x-50+displacementX,y+20+displacementY);
      vertex(x+50+displacementX,y+20+displacementY);
      vertex(x+70+displacementX,y+displacementY);
      vertex(x-70+displacementX,y+displacementY);
      endShape(CLOSE);
      fill(160,82,45);// upper deck
      rect(x-70+displacementX,y-30+displacementY,60,30);
      fill(255);//sail
      triangle(x+displacementX,y-90+displacementY,x+20+displacementX,y-30+displacementY,x+displacementX,y+displacementY);
      fill(flag); //flag
      triangle(x+displacementX,y-90+displacementY,x-30+displacementX,y-85+displacementY,x+displacementX,y-80+displacementY);
    }else{
      fill(139, 69, 19);
      beginShape();//hull
      vertex(x+50-displacementX,y+20+displacementY);
      vertex(x-50-displacementX,y+20+displacementY);
      vertex(x-70-displacementX,y+displacementY);
      vertex(x+70-displacementX,y+displacementY);
      endShape(CLOSE);
      fill(160,82,45);// upper deck
      rect(x+10-displacementX,y-30+displacementY,60,30);
      fill(255);//sail
      triangle(x-displacementX,y-90+displacementY,x-20-displacementX,y-30+displacementY,x-displacementX,y+displacementY);
      fill(flag); //flag
      triangle(x-displacementX,y-90+displacementY,x+30-displacementX,y-85+displacementY,x-displacementX,y-80+displacementY);
    }
    displacementX+=1.25;
    displacementY=15*sin(displacementX/30);
  }
}
