// =================== 全局变量 ===================
let images = [];       // 存放 MovableImage 对象
let bubbles = [];      // 存放 Bubble 对象
let stars = [];        // 存放 Star 对象
let isDragging = false; 
let draggedIndex = -1;

let hueValue = 0;      // 用于呈现彩色文字的 HSB 中的色相
let overlayImg;        // 覆盖图片（waves.png）
let oceanImg;          // 背景图片（ocean.jpg）

// 由于在 p5.js 中不建议在构造器里做 loadImage（异步），
// 因此我们先把所有需要的图片都在 preload() 里加载好，
// 然后在 setup() 里直接传递给 MovableImage 等对象使用。
let mouseImg1, mouseImg2, mouseImg3, mouseImg4; 
let pigImg, krillImg;

// =================== 预加载函数 ===================
function preload() {
  // 这里统一加上“upload/”前缀
  oceanImg   = loadImage("upload/ocean.jpg");
  overlayImg = loadImage("upload/waves.png");
  
  mouseImg1  = loadImage("upload/mouse 1.png");
  mouseImg2  = loadImage("upload/mouse 2.png");
  mouseImg3  = loadImage("upload/mouse 3.png");
  mouseImg4  = loadImage("upload/mouse 4.png");
  pigImg     = loadImage("upload/pig 1.png");
  krillImg   = loadImage("upload/krill.png");
}

// =================== 初始化 ===================
function setup() {
  createCanvas(800, 600);

  // images 数组共 62 个元素
  // 前 10 个用 mouseImg1
  for (let i = 0; i < 10; i++) {
    images[i] = new MovableImage(mouseImg1, width / 2, height / 2, 50);
  }
  // 接下来 10 个用 mouseImg2
  for (let i = 10; i < 20; i++) {
    images[i] = new MovableImage(mouseImg2, width / 2, height / 2, 50);
  }
  // 接下来 10 个用 mouseImg3
  for (let i = 20; i < 30; i++) {
    images[i] = new MovableImage(mouseImg3, width / 2, height / 2, 50);
  }
  // 接下来 10 个用 mouseImg4
  for (let i = 30; i < 40; i++) {
    images[i] = new MovableImage(mouseImg4, width / 2, height / 2, 50);
  }

  // 第 40 个放猪
  images[40] = new MovableImage(pigImg, width / 2, height / 2, 100);

  // 剩下的 21 个放磷虾
  for (let i = 41; i < 62; i++) {
    images[i] = new MovableImage(krillImg, width / 2, height / 2, 50);
  }

  // 设置文字大小、对齐方式及颜色模式
  textSize(32);
  textAlign(CENTER, CENTER);
  colorMode(HSB, 360, 100, 100);
}

// =================== 主循环 ===================
function draw() {
  // 先绘制背景：这里用 image 而不是 background
  image(oceanImg, 0, 0, width, height);
  
  // 让每个 MovableImage 自行更新位置并绘制
  for (let imgObj of images) {
    imgObj.update();
    imgObj.draw();
  }

  // 随机生成气泡（Bubble）
  if (random(1) < 0.1) {
    bubbles.push(new Bubble(random(width), height, random(10, 30)));
  }
  // 更新、绘制气泡
  for (let i = bubbles.length - 1; i >= 0; i--) {
    let b = bubbles[i];
    b.update();
    b.draw();
    if (!b.isVisible()) {
      bubbles.splice(i, 1);
    }
  }

  // 随机生成星星（Star）
  if (random(1) < 0.05) {
    stars.push(new Star(random(width), height, random(5, 15)));
  }
  // 更新、绘制星星
  for (let i = stars.length - 1; i >= 0; i--) {
    let s = stars[i];
    s.update();
    s.draw();
    if (!s.isVisible()) {
      stars.splice(i, 1);
    }
  }
  
  // 覆盖图层
  image(overlayImg, 400, 300, width, height);

  // 绘制文本（带阴影效果）
  // 先绘制几层白色文字，制造“描边”/“阴影”效果
  fill(255);
  text("Welcome to chaotic aquarium", width / 2 - 2, height / 2 - 2);
  text("Welcome to chaotic aquarium", width / 2 + 2, height / 2 - 2);
  text("Welcome to chaotic aquarium", width / 2 - 2, height / 2 + 2);
  text("Welcome to chaotic aquarium", width / 2 + 2, height / 2 + 2);
  
  // 再用 HSB 模式的 hueValue 来绘制彩色文本
  fill(hueValue, 100, 100);
  text("Welcome to chaotic aquarium", width / 2, height / 2);

  // 更新色相 hueValue
  hueValue += 1;
  if (hueValue > 360) {
    hueValue = 0;
  }
}

