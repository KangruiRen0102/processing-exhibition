SkibidiBall[] skibidiballs = new SkibidiBall[16]; //create an array that can hold 30 objects from a created class

void setup() {
    size(1080, 720);
    
    for(int i = 0; i < skibidiballs.length; i++) { //create a for loop that iterates over each element in the array
        int dx, dy;
        
        do {
            dx = int(random(-5, 5));
            dy = int(random(-5, 5));
        } while (dx == 0 || dy == 0); //prevent the x and y velocities from having a value of zero, as the balls not moving symbolizes failure and that's depressing. idk im an engineer, not a philosopher
        
        skibidiballs[i] = new SkibidiBall(int(random(400,600)), int(random(250, 300)), dx, dy, int(random(10,50))); //The SkibidiBall constructor takes five arguments: the x and y coordinates, the horizontal and vertical speeds, and the size of the ball. each is randomized to symbol each unique engineering student
    }}
void draw() {
    for(int i=0; i < skibidiballs.length; i++) {
        skibidiballs[i].display();
        skibidiballs[i].update(); // The display() method is used to handle drawing the balls on the canvas, while the update() method is used to handle updating the ball's unique positions and velocities.
}}

class SkibidiBall { //declares a new class
    private int y, x, dy, dx, size; //store position, velocity, size of ball
    private color colour = color(0 ,0 , 0); //declare a private color member for the balls
    
    public SkibidiBall(int x, int y, int dx, int dy, int size) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.size = size; //constructor; allign each parameter with its respective variables
        if (random(10) < 5) {
        this.colour = color(0, 255, 0); // Green
    } else {
        this.colour = color(255, 255, 0); // Yellow  
      // starting color is either green or yellow, which are out university colors. this symbolizes our starting point in university
    }
 }
    public void update() {
         move();
         checkwallcollision(); //update movement, and check for collision in order to keep the balls in the box at all times
    }

    public void move() {
        y += dy; 
        x += dx; //updates the x and y members by adding the dx and dy variables. this is the velocity, and how i make the skibidiballs move
    }  
    
    public void checkwallcollision() {
        if(horizontalwallcollide()) {
             setdy(getdy() * -1);
             colorchange();
         }   
        if(verticalwallcollide()) {
             setdx(getdx() * -1);
             colorchange();  //reverse dx and dy values on collision with wall, to ricochet the balls, while changing color at the same time to a completely random color. this symbolizes the unique impacts and memories of each ball
         }
    }
    public void colorchange() {
        this.colour = color(random(255),random(255),random(255)); //generates a random color with random red, blue, green components
    }
      public boolean verticalwallcollide() {
          if (getX()+(getSize()/2) > width || getX()-(getSize()/2) < 0) {
            return true;
          }
          return false;
      }
      public boolean horizontalwallcollide() {
          if (getY()+(getSize()/2) > height || getY()-(getSize()/2) < 0) { //checks for collisions, checks for ball radius so ball edges bounce off the walls
            return true;
          }
          return false;
      }
      public void display() {
          fill(this.colour);
          ellipse(x, y, size, size);  //display method to display ball onto canvas
      }
      public void setdy(int dy) {
        this.dy = dy;
      }
      public void setdx(int dx) {
        this.dx = dx; 
      }
      public int getdy() {
          return this.dy;
      }
      public int getdx() {
          return this.dx = dx;
      }
      public int getX() {
          return this.x;
      }
      public int getY() {
          return this.y;
      }
      public int getSize() {
          return this.size; //setter and getter methods
      }}
