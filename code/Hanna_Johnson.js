function setup() {
    createCanvas(600, 200);
  
    // Draw background gradient
    let x1 = 0;
    let y1 = 0;
    let x2 = 600;
    let y2 = 0;
    let R1 = 45;
    let G1 = 30;
    let B1 = 81;
    
    for (let x = 0; x <= 200; x++) {
      stroke(R1, G1, B1);
      line(x1, y1, x2, y2);
      y1++;
      y2++;
      B1++;
    }
  
    // Draw stars
    stroke(255);
    strokeWeight(2);
    for (let i = 0; i < 50; i++) {
      let randomX = random(0, 600);
      let randomY = random(0, 200);
      point(randomX, randomY);
    }
  }
  
  function drawMoon() {
    stroke(200);
    fill(200);
    ellipseMode(CENTER);
    smooth();
    ellipse(60, 30, 15, 15);
  }
  
  function draw() {
    drawNorthernLights();
    drawBuilding();
    drawMoon();
  }
  
  function drawNorthernLights() {
    frameRate(8);
    strokeWeight(10);
    noFill();
    stroke(random(51, 170), random(51, 255), random(170, 255), 40);
    beginShape();
    vertex(random(0, 600), 0);
    curveVertex(0, 0);
    curveVertex(0, 0);
    curveVertex(150, 50);
    curveVertex(mouseX, mouseY);
    curveVertex(450, 150);
    curveVertex(600, 200);
    curveVertex(600, 200);
    endShape();
  }
  
  function drawBuilding() {
    strokeWeight(2);
    smooth();
  
    // Building 1
    stroke(35, 100);
    fill(35);
    rect(0, 100, 30, 100);
  
    // Building 2
    stroke(35);
    fill(35);
    rect(35, 80, 18, 120);
  
    // Building 3
    stroke(40);
    fill(40);
    rect(110, 50, 30, 150);
  
    // Building 4
    stroke(0);
    fill(0);
    rect(15, 120, 25, 80);
  
    // Building 5
    stroke(0);
    fill(0);
    rect(50, 103, 17, 97);
    rect(53, 100, 11, 100);
    rect(67, 170, 16, 30);
    rect(83, 130, 17, 70);
    rect(86, 127, 11, 73);
  
    // Muttart
    triangle(90, 200, 150, 200, 120, 160);
    triangle(125, 200, 165, 200, 145, 180);
  
    // Legislature
    rect(153, 140, 164, 60);
    rectMode(CENTER);
    rect(235, 140, 46, 8);
    rect(235, 140, 30, 20);
    rect(235, 140, 24, 38);
    ellipseMode(CENTER);
    ellipse(235, 121, 22, 20);
    rect(235, 140, 5, 65);
    ellipse(235, 107, 5, 5);
  
    // Peak residences
    stroke(35);
    fill(35);
    rectMode(CORNER);
    rect(320, 100, 21, 100);
    triangle(320, 100, 320, 90, 340, 100);
  
    // Building 6
    stroke(0);
    fill(0);
    rect(340, 85, 60, 115);
    rect(340, 100, 70, 100);
    rect(346, 80, 47, 120);
    rect(350, 76, 7, 123);
    rect(380, 76, 7, 123);
  
    // Building 7
    stroke(35);
    fill(35);
    rect(480, 90, 20, 110);
  
    // Bridge
    stroke(0);
    fill(0);
    rect(400, 193, 200, 7);
    noFill();
    arc(450, 185, 100, 40, PI, TWO_PI);
    line(400, 185, 500, 185);
    line(450, 165, 450, 185);
    line(443, 167, 443, 185);
    line(457, 167, 457, 185);
    line(436, 167, 436, 185);
    line(464, 167, 464, 185);
    line(471, 168, 471, 185);
    line(429, 168, 429, 185);
    line(478, 168, 478, 185);
    line(422, 168, 422, 185);
    line(485, 171, 485, 185);
    line(415, 171, 415, 185);
    line(492, 173, 492, 185);
    line(408, 173, 408, 185);
  
    // Epcor tower
    rect(495, 135, 45, 65);
    quad(496, 137, 505, 130, 530, 130, 539, 137);
    triangle(512, 130, 522, 130, 517, 125);
  
    // Church
    rect(545, 165, 35, 35);
    triangle(545, 165, 562.5, 150, 580, 165);
    rect(580, 120, 20, 80);
  }
  