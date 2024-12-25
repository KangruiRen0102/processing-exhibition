let cols, rows;
let noiseMap;
let time = 0;

// In the setup function, we set up the canvas size and divide it into rows and columns 
// to create the noise map for the aurora borealis effect.
function setup() {
  createCanvas(800, 600);
  cols = floor(width / 5);
  rows = floor(height / 5);
  
  // Initialize the noiseMap as a 2D array
  noiseMap = Array.from({ length: cols }, () => Array(rows).fill(0));
  
  noStroke();
  smooth();
}

function draw() {
  background(0);
  
  // Generate the noise map to animate the aurora
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let xoff = map(i, 0, cols, 0, 5);
      let yoff = map(j, 0, rows, 0, 5);
      noiseMap[i][j] = noise(xoff, yoff, time);
    }
  }
  
  // Create the aurora effect by mapping noise values to green color and drawing small ellipses
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let n = noiseMap[i][j];
      if (n > 0.3) {
        let greenVal = map(n, 0.3, 1.0, 0, 255);
        fill(0, greenVal, 0, 150);
        ellipse(i * 5, j * 5, 3, 3);
      }
    }
  }
  
  // Increment time to animate the aurora
  time += 0.03;
  
  // Draw Mountain 1
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
  
  // Add snow to Mountain 1
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
  
  // Draw Mountain 2
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
  
  // Add snow to Mountain 2
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
  
  // Draw Mountain 3
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
  
  // Add snow to Mountain 3
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
  
  // Draw the polar bear
  drawPolarBear();
}

function drawPolarBear() {
  // Define the mountain vertices for the bear's path
  const mountainVertices = [
    [0, height], [50, height - 50], [80, height - 114], [158, height - 186],
    [186, height - 278], [224, height - 248], [306, height - 314], [326, height - 347],
    [340, height - 372], [370, height - 379], [410, height - 417], [421, height - 444],
    [443, height - 454], [481, height - 373], [519, height - 330], [585, height - 258],
    [625, height - 304], [656, height - 247], [727, height - 194], [752, height - 115], [width, height]
  ];

  // Set the bear's x-position based on the mouse, constrained within the mountain range
  let bearX = constrain(mouseX, mountainVertices[0][0], mountainVertices[mountainVertices.length - 1][0]);
  
  // Find the segment of the mountain where the bear is located
  let bearY = height;
  for (let i = 0; i < mountainVertices.length - 1; i++) {
    let [x1, y1] = mountainVertices[i];
    let [x2, y2] = mountainVertices[i + 1];
    if (bearX >= x1 && bearX <= x2) {
      let t = map(bearX, x1, x2, 0, 1);
      bearY = lerp(y1, y2, t);
      break;
    }
  }
  
  // Calculate the bear's position and dimensions
  let bearWidth = 55.6 - 2.7;
  let bearOffset = bearWidth / 2;
  let bearCenter = bearX;
  
  // Draw the polar bear following the mountain slope
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
