// 全局变量声明
let studentPosX, studentPosY;    // 学生（圆形）的当前位置
let initialStudentSize = 30;      // 学生的初始大小
let finalStudentSize = 40;        // 学生的目标大小
let initialColor;                  // 学生的初始颜色（黄色）
let finalColor;                    // 学生的目标颜色（蓝色）
let studentSpeedX = 2;             // 学生在X轴的移动速度
let studentSpeedY = 2;             // 学生在Y轴的移动速度
let growthRate = 0.1;              // 学生大小增长的速度

let cupPosX, cupPosY;              // 杯子的当前位置
let cupHeight = 0;                 // 杯子中水的高度
let knowledgeCup = true;           // 杯子是否正在填充

let particles = [];                // 存储粒子的数组
let particleSpeed = 0.1;           // 粒子的移动速度

let resetTimer = null;             // 场景重置的计时器

function setup() {
  createCanvas(399, 399);           // 创建画布大小为399x399像素
  RedoScene();                      // 初始化场景
  initialColor = color(255, 204, 0); // 学生的初始颜色（黄色）
  finalColor = color(0, 204, 255);   // 学生的目标颜色（蓝色）
}

function draw() {
  background(255);                   // 设置背景为白色

  // 更新并显示所有粒子
  for (let i = 0; i < particles.length; i++) {
    let p = particles[i];
    p.update();
    p.display();
  }

  // 设置杯子的位置
  cupPosX = width / 2 - 100;         // 水平居中（减去杯子宽度的一半）
  cupPosY = height - 200;            // 垂直位置位于画布底部

  // 绘制杯子
  fill(150, 75, 0, 100);              // 杯子的颜色（半透明棕色）
  noStroke();
  rect(cupPosX, cupPosY, 200, 200);   // 绘制杯子的矩形

  // 绘制杯子中的水
  fill(0, 0, 255, 150);               // 水的颜色（半透明蓝色）
  noStroke();
  rect(cupPosX, cupPosY + 200 - cupHeight, 200, cupHeight); // 绘制水的高度

  // 移动学生
  moveStudent();

  // 如果杯子正在填充，逐渐增加学生的大小
  if (knowledgeCup) {
    if (initialStudentSize < finalStudentSize) {
      initialStudentSize += growthRate; // 增加学生的大小
    }
  }

  // 根据杯子中水的高度，计算学生的颜色过渡
  let currentColor = lerpColor(initialColor, finalColor, cupHeight / 200); // 平滑的颜色过渡

  // 绘制学生（圆形）
  fill(currentColor);                 // 应用过渡后的颜色
  noStroke();
  ellipse(studentPosX, studentPosY, initialStudentSize, initialStudentSize); // 绘制学生

  // 如果杯子正在填充，逐渐增加水的高度
  if (knowledgeCup) {
    cupHeight += 0.5;                 // 增加水的高度
    if (cupHeight >= 200) {           // 当杯子满时
      knowledgeCup = false;           // 停止填充
      resetTimer = frameCount + 6;     // 设置在约100毫秒后重置场景（假设60fps）
    }
  }

  // 如果杯子已满并且计时器已到，重置场景
  if (!knowledgeCup && resetTimer !== null && frameCount >= resetTimer) {
    RedoScene();                      // 重置场景
    resetTimer = null;                // 重置计时器
  }

  // 以一定概率添加新的粒子到背景
  if (random(1) < 0.05) {              // 5%的概率
    particles.push(new Particle(random(width), random(height), random(-1, 1), random(-2, 2)));
  }
}

// 移动学生的函数
function moveStudent() {
  studentPosX += studentSpeedX;        // 更新学生在X轴的位置
  studentPosY += studentSpeedY;        // 更新学生在Y轴的位置

  // 如果学生碰到画布边缘，反转其移动方向
  if (studentPosX <= 0 || studentPosX >= width) {
    studentSpeedX *= -1;               // 反转X轴方向
  }
  if (studentPosY <= 0 || studentPosY >= height) {
    studentSpeedY *= -1;               // 反转Y轴方向
  }
}

// 重置场景的函数
function RedoScene() {
  studentPosX = width / 2;             // 将学生位置重置到画布中心
  studentPosY = height / 2;
  initialStudentSize = 30;             // 将学生大小重置为初始值
  cupHeight = 0;                        // 将杯子中的水高度重置为0
  knowledgeCup = true;                  // 开始再次填充杯子
  particles = [];                        // 清空粒子数组
}

// Particle 类：表示单个粒子的属性和行为
class Particle {
  constructor(x, y, speedX, speedY) {
    this.x = x;                       // 粒子在X轴的位置
    this.y = y;                       // 粒子在Y轴的位置
    this.speedX = speedX;             // 粒子在X轴的速度
    this.speedY = speedY;             // 粒子在Y轴的速度
    this.col = color(random(255), random(255), random(255), 100); // 粒子的颜色（半透明）
  }

  // 更新粒子的位置
  update() {
    this.x += this.speedX * particleSpeed; // 更新X轴位置
    this.y += this.speedY * particleSpeed; // 更新Y轴位置

    // 如果粒子超出画布边缘，则从另一侧重新出现
    if (this.x < 0) this.x = width;
    if (this.x > width) this.x = 0;
    if (this.y < 0) this.y = height;
    if (this.y > height) this.y = 0;
  }

  // 显示粒子
  display() {
    noStroke();
    fill(this.col);                     // 应用粒子的颜色
    ellipse(this.x, this.y, 4, 4);     // 绘制粒子为小圆点
  }
}
