// ========== 全局变量 ==========
let backgroundImage;
let fragments = [];       // 相当于 MemoryFragment[] fragments; 
let numFragments = 50;    // 碎片数量

// ========== 预加载函数，p5.js 在程序开始前会先执行它 ==========
function preload() {
  // 用于加载图片等素材
  backgroundImage = loadImage("uploads/Background.jpg"); 
  // 注意：这里假设你的图片在 "upload/Background.jpg" 路径下
  // 如果路径不同，请自行修改。
}

// ========== 设置函数，只在初始化时运行一次 ==========
function setup() {
  createCanvas(700, 700); // 相当于 Processing 的 size(700, 700)

  // 初始化 MemoryFragment 数组
  for (let i = 0; i < numFragments; i++) {
    fragments[i] = new MemoryFragment();
  }
}

// ========== 主循环函数，每帧都会被调用 ==========
function draw() {
  // 先画背景图，让它铺满整个画面
  image(backgroundImage, 0, 0, width, height);

  // 更新并显示所有记忆碎片
  for (let fragment of fragments) {
    fragment.update();
    fragment.display();
  }
}

// ========== 鼠标移动事件 ==========
function mouseMoved() {
  // 当鼠标移动时，让所有碎片都被鼠标“吸引”
  for (let fragment of fragments) {
    fragment.attractToMouse();
  }
}

// ========== 鼠标按下事件 ==========
function mousePressed() {
  // 当鼠标被按下时，改变碎片尺寸/颜色
  for (let fragment of fragments) {
    fragment.changeSizeOnClick();
  }
}

// ========== MemoryFragment 类 ==========
class MemoryFragment {

  constructor() {
    // 随机初始位置
    this.x = random(width);
    this.y = random(height);
    // 碎片大小
    this.size = random(15, 30);
    // 向上漂浮的速度
    this.speed = random(0.5, 1.5);
    // 透明度
    this.alpha = random(100, 200);
    // 碎片颜色（此处可能需要自己改范围）
    this.fragmentColor = color(random(255, 255), random(150, 255), random(100, 150));
    // 吸引力强度
    this.attractionStrength = 1;
  }

  // --- 更新位置、透明度 ---
  update() {
    // 向上漂移
    this.y -= this.speed;
    // 逐渐淡出
    this.alpha -= 0.5;

    // 如果完全消失，则重置碎片
    if (this.alpha <= 0) {
      this.reset();
    }
  }

  // --- 重置碎片到初始状态 ---
  reset() {
    this.x = random(width);
    this.y = height + random(10);
    this.size = random(15, 30);
    this.speed = random(0.5, 1.5);
    this.alpha = random(100, 200);
  }

  // --- 显示碎片（此处以叶子形状绘制）---
  display() {
    noStroke();
    fill(this.fragmentColor, this.alpha);
    
    push();
    translate(this.x, this.y);
    // 让叶子做一个缓慢的旋转 (frameCount / 10)
    rotate(radians(frameCount / 10));

    beginShape();
      vertex(0, -this.size / 2);
      bezierVertex(-this.size / 3, -this.size, -this.size / 2, 0, 0, this.size / 2);
      bezierVertex(this.size / 2, 0, this.size / 3, -this.size, 0, -this.size / 2);
    endShape(CLOSE);

    pop();
  }

  // --- 被鼠标吸引 ---
  attractToMouse() {
    let distance = dist(this.x, this.y, mouseX, mouseY);
    // 如果在鼠标 200 像素范围内，就朝鼠标位置移动
    if (distance < 200) {
      let angle = atan2(mouseY - this.y, mouseX - this.x);
      this.x += cos(angle) * this.attractionStrength;
      this.y += sin(angle) * this.attractionStrength;
    }
  }

  // --- 点击时改变大小和颜色 ---
  changeSizeOnClick() {
    // 如果鼠标距离碎片中心足够近，就触发效果
    if (dist(mouseX, mouseY, this.x, this.y) < this.size) {
      this.size += 5;
      // 再次随机一个颜色
      this.fragmentColor = color(random(255, 255), random(150, 255), random(100, 150));
    }
  }
}
