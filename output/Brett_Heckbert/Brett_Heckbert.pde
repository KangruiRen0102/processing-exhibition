// Defines variables for waves
int wave = 6; // sets the number of waves
float[] offsets;  // defines array for wave offsets
color[] wave_colour; // defines array for wave colors

void setup() {
  size(800, 600); // sets the image size to 800x600
  offsets = new float[wave]; // starts the offsets with a length equal to the number of waves
  wave_colour = new color[] {
    color(50, 200, 255, 100),   // Light blue
    color(100, 255, 150, 120),  // Light green
    color(200, 25, 255, 80),    // Purple
    color(255, 100, 200, 120)   // Pink
  };

  // Randomize the initial phase offsets for each wave to create variation
  for (int j = 0; j < wave; j++) {
    offsets[j] = random(TWO_PI); // sets a random starting phase for each wave
  }
}

void draw() {
  background(10, 15, 50); // sets the background color to dark blue to create a night sky

  // Adjusts the coordinate system to make the waves appear from the top of the canvas and not the bottom
  pushMatrix(); // saves the current transformation state
  translate(width / 2, height / 2); // moves the origin to the center of the canvas for symetrical rotation
  rotate(PI); // rotates the canvas 180 degrees to flip the waves to the top
  translate(-width / 2, -height / 2); // moves the origin back to the top-left corner

  // Loop to draw each wave
  for (int j = 0; j < wave; j++) {
    draw_wave(j, wave_colour[j % wave_colour.length]); // draws a wave with a specific colour
    offsets[j] += 0.2; // increments the wave offset for better animation
  }

  // Creates stars in the night sky
  stars(100); // draws 100 stars

  popMatrix(); // restores the previous transformation state
}

// Draws a single wave with animation and color
void draw_wave(int index, color wave_colour) {
  float wave_height = height / 4.0; // defines the max wave height
  float wave_pos_y = height / 2.0 + index * 30; // positions each wave below the previous one
  float wave_speed = 0.5 + index * 0.1; // adjusts the animation speed for each wave

  noStroke(); // disables stroke for the wave shape
  fill(wave_colour); // fills wave with colour

  beginShape(); // Begins defining the wave shape
  for (float x = 0; x <= width; x += 10) {
    // calculates the y-coordinate using sine wave combined with perlin noise
    float y = wave_pos_y + sin((x + offsets[index]) * 0.02) * wave_height * noise(x * 0.01, frameCount * 0.005);
    vertex(x, y); // adds a vertex to the wave shape
  }
  vertex(width, height); // adds a vertex at the bottom-right corner
  vertex(0, height); // adds a vertex at the bottom-left corner
  endShape(CLOSE); // closes the shape and fills it
}

// Creates random position and brightness for stars
void stars(int count) {
  for (int j = 0; j < count; j++) {
    float x = random(width); // sets random x-coordinate for the star position
    float y = random(height); // sets random y-coordinate for the star postion
    float brightness = random(100, 255); // sets random brightness for the star
    noStroke(); // disables stroke for the stars
    fill(brightness, brightness, brightness, 150); // sets the star color with alpha for star transparency
    ellipse(x, y, random(1, 3), random(1, 3)); // draws a very small circle to represent the star shape
  }
}
