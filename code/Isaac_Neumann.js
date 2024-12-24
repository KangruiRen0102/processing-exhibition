// -----------------------------
// 翻译自 Processing 代码到 p5.js
// -----------------------------

// ========== 全局变量 ==========
let buildingHeight = 100;  // 初始建筑高度
let buildingWidth = 200;   // 建筑宽度
let buildingX;             // 建筑左上角 X 坐标
let buildingY;             // 建筑左上角 Y 坐标

let windowWidth = 30;      // 窗宽
let windowHeight = 40;     // 窗高
let windowPadding = 20;    // 窗户之间及与边缘的间隔

let monthCount = 0;        // 计数器：记录月数
let maxMonths = 28;        // 最多月份限制

// 定义云的列表
let clouds = [];           // 用来存放多个云对象的数组

// ========== Cloud 云的类 (ES6 语法) ==========
class Cloud {
  constructor(x, y, size, speed) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
  }

  // 云从左往右移动，超出屏幕后回到左侧
  move() {
    this.x += this.speed;
    if (this.x > width) {
      this.x = -this.size;
    }
  }

  // 在画布上显示云
  display() {
    drawCloud(this.x, this.y, this.size);
  }
}

// ========== p5.js setup() 函数 ==========
function setup() {
  createCanvas(1200, 900);  // 创建画布大小
  noFill();                 // 默认无填充
  stroke(0);                // 设置描边颜色为黑色

  // 使建筑居中放置：X 位置居中，Y 位置放在底部上方
  buildingX = (width - buildingWidth) / 2;
  buildingY = height - 50;

  // 随机创建一些云
  for (let i = 0; i < 8; i++) {
    let cloudX = random(width);           // 随机 X 坐标
    let cloudY = random(50, 200);         // 随机 Y 坐标（保持在顶部区域）
    let cloudSize = random(50, 100);      // 随机云大小
    let cloudSpeed = random(0.2, 0.5);    // 随机云移动速度
    clouds.push(new Cloud(cloudX, cloudY, cloudSize, cloudSpeed));
  }
}

// ========== p5.js draw() 函数 ==========
function draw() {
  // 背景填充天蓝色
  background(135, 206, 235);

  // 移动并绘制所有云
  for (let c of clouds) {
    c.move();
    c.display();
  }

  // 按层绘制建筑物
  // 每层高度为 100，所以循环次数 = buildingHeight / 100
  for (let i = 0; i < buildingHeight / 100; i++) {
    let storyY = buildingY - (i * 100);

    // 绘制当前层（填充灰色）
    fill(150);
    rect(buildingX, storyY - 100, buildingWidth, 100);

    // 绘制当前层上的窗户
    drawWindows(storyY - 100);
  }

  // 绘制最下方的草地
  drawGrass();

  // 绘制右上角的月份显示
  drawMonthCounter();
}

// ========== 绘制窗户函数 ==========
function drawWindows(baseY) {
  fill(255); // 窗户颜色：白色

  // 计算所有窗户+间隔的总宽度
  let totalWindowWidth = 3 * windowWidth + 2 * windowPadding;
  // 将窗户整体在建筑层上水平居中
  let startX = buildingX + (buildingWidth - totalWindowWidth) / 2;

  // 每层画三扇窗
  for (let i = 0; i < 3; i++) {
    let windowX = startX + i * (windowWidth + windowPadding);
    let windowY = baseY + windowPadding;
    rect(windowX, windowY, windowWidth, windowHeight);
  }
}

// ========== 绘制单朵云（由3个椭圆组成） ==========
function drawCloud(x, y, size) {
  fill(255); // 云朵颜色：白色
  // 中心椭圆
  ellipse(x, y, size, size);
  // 右侧椭圆
  ellipse(x + size * 0.5, y - size * 0.25, size * 0.8, size * 0.8);
  // 左侧椭圆
  ellipse(x - size * 0.5, y - size * 0.25, size * 0.8, size * 0.8);
}

// ========== 绘制草地 ==========
function drawGrass() {
  fill(34, 139, 34);
  rect(0, height - 50, width, 50);
}

// ========== 绘制月份计数器（右上角） ==========
function drawMonthCounter() {
  fill(0);
  textSize(32);
  textAlign(RIGHT, TOP);
  text("Months: " + monthCount, width - 20, 20);
}

// ========== 鼠标点击事件，增加建筑楼层与月份 ==========
function mousePressed() {
  if (monthCount < maxMonths) {
    buildingHeight += 100; // 每点一次增加一层
    monthCount += 4;       // 记录过去了 4 个月
  }
}
