//"Journey through the whisper of the sea"
//Declan O'Neill 1829725
//The background and underwater visual that has alternating shades of blue changing dependent on time
int numParts = 100;
int partWidth;
color[] oceanColors = new color[3];
color[] currentColors = new color[numParts];
int changeTime = 300; //
int lastChangeTime = 0;
//The golden ball is given the title fish
PVector fishPos;
PImage fish;
boolean facing = true;
// The partitions in the background oscillate as a continous wave to add visual appeal
float[] waveOffsets;
float waveSpeed = 0.05;
float waveAmplitude = 100;
float waveFrequency = 0.01;
// The fish produces a cluster of bubbles the mouse is left clicked
ArrayList<Bubble> bubbles;
// Each left click for the interaction will result in a random shape appearing in a random location
boolean shapeVisible = false;
int shapeType; // 0 = Circle, 1 = Star, 2 = Shell
PVector shapePos;
int shapeSize;
int shapeStartTime;
// Green lines at the bottom of the display are ment to symbolize seaweed
ArrayList<Seaweed> seaweeds;
// Red cricle which appears at the same time and location as the Jellyfish called JellyFishMarkers
ArrayList<JellyFishMarker> JellyFishMarkers;
// Jellyfish
ArrayList<Jellyfish> jellyfish;
// Sharks
ArrayList<Shark> sharks;

void setup() {
size(800, 600);
 partWidth = width / numParts;
// Set wave colours
 oceanColors[0] = color(10, 30, 80);
 oceanColors[1] = color(15, 45, 100);
 oceanColors[2] = color(20, 60, 120);
for (int i = 0; i < numParts; i++) {
 currentColors[i] = oceanColors[int(random(3))];
 }
// Begin background waves
waveOffsets = new float[numParts];
for (int i = 0; i < numParts; i++) {
 waveOffsets[i] = random(TWO_PI);
 }
// Load fish image
 fish = createFishImage(true);
// Inital starting position of the fish
 fishPos = new PVector(width / 2, height / 2);
// Initiate bubbles
 bubbles = new ArrayList<Bubble>();
// Initiate seaweed
 seaweeds = new ArrayList<Seaweed>();
for (int i = 0; i < 10; i++) {
 seaweeds.add(new Seaweed(random(width), height, random(50, 300)));
 }
// Initialize JellyFishMarkers
 JellyFishMarkers = new ArrayList<JellyFishMarker>();
// Initiate Jellyfish
 jellyfish = new ArrayList<Jellyfish>();
// Initialize sharks
 sharks = new ArrayList<Shark>();
for (int i = 0; i < 6; i++) {
 sharks.add(new Shark(0, random(height))); // Places 6 sharks starting at the left side of the display
 }
}

void draw() {
background(0);
// Ocean back ground with waves drawn
for (int i = 0; i < numParts; i++) {
 float waveY = sin(waveOffsets[i]) * waveAmplitude;
 fill(currentColors[i]);
 noStroke();
 rect(i * partWidth, waveY, partWidth, height);
 waveOffsets[i] += waveSpeed;
 }
// Change ocean colors over set time interval
if (millis() - lastChangeTime > changeTime) {
 for (int i = 0; i < numParts; i++) {
 currentColors[i] = oceanColors[int(random(3))];
 }
 lastChangeTime = millis();
 }
// Draw seaweed
for (Seaweed seaweed : seaweeds) {
 seaweed.display();
  }
// Draw bubbles
for (int i = bubbles.size() - 1; i >= 0; i--) {
 Bubble b = bubbles.get(i);
 b.update();
 b.display();
 if (b.isOffScreen()) {
 bubbles.remove(i);
 }
 }
// Draw JellyFishMarkers
for (int i = JellyFishMarkers.size() - 1; i >= 0; i--) {
 JellyFishMarker c = JellyFishMarkers.get(i);
 c.update();
 c.display();
 if (c.isExpired()) {
 JellyFishMarkers.remove(i);
 }
 }
// Draw jellyfish
for (int i = 0; i < jellyfish.size(); i++) {
 Jellyfish j = jellyfish.get(i);
 j.update();
 j.display();
 }
// Draw the sharks
for (Shark s : sharks) {
 s.update();
 s.display();
 }
// Draw the fish
pushMatrix();
translate(fishPos.x, fishPos.y);
if (!facing) {
scale(1, 1); // Flip horizontally
 }
image(fish, -fish.width / 2, -fish.height / 2);
popMatrix();
//PImage currentFish = facing ? fish : fishLeft;
//image(currentFish, fishPos.x - currentFish.width / 2, fishPos.y - currentFish.height / 2);
// Move fish slightly towards the target position to visuallize a smooth transition
if (mousePressed && mouseButton == LEFT) {
 fishPos.x = lerp(fishPos.x, mouseX, 0.05);
 }
// Draw random shape
if (shapeVisible && millis() - shapeStartTime < 5000) {
 drawRandomShape(shapeType, shapePos.x, shapePos.y, shapeSize);
 } else {
 shapeVisible = false; // Shape is hidden after a set time interval
 }
}

