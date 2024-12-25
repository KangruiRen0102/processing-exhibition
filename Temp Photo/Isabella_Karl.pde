int cols, rows;
float[][] noiseMap;
float time = 0;

// In the void setup we are starting to set up the size of the canvas 
// as well as dividing the canvas into rows and columns so we can set 
// up the noise map that will be used to make the aurora borealis effect.
void setup() {
  size(800, 600);
  cols = width / 5;
  rows = height / 5;
  noiseMap = new float[cols][rows];
  noStroke();
  smooth();
}

void draw() {
  background(0);
  
  // Here we are generating the noise map for the aurora to make it look 
  // like they "move" in the sky.
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float xoff = map(i, 0, cols, 0, 5);
      float yoff = map(j, 0, rows, 0, 5);
      noiseMap[i][j] = noise(xoff, yoff, time);
    }
  }
  
  // Here we are creating the aurora effect and mapping the noise value to make
  // the aurora flow smoothly, then we choose the color to be green. Small ellipses
  // were used to make the aurora look smoother. I got help from ChatGPT with perfecting
  // the aurora effect.
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float n = noiseMap[i][j];
      if (n > 0.3) {
        float green = map(n, 0.3, 1.0, 0, 255);
        fill(0, green, 0, 150);
        ellipse(i * 5, j * 5, 3, 3);
      }
    }
  }
  
  // Setting a time increment for the aurora animation. A lower number means slower movement.
  time += 0.03;
  
  // Drawing Mountain 1
  fill(50);
  beginShape();
  vertex(0, height);
  vertex(50, height - 50);
  vertex(80, height - 114);
  vertex(158, height - 186);
  vertex(186, height - 278);
  vertex(224, height - 248);
  vertex(269, height - 229);
  vertex(356, height - 149);
  vertex(387, height - 135);
  vertex(510, height);
  endShape(CLOSE);
  
  // Adding snow to Mountain 1
  fill(255);
  beginShape();
  vertex(313, height - 189);
  vertex(301, height - 133);
  vertex(264, height - 172);
  vertex(238, height - 116);
  vertex(206, height - 194);
  vertex(166, height - 128);
  vertex(158, height - 186);
  vertex(186, height - 278);
  vertex(224, height - 248);
  vertex(269, height - 229);
  endShape(CLOSE);
  
    // Drawing Mountain 2
  fill(25);
  beginShape();
  vertex(510, height);
  vertex(442, height - 75);
  vertex(459, height - 92);
  vertex(510, height - 161);
  vertex(565, height - 206);
  vertex(585, height - 258);
  vertex(625, height - 304);
  vertex(656, height - 247);
  vertex(727, height - 194);
  vertex(752, height - 115);
  vertex(width, height);
  endShape(CLOSE);
  
  // Adding snow to Mountain 2
  fill(255);
  beginShape();
  vertex(538, height - 183);
  vertex(565, height - 206);
  vertex(585, height - 258);
  vertex(625, height - 304);
  vertex(656, height - 247);
  vertex(727, height - 194);
  vertex(713, height - 153);
  vertex(670, height - 202);
  vertex(652, height - 147);
  vertex(626, height - 183);
  vertex(604, height - 119);
  vertex(583, height - 182);
  vertex(539, height - 144);
  endShape(CLOSE);
  
  // Drawing Mountain 3
  fill(55);
  beginShape();
  vertex(442, height - 75);
  vertex(459, height - 92);
  vertex(510, height - 161);
  vertex(565, height - 206);
  vertex(585, height - 258);
  vertex(481, height - 373);
  vertex(443, height - 454);
  vertex(421, height - 444);
  vertex(410, height - 417);
  vertex(370, height - 379);
  vertex(340, height - 372);
  vertex(306, height - 314);
  vertex(224, height - 248);
  vertex(269, height - 229);
  vertex(356, height - 149);
  vertex(387, height - 135);
  vertex(442, height - 75);
  endShape(CLOSE);
  
  // Adding snow to Mountain 3
  fill(255);
  beginShape();
  vertex(481, height - 373);
  vertex(443, height - 454);
  vertex(421, height - 444);
  vertex(410, height - 417);
  vertex(370, height - 379);
  vertex(340, height - 372);
  vertex(326, height - 347);
  vertex(340, height - 306);
  vertex(380, height - 337);
  vertex(397, height - 273);
  vertex(441, height - 352);
  vertex(494, height - 272);
  vertex(519, height - 330);
  endShape(CLOSE);

  // Initializing the drawing of the animal which will be a polar bear.
  drawPolarBear(0);
}

