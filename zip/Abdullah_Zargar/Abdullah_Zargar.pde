
//Keywords- Civil and Environmental Engineering, Sea, Flow

// First I will initialize all the variables for the water and the dam 

float WaveOffset = 0;  // This will be used to animate the waves 
float ValleyWaveOffset = 0;  
boolean GateOpen = false;  // State of the Gate
boolean ValleyDraining = false;  // Valley draining state
float ReservoirWaterLevel = 80;  // Initial water level on the reservoir side
float ValleyWaterLevel = -10;  // Initial water level on the valley side
float DamHeight = 100;  // The height of the dam

// These are the variables for clouds & raindrops

int CloudCount = 3;  // Number of clouds

//X & Y positions of the clouds

int[] CloudX = {100, 220, 550};  
int[] CloudY = {50, 80, 40}; 
int RDC = 35;  //RDC stands for Rain Drop Count
float[] RainDropX = new float[RDC];  // X positions of raindrops
float[] RainDropY= new float[RDC];

// These are the variables for mountains

int MountainHeight = 280;
int MountainCount = 3; //3 mountains 
int[] MountainX = {-50, 200, 500};  //X-positions of the mountains

// These are the variables for the sun

int SunX = 600;  
int SunY = 100;  
int SunRadius = 50;  

void setup() {
  size(800, 400);
  
  // Initialize raindrop positions, ensuring the first cloud is over the reservoir

  for (int i = 0; i < RDC; i++) {
    int CloudIndex = int(random(CloudCount));  // Picks a random cloud for each raindrop
    
    // Ensure cloudIndex is always between 0 and cloudCount - 1
    if (CloudIndex >= CloudCount) {
      CloudIndex = CloudCount - 1;  // Prevents them to be out of bounds
    }

    // Adjust raindropX for first cloud to fall over the reservoir
    //Most raint should fall over the reservior for it to fill up. Some over the rest
  
    if (CloudIndex == 0) {
      RainDropX[i] = random(CloudX[CloudIndex] - 50, CloudX[CloudIndex] + 50);  // Random X near the cloud over the reservoir
    } else {
      RainDropX[i] = random(CloudX[CloudIndex] - 50, CloudX[CloudIndex] + 50);  // X position near other clouds
    }
    
    RainDropY[i] = random(CloudY[CloudIndex] + 20, CloudY[CloudIndex] + 50);  // Y position below the cloud
  }
}

void draw() {
  background(135, 206, 235);  // Sky blue background
  
  DrawMountains();  // Draw mountains in the background (behind water and dam)
  DrawSun();  // Draw the sun in the sky
  DrawSeaAndValley();
  DrawDam();
  DrawCloudsAndRaindrops();  // Draw clouds and raindrops
  
  if (GateOpen) {
    DrawWaterFlow();  // Draw water flow from reservoir to valley
  }
  
  if (ValleyDraining) {
    DrainValley();  // Drain water in the valley
  }
  
  // Slowly increase reservoir water level back to the dam height if the gate is closed
  
  if (!GateOpen && ReservoirWaterLevel < DamHeight) {
    ReservoirWaterLevel += 0.1;  // Slowly raise water level
  }
}

  
// Function to draw both sea and valley with realistic waves (use sin function to create waves)
void DrawSeaAndValley() {
  fill(0, 0, 255);  // Unified blue color for water
  noStroke();
  
  // Reservoir side (left) with rising water level, ensuring it doesn't exceed dam height
  
  for (int x = 0; x < width / 2; x += 10) {
    // Ensure the water level doesn't exceed the dam height
    float y = 320 - min(ReservoirWaterLevel, DamHeight) + 10 * sin((x + WaveOffset) * 0.05);  // Reservoir water level rising
    rect(x, y, 10, height - y);
  }
  
  // Valley side (right) with water level rising when gate is open or overflow happens
  
  for (int x = width / 2; x < width; x += 10) {
    float y = height - ValleyWaterLevel + 5 * sin((x + ValleyWaveOffset) * 0.05);  // Smaller wave height for the valley
    rect(x, y, 10, height - y);
  }
  
  WaveOffset += 1.5;  // Animate waves in the reservoir
  
  if (GateOpen) {
    ValleyWaveOffset += 1.5;  // Animate waves in the valley when the gate is open
    ValleyWaterLevel = min(ValleyWaterLevel + 0.5, 150);  // Gradually increase the valley water level
    ReservoirWaterLevel = max(ReservoirWaterLevel - 0.5, 0);  // Gradually decrease the reservoir water level
  }
}