void mousePressed() {
if (mouseButton == LEFT) {
 facing = mouseX > fishPos.x;
 // When mouse is left clicked, a random shape appears
 shapeVisible = true;
 shapeType = int(random(3)); // Randomly choose shape type
 shapePos = new PVector(random(width), random(height)); // Random position
 shapeSize = int(random(20, 60)); // Random size
 shapeStartTime = millis(); // Set start time for visibility
 // Add bubbles to the fish
 for (int i = 0; i < 5; i++) {
 bubbles.add(new Bubble(fishPos.x, fishPos.y));
 }
 // Add JellyFishMarker at the mouse position
 JellyFishMarkers.add(new JellyFishMarker(mouseX, mouseY));
 // Add jellyfish at the mouse position
 jellyfish.add(new Jellyfish(mouseX, mouseY));
 // Moving of shark when clicked
 for (Shark s : sharks) {
 if (dist(mouseX, mouseY, s.pos.x, s.pos.y) < 50) {
 s.startDragging();
 }
 }
 }
if (mouseButton == RIGHT) {
 resetScene(); // Right click resets the display
 }
}

void mouseReleased() {
// Stop dragging sharks when the mouse is released
for (Shark s : sharks) {
 s.stopDragging();
 }
}

// Reset the scene right click input specifics
// Waves are not reset for visual appeal
void resetScene() {
// Reset of all shark positions
for (Shark s : sharks) {
 s.pos.set(0, random(height));
 }
// Clear dynamic objects
 bubbles.clear();
 seaweeds.clear();
 JellyFishMarkers.clear();
 jellyfish.clear();
// Regenerate seaweed
for (int i = 0; i < 10; i++) {
 seaweeds.add(new Seaweed(random(width), height, random(50, 300)));
 }
}

//Random shape generated specifics
void drawRandomShape(int type, float x, float y, int size) {
switch (type) {
 case 0: // Circle
 fill(200, 100, 200, 150);
 ellipse(x, y, size, size);
 break;
 case 1: // Star
 fill(255, 200, 0, 150);
 drawStar(x, y, size / 2, size, 5);
 break;
 case 2: // Shell
 fill(255, 182, 193, 150);
 arc(x, y, size, size, PI, TWO_PI);
 break;
 }
}

//Specifics for case 1 random shape (star)
void drawStar(float x, float y, float radius1, float radius2, int npoints) {
float angle = TWO_PI / npoints;
float halfAngle = angle / 2.0;
beginShape();
for (float a = 0; a < TWO_PI; a += angle) {
 float sx = x + cos(a) * radius2;
 float sy = y + sin(a) * radius2;
 vertex(sx, sy);
 sx = x + cos(a + halfAngle) * radius1;
 sy = y + sin(a + halfAngle) * radius1;
 vertex(sx, sy);
 }
endShape(CLOSE);
}
PImage createFishImage(boolean facing) {
int fishWidth = 60;
int fishHeight = 30;
PImage fish = createImage(fishWidth, fishHeight, ARGB);
 fish.loadPixels();
for (int y = 0; y < fishHeight; y++) {
 for (int x = 0; x < fishWidth; x++) {
 if (dist(x, y, facing ? 20 : fishWidth - 20, fishHeight / 2) < 15) {
 fish.pixels[x + y * fishWidth] = color(255, 140, 0); // Bright orange
 } else {
 fish.pixels[x + y * fishWidth] = color(0, 0); // Transparent
 }
 }
 } 
 fish.updatePixels();
return fish;
}


