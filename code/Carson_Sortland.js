let f;
let letter;
let words1 = "1:";
let words2 = "2:";
let dist = "Distance:";
let time = "Time:";
let mode = 1;
let loct1 = "";
let loct2 = "";

function setup() {
  createCanvas(930, 1150);
  noStroke();

  textFont("Arial", 20);
  textAlign(CENTER, CENTER);
}

function draw() {
  background(165, 215, 0);

  // Compass
  fill(255, 0, 0);
  ellipse(750, 150, 100, 100);
  fill(165, 215, 0);
  ellipse(750, 150, 97, 97);
  fill(255, 0, 0);
  rect(748.5, 75, 3, 125);
  rect(700, 148.5, 100, 3);
  triangle(750, 75, 765, 95, 735, 95);

  // Roads and towns
  fill(255, 255, 0); // Cal-Ed
  push();
  translate(110, -5);
  rotate(0.1428);
  rect(50, 100, 4, 909);
  pop();

  fill(0, 255, 225); // Cal
  ellipse(20, 1000, 20, 20);

  fill(255, 255, 0); // Ed-Wain
  push();
  translate(149, 103);
  rotate(-1.1358);
  rect(0, 0, 4, 612);
  pop();

  fill(0, 255, 225); // Ed
  ellipse(149, 123, 20, 20);

  fill(0); // Sask border
  rect(867, 0, 4, 400);
  rect(867, 550, 4, 390);

  fill(255, 255, 0); // Wain-Con
  rect(696, 376, 4, 348);

  fill(0, 255, 255); // Wain
  ellipse(696, 376, 20, 20);

  fill(255, 255, 0); // Ed-Con
  push();
  translate(545, 390);
  rotate(-1.091);
  rect(0, 0, 4, 175.5);
  pop();

  fill(255, 255, 0); // Con-Cal
  rect(627, 724, 69, 4);
  rect(627, 724, 4, 96);
  push();
  translate(440, 780);
  rotate(-1.369);
  rect(0, 0, 4, 195);
  pop();
  rect(190, 777, 251, 4);
  rect(190, 777, 4, 45);
  rect(72, 820, 120, 4);
  rect(72, 820, 4, 39);
  rect(39, 855, 33, 4);

  fill(0, 255, 255); // Con
  ellipse(696, 724, 20, 20);

  fill(255, 255, 0); // Cal-Wain
  rect(98, 470, 135, 4);
  push();
  translate(230, 471);
  rotate(-1.0191);
  rect(0, 0, 30, 4);
  pop();
  rect(244, 445, 318, 4);
  rect(560, 397, 4, 51);
  rect(627, 341, 4, 89);

  // User interface box
  fill(245, 222, 179);
  rect(620, 940, 320, 320);
  fill(0);
  rect(620, 940, 320, 4);
  rect(620, 940, 4, 320);

  // Text
  textAlign(LEFT, TOP);
  fill(0);
  text("EDMONTON", 105, 55);
  text("Wainwright", 670, 305);
  text("Consort", 665, 705);
  text("Calgary", 20, 1000);

  push();
  translate(827, 435);
  rotate(-PI / 2);
  text("Saskatchewan", 0, 0);
  pop();

  text(words1, 650, 940, 200, 20);
  text(words2, 650, 980, 200, 20);
  text(dist, 650, 1020, 200, 20);
  text(time, 650, 1060, 200, 20);

  fill(255, 0, 0);
  text("N", 710, 40);
}

function keyTyped() {
  if ((key >= 'A' && key <= 'z') || key === ' ') {
    letter = key;
    if (mode === 1) {
      words1 += key;
      loct1 += key.toLowerCase();
    }
    if (mode === 2) {
      words2 += key;
      loct2 += key.toLowerCase();
    }
  }

  if (key === '1') {
    mode = 1;
    words1 = "1:";
    loct1 = "";
  }

  if (key === '2') {
    mode = 2;
    words2 = "2:";
    loct2 = "";
  }

  if (key === '3') {
    calculateDistance();
  }
}

function calculateDistance() {
  if (loct1 === "consort") {
    if (loct2 === "edmonton") {
      dist = "Distance: 301 Km";
      time = "Time: 3h 5m";
    } else if (loct2 === "wainwright") {
      dist = "Distance: 100 Km";
      time = "Time: 1h 2m";
    } else if (loct2 === "calgary") {
      dist = "Distance: 356 Km";
      time = "Time: 3h 35m";
    }
  } else if (loct1 === "edmonton") {
    if (loct2 === "consort") {
      dist = "Distance: 301 Km";
      time = "Time: 3h 5m";
    } else if (loct2 === "wainwright") {
      dist = "Distance: 206 Km";
      time = "Time: 2h 8m";
    } else if (loct2 === "calgary") {
      dist = "Distance: 300 Km";
      time = "Time: 2h 59m";
    }
  } else if (loct1 === "wainwright") {
    if (loct2 === "consort") {
      dist = "Distance: 100 Km";
      time = "Time: 1h 2m";
    } else if (loct2 === "edmonton") {
      dist = "Distance: 206 Km";
      time = "Time: 2h 8m";
    } else if (loct2 === "calgary") {
      dist = "Distance: 419 Km";
      time = "Time: 4h 12m";
    }
  } else if (loct1 === "calgary") {
    if (loct2 === "consort") {
      dist = "Distance: 356 Km";
      time = "Time: 3h 35m";
    } else if (loct2 === "edmonton") {
      dist = "Distance: 300 Km";
      time = "Time: 2h 59m";
    } else if (loct2 === "wainwright") {
      dist = "Distance: 419 Km";
      time = "Time: 4h 12m";
    }
  }
}
