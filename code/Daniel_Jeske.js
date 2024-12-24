let northernLights; // Instance of NorthernLights class
let ocean;                   // Instance of Ocean class
let moon;                    // Instance of Moon class
let rowboat;                 // Instance of Rowboat class
let stars = [];              // List to store stars

function setup() {
  createCanvas(800, 600);              // Set the size of the canvas
  noStroke();                  
  
  northernLights = new NorthernLights(); // Initialize NorthernLights instance
  ocean = new Ocean();                   // Initialize Ocean instance
  moon = new Moon();                     // Initialize Moon instance
  rowboat = new Rowboat();               // Initialize Rowboat instance
}

function draw() {
  background(0, 0, 50);        // Set the background color to dark blue (night sky)

  northernLights.display();    // Display the northern lights
  moon.display();              // Display the moon
  ocean.display();             // Display the ocean
  rowboat.display();           // Display the rowboat with a person in it
  
  // Display stars
  for (let i = stars.length - 1; i >= 0; i--) {
    let star = stars[i];
    star.display();
    if (star.isDone()) {
      stars.splice(i, 1);         // Remove the star when it is done flickering
    }
  }
}

function mousePressed() {
  if (mouseY < height - 100) { // Ensure the star only occurs in the sky
    stars.push(new Star(mouseX, mouseY)); // Add a new star at the mouse position
  }
}

class NorthernLights {
  constructor() {
    this.alpha = 100;               // Set initial transparency
    this.time = 0;                  // Initialize time to 0
  }

  display() {
    this.time += 0.001;             // Increment time to animate

    for (let y = 100; y < height / 2; y += 30) { // Loop to create multiple horizontal bands of northern lights. 
      let greenShade = map(y, 100, height / 2, 50, 255); // Map y position to green shade intensity ranging from 50 to 255
      fill(0, greenShade, 0, this.alpha); // Set fill color with mapped green shade and transparency

      beginShape();            // Begin custom shape
      for (let x = 0; x < width; x++) { // Loop to create vertices along the x-axis
        let noiseFactor = noise(x * 0.01, y * 0.01, this.time); // Computes a noise value based on the x, y, and time variables
        let offset = sin(noiseFactor * TWO_PI) * 50; // Use sine function to create an offset for the vertices
        vertex(x, y + offset); // Create vertex with offset
      }
      endShape(CLOSE);         
    }
  }
}

class Ocean {
  display() {
    fill(0, 0, 150);           // Set fill color to dark blue for the ocean
    rect(0, height - 100, width, 100); // Draw a rectangle to represent the ocean
  }
}

class Moon {
  constructor() {
    this.x = width - 100;           // Set x, y, and radius coordinates for moon
    this.y = 100;                   
    this.radius = 50;               
  }

  display() {
    fill(255, 255, 255, 200);  // Set color of moon to white 
    circle(this.x, this.y, this.radius * 2); // Draw the moon as a circle
  }
}

class Rowboat {
  constructor() {
    this.x = 400;                   // Set x and y coordinates of rowboat
    this.y = 500;                   
    this.width = 100;               // Set width and height of rowboat
    this.height = 20;               
  }

  display() {
    // Draw the boat
    fill(139, 69, 19);         // Set fill color of rowboat to brown
    beginShape();              // Make basic shape for rowboat
    vertex(this.x - this.width / 2, this.y);   
    vertex(this.x + this.width / 2, this.y);  
    vertex(this.x + this.width / 2 - 10, this.y + this.height); 
    vertex(this.x - this.width / 2 + 10, this.y + this.height); 
    endShape(CLOSE);           

    // Draw boat details
    fill(160, 82, 45);         // Set fill color for rowboat details
    rect(this.x - this.width / 2 + 5, this.y + 5, this.width - 10, this.height / 2); // Draw details for rowboat

    // Draw a person in the boat
    let personY = this.y - 15;    // Set y position of the person 
    fill(255, 224, 189);       // Set fill color 
    circle(this.x, personY - 10, 20); // Draw the head as a circle
    fill(0);                   // Set fill color to black for the body
    rect(this.x - 5, personY, 10, 20); // Draw the body as a rectangle
  }
}

class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.timer = 0;           // Initialize the timer to 0, indicating the star has just appeared
    this.flickering = true;   // Set the flickering status to true, meaning the star is visible and flickering
  }

  display() {
    if (this.flickering) {
      fill(255);              // White color for the star
      beginShape();           // Begin custom shape for pointy star
      for (let i = 0; i < 10; i++) {
        let angle = TWO_PI / 10 * i;
        let r = (i % 2 === 0) ? 7 : 3.5; // radii for small pointy shape
        let sx = this.x + cos(angle) * r;
        let sy = this.y + sin(angle) * r;
        vertex(sx, sy);
      }
      endShape(CLOSE);
      this.timer++;
      if (this.timer > 50) {        // Star flickers for 50 frames
        this.flickering = false;
      }
    }
  }

  isDone() {
    return !this.flickering;
  }
}
