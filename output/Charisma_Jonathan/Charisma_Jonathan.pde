// Civil Engineering Building Construction Visualization
// This program demonstrates key concepts in building construction through animation
// Author: Your Name
// Date: December 22, 2024

// Construction Parameters
// These variables represent real-world building specifications
int buildingHeight = 0;    // Current construction height (in pixels)
int maxHeight = 300;       // Target building height (typical 10-story building)
int buildingWidth = 100;   // Standard structural bay width
int buildingX = 250;       // Building position (centered on site)
int groundHeight = 50;     // Foundation depth below grade
int journeyStep = 0;       // Construction progress counter

// Initial setup of construction site and parameters
void setup() {
  size(600, 400);         // Site plan dimensions (scaled representation)
  background(200, 230, 255); // Clear sky conditions for construction
  frameRate(30);          // Animation speed (30 frames per second)
  
  // Display initial construction site information
  println("Construction Site Initialized");
  println("Target Height: " + maxHeight + " units");
  println("Foundation Depth: " + groundHeight + " units");
}

// Main construction animation loop
void draw() {
  // Clear construction site view for next frame
  background(200, 230, 255);  // Reset sky background
  
  // Phase 1: Site Preparation and Foundation
  // Draw ground and foundation layer
  fill(100, 200, 100);       // Topsoil representation
  noStroke();                // Smooth ground surface
  rect(0, height - groundHeight, width, groundHeight);
  
  // Add foundation detail
  fill(130, 130, 130);      // Concrete foundation color
  rect(buildingX - 10, height - groundHeight, 
       buildingWidth + 20, groundHeight/2);   // Foundation footprint
  
  // Draw main building structure
  fill(150, 150, 150);       // Gray color for building
  stroke(100, 100, 100);     // Darker gray for building outline
  rect(buildingX, height - groundHeight - buildingHeight, 
       buildingWidth, buildingHeight);
  
  // Draw windows (representing facade elements)
  fill(200, 200, 255);       // Light blue for windows
  noStroke();
  int windowSpacing = 30;    // Vertical space between windows
  int windowSize = 15;       // Size of each window
  
  // Add windows as building grows
  for (int y = windowSpacing; y < buildingHeight; y += windowSpacing) {
    for (int x = buildingWidth/3; x < buildingWidth; x += windowSize * 2) {
      rect(buildingX + x, height - groundHeight - buildingHeight + y,
           windowSize, windowSize);
    }
  }

  // Draw construction crane
  stroke(50, 50, 50);        // Dark gray for crane
  strokeWeight(5);           // Thicker lines for crane
  
  // Vertical tower (crane mast)
  int craneHeight = min(buildingHeight + 50, maxHeight);
  line(buildingX - 20, height - groundHeight,
       buildingX - 20, height - groundHeight - craneHeight);
       
  // Horizontal arm (crane jib)
  line(buildingX - 20, height - groundHeight - craneHeight,
       buildingX - 100, height - groundHeight - craneHeight);
       
  // Crane cable
  strokeWeight(2);
  int cableX = buildingX - 80;
  line(cableX, height - groundHeight - craneHeight,
       cableX, height - groundHeight - craneHeight + 50);
  
  // Update building height
  if (buildingHeight < maxHeight && frameCount % 10 == 0) {
    buildingHeight += 2;     // Increase building height gradually
    journeyStep++;           // Increment progress counter
  }
  
  // Display construction progress
  fill(0);                   // Black color for text
  textSize(16);
  text("Construction Progress: Step " + journeyStep, 10, 30);
  text("Building Height: " + buildingHeight + " units", 10, 50);
  
  // Show completion message
  if (buildingHeight >= maxHeight) {
    fill(0);
    textSize(24);
    textAlign(CENTER);
    text("Building Construction Complete!", width/2, height/2);
    noLoop();               // Stop animation when building is complete
  }
}

// Mouse click to restart animation
void mousePressed() {
  if (buildingHeight >= maxHeight) {
    buildingHeight = 0;     // Reset building height
    journeyStep = 0;        // Reset progress counter
    loop();                 // Restart animation
  }
}
