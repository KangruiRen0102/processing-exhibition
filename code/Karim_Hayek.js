function setup() {
  createCanvas(800, 600);
  noLoop(); // Stops the drawing from looping
}

function draw() {
  // Background
  background(30, 30, 60); // Dark blue representing the darkness of the situation

  // Draw the sea
  fill(20, 20, 50);
  rect(0, 300, 800, 300); // Sea 

  // Tsunami wave representing the struggles an engineer goes through and how helpless they can feel sometimes
  fill(10, 10, 40);
  beginShape();
  vertex(400, 300);
  vertex(800, 300);
  vertex(800, 100);
  bezierVertex(700, 50, 650, 30, 500, 100);
  bezierVertex(450, 120, 420, 140, 400, 180);
  endShape(CLOSE);

  fill(15, 15, 50);
  beginShape();
  vertex(450, 300);
  vertex(800, 300);
  vertex(800, 150);
  bezierVertex(700, 100, 600, 80, 450, 160);
  bezierVertex(430, 180, 440, 200, 450, 220);
  endShape(CLOSE);

  fill(20, 20, 60);
  beginShape();
  vertex(500, 300);
  vertex(800, 300);
  vertex(800, 200);
  bezierVertex(750, 150, 700, 130, 500, 180);
  endShape(CLOSE);

  // Island of hope behind the tsunami representing all the good things at the end of the journey that keep us moving forward
  fill(34, 139, 34); // Island 
  arc(700, 250, 100, 50, PI, TWO_PI); // Island shape

  // Hopeful light on the island that is often hard to see
  fill(255, 223, 0, 150); // Yellow transparent light
  noStroke();
  ellipse(700, 230, 120, 60);

  // Dark clouds representing the darkness and helplessness sometimes a student feels
  fill(50);
  ellipse(200, 100, 300, 80);
  ellipse(400, 80, 400, 100);
  ellipse(650, 120, 250, 70);

  // Boat
  fill(139, 69, 19); // Brown boat
  beginShape();
  vertex(300, 300);
  vertex(400, 300);
  vertex(370, 330);
  vertex(330, 330);
  endShape(CLOSE);

  // Sail
  fill(200);
  triangle(350, 300, 350, 220, 400, 300);

  // Person on the boat representing an engineering student in their journey
  fill(200, 150, 100);
  ellipse(360, 280, 20, 20); // Head
  fill(50);
  rect(355, 290, 10, 20); // Body

  // Dark atmosphere 
  noStroke();
  fill(0, 0, 30, 150);
  rect(0, 0, width, height);

  // Lightning bolt adding more theme to the art
  stroke(255, 255, 100);
  strokeWeight(3);
  line(600, 50, 620, 150);
  line(620, 150, 580, 200);
  line(580, 200, 600, 250);
}
