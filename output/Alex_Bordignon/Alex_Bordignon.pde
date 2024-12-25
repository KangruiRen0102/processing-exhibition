// Global variables for stars
PVector[] stars;  // Array to store star positions
int numStars = 30;  // Number of stars to display
int auroraLines = 10;  // Initial number of aurora glow lines
int initialAuroraLines = 10;  // To reset aurora lines when R is pressed
color[] auroraColors;  // Array to store colors for each aurora glow
float celestialX = 0;  // Horizontal position (for both moon and sun)
float celestialY;  // Vertical position (calculated based on sine wave)
float celestialSpeed = 3;  // Speed of movement (same for both moon and sun)
float arcHeight = 200;  // Height of the arc (adjusted for better visibility)
float arcStartY = 250;  // Starting Y position of the arc

boolean isSun = false;  // Flag to check if it's sun time
float celestialSize = 80;  // Size for both moon and sun

// Aurora fading effect variables
float auroraOpacity = 255;  // Initial opacity for aurora (full opacity)

// Colors for sunrise and sunset
color skyBlue = color(135, 206, 250);  // Daytime sky blue
color sunsetOrange = color(255, 140, 0);  // Sunset/sunrise orange
color nightBlue = color(10, 20, 50);  // Night sky dark blue
color oceanDay = color(70, 130, 180);  // Light blue ocean for daytime
color oceanNight = color(0, 0, 128);  // Dark blue ocean for nighttime

boolean isEclipse = false;  // Flag to check if eclipse is happening
color eclipseColor = color(0);  // Color for the eclipse (black sun with orange glow)
color eclipseWater = oceanNight;  // Water color during eclipse (nighttime water)


void setup() {
  size(800, 600);  // Set canvas size
  smooth();        // Enable smooth rendering

  // Initialize aurora colors
  auroraColors = new color[auroraLines];
  initializeAuroraColors();

  // Generate random star positions
  stars = new PVector[numStars];
  for (int i = 0; i < numStars; i++) {
    float starX = random(width);  // Random x position
    float starY = random(height / 2);  // Random y position in the top half of the sky
    stars[i] = new PVector(starX, starY);
   }
}

void draw() {

  // Set the background and ocean colors based on the current state (eclipse or normal day/night)
  color currentBackground;
  color currentOcean;

  float transitionSpeed = 0.5;
  float transitionFactor = map(celestialX, 0, width, 0, 1);
  transitionFactor = min(transitionFactor + transitionSpeed, 1);

  if (isEclipse) {
    currentBackground = color(0);  // Black sky during eclipse
    currentOcean = eclipseWater;  // Nighttime water color
  } else if (isSun) {
    currentBackground = lerpColor(sunsetOrange, skyBlue, transitionFactor);
    currentOcean = oceanDay;

    auroraOpacity = 0;  // Set aurora opacity to 0 during daytime
  } else {
    currentBackground = lerpColor(sunsetOrange, nightBlue, transitionFactor);
    currentOcean = oceanNight;

    auroraOpacity = 255;  // Ensure aurora is fully visible at night
  }

  // Draw the sky
  for (int i = 0; i < height / 2; i++) {
    color gradientColor = lerpColor(sunsetOrange, currentBackground, transitionFactor);
    stroke(gradientColor);
    line(0, i, width, i);
  }

  // Bottom half of the sky
  for (int i = height / 2; i < height; i++) {
    stroke(currentBackground);
    line(0, i, width, i);
  }

  // Draw the ocean (drawn before stars now)
  for (int i = height / 2; i < height; i++) {
    stroke(currentOcean);
    line(0, i, width, i);
  }

  // Only draw aurora if there's no eclipse and it's nighttime
  if (!isEclipse && auroraOpacity > 0) {
    drawAurora();  // Draw the aurora in the sky
    drawAuroraReflection();  // Draw the aurora reflection in the water
  }

  // Update celestial position for both sun and moon
  updateCelestialPosition();  // Ensure movement of the celestial body (even during eclipse)

  // Draw celestial body (sun or moon)
  if (isEclipse) {
    // Draw the orange glow first, outside the sun's radius
    drawGlow(celestialX, celestialY, 65, color(255, 100, 0));  // Larger glow radius
    drawCelestial(celestialX, celestialY, color(0));  // Black center of the sun
    drawReflection(celestialX, celestialY, color(0)); // Reflection of the black sun
  } else {
    // Normal sun or moon
    if (isSun) {
      drawCelestial(celestialX, celestialY, color(255, 255, 0));  // Sun
      drawReflection(celestialX, celestialY, color(255, 255, 0));
    } else {
      drawCelestial(celestialX, celestialY, color(200, 200, 255));  // Moon
      drawReflection(celestialX, celestialY, color(200, 200, 255));
    }
  }

  // Draw stars after the ocean, so they are on top
  if (!isSun && !isEclipse) {
    drawStars();  // Draw stars and their reflections
  }
}

