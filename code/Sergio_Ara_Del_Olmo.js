// 定义小船的 X 坐标和速度
let boat1X;
let boat1Speed = 2;

// 布尔值，用于鼠标点击改变背景颜色
let buttonClicked = false;

// 设置画布
function setup() {
  createCanvas(800, 600); // 画布大小
  background(0); // 初始背景为黑色

  // 小船初始位置
  boat1X = width - 300;
}

// 主绘图函数
function draw() {
  // 根据按钮状态切换背景颜色
  if (buttonClicked) {
    background(10, 180, 300); // 按下后背景变成蓝色
  } else {
    background(0); // 初始背景为黑色
  }

  // 调用各个绘图函数
  sun();
  sun2();
  barrier();
  drawOcean();
  drawSailboat(boat1X, height / 2 + 140);

  // 让小船的所有部分同时移动
  boat1X += boat1Speed;

  // 如果小船到达边界，反向移动
  if (boat1X > width - 100 || boat1X < 0) {
    boat1Speed *= -1;
  }
}

// 鼠标点击事件切换背景颜色
function mousePressed() {
  buttonClicked = !buttonClicked; // 反转布尔值
}

// 绘制太阳的光线
function sun() {
  stroke(255, 165, 0); // 橙黄色光线
  strokeWeight(10); // 光线宽度
  noFill();

  ellipse(width / 2, height / 2, 300, 300); // 第一层光圈
  ellipse(width / 2, height / 2, 500, 500); // 第二层光圈
  ellipse(width / 2, height / 2, 700, 700); // 第三层光圈
}

// 绘制太阳本体
function sun2() {
  stroke(255, 100, 0); // 深橙色轮廓
  fill(255, 0, 0); // 红色填充
  ellipse(width / 2, height / 2, 200, 200); // 太阳
}

// 绘制海洋
function drawOcean() {
  fill(0, 102, 204); // 海洋蓝色
  noStroke();
  rect(0, height / 2, width, height / 2); // 覆盖画布底部一半
}

// 绘制海洋和天空的分界线
function barrier() {
  stroke(128, 0, 200); // 紫色线条
  strokeWeight(15); // 线条宽度
  line(0, height / 2, width, height / 2); // 分界线
}

// 绘制帆船
function drawSailboat(boatX, boatY) {
  // 帆船的 X 和 Y 坐标，用于定位帆船组件
  let X = boatX + 100 / 2;
  let Y = boatY - 50;

  // 绘制船体
  fill(200, 0, 0); // 红色船体
  rect(boatX, boatY, 100, 30);

  // 绘制船桅
  stroke(139, 69, 19); // 棕色桅杆
  strokeWeight(4);
  line(X, Y + 50, X, Y - 40); // 桅杆从船体中心延伸

  // 绘制帆
  fill(255); // 白色帆
  noStroke();
  triangle(X, Y - 40, boatX, boatY - 40, boatX + 50, boatY - 40); // 三角形帆
}
