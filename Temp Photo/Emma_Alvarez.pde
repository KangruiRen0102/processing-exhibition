
drop[] drops = new drop[75];
ArrayList<Flower> flowers = new ArrayList<Flower>();

void setup() {
  size(640, 360); 
  background(173, 216, 230); 
  for (int a = 0; a < drops.length; a++) {
    drops[a] = new drop();
  }
}

void draw() {
  background(173, 216, 230); 
  drawHills();

  for (Flower f : flowers) {
    f.display();
  }

  for (drop d : drops) {
    d.fall();
    d.show();
  }
}

void drawHills() {
  noStroke();
  fill(144, 238, 144);
  arc(-200, 400, 800, 600, PI, TWO_PI); 
  arc(440, 400, 800, 600, PI, TWO_PI); 


  fill(60, 179, 113);
  arc(0, 500, 700, 500, PI, TWO_PI);
  arc(500, 500, 700, 500, PI, TWO_PI); 
  
  fill(34, 139, 34);
  arc(-150, 600, 800, 700, PI, TWO_PI); 
  arc(500, 600, 800, 700, PI, TWO_PI);
}

void mousePressed() {
  
  flowers.add(new Flower(mouseX, mouseY));
}


class drop {
  float x = random(width); 
  float y = random(-500, -50); 
  float yrate = random(6, 7); 
  void fall() {
    y += yrate;
    if (y > height) {
      y = random(-500, -50);
      x = random(width);
    }
  }

  void show() {
    stroke(0, 0, 255);
    strokeWeight(1);
    line(x, y, x, y + 15);
  }
}

class Flower {
  float x, y;
  
  Flower(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    pushMatrix();
    translate(x, y);

   
    stroke(34, 139, 36);
    strokeWeight(3);
    line(0, 0, 0, 70);
    fill(0, 128, 0);
    noStroke();
    ellipse(-10, 20, 20, 10);
    ellipse(10, 20, 20, 10);

    fill(255,153,204); 
    for (int i = 0; i < 6; i++) {
      float angle = TWO_PI / 6 * i;
      float petalX = cos(angle) * 20;
      float petalY = sin(angle) * 20;
      ellipse(petalX, petalY, 20, 30);
    }

    fill(255, 255, 102); 
    ellipse(0, 0, 20, 20);

    popMatrix();
  }
}