// =================== 鼠标事件 ===================
function mousePressed() {
  // 判断鼠标是否点中了某个图片
  for (let i = 0; i < images.length; i++) {
    if (images[i].isMouseOver(mouseX, mouseY)) {
      isDragging = true;
      draggedIndex = i;
      break;
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedIndex = -1;
}

function mouseDragged() {
  if (isDragging && draggedIndex !== -1) {
    images[draggedIndex].x = mouseX - images[draggedIndex].rad;
    images[draggedIndex].y = mouseY - images[draggedIndex].rad;
  }
}

// =================== MovableImage 类 ===================
class MovableImage {
  constructor(img, startX, startY, radius) {
    this.img = img;          // 注意，这里直接接收预先加载好的图像对象
    this.x = startX;
    this.y = startY;
    this.rad = radius;

    this.angleX = random(TWO_PI);
    this.angleY = random(TWO_PI);
    this.speedX = random(0.5, 1.5);
    this.speedY = random(0.5, 1.5);

    this.rotationAngle = 0;
    this.rotationSpeed = random(0.005, 0.02);
  }

  update() {
    // 如果没被拖拽就自己动
    if (!isDragging || draggedIndex !== images.indexOf(this)) {
      let vx = cos(this.angleX) * 2;
      let vy = sin(this.angleY) * 2;
      this.x += vx;
      this.y += vy;
      this.angleX += this.speedX * 0.01;
      this.angleY += this.speedY * 0.01;

      // 自转角度
      this.rotationAngle += this.rotationSpeed;

      // 碰到边界处理
      this.handleBoundaryCollision();
    }
  }

  draw() {
    push();
    translate(this.x + this.rad, this.y + this.rad);
    rotate(this.rotationAngle);
    imageMode(CENTER);
    image(this.img, 0, 0, this.rad * 2, this.rad * 2);
    pop();
  }

  handleBoundaryCollision() {
    // 左右边界
    if (this.x < 0 || this.x + this.rad * 2 > width) {
      this.angleX += PI;
      this.x = constrain(this.x, 0, width - this.rad * 2);
    }
    // 上下边界
    if (this.y < 0 || this.y + this.rad * 2 > height) {
      this.angleY += PI;
      this.y = constrain(this.y, 0, height - this.rad * 2);
    }
  }

  // 传进当前 mouseX, mouseY
  isMouseOver(mx, my) {
    let distance = dist(mx, my, this.x + this.rad, this.y + this.rad);
    return distance < this.rad;
  }
}

// =================== Bubble 类 ===================
class Bubble {
  constructor(startX, startY, radius) {
    this.x = startX;
    this.y = startY;
    this.rad = radius;
    this.vy = random(1, 4); // 泡泡上升速度
    this.alpha = 255;
  }

  update() {
    // 往上移动
    this.y -= this.vy;
    // 逐渐透明
    this.alpha -= 2;
  }

  draw() {
    noStroke();
    fill(255, 255, 140, this.alpha);
    ellipse(this.x, this.y, this.rad * 2, this.rad * 2);
  }

  isVisible() {
    return this.alpha > 0;
  }
}

// =================== Star 类 ===================
class Star {
  constructor(startX, startY, radius) {
    this.x = startX;
    this.y = startY;
    this.rad = radius;
    this.vy = random(1, 4); // 与气泡类似的上升速度
    this.alpha = 255;
    this.twinkleFactor = random(0.01, 0.05); // 闪烁速度
  }

  update() {
    this.y -= this.vy;
    this.alpha -= 2;
    // 简单的闪烁：半径做正弦震荡
    this.rad += this.twinkleFactor * sin(frameCount * 0.1);
  }

  draw() {
    noStroke();
    fill(0, 0, 140, this.alpha);
    this.drawStar(this.x, this.y, this.rad, this.rad / 2);
  }

  // 画五角星
  drawStar(x, y, outerRadius, innerRadius) {
    let angle = TWO_PI / 5;
    let halfAngle = angle / 2.0;
    beginShape();
    for (let a = 0; a < TWO_PI; a += angle) {
      let sx = x + cos(a) * outerRadius;
      let sy = y + sin(a) * outerRadius;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * innerRadius;
      sy = y + sin(a + halfAngle) * innerRadius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }

  isVisible() {
    return this.alpha > 0;
  }
}
