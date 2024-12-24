// 全局变量
let buildingCount = 1; // 起始建筑数量
let peopleCount = 3;   // 起始人物数量
let skyState = 0;      // 天空状态：0 = 白天, 1 = 黄昏, 2 = 黎明, 3 = 黄昏, 4 = 夜晚
let clickCounter = 0;  // 点击计数器

function setup() {
  createCanvas(800, 400); // 创建画布
  noLoop(); // 停止连续绘图，只有通过用户交互才会重新绘制
}

function draw() {
  drawSky();       // 绘制天空背景
  drawBuildings(); // 根据建筑数量绘制建筑
  drawPeople();    // 绘制人物
  drawGround();    // 绘制地面
}

function drawSky() {
  // 根据 skyState 渲染天空背景渐变
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1); // 根据 y 坐标计算插值
    let c;

    // 根据当前天空状态设置渐变颜色
    if (skyState === 0) {
      c = lerpColor(color(135, 206, 235), color(25, 25, 112), inter); // 白天
    } else if (skyState === 1) {
      c = lerpColor(color(255, 140, 0), color(75, 0, 130), inter); // 黄昏
    } else if (skyState === 2) {
      c = lerpColor(color(255, 223, 186), color(255, 69, 0), inter); // 黎明
    } else if (skyState === 3) {
      c = lerpColor(color(72, 61, 139), color(25, 25, 112), inter); // 黄昏
    } else if (skyState === 4) {
      c = lerpColor(color(0, 0, 0), color(25, 25, 112), inter); // 夜晚
    }

    stroke(c);
    line(0, y, width, y); // 绘制水平线以创建渐变效果
  }

  // 添加天空细节：星星或云朵
  if (skyState === 1 || skyState === 3 || skyState === 4) {
    drawStars();
  } else {
    drawClouds();
  }
}

function drawStars() {
  // 在暗色天空中绘制星星
  for (let i = 0; i < 100; i++) {
    let x = random(width);
    let y = random(height);
    let size = random(1, 3);
    fill(255, 255, 255, 150);
    noStroke();
    ellipse(x, y, size, size);
  }
}

function drawClouds() {
  // 在白天或明亮天空中绘制云朵
  fill(255, 255, 255, 180);
  noStroke();

  let cloudCount = int(random(7, 15));
  for (let i = 0; i < cloudCount; i++) {
    let cloudX = random(width);
    let cloudY = random(height / 2);
    let cloudWidth = random(100, 250);
    let cloudHeight = random(50, 120);

    for (let j = 0; j < 6; j++) {
      let puffX = cloudX + random(-cloudWidth / 2, cloudWidth / 2);
      let puffY = cloudY + random(-cloudHeight / 2, cloudHeight / 2);
      ellipse(puffX, puffY, random(40, 80), random(40, 80));
    }
  }
}

function drawBuildings() {
  fill(0);
  noStroke();

  for (let i = 0; i < buildingCount; i++) {
    let buildingWidth = int(random(50, 100));
    let buildingHeight = int(random(150, 300));
    let x = int(random(width / 2, width - buildingWidth));
    rect(x, height - buildingHeight, buildingWidth, buildingHeight);
  }
}

function drawPeople() {
  fill(0);

  for (let i = 0; i < peopleCount; i++) {
    let x = random(50, width / 2 - 50);
    let bodyHeight = 40;
    let bodyWidth = 10;
    let headSize = 15;

    let groundY = height - 20;

    rect(x - bodyWidth / 2, groundY - bodyHeight, bodyWidth, bodyHeight);
    ellipse(x, groundY - bodyHeight - headSize / 2, headSize, headSize);
  }
}

function drawGround() {
  strokeWeight(50);
  stroke(0);
  line(0, height - 20, width, height - 20);
}

function mousePressed() {
  // 响应鼠标点击，更新场景
  skyState = (skyState + 1) % 5; // 切换天空状态
  peopleCount = min(peopleCount + 1, 10); // 增加人物数量，最大为 10

  clickCounter++;
  if (clickCounter % 3 === 0) {
    buildingCount = min(buildingCount + 1, 20); // 每点击三次增加建筑数量，最大为 20
  }

  redraw(); // 根据更新的参数重新绘制场景
}
