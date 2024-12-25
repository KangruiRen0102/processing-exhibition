// Theme: "A state of metamorphosis enacts new change, creating infinite bloom like a blossoming flower like a rose."

// Global variables
ArrayList<Rose> roses;              // Holds all the 3D roses in the scene
ArrayList<Caterpillar> caterpillars; // Holds all caterpillars (including transformed butterflies)
boolean infiniteMode = true;        // Controls whether roses grow infinitely or pause

// Camera control variables
float cameraX = 0, cameraY = 0, cameraZ = 500; // Initial camera position in 3D space
float rotationX = 0, rotationY = 0;            // Camera rotation angles for orbiting around the scene
float zoom = 500;                              // Zoom level (distance of the camera from the origin)
float prevMouseX, prevMouseY;                  // Stores the previous mouse positions for drag-based camera control


void setup() {
    size(800, 600, P3D); // Set up the canvas with 3D rendering enabled (P3D mode)
    roses = new ArrayList<Rose>(); // Initialize the roses list
    caterpillars = new ArrayList<Caterpillar>(); // Initialize the caterpillars list

    // Create a few roses placed randomly in the 3D scene
    for (int i = 0; i < 5; i++) { // Generate 5 roses to keep the scene visually clean
        float x = random(-300, 300);  // Random X position in a range
        float y = random(-150, 150);  // Random Y position
        float z = random(-200, 200);  // Random Z position
        float size = random(30, 50);  // Initial size of the rose
        float growthRate = random(0.2, 0.5); // Speed of growth
        int petals = int(random(3, 8)); // Randomize number of petals for each rose
        roses.add(new Rose(x, y, z, size, growthRate, petals)); // Add the rose to the list
    }

    // Add an initial caterpillar
    caterpillars.add(new Caterpillar(new PVector(0, 200, 0))); // Position it above the roses
}


void draw() {
    background(20); // Set a dark background to make the roses and caterpillars stand out

    // Set up the camera with rotation and zoom (orbit-style view around the origin)
    camera(
        zoom * sin(rotationY) * cos(rotationX), // X position: Camera rotates horizontally
        zoom * sin(rotationX),                  // Y position: Camera rotates vertically
        zoom * cos(rotationY) * cos(rotationX), // Z position: Camera distance
        0, 0, 0,                               // Camera looks at the origin (0, 0, 0)
        0, 1, 0                                // "Up" vector for the camera
    );

    // Draw and grow each rose
    for (Rose rose : roses) {
        rose.grow();    // Update growth based on infiniteMode
        rose.display(); // Render the rose in 3D space
    }

    // Animate and display each caterpillar or butterfly
    for (Caterpillar caterpillar : caterpillars) {
        caterpillar.animate(); // Animate the caterpillar's movement or butterfly's flight
        caterpillar.display(); // Render the caterpillar or butterfly
    }

}

void mouseDragged() {
    float deltaX = mouseX - prevMouseX; // Calculate horizontal drag distance
    float deltaY = mouseY - prevMouseY; // Calculate vertical drag distance
    rotationY += deltaX * 0.01;         // Adjust horizontal rotation
    rotationX -= deltaY * 0.01;         // Adjust vertical rotation
    prevMouseX = mouseX;                // Update previous mouse X position
    prevMouseY = mouseY;                // Update previous mouse Y position
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount(); // Detect scroll amount
    zoom += e * 20;             // Adjust zoom level proportionally
    zoom = constrain(zoom, 200, 1500); // Limit zoom range for usability
}


void mousePressed() {
    // Add a new rose at a random 3D position when the user clicks
    float x = random(-300, 300);
    float y = random(-150, 150);
    float z = random(-200, 200);
    float size = random(30, 50);
    float growthRate = random(0.2, 0.5);
    int petals = int(random(3, 8));
    roses.add(new Rose(x, y, z, size, growthRate, petals)); // Add the new rose
}

void keyPressed() {
    if (key == 'i' || key == 'I') {
        infiniteMode = !infiniteMode; // Toggle the infinite bloom mode for roses
        for (Rose rose : roses) {
            rose.infiniteBloom = infiniteMode; // Apply the mode to all roses
        }
    }

    if (key == 'c' || key == 'C') {
        // Add a new caterpillar at a random position when the 'C' key is pressed
        caterpillars.add(new Caterpillar(new PVector(random(-300, 300), 200, random(-300, 300))));
    }
}


// Class to represent a 3D caterpillar that transforms into a butterfly
class Caterpillar {
    PVector position; // 3D position of the caterpillar or butterfly
    boolean isButterfly = false; // Indicates whether the caterpillar has transformed
    float wingAngle = 0;         // Used to animate the butterfly's wing flapping
    float time = 0;              // Animation timer for controlling movement patterns
    int segments = 6;              // Animation timer for controlling movement patterns

    Caterpillar(PVector startPosition) {
        this.position = startPosition.copy();
    }

