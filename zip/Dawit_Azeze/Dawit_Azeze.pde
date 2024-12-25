//Number, dimensions, and speed of planets 
int numPlanets = 5; 
float[] planetRadii = new float[numPlanets]; 
float[] planetAngles = new float[numPlanets]; 
float[] planetSpeeds = new float[numPlanets];
//Speed, colors, and number of starts
int numStars = 300; 
float[] starX = new float[numStars];
float[] starY = new float[numStars];
float[] starSize = new float[numStars]; 
float[] starSpeed = new float[numStars]; 
float[] starLayer = new float[numStars];

void setup() {
  size(800, 800);
  noFill();
  frameRate(30);
  smooth();

  // Initialize planets' radii, angles, and speeds
  for (int i = 0; i < numPlanets; i++) {
    planetRadii[i] = random(50, 300); // Random distances from the center
    planetAngles[i] = random(TWO_PI); // Random initial angles
    planetSpeeds[i] = random(0.002, 0.005); // Random orbital speeds
  }

  // Initialize stars
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(-400, 400);
    starY[i] = random(-400, 400);
    starSize[i] = random(1, 3); // Random sizes for the stars
    starSpeed[i] = random(0.1, 0.5); // Random speed for parallax
    starLayer[i] = random(0.5, 2.5); // Layer depth for stars (near or far)
  }
}

void draw() {
  background(10, 10, 30);
  translate(width / 2, height / 2);
  
  float t = millis() / 6000.0; //

  // stars in the background for effect
  for (int i = 0; i < numStars; i++) {
    float x = starX[i] + starSpeed[i] * t * starLayer[i];
    float y = starY[i] + starSpeed[i] * t * starLayer[i];
    
    // Wrap stars around screen
    if (x > width) starX[i] = -width;
    if (x < -width) starX[i] = width;
    if (y > height) starY[i] = -height;
    if (y < -height) starY[i] = height;
    
    float size = starSize[i];
    stroke(255, 255, 255, map(starLayer[i], 0.5, 2.5, 200, 100)); // Fainter stars in backround
    strokeWeight(size);
    point(x, y);
  }

  //glowing line arcs
  for (int i = 0; i < 8; i++) { // Increase the number of arcs
    float angle = map(i, 0, 8, 0, TWO_PI) + t;
    float x1 = 300 * cos(angle);
    float y1 = 300 * sin(angle);
    stroke(255, 100 + 80 * sin(t * 2), 200, 180);
    strokeWeight(3 + sin(t));
    line(0, 0, x1, y1);
    noFill();
    stroke(255, 220, 220, 180);
    arc(0, 0, 320 + 30 * sin(t * 2), 320 + 30 * cos(t * 2), angle, angle + QUARTER_PI);
  }

  //clock hands and markers
  float pulse = 1 + 0.4 * sin(t * TWO_PI); // 

  // Clock hour markers
  for (int i = 0; i < 12; i++) {
    float angle = map(i, 0, 12, 0, TWO_PI) - HALF_PI;
    float x1 = 300 * cos(angle);
    float y1 = 300 * sin(angle);
    float x2 = 330 * cos(angle);
    float y2 = 330 * sin(angle);
    stroke(180 + 50 * sin(t * 3), 255, 150, 200);
    strokeWeight(4); 
    line(x1, y1, x2, y2);
  }

  // Clock hands
  float secondAngle = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  float minuteAngle = map(minute(), 0, 60, 0, TWO_PI) - HALF_PI;
  float hourAngle = map(hour() % 12, 0, 12, 0, TWO_PI) - HALF_PI;

  // Second hand 
  stroke(255, 255, 255, 200); // Set the second hand to white
  strokeWeight(3);
  line(0, 0, 200 * cos(secondAngle), 200 * sin(secondAngle));

  // Minute hand
  stroke(255, 255, 255, 220);
  strokeWeight(5);
  line(0, 0, 150 * cos(minuteAngle), 150 * sin(minuteAngle));

  // Hour hand
  stroke(255, 215, 0, 220);
  strokeWeight(7);
  line(0, 0, 100 * cos(hourAngle), 100 * sin(hourAngle));

  //glowing central orb 
  noStroke();
  fill(255, 200, 80, 180 + 60 * sin(t * 4));
  ellipse(0, 0, 40 + 15 * sin(t * 2), 40 + 15 * cos(t * 2));

  // planets orbiting around the clock with glow 
  for (int i = 0; i < numPlanets; i++) {
   
    planetAngles[i] += planetSpeeds[i];

    // Calculate the planet's current position
    float x = planetRadii[i] * cos(planetAngles[i]);
    float y = planetRadii[i] * sin(planetAngles[i]);

    // makes planets seem smaller and dimmer as they get farther away
    float sizeFactor = map(planetRadii[i], 50, 400, 1.0, 0.2); 
    float alpha = map(planetRadii[i], 50, 400, 255, 100); // alpha decreases as planet moves farther out

    // Planet colors change depending on distance
    color planetColor;
    if (i == 0) {
      planetColor = color(255, 100, 100); 
    } else if (i == 1) {
      planetColor = color(100, 200, 255); 
    } else if (i == 2) {
      planetColor = color(200, 255, 100); 
    } else if (i == 3) {
      planetColor = color(255, 255, 0); 
    } else {
      planetColor = color(255, 150, 255); 
    }

    //a glowing effect around planets
    noStroke();
    fill(planetColor, alpha - 50); 
    ellipse(x, y, 40 * sizeFactor, 40 * sizeFactor); 

    //planets with a glow and size effect
    stroke(planetColor);
    fill(planetColor, alpha);
    ellipse(x, y, 30 * sizeFactor, 30 * sizeFactor); 
  }

  // Gradually move the planets further out as time passes
  for (int i = 0; i < numPlanets; i++) {
    planetSpeeds[i] *= 1.0001; // Slowly increase speed for acceleration
    planetRadii[i] += 0.05; // Increase radius slowly to make planets move outward
    if (planetRadii[i] > 400) {
      planetRadii[i] = 50; // Reset radius if it gets too far
    }
  }
}