// Function to draw the dam
void DrawDam() {
  fill(150);  // Gray for the dam
  stroke(0);  // Black outline
  strokeWeight(2);

  // Draw the rhombus-shaped dam
  beginShape();
  vertex(width / 2 - 50, 200);  // Top-left corner (narrower)
  vertex(width / 2 + 50, 200);  // Top-right corner (narrower)
  vertex(width / 2 + 80, 400);  // Bottom-right corner (wider)
  vertex(width / 2 - 80, 400);  // Bottom-left corner (wider)
  endShape(CLOSE);
}

// Function to draw a triangular water flow from the dam
void DrawWaterFlow() {
  fill(0, 0, 255);  // Blue for water flow
  noStroke();
  
  // Draw a right-angled triangle for the water flow
  beginShape();
  vertex(width / 2 + 50, 250);  // Top of the triangle (point)
  vertex(width / 2 + 50, 400);  // Bottom-right corner (base of triangle)
  vertex(width / 2 + 80, 400);  // Bottom-left corner (base of triangle)
  endShape(CLOSE);
}

// Function to drain water from the valley
void DrainValley() {
  ValleyWaterLevel = max(ValleyWaterLevel - 1, 0);  // Gradually decrease valley water level
  
  if (ValleyWaterLevel == 0) {
    ValleyDraining = false;  // Stop draining when valley is empty
  }
}

// Function to handle mouse clicks for gate control and valley draining
void mousePressed() {
  
  if (!GateOpen && !ValleyDraining) {
    GateOpen = true;  // Open the gate to release water into the valley
  } else if (GateOpen && !ValleyDraining) {
    GateOpen = false;  // Close the gate
    ValleyDraining = true;  // Start draining the valley
  }
}

// Function to draw clouds and raindrops
void DrawCloudsAndRaindrops() {
  // Draw multiple clouds as white ellipses
  fill(255);  // White color for clouds
  noStroke();
  
  // Loop through each cloud and draw
  
  for (int i = 0; i < CloudCount; i++) {
    // Draw a cloud with several ellipses to make it look fluffy
    ellipse(CloudX[i], CloudY[i], 100, 50);  // Main cloud body
    ellipse(CloudX[i] + 30, CloudY[i] - 10, 80, 40);  // Upper-right cloud part
    ellipse(CloudX[i] - 40, CloudY[i] - 10, 80, 40);  // Upper-left cloud part
  }
  
  // Draw raindrops falling from the clouds
  stroke(0, 0, 255);  // Blue for raindrops
  
  for (int i = 0; i < RDC; i++) {
    int CloudIndex = int(random(CloudCount));  // Pick a random cloud for each raindrop
    float x = RainDropX[i];
    float y = RainDropY[i];
    
    // Draw each raindrop as a line
    line(x, y, x, y + 3);  
    
    // Update raindrop position to show falling
    RainDropY[i] += 1;  // Move raindrop down
    
    // Reset raindrop to top if it falls past the bottom of the screen
  
    if (RainDropY[i] > height) {
      RainDropY[i] = random(CloudY[CloudIndex] + 20, CloudY[CloudIndex] + 50);  // Reset to above cloud
    }
  }
}

// Function to draw mountains in the background
void DrawMountains() {
  fill(34, 139, 34);  // Green for mountains
  noStroke();

  // Draw each mountain range
  
  for (int i = 0; i < MountainCount; i++) {
    beginShape();
    vertex(MountainX[i], height);  // Left edge of the mountain
    vertex(MountainX[i] + 200, height - MountainHeight);  // Peak of the mountain
    vertex(MountainX[i] + 400, height);  // Right edge of the mountain
    endShape(CLOSE);
  }
}

// Function to draw the sun
void DrawSun() {
  fill(255, 223, 0);  // Yellow color for the sun
  noStroke();
  ellipse(SunX, SunY, SunRadius * 2, SunRadius * 2);  // Draw sun as a circle
}
