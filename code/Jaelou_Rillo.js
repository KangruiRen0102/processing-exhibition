// p5.js 代码，忠实还原 Processing 逻辑与绘制顺序

let bg;  // 原处理器中的 PImage bg
let img; // 原处理器中的 PImage img

// 用于控制浪的水平移动
let offset = 0;
let easing = 0.001;

// 时钟相关变量
let cx, cy;
let secondsRadius;
let minutesRadius;
let hoursRadius;
let clockDiameter;

function preload() {
  // 根据实际存放路径来写，如放在同级则写 "Sunset.jpg"
  // 如果放在 "upload" 文件夹下，就要写 "upload/Sunset.jpg"
  bg = loadImage("uploads/Sunset.jpg");
  img = loadImage("uploads/WaveOfKanagawa.png");
}

function setup() {
  createCanvas(1000, 800);
  
  // 在 setup 里对图片进行缩放，与原 Processing 代码中相同
  bg.resize(1000, 800);
  img.resize(1000, 800);

  // 定义钟表指针长度
  let radius = min(width, height) / 2;
  secondsRadius = radius * 0.42;
  minutesRadius = radius * 0.40;
  hoursRadius   = radius * 0.20;
  clockDiameter = radius * 1.8;

  // 计算钟心位置
  cx = width / 2;
  cy = height / 2;
}

function draw() {
  // 1) 用 bg 图片当背景
  //   这里直接在背景处铺满(0,0)，宽高都为 1000,800
  image(bg, 0, 0);

  // 2) 先在 (0,0) 位置画浪图一次
  image(img, 0, 0);

  // 3) 画“太阳”（其实是一个星形）的逻辑
  push();
    translate(width / 2 + 20, height / 2);
    rotate(frameCount / -250.0);
    fill(245, 245, 7);
    noStroke();
    star(0, 0, 150, 350, 20);
  pop();

  // 4) 根据当前时间映射到指针角度
  let s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  let m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI;
  let h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;

  // 绘制秒针
  stroke(140, 13, 8);
  strokeWeight(2);
  line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);

  // 绘制分针
  strokeWeight(4);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);

  // 绘制时针
  strokeWeight(6);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);

  // 5) 最后再次绘制浪图，但带有 offset
  //    这样浪会随鼠标左右移动，同时覆盖在太阳部分
  let dx = (mouseX - img.width / 2) - offset;
  offset += dx * easing;
  image(img, offset, 10);
}

// 与原 Processing 的 star() 函数对应
function star(x, y, radius1, radius2, npoints) {
  let angle = TWO_PI / npoints;
  let halfAngle = angle / 2.0;
  beginShape();
  for (let a = 0; a < TWO_PI; a += angle) {
    let sx = x + cos(a) * radius2;
    let sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a + halfAngle) * radius1;
    sy = y + sin(a + halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
