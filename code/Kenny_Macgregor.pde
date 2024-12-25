
float scale = 10; //each cell will be 10x10 pixels
int rows,cols;
float[][] flowfield; //define flow field as a 2d array of cells
particle[] swarm;
int swarmSize = 2500; //particle number, you can play around with this


// in the setup function we setup everything that our functions use
// the for loop on command will create the individual particles from the swarm size
// we also create a vector field "flow field" by calling generateFlowField()
void setup(){
  size(1200,700);
  colorMode(HSB,360,100,100); //switch from RGB to HSB
  swarm = new particle[swarmSize]; 
  for(int i = 0; i < swarmSize; i++){ 
    swarm[i] = new particle();
  }
  rows = int(height/scale);
  cols = int(width/scale);
  flowfield = new float[rows][cols];
   generateFlowField();
  background(0);
}

//class for the particle from which we create a swarm of particles
//we define our vector field as forces from which the particles will be influenced by
class particle{
  PVector position; //create 2d vector "position"
  PVector velocity; //create 2d vector "velocity"
  
  //constructor for patricle that instances will be based off of
  particle(){
    position = new PVector(random(width),random(height)); //when particle is created random position
    velocity = new PVector(0,0); // initially 0 velocity
  }
  //this function is VERY complicated
  //it calculates the acceleration due to the force vector from the cell that this particle is in
  //acceleartion x defined as force*x component of vector angle and vice versa for y
  void update(){
    PVector acceleration = new PVector(0,0); //acceleration starts at 0
    float force = 1; //force generated by each vector
    acceleration.x = force*cos(flowfield[int(position.y/scale)][int(position.x/scale)]); //define particle accelerations
    acceleration.y = force*sin(flowfield[int(position.y/scale)][int(position.x/scale)]);
    velocity.add(acceleration); //add acceleration to velocity
    position.add(velocity); //add velocity to position
    position.x = (position.x+width)%width; //make sure particle stays on screen
    position.y = (position.y+height)%height;
    
    velocity.mult(0.1); //friction nessecary because otherwise particles will somehow go supersonic
  }
  //display function shows the particle on the screen
  void display(){
    fill(0,100,100, 5); //reminder HSB mode not RGB
    stroke(0,100,100,5); //to change color of the flow change the first number
                         //in fill and stroke, recommend using RGB to HSB calculator
    circle(position.x,position.y,5);
  }
}
//draw the particles, update the particles, as long as swarmsize is below the set swarmsize number
void draw(){
 for(int i=0; i < swarmSize; i++){
    swarm[i].update();
    swarm[i].display();
 }
}

// this function creates a vector field from noise
void generateFlowField(){
  float noiseScale = 0.05; // "zoom" of the noise, something to play around with
  for(int r=0; r < rows; r++){
    for(int c=0; c < cols; c++){
      //generate the noise using processing's built in noise function from
      // 0 to 1 and then map it using map() from 0 to 2pi
      flowfield[r][c] = map(noise(r*noiseScale,c*noiseScale),0,1,0,2*PI); 
    }
  }
}
    
