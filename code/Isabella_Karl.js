let cols, rows;
let noiseMap;
let time = 0;
let mountainVertices = [];
let bearWidth = 55.6 - 2.7;

function setup() {
  createCanvas(800, 600);
  cols = floor(width / 5);
  rows = floor(height / 5);
  noiseMap = Array.from({ length: cols }, () => Array(rows).fill(0));
  noStroke();
  smooth();

  // 定义山脉的顶点
  mountainVertices = [
    [0, height], [50, height - 50], [80, height - 114], [158, height - 186],
    [186, height - 278], [224, height - 248], [306, height - 314], [326, height - 347],
    [340, height - 372], [370, height - 379], [410, height - 417], [421, height - 444],
    [443, height - 454], [481, height - 373], [519, height - 330], [585, height - 258],
    [625, height - 304], [656, height - 247], [727, height - 194], [752, height - 115], [width, height]
  ];
}

function draw() {
  background(0);

  // 生成噪声地图
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let xoff = map(i, 0, cols, 0, 5);
      let yoff = map(j, 0, rows, 0, 5);
      noiseMap[i][j] = noise(xoff, yoff, time);
    }
  }

  // 绘制极光
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let n = noiseMap[i][j];
      if (n > 0.3) {
        let green = map(n, 0.3, 1.0, 0, 255);
        fill(0, green, 0, 150);
        ellipse(i * 5, j * 5, 3, 3);
      }
    }
  }

  // 动画时间增量
  time += 0.03;

  // 绘制山脉
  drawMountains();

  // 绘制北极熊
  drawPolarBear();
}

// 绘制山脉和雪
function drawMountains() {
  // 山脉1
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

  // 山脉2
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
}

// 绘制北极熊
function drawPolarBear() {
  let bearX = constrain(mouseX, mountainVertices[0][0], mountainVertices[mountainVertices.length - 1][0]);
  
  for (let i = 0; i < mountainVertices.length - 1; i++) {
    let p1 = mountainVertices[i];
    let p2 = mountainVertices[i + 1];
    if (bearX >= p1[0] && bearX <= p2[0]) {
      let t = (bearX - p1[0]) / (p2[0] - p1[0]);
      let bearY = lerp(p1[1], p2[1], t);
      let bearOffset = bearWidth / 2;

      // 绘制北极熊
      fill(200);
      beginShape();
      vertex(bearX - bearOffset + 2.7, bearY);
      vertex(bearX - bearOffset, bearY - 4.0);
      vertex(bearX - bearOffset + 1.7, bearY - 20.5);
      vertex(bearX - bearOffset + 2.8, bearY - 33.6);
      vertex(bearX - bearOffset + 5.6, bearY - 33.5);
      vertex(bearX - bearOffset + 18.1, bearY - 39.7);
      vertex(bearX - bearOffset + 33.5, bearY - 38.4);
      vertex(bearX - bearOffset + 39.6, bearY - 40.4);
      vertex(bearX - bearOffset + 46.1, bearY - 37.5);
      vertex(bearX - bearOffset + 55.6, bearY - 36.2);
      vertex(bearX - bearOffset + 57.8, bearY - 36.8);
      vertex(bearX - bearOffset + 58.5, bearY - 34.1);
      vertex(bearX - bearOffset + 62.6, bearY - 30.0);
      vertex(bearX - bearOffset + 62.8, bearY - 28.1);
      vertex(bearX - bearOffset + 67.3, bearY - 23.5);
      vertex(bearX - bearOffset + 63.8, bearY - 21.0);
      vertex(bearX - bearOffset + 56.7, bearY - 22.0);
      vertex(bearX - bearOffset + 47.8, bearY - 21.4);
      vertex(bearX - bearOffset + 45.4, bearY - 14.0);
      vertex(bearX - bearOffset + 50.9, bearY - 7.4);
      vertex(bearX - bearOffset + 50.7, bearY - 2.8);
      vertex(bearX - bearOffset + 48.5, bearY - 0.2);
      vertex(bearX - bearOffset + 47.0, bearY - 0.7);
      vertex(bearX - bearOffset + 47.2, bearY - 4.8);
      vertex(bearX - bearOffset + 38.1, bearY - 9.3);
      vertex(bearX - bearOffset + 38.1, bearY - 11.3);
      vertex(bearX - bearOffset + 35.7, bearY - 9.0);
      vertex(bearX - bearOffset + 36.2, bearY - 2.6);
      vertex(bearX - bearOffset + 38.7, bearY - 1.9);
      vertex(bearX - bearOffset + 39.5, bearY);
      vertex(bearX - bearOffset + 32.8, bearY);
      vertex(bearX - bearOffset + 31.3, bearY - 1.7);
      vertex(bearX - bearOffset + 28.7, bearY - 9.9);
      vertex(bearX - bearOffset + 28.9, bearY - 16.4);
      vertex(bearX - bearOffset + 23.8, bearY - 15.6);
      vertex(bearX - bearOffset + 23.0, bearY - 3.2);
      vertex(bearX - bearOffset + 26.6, bearY - 0.5);
      vertex(bearX - bearOffset + 26.6, bearY);
      vertex(bearX - bearOffset + 20.2, bearY);
      vertex(bearX - bearOffset + 16.4, bearY - 5.2);
      vertex(bearX - bearOffset + 12.8, bearY - 12.4);
      vertex(bearX - bearOffset + 6.9, bearY - 4.0);
      vertex(bearX - bearOffset + 7.0, bearY - 3.1);
      vertex(bearX - bearOffset + 9.7, bearY - 1.7);
      vertex(bearX - bearOffset + 9.9, bearY);
      endShape(CLOSE);
      break;
    }
  }
}
