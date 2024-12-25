// Everything below is for the flower and the animation for it to grow thus using the keyterms metaorphosis and bloom


float flowerSize = 50; // Initial size of the flower
float growthRate = 0.5; // Rate at which the flower grows
boolean metamorphosisStarted = false; // Flag to start metamorphosis
float shadowOffset = 20; // Initial shadow offset
float angle = 0; // Angle for petal rotation
void setup() {
size(800, 600); // Canvas size
noStroke();
}
void draw() {
background(30, 30, 50); // Deep blue background
drawShadow(); // Draw dynamic shadow
drawBloom(); // Draw blooming flower
checkMetamorphosis(); // Handle metamorphosis logic
}
// Function to draw the flower with bloom and metamorphosis
void drawBloom() {
translate(width / 2, height / 2); // Center the flower
// Draw petals
for (int i = 0; i < 12; i++) {
pushMatrix();
rotate(TWO_PI / 12 * i + angle); // Rotate petals evenly
fill(lerpColor(color(255, 100, 150), color(200, 200, 50), flowerSize / 200));
ellipse(0, flowerSize / 2, flowerSize / 2, flowerSize); // Petal shape
popMatrix();
}
// Draw flower center
fill(50, 100, 255);
ellipse(0, 0, flowerSize / 3, flowerSize / 3);
// Increase the size of the flower until a limit
if (!metamorphosisStarted) {
flowerSize += growthRate;
if (flowerSize > 150) metamorphosisStarted = true; // Start metamorphosis
}
}
// This sections code is resposible for the shadows
void drawShadow() {
pushMatrix();
translate(width / 2 + shadowOffset, height / 2 + shadowOffset); // Offset shadow
for (int i = 0; i < 12; i++) {
pushMatrix();
rotate(TWO_PI / 12 * i + angle); // Rotate shadow petals
fill(0, 50); // Semi-transparent black for shadow
ellipse(0, flowerSize / 2, flowerSize / 2, flowerSize); // Shadow petals
popMatrix();
}
popMatrix();
}
// Function to gradually metamorphosize the flower
void checkMetamorphosis() {
if (metamorphosisStarted) {
// Rotate petals for a transformation effect
angle += 0.01;
// Change growth rate to make the flower appear to shift
growthRate = sin(frameCount * 0.01) * 0.5;
// Slightly distort the shadow
shadowOffset = 20 + sin(frameCount * 0.05) * 10;
}
}
