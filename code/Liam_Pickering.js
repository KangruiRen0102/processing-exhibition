// 类定义部分
// Rectangle 类用于绘制各种矩形实例，例如旅客、桥梁、河流等
class Rectangle {
  constructor(startX, startY, w, h, col) {
    this.x = startX;
    this.y = startY;
    this.width = w;
    this.height = h;
    this.c = col;
  }

  // 绘制矩形
  display() {
    fill(this.c);        // 填充颜色
    noStroke();          // 无边框
    rect(this.x, this.y, this.width, this.height); // 绘制矩形
  }

  // 处理移动逻辑（仅适用于 Traveller）
  move() {
    if (keyIsPressed) { // 检查是否有按键被按下
      if (keyCode === RIGHT_ARROW) {
        this.x += 3; // 向右移动
      } else if (keyCode === LEFT_ARROW) {
        this.x -= 3; // 向左移动
      } else if (keyCode === UP_ARROW) {
        this.y -= 3; // 向上移动
      } else if (keyCode === DOWN_ARROW) {
        this.y += 3; // 向下移动
      }

      // 约束 Traveller 的移动范围，模拟桥梁栏杆和河岸墙壁的阻挡
      if (this.x >= 390 && this.x <= 530 && this.y < 100 && this.y > 70) { // 桥梁部分
        this.y = constrain(this.y, 80, 120 - this.height);
      } else if (this.x < 420) { // 左侧墙壁
        this.x = constrain(this.x, 0, 420 - this.width);
        this.y = constrain(this.y, 0, 400 - this.height);
      } else if (this.x > 520) { // 右侧墙壁
        this.x = constrain(this.x, 531, 600 - this.width);
        this.y = constrain(this.y, 0, 400 - this.height);
      }

      // 当 Traveller 到达特定位置时改变其大小
      if (this.x >= 530 && this.x <= 580 && this.y >= 320 && this.y <= 350) { // 到达路径末端
        this.width = 40;
        this.height = 40;
      }
      if (this.x >= 400 && this.x <= 420 && this.y >= 70 && this.y <= 100) { // 到达桥梁
        this.width = 30;
        this.height = 30;
      }
    }
  }
}

// Circle 类用于绘制树木
class CircleShape { // 重命名为 CircleShape 避免与 p5.js 内置的 Circle 冲突
  constructor(startX, startY, r, col) {
    this.x = startX;
    this.y = startY;
    this.radius = r;
    this.c = col;
  }

  // 绘制圆形
  display() {
    fill(this.c); // 填充颜色
    stroke(50, 50, 0); // 设置边框颜色为深棕色
    ellipse(this.x, this.y, 2 * this.radius, 2 * this.radius); // 绘制圆形
  }
}

// 全局变量定义部分
let Traveller;
let Bridge;
let River;
let Rail1;
let Rail2;
let Wall1;
let Wall2;
let Wall3;
let Wall4;
let Path1;
let Path2;
let Path3;
let Path4;
let Path5;
let Path6;
let Path7;
let Finish1;
let Finish2;
let Finish3;
let Tree1;
let Tree2;
let Tree3;
let Tree4;
let Tree5;
let Tree6;
let Tree7;
let Tree8;
let Tree9;
let Tree10;

let allRect;
let allCirc;

