// 项目: Mother and Child Journey - A hopeful night sky scene

let motherX, childX;        // 母亲和孩子的位置
let starX = [], starY = []; // 存储星星位置的数组
let numStars = 200;         // 夜空中的星星数量
let starsVisible = true;    // 星星是否可见
let starSpeed = 0.5;        // 星星移动速度（下落效果）

function setup() {
  createCanvas(800, 800);    // 创建800x800像素的方形画布
  
  motherX = width / 2;        // 母亲初始位置水平居中
  childX = motherX - 40;      // 孩子初始位置略偏左
  
  // 初始化星星的位置，位于画布上半部分
  for (let i = 0; i < numStars; i++) {
    starX[i] = random(width);          // 星星的随机X位置
    starY[i] = random(height / 2);     // 星星的随机Y位置（上半部分）
  }
}

function draw() {
  background(30, 30, 60); // 夜空：深蓝色背景
  
  if (starsVisible) {
    drawStars(); // 如果星星可见，绘制星星
  }
  
  drawMoon();           // 绘制月亮（右上角）
  drawMountainRange();  // 绘制山脉
  drawMotherAndChild(); // 绘制母亲和孩子
  drawPath();           // 绘制路径
  drawInstructions();   // 显示用户指示
}

// 绘制星星的函数
function drawStars() {
  fill(255, 255, 100); // 星星的柔和黄色光芒
  noStroke();
  for (let i = 0; i < numStars; i++) {
    ellipse(starX[i], starY[i], random(3, 6), random(3, 6)); // 星星大小随机
    starY[i] += starSpeed; // 星星以当前速度向下移动
    
    // 当星星下落超过画布上半部分时，重置到顶部并随机X位置
    if (starY[i] > height / 2) { 
      starY[i] = 0;                 // 重置到顶部
      starX[i] = random(width);     // 随机X位置
    }
  }
}

// 绘制月亮的函数
function drawMoon() {
  fill(255, 255, 200); // 淡黄色月亮
  ellipse(width - 100, 100, 80, 80); // 稍微偏离中心的月亮
}

// 绘制山脉的函数
function drawMountainRange() {
  fill(50, 50, 80); // 深灰蓝色
  noStroke();
  
  // 绘制多个不同的山脉，营造地平线效果
  triangle(50, height - 200, 150, height - 400, 250, height - 200);
  triangle(200, height - 200, 300, height - 350, 400, height - 200);
  triangle(350, height - 200, 450, height - 300, 550, height - 200);
  triangle(500, height - 200, 600, height - 400, 700, height - 200);
  triangle(650, height - 200, 750, height - 350, 850, height - 200); // 850超出画布宽度800，可以调整
}

// 绘制路径的函数
function drawPath() {
  stroke(200); // 柔和灰色
  line(0, height - 50, width, height - 50); // 绘制一条水平线作为路径
}

// 绘制母亲和孩子的函数
function drawMotherAndChild() {
  // 绘制母亲
  fill(150, 0, 150); // 紫色
  ellipse(motherX, height - 90, 50, 50);  // 头部
  rect(motherX - 15, height - 65, 30, 40); // 身体
  
  // 绘制孩子
  fill(0, 150, 150); // 青色
  ellipse(childX, height - 90, 30, 30);  // 头部
  rect(childX - 10, height - 65, 20, 30); // 身体
}

// 绘制用户指示的函数
function drawInstructions() {
  fill(255); // 白色文字
  textSize(12);
  text("Press SPACE to toggle stars on/off.", 10, height - 60); // 星星可见性
  text("Press UP/DOWN to adjust star speed.", 10, height - 40); // 调整速度
}

// 处理按键事件的函数
function keyPressed() {
  if (key === ' ') {
    starsVisible = !starsVisible; // 按空格键切换星星的显示与隐藏
  }
  
  if (keyCode === UP_ARROW) {
    starSpeed = min(5, starSpeed + 0.1); // 按上箭头增加星星速度，最大为5
  }
  
  if (keyCode === DOWN_ARROW) {
    starSpeed = max(0.1, starSpeed - 0.1); // 按下箭头减少星星速度，最小为0.1
  }
}
