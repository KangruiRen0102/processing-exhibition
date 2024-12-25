//My memory of seeing aurora in Edmonton
PShape skyline;
int numBands = 15;
float[] offsets;
ArrayList<Particle> particles = new ArrayList<>();
String[] memoryTexts = {
    "Snow crunching in Edmonton's winter..." ,
    "The colors of Aurora looked like painting in night sky...",
    "A quiet walk in Elk Island...",
    "Warm Lights in a cold night was new to me...",
};
int memoryIndex = 0 ;
int memoryTimer = 0;

void setup() {
  size(900, 600);
  skyline = createSkyline();
  offsets = new float[numBands];
  for (int i = 0; i < numBands; i++) {
    offsets[i] = random(TWO_PI);
  }
}

void draw() 
  {
  background(0);
  drawAurora(); //Drawing aurora 
  drawMoon(); //Drawing moon after aurora
  shape(skyline,0,height-150); //Drawing fading particles as stars
  drawParticles(); //Dispalying text based memories
  drawMemoryText();
}


void drawMoon() {
  float moonX = width -100; //Positioning on the right side
  float moonY = 100; //Positioning near to top
  float moonRadius = 80; //Size of the moon
  
  // Draw the moon's glow
  for (float r = moonRadius * 1.5; r > moonRadius; r -= 5) {
    fill(255, 255, 200, map(r, moonRadius, moonRadius * 1.5, 20, 0)); // Glow gradient
    ellipse(moonX, moonY, r, r);
  }
  
  // Draw the moon
  fill(255, 255, 200);
  ellipse(moonX, moonY, moonRadius, moonRadius);
  
  // Optional: Add craters
  fill(230, 230, 180);
  ellipse(moonX - 15, moonY - 10, 10, 10);
  ellipse(moonX + 10, moonY + 5, 15, 15);
  ellipse(moonX - 20, moonY + 15, 8, 8);
}
void drawAurora() {
  noStroke();
  int numBands = 15; // More layers for overlapping effects
  for (int i = 0; i < numBands; i++) {
    float yOffset = map(noise(i * 0.1, millis() * 0.0001), 0, 1, 80, 180); // Slow vertical motion
    float alpha = map(sin(millis() * 0.0005 + offsets[i]), -1, 1, 40, 100); // Softer transparency

    int color1 = color(0, 128, 255);  // Blue
    int color2 = color(0, 255, 128); // Green
    int color3 = color(255, 64, 64); // Red
    int color4 = color(255, 0, 128); // Pink

    // Blend colors dynamically
    float colorNoise = noise(i * 0.1, millis() * 0.0001); // Smoothen transitions
    int blendedColor = lerpColor(
      lerpColor(color1, color2, colorNoise),
      lerpColor(color3, color4, colorNoise),
      sin(millis() * 0.0005)
    );

    fill(blendedColor, alpha);
    beginShape();
    for (int x = 0; x <= width; x += 10) {
      float noiseFactor = noise(x * 0.0001, i * 0.01) * 30; // Subtle noise
      float curtainEffect = sin(x * 0.004 + millis() * 0.00007) * 80; // Vertical undulations
      float y = height / 2 - yOffset + noiseFactor + curtainEffect; // Combining effects
      vertex(x, y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

PShape createSkyline() {
  PShape skyline = createShape();
  skyline.beginShape();
  skyline.fill(20);
  skyline.stroke(255);
  //Trying to potray edmonton skyline from my first aurora watch memory
  skyline.vertex(0,150);
  skyline.vertex(80,100);//Roofshapes
  skyline.vertex(120,120);
  skyline.vertex(200, 90); //Building antenna
  skyline.vertex(240, 110);
  skyline.vertex(320,70); //High rise
  skyline.vertex(400,140);
  skyline.vertex(500, 80); //Arches of bridge
  skyline.vertex(600, 120);
  skyline.vertex(750, 100); //Rooftop covered in snow
  skyline.vertex(900, 150);
  skyline.vertex(900, 200);
  skyline.vertex(0, 200);
  skyline.endShape(CLOSE);
  return skyline;
}

void drawParticles() {
  for(int i = particles.size()-1; i >=0; i--) {
    Particle p=particles.get(i);
    p.update();
    p.display();
    if (p.isFaded()) {
      particles.remove(i);
   }
}
  //Adding more particles at random intervals
  if (frameCount % 10 == 0) {
    particles.add(new Particle(random(width), random(height/2-100,height/2+50)));
  }
}

void drawMemoryText() {
  fill(255, 200);
  textSize(22);
  textAlign(CENTER);
  text(memoryTexts[memoryIndex], width/2,height - 30);
  
  //Cycle through memory texts
  memoryTimer++;
  if (memoryTimer>300) {
    memoryIndex=(memoryIndex+1)%memoryTexts.length;
    memoryTimer=0;
  }
}

class Particle {
  float x,y;
  float alpha = 255;
  float speedX, speedY;
  
  Particle(float x,float y) {
    this.x=x;
    this.y=y;
    this.speedX=random(-1,1);
    this.speedY=random(-0.5,-1.5);
  }
  
  void update() {
    x += speedX;
    y += speedY;
    alpha -= 2; //Fading out
  }
  
  void display() {
    noStroke();
    fill(255, alpha);
    ellipse(x, y, 5,5);
  }
  
  boolean isFaded() {
    return alpha <= 0;
  }
}

  
  
   
    
    
  
    
  
  


    
    
    
    