void drawPolarBear(float x) {
  
  // Defining an array of vertices which will represent the points along the bear's
  // path up the mountains.
  float[][] mountainVertices = {
    {0, height}, {50, height - 50}, {80, height - 114}, {158, height - 186},
    {186, height - 278}, {224, height - 248}, {306, height - 314}, {326, height - 347},
    {340, height - 372}, {370, height - 379}, {410, height - 417}, {421, height - 444},
    {443, height - 454}, {481, height - 373}, {519, height - 330}, {585, height - 258},
    {625, height - 304}, {656, height - 247}, {727, height - 194}, {752, height - 115}, {width, height}
  };

  // Setting the bear's x-position equal to the x-coordinate of the mouse while keeping
  // the bear within the array of verticies previously defined.
  float bearX = mouseX;
  if (bearX < mountainVertices[0][0]) {
    bearX = mountainVertices[0][0];
  }
  if (bearX > mountainVertices[mountainVertices.length - 1][0]) {
    bearX = mountainVertices[mountainVertices.length - 1][0];
  }
  
  // In this little section, the goal is to find which two vertices to interpolate 
  // between based on the bear's x position.(The slope at which the bear moves 
  // will change depending on which two vertices it is between). I got help from
  // ChatGPT to figure out how to get the polar bear to move up and along the
  // mountain slopes.
  for (int i = 0; i < mountainVertices.length - 1; i++) {
    float[] p1 = mountainVertices[i];
    float[] p2 = mountainVertices[i + 1];
    if (bearX >= p1[0] && bearX <= p2[0]) {
      float t = (bearX - p1[0]) / (p2[0] - p1[0]);
      float bearY = lerp(p1[1], p2[1], t);      
      float bearCenter = bearX;
      
      // Calculate the point on the bear which I want to follow the slope of the
      // mountain. In this case it is half of the width of the bear.
      float bearWidth = 55.6 - 2.7;
      float bearOffset = bearWidth / 2;
      
      // Drawing the polar bear and making it follow the slopes up the mountain
      // spanning the whole width of the canvas. The number values in the vertex
      // functions are the same as when I drew the mountains. They get drawn and
      // then adjusted based on mouse position and slope of the mountain.
      fill(200);
      beginShape();
      vertex(bearCenter - bearOffset + 2.7, bearY);
      vertex(bearCenter - bearOffset, bearY - 4.0);
      vertex(bearCenter - bearOffset + 1.7, bearY - 20.5);
      vertex(bearCenter - bearOffset + 2.8, bearY - 33.6);
      vertex(bearCenter - bearOffset + 5.6, bearY - 33.5);
      vertex(bearCenter - bearOffset + 18.1, bearY - 39.7);
      vertex(bearCenter - bearOffset + 33.5, bearY - 38.4);
      vertex(bearCenter - bearOffset + 39.6, bearY - 40.4);
      vertex(bearCenter - bearOffset + 46.1, bearY - 37.5);
      vertex(bearCenter - bearOffset + 55.6, bearY - 36.2);
      vertex(bearCenter - bearOffset + 57.8, bearY - 36.8);
      vertex(bearCenter - bearOffset + 58.5, bearY - 34.1);
      vertex(bearCenter - bearOffset + 62.6, bearY - 30.0);
      vertex(bearCenter - bearOffset + 62.8, bearY - 28.1);
      vertex(bearCenter - bearOffset + 67.3, bearY - 23.5);
      vertex(bearCenter - bearOffset + 63.8, bearY - 21.0);
      vertex(bearCenter - bearOffset + 56.7, bearY - 22.0);
      vertex(bearCenter - bearOffset + 47.8, bearY - 21.4);
      vertex(bearCenter - bearOffset + 45.4, bearY - 14.0);
      vertex(bearCenter - bearOffset + 50.9, bearY - 7.4);
      vertex(bearCenter - bearOffset + 50.7, bearY - 2.8);
      vertex(bearCenter - bearOffset + 48.5, bearY - 0.2);
      vertex(bearCenter - bearOffset + 47.0, bearY - 0.7);
      vertex(bearCenter - bearOffset + 47.2, bearY - 4.8);
      vertex(bearCenter - bearOffset + 38.1, bearY - 9.3);
      vertex(bearCenter - bearOffset + 38.1, bearY - 11.3);
      vertex(bearCenter - bearOffset + 35.7, bearY - 9.0);
      vertex(bearCenter - bearOffset + 36.2, bearY - 2.6);
      vertex(bearCenter - bearOffset + 38.7, bearY - 1.9);
      vertex(bearCenter - bearOffset + 39.5, bearY);
      vertex(bearCenter - bearOffset + 32.8, bearY);
      vertex(bearCenter - bearOffset + 31.3, bearY - 1.7);
      vertex(bearCenter - bearOffset + 28.7, bearY - 9.9);
      vertex(bearCenter - bearOffset + 28.9, bearY - 16.4);
      vertex(bearCenter - bearOffset + 23.8, bearY - 15.6);
      vertex(bearCenter - bearOffset + 23.0, bearY - 3.2);
      vertex(bearCenter - bearOffset + 26.6, bearY - 0.5);
      vertex(bearCenter - bearOffset + 26.6, bearY);
      vertex(bearCenter - bearOffset + 20.2, bearY);
      vertex(bearCenter - bearOffset + 16.4, bearY - 5.2);
      vertex(bearCenter - bearOffset + 12.8, bearY - 12.4);
      vertex(bearCenter - bearOffset + 6.9, bearY - 4.0);
      vertex(bearCenter - bearOffset + 7.0, bearY - 3.1);
      vertex(bearCenter - bearOffset + 9.7, bearY - 1.7);
      vertex(bearCenter - bearOffset + 9.9, bearY);
      endShape(CLOSE);
    }
  }
}