// Function to draw the orange glow around the sun during the eclipse
void drawGlow(float x, float y, float radius, color glowColor) {
  noStroke();
  fill(glowColor);
  ellipse(x, y, radius * 2, radius * 2);  // Draw a glowing circle around the sun
}


// Function to draw the eclipse celestial body (black sun with orange glow)
void drawCelestialEclipse(float x, float y, color celestialColor) {
  float sizeModifier = 1.3;  // Celestial larger
  float glowIntensity = 10;  // Stronger Glow

  // Draw the eclipse (black sun with orange glow)
  noStroke();
  fill(celestialColor, 220);  // Black sun with no opacity
  ellipse(x, y, celestialSize * sizeModifier, celestialSize * sizeModifier);  // Eclipse body

  // Orange glow around the eclipse
  for (int glow = 1; glow <= glowIntensity; glow++) {
    int glowAlpha = 80 - glow * 10;  // Orange glow for eclipse
    fill(255, 140, 0, glowAlpha);  // Orange color for the glow
    float glowSize = celestialSize * sizeModifier + glow * 15;  // Glow size increases progressively
    ellipse(x, y, glowSize, glowSize);
  }
}


// Function to draw the stars and their reflections
void drawStars() {
  for (int i = 0; i < numStars; i++) {
    PVector star = stars[i];
    float starSize = random(2, 5);  // Random size for the star (small)

    // Draw the star in the sky
    fill(255, 255, 255, random(180, 255));  // White color with slight twinkle effect
    noStroke();
    beginShape();
    vertex(star.x, star.y - starSize);         // Top vertex
    vertex(star.x + starSize, star.y);        // Right vertex
    vertex(star.x, star.y + starSize);        // Bottom vertex
    vertex(star.x - starSize, star.y);        // Left vertex
    endShape(CLOSE);

    // Reflect the star in the water (same logic as celestial reflection)
    float reflectionY = height - (star.y - height / 2) - 250 ;  // Mirror Y position for reflection
    float reflectionSize = starSize * 1.2;  // Slightly larger for distortion
    fill(255, 255, 255, random(50, 120));  // Faded white for reflection
    beginShape();
    vertex(star.x, reflectionY - reflectionSize);         // Top vertex
    vertex(star.x + reflectionSize, reflectionY);        // Right vertex
    vertex(star.x, reflectionY + reflectionSize);        // Bottom vertex
    vertex(star.x - reflectionSize, reflectionY);        // Left vertex
    endShape(CLOSE);
  }
}



