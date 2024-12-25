PImage img;  // to store the image 
PGraphics maskGraphic;  // A PGraphics object to hold the circular mask
int circleRadius = 1;  // Starting radius for the circle
boolean imageRevealed = false;  // A flag to check if the image is fully revealed

void setup() {
  size(626, 351);  // Setting window size to match image dimensions
  img = loadImage("Eya Zaied.jpg");  // Loading the image
  maskGraphic = createGraphics(img.width, img.height);  // Create a graphics object for the mask
  maskGraphic.beginDraw();
  maskGraphic.background(0);  // Start with a black background 
  maskGraphic.endDraw();
  imageMode(CENTER);  // Set image mode to start drawing from the center
}

void draw() {
  background(255);  // Start drawing from a white background
  
  // Draw the circular mask on the maskGraphic
  maskGraphic.beginDraw();
  maskGraphic.fill(255);  // White color for the  reveal
  maskGraphic.ellipse(maskGraphic.width / 2, maskGraphic.height / 2, circleRadius, circleRadius);
  maskGraphic.endDraw();
  
  // Apply the mask to the image and display it
  PImage maskedImage = img.get();  // Copying the image to a new PImage
  maskedImage.mask(maskGraphic);  // Applying the circular mask
  
  // Display the image with the mask
  image(maskedImage, width / 2, height / 2);
  
  // Increase the radius of the circle as it reveals the image
  if (circleRadius < img.width * 1.5) {
    circleRadius += 5;  // Increase radius gradually
  } else {
    imageRevealed = true;  // Image is fully revealed
  }

}
