//
//the code below sets the flowers and ripples as variables
ArrayList<Ripple> ripples;
ArrayList<Flower> flowers;

void setup() {
  size(800, 800);
  ripples = new ArrayList<Ripple>();
  flowers = new ArrayList<Flower>();
  frameRate(60);
}

void draw() {
  background(25, 25, 50); //amount of red, blue, and green to get the dark blue colour of the background

  for (int i = ripples.size() - 1; i >= 0; i--) {
    Ripple ripple = ripples.get(i);
    ripple.update();
    ripple.display();

    if (ripple.lifetime % 20 == 0 && ripple.lifetime > 0) {
      float angle = random(TWO_PI);
      float x = ripple.x + cos(angle) * ripple.radius;
      float y = ripple.y + sin(angle) * ripple.radius;
      flowers.add(new Flower(x, y, random(10, 30)));
      //the code above makes the flowers appear as the ripple expands
    }
    
    if (ripple.isDone()) {
      ripples.remove(i); //this removes the ripple after it expands enough
    }
  }

  for (Flower flower : flowers) {
    flower.display(); //displays the flowers created
  }
}

void mousePressed() {
  ripples.add(new Ripple(mouseX, mouseY));
}
//when the mouse is clicked, the above code makes the ripple effect start from where the click occured.

//the below code makes the ripple effect expand after it is made.
class Ripple {
  float x, y;
  float radius;
  float speed;
  int lifetime;

  Ripple(float x, float y) {
    this.x = x;
    this.y = y;
    this.radius = 0;
    this.speed = 2;
    this.lifetime = 0;
  }

  void update() {
    radius += speed;
    lifetime++;
  }

  void display() {
    noFill();
    stroke(255, 200, 100, 200 - lifetime * 2); // Gradually fade out
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
  }

  boolean isDone() {
    return lifetime > 100;
  }
}

//the below code makes the flower bloom (increase size) after they appear.
class Flower {
  float x, y;
  float size;
  float bloom;

  Flower(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.bloom = 0;
  }

//the code below makes the flowers bloom gradually.
  void display() {
    if (bloom < size) {
      bloom += 0.5;
    }

//the below code makes pink petals for the flowers, so they actually look like flowers :)
    pushMatrix();
    translate(x, y);
    for (int i = 0; i < 6; i++) {
      float angle = TWO_PI / 6 * i;
      float petalX = cos(angle) * bloom;
      float petalY = sin(angle) * bloom;
      noStroke();
      fill(250, 100, 150, 225);
      ellipse(petalX, petalY, bloom / 2, bloom);
    }
    popMatrix();

//this code makes a yellow point in the middle of the flower.
    noStroke();
    fill(255, 200, 50);
    ellipse(x, y, bloom / 3, bloom / 3);
  }
}