// Function to draw the reflection of the celestial object
void drawReflection(float x, float y, color celestialColor) {
  // Reflection position: Mirror the celestial position vertically (relative to waterline)
  float reflectionY = height - (y - height / 2) * 0.1;  // Flip Y position for reflection

  // Set the opacity of the reflection (this controls how faded the reflection looks)
  float reflectionOpacity = 100;  // You can adjust this value for more or less opacity

  // Slightly stretch the reflection to give a more realistic look
  float reflectionSize = celestialSize * 1.2;  // Increase the size of the reflection a bit to simulate distortion

  // Draw the reflection with adjusted opacity
  noStroke();
  fill(celestialColor, reflectionOpacity);  // Use the same color as the celestial body but with opacity
  ellipse(x, reflectionY, reflectionSize, reflectionSize);  // Draw the reflected celestial body
}


// Function to initialize random colors for aurora glows
void initializeAuroraColors() {
  for (int i = 0; i < auroraLines; i++) {
    // Randomly pick yellow, purple, red, or green for each glow
    int choice = int(random(4));  // Change from 3 to 4 options
    if (choice == 0) auroraColors[i] = color(255, 255, 100); // Yellow
    else if (choice == 1) auroraColors[i] = color(200, 100, 255); // Purple
    else if (choice == 2) auroraColors[i] = color(255, 100, 100); // Red
    else auroraColors[i] = color(100, 255, 100); // Green
  }
}

// Function to create aurora effect with stronger glow
void drawAurora() {
  for (int i = 0; i < auroraLines; i++) {
    color c = auroraColors[i];  // Get the color for this glow

    // Draw the glow: multiple semi-transparent parallel layers
    for (int glow = 1; glow <= 15; glow++) {  // Increase the number of glow layers for a stronger effect
      stroke(red(c), green(c), blue(c), auroraOpacity - glow * 5);  // Adjust opacity for more prominence
      noFill();
      beginShape();
      for (int x = 0; x < width; x += 10) {
        // Offset the glow slightly for better visibility
        float y = noise(x * 0.01, frameCount * 0.01 + i) * height / 2 - glow * 2;
        vertex(x, y);
      }
      endShape();
    }
  }
}

// Function to draw the reflection of the aurora
void drawAuroraReflection() {
  float reflectionOpacity = auroraOpacity * 0.5;  // Slightly less opacity for the reflection
  float auroraHeight = height / 2 - 300;  // The height at which the aurora is drawn
  
  // Draw aurora reflection by mirroring the aurora path
  for (int i = 0; i < auroraLines; i++) {
    color c = auroraColors[i];  // Get the color for this glow
    
    // Draw the glow: multiple semi-transparent parallel layers
    for (int glow = 1; glow <= 15; glow++) {  // Increase the number of glow layers for a stronger effect
      stroke(red(c), green(c), blue(c), reflectionOpacity - glow * 5);  // Adjust opacity for more prominence
      noFill();
      beginShape();
      for (int x = 0; x < width; x += 10) {
        // Offset the glow slightly for better visibility
        float y = noise(x * 0.01, frameCount * 0.01 + i) * height / 2 - glow * 2;
        float reflectionY = height - (y - auroraHeight);  // Mirror the Y position for reflection
        vertex(x, reflectionY);  // Draw each mirrored aurora point
      }
      endShape();
    }
  }
}



void updateCelestialPosition() {
  if (mousePressed) {
    // Follow the mouse when the mouse is held down
    celestialX = mouseX;
    celestialY = mouseY;
  } else {
    // Update position as it moves from left to right
    celestialX += celestialSpeed;

    // Use a sine wave to create the Y position (arc path)
    float sineFactor = sin(map(celestialX, 0, width, 0, PI));  // Generate a sine wave oscillation
    celestialY = arcStartY - sineFactor * arcHeight;  // Adjust for the arc height

    // Only allow the eclipse to occur when the sun first appears
    if (celestialX >= 0 && celestialX < 5 && isSun) {
      isEclipse = (random(10) < 1);  // Random chance of eclipse only when the sun appears
    }

    // Transition from moon to sun when the celestial object reaches the left side
    if (celestialX >= width && !isSun) {
      celestialX = 0;  // Reset to the initial position (left side)
      isSun = true;  // Ensure it's sun after reset, no eclipse
    }

    // Transition from sun to moon when the celestial object reaches the right side
    if (celestialX >= width && isSun) {
      celestialX = 0;  // Reset to the initial position (left side)
      isSun = false;  // Switch to moon (night)
      isEclipse = false;  // Reset eclipse at the end of the day
    }
  }
}





