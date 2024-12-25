
//Ripple properties
int centerX = 400;  
int centerY = 300;  
float radius = 0f; 
int fillColor = color(92, 150, 240); 
float maxRadius = 1000f; 
int duration = 10000;  // Ripple effect are in milliseconds
long startTime; 
boolean isCreatingRipple = false;  // Flag to control ripple creation

//Setting up the text after the ripple has started, showcasing the "Hope" part of the thematic statement
boolean showText = false;  // Flag to control text display
int textDelay = 3000;  // Delay for text display in milliseconds (3 seconds)


void setup() {
    size(800, 600);  // Set canvas size (800x600)
    noFill();
    textAlign(CENTER, CENTER);
}


void draw() {
    background(255);  // Clear the screen with white

    // All of the text is shown beforehand, displaying the "Chaos" part of the thematic statement
    //This is to show less alignment, being able to portrays the chaos
    //textSize = size of the text
    //fill(colour()) = the colour of the text
    //x and y values = coordinates of the texts on the screen
    //float angle = radians() and rotate(angle0 rotates the texts a certain amount of degrees
   
    textSize(35);
    fill(color(0, 0, 0));  // Set text color to black
    text("why can't I do better?", 200, 200);  // Draw text at specified position 
     
    text("it's too much", 400, 400); 
    
    text("what if", 150, 25) ; 
    
    text("if they can do it why can't you", 230, 580);
    
    text("do it like they do", 620, 20);
    
    text("too frustrating", 105, 300);
    
    text("I don't want to do it anymore" , 510, 260);
    
    textSize(45);
    text("I need to do more", 630, 550); 
    
    text("give up", 260, 430);
  
    textSize(30);
    text("i'm lost", 375, 75); 
    
    text("i'm scared to fail", 500, 175); 
    
    text("why can't I be like them", 600, 330);
    
    text("be better", 600, 150);
    
    text("fit in", 260, 340);
    
    text("you have to do this", 240, 545);
    
    textSize(25);
    text("do more than that", 110, 170);
    
    text("don't make mistakes", 200, 380); 
    
    text("dumb" , 610, 440);
    
    fill(color(255, 0, 0));
    textSize(40);
    text("my efforts are not enough", 530, 290);
    
    text("I keep failing", 475, 50);
    
    text("I don't know what to do", 200, 480); 
    
    text("i'm so jealous of them", 400, 120) ; 
    
    textSize(25);
    text("do it perfectly", 530, 520); 
    
    pushMatrix();
    float angle1 = radians(35);
    translate(700,420);
    rotate(angle1);
    textSize(25);
    fill(color(0, 0, 0));
    text("I am not good enough", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle2 = radians(-45);
    translate(390,310);
    rotate(angle2);
    textSize(20);
    fill(color(0,0,0));
    text("there's too many things", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle3 = radians(-20);
    translate(680,60);
    rotate(angle3);
    fill(color(0,0,0));
    textSize(30);
    text("it never gets easier", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle4 = radians(20);
    translate(180,450);
    rotate(angle4);
    fill(color(0, 0, 0));
    textSize(30);
    text("I couldv'e done so much better", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle5 = radians(-30);
    translate(400,530);
    rotate(angle5);
    fill(color(0, 0, 0));
    textSize(25);
    text("it's too hard", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle6 = radians(30);
    translate(170,100);
    rotate(angle6);
    fill(color(0,0,0));
    textSize(40);
    text("maybe I should quit", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle7 = radians(-15);
    translate(120,530);
    rotate(angle7);
    textSize(25);
    fill(color(0, 0, 0));
    text("don't deserve to rest", 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(230,300);
    rotate(angle3);
    textSize(45);
    fill(color(255, 0, 0));
    text("wish I could be like them", 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(620,220);
    rotate(angle4);
    textSize(35);
    fill(color(0, 0, 0));
    text("i'm so tired", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle8 = radians(10);
    translate(560,475);
    rotate(angle8);
    textSize(35);
    fill(color(0, 0, 0));
    text("need to reach their expectations", 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(140,260);
    rotate(angle8);
    textSize(40);
    fill(color(0, 0, 0));
    text("how do I do this", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle9 = radians(-10);
    translate(250,50);
    rotate(angle9);
    textSize(20);
    fill(color(0, 0, 0));
    text("someone stop it please", 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(100,130);
    rotate(angle4);
    textSize(25);
    fill(color(0, 0, 0));
    text("just stop", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle10 = radians(50);
    translate(700,190);
    rotate(angle10);
    textSize(25);
    fill(color(0, 0, 0));
    text("how are they so perfect", 0, 0);
    popMatrix();
    
    pushMatrix();
    float angle11 = radians(5);
    translate(500,380);
    rotate(angle8);
    textSize(40);
    fill(color(255, 0, 0));
    text("will it ever get better", 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(740,115);
    rotate(angle8);
    textSize(40);
    fill(color(0, 0, 0));
    text("stupid", 0, 0);
    popMatrix();
    
    // Checking the value of isCreatingRipple is true, if true then draw the ripple
    // Showing the ripple covering the pervious words shown on the screen
    if (isCreatingRipple) {
        long elapsedTime = millis() - startTime; 
        float progress = min(elapsedTime / (float) duration, 1f);

        // Update the radius based on time passed
        radius = progress * maxRadius;

        // Drawing the circle
        fill(fillColor);
        noStroke(); 
        ellipse(centerX, centerY, radius * 2, radius * 2); 

        // Check if 3 seconds have passed to show the text
        if (elapsedTime >= textDelay) {
            showText = true;
        }
    }

    // Display the final text after the delay
    // This shows the final message that shows "Hope" completing the last piece to finish the visual
    if (showText) {
        fill(color(255));  // Set text color to white
        textSize(40);
        text("It is okay, breathe", width / 2, height / 2);
    }
}

// When mouse is pressed, then it updates the variable
// Only when the mouse is pressed, then the ripple starts
void mousePressed() {
    isCreatingRipple = true;
    startTime = millis(); 
}
