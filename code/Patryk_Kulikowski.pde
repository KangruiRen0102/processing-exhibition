float noiseOffsetRiver;
//Random locations of the skiiers represented as red triangles 
int numKids = 10;
float[] kidX = new float[numKids];
float[] kidY = new float[numKids];

//Random Ski lodge position static after you start code
float BaseX1 = random(0.33,0.48);
float BaseY1 = random(0.61,0.65);
float Lodgeheight = 20; 

void setup() {
  size(800, 600);
  noStroke();


  // Generate random positions for the makeshift kids static
  for (int i = 0; i < numKids; i++) {
    kidX[i] = random(width * 0.53, width * 0.6);
    kidY[i] = random(height * 0.42, height * 0.6);
  }
  
  noiseOffsetRiver = random(10000);
}

void draw() {
  drawSky();
  drawGlacier();
  drawMountains();
  drawRiver();
  drawSkiLodge();
  drawSkiSlopeKids();
}



// SKY (Gradient)
void drawSky() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0.0, 1.0);
    int c1 = color(135, 206, 235);
    int c2 = color(0, 102, 204);
    int col = lerpColor(c1, c2, inter);
    stroke(col);
    line(0, y, width, y);
  }
  noStroke();
}



// MOUNTAINS
void drawMountains() {
  noStroke();
  fill(60, 60, 80);
  
  // Background mountains (Darker)
  
  triangle(-400, 800, 350, 230, 700, 800);
  
  triangle(300, 700, 900, 0, 1400, 700);
  
 ////////////////////////////////////////////////////////////////// 
 //2nd Glacier inbetween the mountians needs to be here so that it is behind the closest mountains 
 // but in fron of the farthest ones
  float Ymin = 370; 
  float amplitude = 50;
  float Xmin = 190;
  float Xmax = 450;
  fill(218, 237, 255, 255);
  
  square(Xmin,Ymin,Xmax-Xmin);
  
  beginShape();

  vertex(Xmin, Ymin);
  for (float x = Xmin; x <= Xmax; x += 15) {
    float n = noise(x * 0.02 + 100);
    float GlacierTop = Ymin - amplitude * n;
    vertex(x, GlacierTop);
  }
  vertex(Xmax,Ymin);
  endShape(CLOSE);
////////////////////////////////////////////////////////////////
  
  //Foreground mountains 
  
  fill(80, 80, 100);

  triangle(-200, 800, 50, 100, 500, 800);
  
  triangle(100, 700, 700, 175, 1200, 700);
  

}

//Drawing the glacier at the top 

void drawGlacier() {
  float Ymin = 270; 
  float amplitude = 50;
  float Xmin = 350;
  float Xmax = 650;
  fill(218, 237, 255, 255);
  
  square(Xmin,Ymin,Xmax-Xmin);
  
  beginShape();

  vertex(Xmin, Ymin);
  for (float x = Xmin; x <= Xmax; x += 15) {
    float n = noise(x * 0.02 + 100);
    float GlacierTop = Ymin - amplitude * n;
    vertex(x, GlacierTop);
  }
  vertex(Xmax,Ymin);
  endShape(CLOSE);
  
}

  

// River code 
void drawRiver() {
  fill(30, 144, 255, 180);
  beginShape();

  int riverTop = 430;          
  int riverBottom = height;  

  // Left edge of river
  for (int y = riverTop; y <= riverBottom; y += 5) {
    float ny = noiseOffsetRiver + y * 0.005;
    // Adjust horizontal range here if you wish (the .1–.4 range sets how wide it can shift)
    float riverX = map(noise(ny), 0, 0.5,-0.15*y+330, -0.15*y+378);
    vertex(riverX, y);
  }

  // Right edge of river
  for (int y = riverBottom; y >= riverTop; y -= 5) {
    float ny = noiseOffsetRiver + y * 0.005 ;
    float riverX = map(noise(ny), 0, 0.5, 0.2*y+200, 0.2*y+230);
    vertex(riverX, y);
  }

  endShape(CLOSE);
  

  noiseOffsetRiver += 0.0005;
}

// Ski Lodge position based on the inital global variable when code first ran 
void drawSkiLodge(){
  fill(153,76,0,255);
  beginShape();
  square(BaseX1*width,BaseY1*height,Lodgeheight);
  fill(102,51,0,255);
  triangle(BaseX1*width-10,BaseY1*height,BaseX1*width+0.5*Lodgeheight,BaseY1*height-10,BaseX1*width+Lodgeheight+10,BaseY1*height);
 
}


// Skiiers on the slope
void drawSkiSlopeKids() {
  fill(255, 0, 0);
  noStroke();
  for (int i = 0; i < numKids; i++) {
    triangle(
      kidX[i],     kidY[i] - 5,  // top point
      kidX[i] - 4, kidY[i] + 5,  // left foot
      kidX[i] + 4, kidY[i] + 5   // right foot
      
    );
  }
}
