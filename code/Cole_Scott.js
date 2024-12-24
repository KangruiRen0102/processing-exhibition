let waveOffsets = [];
let waveSpeed = 0.02;
let numWaves = 10;

// Aurora
let auroraPoints = [];
let auroraLayers = 12;
let auroraSegments = 200;
let auroraSpeed = 0.002;

// Ship
let shipX, shipY;
let shipAmplitude = 20;   // 振幅
let WaveFrequency = 0.013; 
let shipBaseY;

// Stars
let stars = [];

function setup() {
  // 使用 WEBGL 以支持 rotateX 等 3D 变换
  createCanvas(1920, 1080, WEBGL);
  background(15, 20, 60);

  // 初始化波浪
  for (let i = 0; i < numWaves; i++) {
    waveOffsets[i] = random(1000);
  }

  // 初始化极光
  for (let i = 0; i < auroraLayers; i++) {
    auroraPoints[i] = [];
    for (let j = 0; j < auroraSegments; j++) {
      auroraPoints[i][j] = random(5, 300);
    }
  }

  // 初始化船的位置
  shipX = width / 2;
  shipBaseY = height / 1.3;

  // 生成星星
  for (let i = 0; i < 150; i++) {
    let starX = random(width);
    let starY = random(height / 1.5);
    let starSize = random(1, 3);
    stars.push(new Star(starX, starY, starSize));
  }
}

function draw() {
  // 在 WEBGL 模式下默认原点在画布中心，这里移动原点到左上角，便于和原 Processing 写法对应
  background(15, 20, 60);
  translate(-width / 2, -height / 2);

  // 先画海浪（加上 3D 旋转）
  push();
  rotateX(PI / 6);
  for (let i = 0; i < numWaves; i++) {
    drawWave(i);
  }
  pop();

  // 更新船位置（横向 lerp 跟随鼠标，纵向跟随正弦）
  shipX = lerp(shipX, mouseX, 0.025);
  shipY = shipBaseY + sin((shipX * WaveFrequency) + waveOffsets[0]) * shipAmplitude + 50;

  drawShip();
  drawStars();
  drawAurora();
  drawInstructions();
}

// 绘制所有星星
function drawStars() {
  for (let s of stars) {
    s.twinkle();
    s.display();
  }
}

// 绘制极光
function drawAurora() {
  noFill();
  push();
  rotateX(PI / 6);

  for (let i = 0; i < auroraLayers; i++) {
    // 紫到绿的渐变
    let startColor = color(100 + i * 30, 0, 255, 200);  
    let endColor   = color(0, 255, 100 + i * 20, 150);  
    let auroraColor = lerpColor(startColor, endColor, float(i) / float(auroraLayers));

    stroke(auroraColor);

    beginShape();
    for (let j = 0; j < auroraSegments; j++) {
      let x = map(j, 0, auroraSegments - 1, 0, width);
      let y = 100 
              + auroraPoints[i][j]
              + sin(j * 0.2 + frameCount * auroraSpeed) * 20
              + cos(j * 0.1 + frameCount * auroraSpeed) * 10;
      vertex(x, y);
    }
    endShape();
  }

  pop();
}

// 绘制海浪
function drawWave(i) {
  // 每个波的偏移
  let yOffset = i * 16 + height / 1.5;

  for (let x = 0; x < width; x++) {
    let waveY = yOffset + sin((x * WaveFrequency) + waveOffsets[i]) * 30;
    // 从浅蓝到深蓝的渐变
    let c1 = color(0, 50, 100);
    let c2 = color(0, 0, 50);
    let amt = map(yOffset, height / 1.5, height, 0, 1);
    let seaColor = lerpColor(c1, c2, amt);

    stroke(seaColor);
    line(x, waveY, x, height);
  }

  // 不断累加波的相位
  waveOffsets[i] += waveSpeed;
}

// 绘制船
function drawShip() {
  push();
  translate(shipX, shipY, 0);

  // 船体
  fill(139, 69, 19);
  stroke(0);
  beginShape();
  vertex(-40, 20, 0);
  vertex(40, 20, 0);
  vertex(60, -10, 0);
  vertex(-60, -10, 0);
  endShape(CLOSE);

  // 桅杆
  stroke(150, 75, 0);
  line(0, -60, 0, 0);
  drawSails();

  pop();
}

// 绘制船帆
function drawSails() {
  push();
  rotateZ(PI / 6);
  fill(255);
  beginShape();
  vertex(-5, -10, 0);
  vertex(-32, -55, 0);
  vertex(20, -50, 0);
  endShape(CLOSE);
  pop();
}

// 绘制提示文字
function drawInstructions() {
  fill(255);
  textSize(20);
  text("Move your ship with the cursor to explore the flowing aurora and sea!", 10, 20);
}

// 星星类
class Star {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.alpha = random(100, 255);
  }

  twinkle() {
    this.alpha += random(-5, 5);
    this.alpha = constrain(this.alpha, 100, 255);
  }

  display() {
    noStroke();
    fill(255, this.alpha);
    ellipse(this.x, this.y, this.size, this.size);
  }
}
