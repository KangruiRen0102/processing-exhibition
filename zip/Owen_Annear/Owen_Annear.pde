class Rectangle { //create rectangles woo yeah
  int x, y, w, h;
  color fillcolor;
  
  Rectangle(int x, int y, int w, int h, color fillcolor) { // constructor for rectangle class
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.fillcolor = fillcolor;
  }
  
  void display() { // method to draw rectangles on screen
    fill(fillcolor);
    rect(x, y, w, h);
  }
  
  boolean isInside(int mx, int my) { //check if point mx and my are inside the rectangle
    return (mx >= x - w / 2 && mx <= x + w / 2 && 
            my >= y - h / 2 && my <= y + h / 2);
  }
}
  
// Lists to store the drawn rectangles
ArrayList<Rectangle> Floors;
ArrayList<Rectangle> Doors;
ArrayList<Rectangle> Windows;

// List to store background colours and index 'Time' used to access indeces
ArrayList<Integer> Backgrounds;
int Time = 0;
  
void setup() {
  size(500,500);
  rectMode(CENTER);
  Floors = new ArrayList<Rectangle>();
  Doors = new ArrayList<Rectangle>();
  Windows = new ArrayList<Rectangle>();
  
  Backgrounds = new ArrayList<Integer>();
  Backgrounds.add(color(135, 205, 235));
  Backgrounds.add(color(50,50,50));
}

void draw() { // throws up shapes on the screen
  background(Backgrounds.get(Time));
  
  if (Time == 0) { // Draw sun or moon depending on chosen time
    fill(255,255,0);
  } else {
    fill (255,255,255);
  }
  ellipse(500,0,100,100);
  
  fill(200);
  rect(mouseX, 500-(50*Floors.size()+25), 150, 50); //have a light grey rectangle follow mouse
                                                    //and sits on top of previous floor
  for (Rectangle floor : Floors) { // draw floors
    floor.display();
  }
  
  for (Rectangle door : Doors) { // draw door
    door.display();
  }
  
  for (Rectangle window : Windows) { // draw windows
    window.display();
  }
}

void mousePressed() { // draw floors using mouse
  

  if (Floors.size() == 0) { // draw first floor, which includes a door
    Floors.add(new Rectangle(mouseX, 500-(50*Floors.size()+25), 150, 50, 100));
    Doors.add(new Rectangle(mouseX, 500-25/2, 10, 25, color(150, 75, 0)));
  } else {
    Rectangle floor = Floors.get(Floors.size()-1); //ensure that second+ floors are on top of previous floors
    if (floor.isInside(mouseX+75, floor.y) == true || floor.isInside(mouseX-75, floor.y)) {
      Floors.add(new Rectangle(mouseX, 500-(50*Floors.size()+25), 150, 50, 100));
    }
  }
}

void keyPressed() {
  if (key == 'r') { // clear all floors, windows when r is pressed
    Floors.clear();
    Doors.clear();
    Windows.clear();
  }
  if (key == 'w' && Floors.size() >= 1) { // create windows over mouse cursor if w is pressed
    for (int i = 0; i < Floors.size(); i++) { // ensure windows can only be placed on floors
      Rectangle floor = Floors.get(i);
      if (floor.isInside(mouseX+5, mouseY+5)==true && floor.isInside(mouseX-5, mouseY-5)==true) {
        Windows.add(new Rectangle(mouseX, mouseY, 10, 10, color(0,0,255)));
      } 
    }
  }
  if (key == 't') { // Change the background colour
    if (Time < Backgrounds.size() -1) {
      Time = Time +1;
    } else {
      Time = 0;
    }
  }
}