// Function to draw a glowing celestial object (moon or sun)
void drawCelestial(float x, float y, color celestialColor) {
  // Make the moon larger if it's nighttime
  float sizeModifier = 1.3;  // Celestial larger
  float glowIntensity = 10;    // Stronger Glow

  // Draw the celestial object (moon or sun)
  noStroke();
  fill(celestialColor, 220);  // Slightly more opaque for better visibility
  ellipse(x, y, celestialSize * sizeModifier, celestialSize * sizeModifier);  // Celestial body

  // Add a glowing effect
  for (int glow = 1; glow <= glowIntensity; glow++) {
    int glowAlpha = isEclipse || !isSun ? 80 - glow * 8 : 50 - glow * 10;  // Same glow for eclipse as moon
    fill(celestialColor, glowAlpha);  
    float glowSize = celestialSize * sizeModifier + glow * 15;  // Glow size increases progressively
    ellipse(x, y, glowSize, glowSize);
  }
}


// Function to handle key presses
void keyPressed() {
  // Change colors if the space bar is pressed
  if (key == ' ') {
    initializeAuroraColors();  // Reassign random colors to each glow
  }

  // Reset the number of aurora lines if R is pressed
  if (key == 'r' || key == 'R') {
    auroraLines = initialAuroraLines;  // Reset to the initial amount
    auroraColors = new color[auroraLines];  // Resize color array
    initializeAuroraColors();  // Reinitialize colors
  }

  // Increase aurora lines when 'm' is pressed
  if (key == 'm' || key == 'M') {
    auroraLines++;  // Add a new aurora line
    auroraColors = expandAuroraColors(auroraColors, 1);  // Expand the colors array
    initializeAuroraColors();  // Reinitialize colors to include the new glow
  }

  // Decrease aurora lines when 'n' is pressed
  if (key == 'n' || key == 'N') {
    if (auroraLines > 1) {  // Ensure there is at least 1 aurora line
      auroraLines--;  // Remove an aurora line
      auroraColors = shrinkAuroraColors(auroraColors, 1);  // Shrink the colors array
      initializeAuroraColors();  // Reinitialize colors to match the reduced count
    }
  }

  // Increase celestial speed when 'p' is pressed
  if (key == 'p' || key == 'P') {
    celestialSpeed += 0.5;  // Increment speed
    println("Celestial speed increased to: " + celestialSpeed);
  }

  // Decrease celestial speed when 'o' is pressed
  if (key == 'o' || key == 'O') {
    celestialSpeed = max(0.1, celestialSpeed - 0.5);  // Decrement speed, ensure it's not below 0.1
    println("Celestial speed decreased to: " + celestialSpeed);
  }
  
    // Decrease celestial speed when 'o' is pressed
  if (key == 'e' && isSun || key == 'E'  && isSun) {
    isEclipse = true;  // Force eclipse to occur
  }
}

// Function to shrink the aurora colors array when decreasing lines
color[] shrinkAuroraColors(color[] oldArray, int extraLength) {
  color[] newArray = new color[oldArray.length - extraLength]; 
  // Copy the old array to the new array, excluding the last element
  for (int i = 0; i < newArray.length; i++) {
    newArray[i] = oldArray[i];
  }
  return newArray;
}


// Function to expand the aurora colors array
color[] expandAuroraColors(color[] oldArray, int extraLength) {
  color[] newArray = new color[oldArray.length + extraLength]; 
  // Copy the old array to the new array
  for (int i = 0; i < oldArray.length; i++) {
    newArray[i] = oldArray[i];
  }
  return newArray;
}
