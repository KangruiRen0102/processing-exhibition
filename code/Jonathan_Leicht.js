let hours = 1;
let counter = 1;
let lineNum = 1;

// 全局变量赋予初始值

function setup() {
  createCanvas(1920, 1080); // 设置画布大小为1920x1080像素
  frameRate(10);             // 设置帧率为10帧每秒
  colorMode(RGB, 255, 255, 255, 255); // 设置颜色模式为RGB，并包含透明度
  background(0);             // 设置初始背景为黑色
  textAlign(LEFT, TOP);      // 设置文本对齐方式为左上角
  textSize(24);              // 设置默认文本大小
}

function draw() {
  // 处理背景颜色
  if ((counter % 2 === 0) && (hours === 9)) {
    // 当小时数为9且计数器为偶数时，背景颜色闪烁
    let bgColor = map(sin(millis() / 500), -1, 1, 0, 255); // 使用sin函数映射到0-255之间
    background(bgColor);
  } else {
    background(0); // 否则，背景保持黑色
  }

  // 绘制随机线条
  stroke(252, 15, 192, 40); // 紫色线条，带有透明度
  strokeWeight(1);           // 线条粗细为1
  for (let i = 0; i < lineNum; i++) {
    let x0 = random(width);
    let y0 = random(height);
    let x1 = random(width);
    let y1 = random(height);
    line(x0, y0, x1, y1);
  }

  // 根据计数器的奇偶性切换显示内容
  if (counter % 2 === 0) {
    // 显示学生和已花费的小时数

    // 显示 "Hours spent" 文本
    fill(255, 255, 255, 255); // 白色
    noStroke();
    textSize(24);
    text("Hours spent:", 40, 120);
    if (hours < 9 && hours > 0) {
      text(hours, 200, 120);
    } else if (hours === 9) {
      text("9+", 200, 120);
    }

    // 绘制学生形象
    noStroke();
    fill(150, 0, 150, 255); // 紫色，完全不透明
    // 绘制身体
    rect(width / 2 - 75, height / 2, 150, 300); // x, y, 宽度, 高度
    // 绘制头部
    ellipse(width / 2, height / 2 - 150, 150, 150); // x, y, 宽度, 高度

    // 绘制眼睛，亮度根据小时数动态变化
    let eyeBrightness = map(hours, 1, 9, 50, 255); // 将小时数映射到50到255之间
    fill(eyeBrightness); // 灰度填充，根据小时数调整亮度
    noStroke();
    circle(width / 2 - 40, height / 2 - 160, 30); // 左眼
    circle(width / 2 + 40, height / 2 - 160, 30); // 右眼

  } else {
    // 显示主页菜单

    // 设置线条数量为20
    lineNum = 20;

    // 显示指示文本
    fill(255, 255, 255, 255); // 白色
    textSize(64);
    noStroke();
    text("Click the mouse to see how it feels working on assignments", 40, 120);
    text("Then press a number from 1 to 9", 40, 200);
  }
}

// 处理鼠标点击事件，切换显示内容
function mouseClicked() {
  counter += 1;
}

// 处理键盘按下事件，设置小时数和线条数量
function keyPressed() {
  if (key >= '1' && key <= '9') {
    hours = int(key);       // 将字符数字转换为整数 (1-9)
    lineNum = hours * 50;   // 根据小时数设置线条数量
  }
}