// 设置函数
function setup() {
  createCanvas(600, 400);  // 创建画布
  background(0, 100, 0); // 设置背景颜色为草绿色

  // 创建 Rectangle 实例
  Traveller = new Rectangle(5, 320, 20, 20, color(150, 0, 0)); // 红色
  River = new Rectangle(450, 0, 50, height, color(0, 0, 150)); // 深蓝色
  Bridge = new Rectangle(425, 75, 100, 50, color(150, 75, 0)); // 棕色
  Rail1 = new Rectangle(420, 70, 110, 10, color(100, 75, 0)); // 深棕色
  Rail2 = new Rectangle(420, 120, 110, 10, color(100, 75, 0)); // 深棕色
  Wall1 = new Rectangle(420, 0, 10, 70, color(150, 150, 150)); // 灰色
  Wall2 = new Rectangle(520, 0, 10, 70, color(150, 150, 150)); // 灰色
  Wall3 = new Rectangle(420, 130, 10, height, color(150, 150, 150)); // 灰色
  Wall4 = new Rectangle(520, 130, 10, height, color(150, 150, 150)); // 灰色
  Path1 = new Rectangle(0, 300, 360, 60, color(50, 50, 0)); // 深棕色
  Path2 = new Rectangle(300, 180, 60, 120, color(50, 50, 0)); // 深棕色
  Path3 = new Rectangle(30, 180, 330, 60, color(50, 50, 0)); // 深棕色
  Path4 = new Rectangle(30, 70, 60, 110, color(50, 50, 0)); // 深棕色
  Path5 = new Rectangle(30, 70, 400, 60, color(50, 50, 0)); // 深棕色
  Path6 = new Rectangle(520, 70, 40, 60, color(50, 50, 0)); // 深棕色
  Path7 = new Rectangle(540, 70, 50, 250, color(50, 50, 0)); // 深棕色
  Finish1 = new Rectangle(540, 320, 50, 10, color(0, 0, 0)); // 黑色
  Finish2 = new Rectangle(540, 330, 50, 10, color(255, 255, 255)); // 白色
  Finish3 = new Rectangle(540, 340, 50, 10, color(0, 0, 0)); // 黑色

  // 创建 Circle 实例（树木）
  Tree1 = new CircleShape(565, 30, 25, color(0, 165, 0)); // 绿色
  Tree2 = new CircleShape(200, 150, 40, color(0, 160, 0)); // 绿色
  Tree3 = new CircleShape(125, 153, 20, color(0, 160, 0)); // 绿色
  Tree4 = new CircleShape(350, 50, 35, color(0, 160, 0)); // 绿色
  Tree5 = new CircleShape(20, 60, 50, color(0, 160, 0)); // 绿色
  Tree6 = new CircleShape(200, 30, 25, color(0, 160, 0)); // 绿色
  Tree7 = new CircleShape(395, 300, 45, color(0, 160, 0)); // 绿色
  Tree8 = new CircleShape(120, 275, 30, color(0, 160, 0)); // 绿色
  Tree9 = new CircleShape(240, 380, 25, color(0, 160, 0)); // 绿色
  Tree10 = new CircleShape(390, 160, 20, color(0, 160, 0)); // 绿色

  // 将 Rectangle 实例添加到 allRect 列表中，顺序决定绘制层级
  allRect = [];
  allRect.push(River); // 河流最底层
  allRect.push(Path1);
  allRect.push(Path2);
  allRect.push(Path3);
  allRect.push(Path4);
  allRect.push(Path5);
  allRect.push(Path6);
  allRect.push(Path7);
  allRect.push(Finish1);
  allRect.push(Finish2);
  allRect.push(Finish3);
  allRect.push(Bridge);
  allRect.push(Rail1);
  allRect.push(Rail2);
  allRect.push(Wall1);
  allRect.push(Wall2);
  allRect.push(Wall3);
  allRect.push(Wall4);
  allRect.push(Traveller); // Traveller 最上层

  // 将 Circle 实例添加到 allCirc 列表中，顺序无关
  allCirc = [];
  allCirc.push(Tree1);
  allCirc.push(Tree2);
  allCirc.push(Tree3);
  allCirc.push(Tree4);
  allCirc.push(Tree5);
  allCirc.push(Tree6);
  allCirc.push(Tree7);
  allCirc.push(Tree8);
  allCirc.push(Tree9);
  allCirc.push(Tree10);
}

// 显示消息的函数
function showMessage(message) {
  fill(0, 225, 200); // 设置文本颜色
  textSize(36); // 设置文本大小
  textAlign(CENTER, CENTER); // 设置文本对齐方式
  text(message, width / 2, height / 2); // 显示文本在画布中心
}

// 绘制函数
function draw() {
  background(0, 100, 0); // 绘制草地背景

  // 绘制所有 Rectangle 实例
  for (let rect of allRect) {
    rect.display();
  }

  // 绘制所有 Circle 实例
  for (let circ of allCirc) {
    circ.display();
  }

  // 处理 Traveller 的移动
  Traveller.move();

  // 检查 Traveller 是否到达终点，如果是，显示消息
  if (Traveller.x >= 530 && Traveller.x <= 580 && Traveller.y >= 320 && Traveller.y <= 350) {
    showMessage("A good journey produces growth.");
  }
}
