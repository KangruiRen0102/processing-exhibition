let img; // Variable to store the image
let maskGraphic; // A p5.Graphics object to hold the circular mask
let circleRadius = 1; // Starting radius for the circle
let imageRevealed = false; // A flag to check if the image is fully revealed

function preload() {
  // Preload the image
  img = loadImage("uploads/Eya Zaied.jpg");
}

function setup() {
  createCanvas(626, 351); // Set canvas size to match image dimensions
  maskGraphic = createGraphics(626, 351); // Create a graphics object for the mask
  maskGraphic.background(0); // Start with a black background
}

function draw() {
  background(255); // Start drawing from a white background

  // Draw the circular mask on the maskGraphic
  maskGraphic.fill(255); // White color for the reveal
  maskGraphic.noStroke();
  maskGraphic.ellipse(maskGraphic.width / 2, maskGraphic.height / 2, circleRadius, circleRadius);

  // Apply the mask to the image
  img.mask(maskGraphic);

  // Display the image with the mask
  image(img, width / 2 - img.width / 2, height / 2 - img.height / 2);

  // Increase the radius of the circle as it reveals the image
  if (circleRadius < img.width * 1.5) {
    circleRadius += 5; // Increase radius gradually
  } else {
    imageRevealed = true; // Image is fully revealed
  }
}
