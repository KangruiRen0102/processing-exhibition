// this section sets up sytems for later use
PFont f;  // font type varible

char letter;  
String words1 = "1:";  // the varible are defined here for use later
String words2 ="2:";
String dist = "Distance:";
String time ="Time:";
int mode = 1;
String loct1="";
String loct2="";


//This sectoin sets up the screen that will be displayed
void setup() {   
  size(930, 1150); // Set the canvas size
  noStroke(); // Remove borders from shapes
  
  
  printArray(PFont.list());  // selectiong font type and size
  f = createFont("Arial", 20);
  textFont(f); 
  textAlign(CENTER, CENTER);
  
}




//This section focuses on drawing the roads, towns and other map elements
//cirles are made from ellipes with a consistant radius
//to create diagonal roads, rectangles are rotated and then offset to the proper position


// This segement handles the creation of roads and cities
void draw() {
  background(165,215,0); // Set the background color
  


fill(255,0,0);   //compass
ellipse(750,150,100,100);
fill(165,215,0);
ellipse(750,150,97,97);
fill(255,0,0);  
rect(748.5,75,3,125);   
rect(700,148.5,100,3);
triangle(750,75,765,95,735,95);
  
  
  fill(255,255,0);   //Cal-Ed
  translate(110,-5);
  rotate(0.1428);
  rect(50,100,4,909);
  rotate(-0.1428);
  translate(-110,5);
 
  fill(0,255,225);   //Cal
  ellipse(20,1000,20,20);
  
  
  fill(255,255,0);  // Ed-Wain
  translate(149,103);
  rotate(-1.1358);
  rect(0,0,4,612);
  rotate(1.1358);
  translate(-149,-123);
  
  fill(0,255,225);  // Ed
  ellipse(149,123,20,20);
 
 fill(0);    //  Sask boarder
 rect(867,0,4,400);
 rect(867,550, 4, 390);
 
 
 fill(255,255,0);  // wain-con
 rect(696,376,4,348);
 
 fill(255,255,0); //Ed-Con
 rect(545,309,4,81);
 
  fill(0,255,255);    // Wain
 ellipse(696,376,20,20);
 
 fill(255,255,0);    //Ed-Con
 translate(545,390);
 rotate(-1.091);
 rect(0,0,4,175.5);
 rotate(1.091);
 translate(-545,-390);
  
 fill(255,255,0);  //Con-Cal
 rect(627,724, 69,4);
 rect(627,724,4,96);
 
 translate(440,780); //Con-cal
 rotate(-1.369);
 rect(0,0,4,195);
 rotate(1.369);
 translate(-440,-780);
  
  rect(190,777,251,4);
  rect(190,777,4,45);
  rect(72,820,120,4);
  rect(72,820,4,39);
  rect(39,855,33,4);
  
  fill(0,255,255);   // Con
 ellipse(696,724,20,20);
 
 
 fill(255,255,0);  // Cal-Wain
 rect(98,470,135,4);
 
 translate(230,471);
 rotate(-1.0191);
 rect(0,0,30,4);
 rotate(1.0191);
 translate(-230,-471);
 
 rect(244,445,318,4);
 rect(560,397,4,51);
 rect(627,341,4,89);
 
 fill(245,222,179);   // user interface box
 rect(620,940,320,320);
 fill(0);
 rect(620,940,320,4);
 rect(620,940,4,320);
  
//  This segement focuses on writng 

  int margin = 10;
  translate(margin*4, margin*4);

  
        fill(0,0,0); //town names
        text("EDMONTON",105,55);
        text("Wainwright", 670,305);
        text("Consort", 665, 705);
        text("Calgary", 20, 1000);
        
        
        fill(0);
        translate(827,435);
        rotate(-PI/2);
        text("Saskatchewan",0,0);
        rotate(PI/2);
        translate(-827,-435);
          
          
        text(words1, 650, 940, 200, 20);  //User inertface
        text(words2, 650, 980, 200, 20);
        text(dist, 650, 1020, 200, 20);
        text(time, 650, 1060, 200, 20);
        
       
        
        
        fill(255,0,0);  //Compass
        text("N", 710,40);
        
}



//   This secetion controls user intractivity

void keyTyped() {
   // The variable "key" always contains the value 
  // of the most recent key pressed.
  if ((key >= 'A' && key <= 'z') || key == ' ') {  //selection for specific keys
    letter = key;
    if (mode == 1){
      words1 = words1 + key;
      loct1 = loct1 + Character.toLowerCase(key);
    }
    if (mode == 2){
      words2 = words2 + key;
      loct2 = loct2 + Character.toLowerCase(key);
    }
    
   
    println(key);  
  }
  
  
  if (key == '1'){ // selecting which town you are typing
    mode = 1; 
    words1 ="1:";
    loct1="";
  } 
  if (key == '2'){
    mode = 2;
    words2 = "2:";
    loct2="";
  }
  
  if (key == '3'){    //requesting distance and travle time
   if (loct1.equals("consort")){
     if (loct2.equals("edmonton")){
       dist="Distance: 301 Km";
       time="Time: 3h 5m";
     }
     if (loct2.equals("wainwright")){
       dist="Distance: 100 Km";
       time="Time: 1h 2m";
     }
     if (loct2.equals("calgary")){
       dist="Distance: 356 Km";
       time="Time: 3h 35m";
     }
   }
   
   if (loct1.equals("edmonton")){
     if (loct2.equals("consort")){
       dist="Distance: 301 Km";
       time="Time: 3h 5m";
     }
     if (loct2.equals("wainwright")){
       dist="Distance: 206 Km";
       time="time: 2h 8m";
     }
     if (loct2.equals("calgary")){
       dist="Distance 300 Km";
       time="time: 2h 59m";
     }
   }
  
   if (loct1.equals("wainwright")){
     if (loct2.equals("consort")){
       dist="Distance: 100 Km";
       time="Time: 1h 2m";
     }
     if (loct2.equals("edmonton")){
       dist="Distance: 206 Km";
       time="time: 2h 8m";
     }
     if (loct2.equals("calgary")){
       dist="Distance: 419 Km";
       time="Time: 4h 12m";
     }
   }
   
   if (loct1.equals("calgary")){
     if (loct2.equals("consort")){
       dist="Distance: 356 Km";
       time="Time: 3h 35m";
     }
     if (loct2.equals("edmonton")){
        dist="Distance 300 Km";
       time="Time: 2h 59m";
     }
    
     if (loct2.equals("wainwright")){
       dist="Distance: 419 Km";
       time="Time: 4h 12m"; 
     }
     } 
  } 
    
}   
 
