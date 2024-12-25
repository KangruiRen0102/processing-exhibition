// the initiation of the creation of the stars using the class also added the object based design by positoning the stars
class Star {
    float x, y;        // Position of the star
    float brightness;  // Brightness of the star

    // the postions of the stars and the brighness
    Star(float x, float y, float brightness) {
        this.x = x;
        this.y = y;
        this.brightness = brightness;
    }
    // Method to display the star
    void display(float alpha) {
        fill(255, 255, 255, brightness * alpha); // by using the alpha function the stars are able to dim its value must be <1 to dim
        ellipse(x, y, 3, 3); // 
    }
}
//creation of the plants a similar simple format as before
// Plant class
class Plant {
    float x, y;        // setting the position of the plant
    float height;      // Height of the plant

    // Constructor
    Plant(float x, float y, float height) {
        this.x = x;
        this.y = y;
        this.height = height;
    }
    // Method to display the plant
    void display() {
        stroke(34, 139, 34); // colur finding 
        strokeWeight(3);
        line(x, y, x, y - height);

        noStroke();
        fill(34, 139, 34);
        for (float i = 0; i < height; i += 20) { //a for loop which is to reapeat the leaf every 20 units
            ellipse(x - 5, y - i, 10, 5); //the creation of the leaves for the seaweed on the right side 
            ellipse(x + 5, y - i, 10, 5); 
        }
    }
}

// Reef class
class Reef {
    float x, y;        // Position of the reef
    float width, height; // Size of the reef