    // Animate the caterpillar or butterfly
    void animate() {
        time += 0.02; // Increment time for animation

        // Caterpillar wiggles forward until it transforms
        if (!isButterfly) {
            position.y -= 0.5; // Move upwards
            if (position.y < 50) {
                isButterfly = true; // Trigger transformation
            }
        } else {
            // Butterfly flies in a looping pattern
            position.x += sin(time * 2) * 2;  // Horizontal swaying motion
            position.z += cos(time * 2) * 2;  // Circular flight
            wingAngle = sin(time * 10) * PI / 8; // Wing flapping
        }
    }

    // Display the caterpillar or butterfly
    void display() {
        pushMatrix(); // Save the current transformation state
        translate(position.x, position.y, position.z); // Move to the current 3D position

        if (!isButterfly) {
            // Draw caterpillar as a series of connected spheres
            noStroke();
            fill(50, 200, 50); // Green color for body
            for (int i = 0; i < segments; i++) {
                translate(0, 12, 0); // Offset for each segment
                sphere(8);                 // Render a sphere for each body segment
            }
        } else {
            // Draw butterfly with wings
            noStroke();                     // No outline for the wings
            fill(255, 100, 150); // Pink wing color
            // Left wing
            pushMatrix();
            rotateY(wingAngle);             // Rotate the left wing based on wingAngle
            ellipse(-20, 0, 50, 80);        // Draw an ellipse for the left wing
            popMatrix();
            // Right wing
            pushMatrix();
            rotateY(-wingAngle);            // Rotate the right wing based on wingAngle
            ellipse(20, 0, 50, 80);         // Draw an ellipse for the right wing
            popMatrix();

            // Body
            fill(50, 50, 50);               // Gray body color
            cylinder(5, 20);                // Use a custom function to render the cylinder
        }

        popMatrix(); // Restore the previous transformation state
    }

    // Utility to draw a cylinder to create butterfly's body
    void cylinder(float radius, float height) {
        beginShape(QUAD_STRIP);             // Begin constructing a quadrilateral strip
        for (int i = 0; i <= 360; i += 10) {
            float angle = radians(i);      // Convert degrees to radians
            float x = cos(angle) * radius; // X-coordinate of the cylinder's edge
            float z = sin(angle) * radius; // Z-coordinate of the cylinder's edge
            vertex(x, 0, z);               // Bottom circle vertex
            vertex(x, height, z);          // Top circle vertex
        }
        endShape(); // Finish the cylinder's surface
    }
}

// Class to represent a 3D rose
class Rose {
    PVector position;         // 3D position of the rose (x, y, z coordinates)
    float size, growthRate;   // Current size (radius of the rose) and growth rate (speed of size increase)
    int petals;               // Number of "petals" (determines the pattern complexity of the rose curve)
    float hueValue;           // Hue value for determining the rose's color (smoothly transitions over time)
    boolean infiniteBloom;    // Whether the rose grows infinitely or stops growing when paused


    Rose(float x, float y, float z, float size, float growthRate, int petals) {
    this.position = new PVector(x, y, z); // Set the initial 3D position of the rose
    this.size = size;                    // Set the initial size of the rose
    this.growthRate = growthRate;        // Set the rate at which the rose grows
    this.petals = petals;                // Define the number of petals
    this.hueValue = random(0, 1);        // Initialize hueValue with a random starting point in the gradient
    this.infiniteBloom = true;           // By default, the rose grows infinitely
}


    void grow() {
    if (infiniteBloom) size += growthRate; // Increase the size if infinite bloom is enabled
    hueValue += 0.001;                    // Smoothly transition the hueValue to cycle through colors
    if (hueValue > 1) hueValue = 0;       // Loop the hueValue back to 0 when it exceeds 1 (completing a color cycle)

    // Reset the rose's size and properties if it grows too large
    if (size > 150) {
        size = random(30, 50);            // Reset to a random smaller size
        petals = int(random(3, 8));       // Randomize the number of petals for variation
        growthRate = random(0.2, 0.5);    // Randomize the growth rate
    }
}

    void display() {
        pushMatrix();     // Save the current transformation state
        translate(position.x, position.y, position.z);     // Move to the rose's 3D position
        noFill();     // Only draw the outline (no fill color)
        stroke(lerpColor(color(255, 0, 0), color(138, 43, 226), hueValue));     // Calculate the rose's color
        strokeWeight(1.5);     // Set the thickness of the rose's outline
        
        beginShape();     // Begin drawing the rose curve
        for (float theta = 0; theta < TWO_PI * 6; theta += 0.01) {     // Loop to create the rose pattern
            float r = size * cos(petals * theta);     // Calculate the radial distance (rose curve equation)
            float x = r * cos(theta);      // X-coordinate in polar to Cartesian conversion
            float y = r * sin(theta);     // Y-coordinate
            float z = r * sin(theta / 2);     // Z-coordinate adds 3D depth
            vertex(x, y, z);     // Add a point to the shape at (x, y, z)
        }
        endShape(CLOSE);     // Close the rose curve to complete the shape
        popMatrix();     // Restore the previous transformation state
    }
}