//Defines the bubble feature
class Bubble {
PVector pos;
float radius;
float speed;
 Bubble(float x, float y) {
 pos = new PVector(x, y);
 radius = random(5, 15);
 speed = random(1, 3);
 }
void update() {
 pos.y -= speed;
 }
void display() {
 noStroke();
 fill(200, 200, 255, 150);
 ellipse(pos.x, pos.y, radius, radius);
 }
boolean isOffScreen() {
 return pos.y + radius < 0;
 }
}


// Defines the seaweed feature
class Seaweed {
float x, baseY;
float height;
float swayOffset;
 Seaweed(float x, float baseY, float height) {
 this.x = x;
 this.baseY = baseY;
 this.height = height;
 this.swayOffset = random(TWO_PI);
 }
void display() {
 stroke(0, 200, 0);
 strokeWeight(4);
 noFill();
 float sway = sin(swayOffset) * 10;
 beginShape();
 for (int i = 0; i < 10; i++) {
 float y = lerp(baseY, baseY - height, i / 10.0);
 float xOffset = sway * (i / 10.0);
 vertex(x + xOffset, y);
 }
 endShape();
 swayOffset += 0.02;
  }
}


class JellyFishMarker {
PVector pos;
float size;
int creationTime;
 JellyFishMarker(float x, float y) {
 pos = new PVector(x, y);
 size = random(30, 70);
 creationTime = millis();
 }
void update() {
 // JellyFishMarkers don&apos;t need to update much, just to exist for a while
 }
void display() {
 fill(255, 0, 0);
 noStroke();
 ellipse(pos.x, pos.y, size, size);
 }
boolean isExpired() {
 // Remove the JellyFishMarker after 5 seconds
 return millis() - creationTime > 5000;
 }
}


//Defines the jellyfish feature
class Jellyfish {
PVector pos;
float size;
float floatSpeed;
color bodyColor;
float pulseTimer;
 Jellyfish(float x, float y) {
 pos = new PVector(x, y);
 size = random(30, 60);
 floatSpeed = random(0.1, 0.3);
 bodyColor = color(random(0, 255), random(0, 255), random(0, 255), 150);
 pulseTimer = random(100);
 }
void update() {
 pos.y += floatSpeed;
 // Pulse effect for the jellyfish
 pulseTimer += 0.1;
 bodyColor = color(
 sin(pulseTimer) * 100 + 100,
 sin(pulseTimer + PI / 3) * 100 + 100,
 sin(pulseTimer + PI / 2) * 100 + 100,
 150
 ); 
  }
void display() {
 noStroke();
 fill(bodyColor);
 ellipse(pos.x, pos.y, size, size * 1.5);
 }
}


//The blue moving objects are called sharks and move across the screen in the right direction
//The poistion of the shark can be modified with the left click of a mouse
class Shark {
PVector pos;
float size;
boolean dragging; // Determine if being dragged
PVector dragOffset;
 Shark(float x, float y) {
 pos = new PVector(x, y);
 size = random(60, 120);
 dragging = false; // Not being dragged initially
 dragOffset = new PVector();
 }
void update() {
 if (dragging) {
 // Smooth dragging
 pos.x = lerp(pos.x, mouseX - dragOffset.x, 0.1);
 pos.y = lerp(pos.y, mouseY - dragOffset.y, 0.1);
 } else {
 // When not being moved the shark will continually progress to the right
 pos.x += 2;
 if (pos.x > width) {
 pos.x = 0; // Once reached the right side the shark resarts its path on the left side of the display
 }
 }
 }
//How the shark will look
void display() {
 fill(100, 100, 255);
 noStroke();
 ellipse(pos.x, pos.y, size, size / 2); // Body of shark
 fill(200, 200, 255);
 triangle(pos.x - size / 2, pos.y, pos.x - size / 2 - 20, pos.y - 20, pos.x - size / 2 - 20, pos.y + 20); // Tail of shark
 }
//
void startDragging() {
 dragging = true;
 dragOffset.set(mouseX - pos.x, mouseY - pos.y);
 }
void stopDragging() {
 dragging = false;
 }
} 
