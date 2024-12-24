// =========== 全局变量 ===========

// 碎片数量
let numShards = 100; 
// 用于存放 Shard 实例的数组
let shards = []; 
// 用于存放记忆图片的数组
let memoryImages = [];
// 用于实现键盘缩放的变量
let zPos = 0;

function preload() {
  // 在 p5.js 中，loadImage() 通常放在 preload() 里统一加载
  // 假设图片路径与代码同级或放在 "upload/" 等文件夹下，请根据实际情况修改
  memoryImages[0] = loadImage("uploads/memory1.jpg");
  memoryImages[1] = loadImage("uploads/memory2.jpg");
  memoryImages[2] = loadImage("uploads/memory3.jpg");
  memoryImages[3] = loadImage("uploads/memory4.jpg");
  memoryImages[4] = loadImage("uploads/memory5.jpg");
}

function setup() {
  // 创建 800 x 800 的 3D 画布（WEBGL）
  createCanvas(800, 800, WEBGL);
  noStroke();       // 关闭描边
  // 如果需要更细腻的透明叠加，可尝试开启混合或设置其他渲染模式

  // 初始化碎片
  for (let i = 0; i < numShards; i++) {
    let angle = random(TWO_PI);         // 环绕Y轴的随机角度
    let radius = random(300, 500);      // 与中心轴的半径距离
    let heightVal = random(-500, 500);  // 在Y轴上的随机高度

    shards[i] = new Shard(
      createVector(radius * cos(angle), heightVal, radius * sin(angle)), 
      random(TWO_PI),                  // 初始旋转角
      random(50, 75),                  // 碎片大小
      memoryImages[floor(random(memoryImages.length))] // 随机挑选一张图片
    );
  }
}

function draw() {
  background(0);  // 背景填充黑色

  // p5.js 中可以使用内置的 lights() 来设置默认光源
  lights();

  // 将场景向 zPos 平移，以实现简单的“前进/后退”视觉效果
  translate(0, 0, zPos);

  // 在 p5.js 的 WEBGL 模式下，(0,0) 本来就在画布中心
  // 因此无需像 Processing 那样再额外 translate(width/2, height/2).

  // 让整个场景绕 Y 轴旋转，产生“环状旋转”效果
  rotateY(frameCount * 0.01);

  // 更新并绘制所有碎片
  for (let shard of shards) {
    shard.update();
    shard.display();
  }
}

// =========== 键盘控制 ===========
function keyPressed() {
  // 按 w/s 键进行前后移动
  if (key === 'w') {
    zPos += 50;  // 相当于“拉近”
  } else if (key === 's') {
    zPos -= 50;  // 相当于“拉远”
  }
}

// =========== Shard 类 ===========
class Shard {
  constructor(position, rotation, size, memoryImage) {
    this.position = position;     // PVector (x, y, z)
    this.rotation = rotation;     // 初始旋转角
    this.size = size;             // 碎片尺寸
    this.memoryImage = memoryImage; 
    this.vertices = [];           // 碎片多边形顶点

    // 随机生成多边形的顶点，只在构造时生成一次
    // 这里假设是一个五边形（vertices.length = 5）
    for (let i = 0; i < 5; i++) {
      this.vertices.push(createVector(
        random(-this.size, this.size),     // x
        random(-this.size, this.size),     // y
        random(-this.size / 5, this.size / 5)  // z（更薄一些）
      ));
    }
  }

  // 更新碎片的旋转等
  update() {
    this.rotation += 0.01; // 自旋转
  }

  // 显示碎片
  display() {
    push();

    // 平移到碎片的中心位置
    translate(this.position.x, this.position.y, this.position.z);

    // 绕自身坐标系进行旋转
    rotateX(this.rotation);
    rotateY(this.rotation * 0.5);
    rotateZ(this.rotation * 0.3);

    // 1) 绘制“玻璃状”碎片主体（多边形）
    fill(200, 200, 255, 150); // 带一些透明度
    beginShape();
    for (let v of this.vertices) {
      vertex(v.x, v.y, v.z);
    }
    endShape(CLOSE);

    // 2) 绘制“回忆图像”那面（作为一个四边形贴图）
    //   这里简单地画在 z=0 的平面上，大小是 size x size
    beginShape(QUADS);
    texture(this.memoryImage);

    // p5.js 中的 vertex 可以多带两个参数 (u, v) 表示贴图坐标
    vertex(-this.size / 2, -this.size / 2, 0, 0, 0);
    vertex( this.size / 2, -this.size / 2, 0, this.memoryImage.width, 0);
    vertex( this.size / 2,  this.size / 2, 0, this.memoryImage.width, this.memoryImage.height);
    vertex(-this.size / 2,  this.size / 2, 0, 0, this.memoryImage.height);

    endShape();
    pop();
  }
}