    // same processes as above
    Reef(float x, float y, float width, float height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    void display() {
        fill(139, 69, 19); 
        rect(x, y, width, height, 10); // a rectangle is used as the model for the reef
    }
}

ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Plant> plants = new ArrayList<Plant>();
ArrayList<Reef> reefs = new ArrayList<Reef>();

// varibles to iniltailze the time of day slider and arura effects
float auroraOffset = 0;

// Time of day slider (0 = moonrise on the left, 1 = twilight on the right)
float timeOfDay = 0.0;

void setup() {
    size(1200, 700);
    noStroke();

    // by using a for loop I can choose as many stars as I want which are to ble placed in a random location however only above the top half to ensure that the stars are not in the water
    for (int i = 0; i < 800; i++) {
        float starX = random(width);
        float starY = random(height / 2); // needed to do this becasue intitaly the stars were in the water and after this the stars are in the top half of the page
        float starBrightness = random(100, 255); //each star gets a random brightness 
        stars.add(new Star(starX, starY, starBrightness));  
    }
// a same approch as the stars, the plants would form randomly after every output
    // Initialize plants (on the sea floor)
    for (int i = 0; i < 15; i++) {
        float plantX = random(50, width - 50); 
        float plantHeight = random(50, 150);  
        plants.add(new Plant(plantX, height - 50, plantHeight));
    }
}

void draw() {
    // the attempt to make the background transion to night to twilight by using the lerpcolor function, the first set of color is the initatial and the second
    // is the last and the contrain is used so that the it trasitions slowly and has a min and max vaulue 
    color skyColor = lerpColor(color(10, 10, 50), color(255, 180, 100), constrain(timeOfDay - 0.7, 0, 0.3) * 3); // A smooth twilight transition 
    background(skyColor);

    // by using this it can control the rate at which the stars fade when the user slides the mouse a higher value would be outputed thus less bright stars
    float alpha = 1 - constrain(timeOfDay * 1, 0, 1); // Gradually fade out stars and aurora
// similar concepts here as the slider is to be dragged the value of alpha is to increase therefore the stars and arura fade out slowly
    drawAurora(alpha);
// A for loop was used to show the stars after changes were made otherwise they would be covered up by the arura
    for (Star star : stars) {
        star.display(alpha);
    }
    drawMoon();
    drawSea();
// A for loop was used to show the plants after changes were made otherwise they would be covered up 
    for (Plant plant : plants) {
        plant.display();
    }
    // Draw the time of day slider
    drawSlider();
}
// A cresent shpape was not possoble therefore it is an illusion of one birght circle and dark circle overlapped to create a cresent effec
// the two circles must act as one 
void drawMoon() {
    // for the x postion the map function is used and also there is the time of day function in it are the values for zero to one with zero being the left hand side and 
    // one being the right hand like a min/max value also the width is 50 so that the moon stay in the screen after the user inputs otherwise it would go out of the frame. in the later
    // lines of code it can be seen that the value for x and y for the moon is user dependant using the slder
    float moonX = map(timeOfDay, 0, 1, 50, width - 50); 
    // the inital height was found iteritvly by guess and check to see which value would closely resemble the moon rise and to simulate a real moon cycle a sin fuction was uses
   // with the input being the time of day subtrctred from the sin funtcion because adding it causes the moon to fall in the water, the sin function which takes on the timeofday and is also scaled by a factor of 3 since initualy the moon was setting in the water
   // and the period needed to be less and a by mutlipiing by a constant the problem was solved and it was done iteritlvy mostly by guess and check
    float moonY = height / 2.54 - sin(timeOfDay *3) * (height / 6); // Arc-like vertical motion, stays above sea
    //the primialry white circle
    fill(255, 255, 200);
    ellipse(moonX, moonY, 80, 80); // Moon position is user dependant and size

    // second cicle for the cresent moon a dark color is used
    fill(10, 10, 10);
    ellipse(moonX + 25, moonY, 80, 80); //  shadow for crescent this is also user dependant but needs to stay a bit far to keep the shape also size is from here
}

void drawAurora(float alpha) {
    int[] colors = { color(0, 255, 150, 150), color(50, 200, 255, 100), color(200, 100, 255, 80) };//needed to create a gradient effect since there are 3 colors in a arura
    int streakCount = 500;//how many of these light bars are present 
    float streakWidth = width / streakCount;

    for (int i = 0; i < streakCount; i++) {
        float x = map(i, 0, streakCount, 0, width);//used to ensure the domain of the streaks where x=0 as the min and x=width as the max
        float noiseValue = noise(i * 0.05, auroraOffset);// by using the noise function which takes on the current number of streaks mutlipled by a scaler which was determined by guess and check
       // the situaion here is like a the period and amiptude of a wave with i*0.5 being the period and aurouraoffset as the am
        float streakHeight = map(noiseValue, 0, 1, height / 6, height / 3); //To ensure that the range of the height is restricted
        fill(colors[i % colors.length], alpha * 255); // Appling  fading alpha and the gradient of the colors
        rect(x, 0, streakWidth, streakHeight);
    }
    auroraOffset += 0.002; //becusae of this the aurua is able to move up and down continously
}
// a simple drawing for the sea floor and reef using the rect and some colors
void drawSea() {
    fill(0, 0, 100, 180); // Blue for the sea
    rect(0, height / 2, width, height / 2); // Sea region

    fill(139, 69, 19); // Brown for the seafloor
    rect(0, height - 50, width, 50); // Seafloor
}
// need slider for user inputs
void drawSlider() {
    // Draw slider background
    fill(200);
    rect(20, height - 40, width - 40, 20, 10);
    fill(50);
    float sliderX = map(timeOfDay, 0, 1, 20, width - 20); 
    ellipse(sliderX, height - 30, 20, 20); // the circular slideer handle 
}
//now the user based input part where the mouse drgged function is used by changing the common varible which is the timeofday fubction the arura can go away and twight can form as well as the stars fade
void mouseDragged() {
    // Update timeOfDay based on slider movement
    if (mouseY > height - 50 && mouseY < height - 20) // in order for the handle to dragged by the user it needs to have the same vertical ranges 
        timeOfDay = map(mouseX, 20, width - 20, 0, 1); // handle spans 0 to 1
        timeOfDay = constrain(timeOfDay, 0, 1); // 
    }
