int maxCircles = 300;  //the maximum # of circles that the code will add
int circleCount = 0;  //the number of circles drawn, startes at zero and will increas to 300

void setup() {
  size(600, 600);  //creats a blank canvas for all the circles to go on 
}

void draw() {  //keeps drawing new circles until all 300 have been drawn
  if (circleCount < maxCircles) {
    float x = random(width);  //a random X position for the circle
    float y = random(height);  //a random Y position for the circle
    float d = random(30, 120);  //a random diamiter for the circle
    circle(x, y, d);  //draws a circle with (x,y) as the position and d as the diameter
    fill(random(255), random(255), random(255));  //random color to fill the circle
    circleCount++;  //add 1 to circle count
  }
}
