#This block sets initial values, such as initial placements of the stars and 
#alpha values. The b and l variables control the alpha in the aurora and stars,
#while the k value control the color.
from collections import deque
history = deque(maxlen=200)
x=random(0,1000)
y=random(0,600)
x2=random(0,1000)
y2=random(0,600)
x3=random(0,1000)
y3=random(0,600)
x4=random(0,1000)
y4=random(0,600)
b=255.0
l=255.0
k=0.0

#size sets the size of the window, no stroke means the stars do not have an outline
#and the backgroun is set to black to represent the night sky.
def setup():
    size(1000, 600)
    noStroke()
    background(0)

#This creates vertexes and connects at certain angles to create stars.
#when the alpha value, b, reaches 0, the program stops until clicked on.
def star():
    global b
    b=b-2
    if b<2:
        b=0
        noLoop()
    c=color(b)
    
    angle = TWO_PI / 4
    halfAngle = angle / 2.0
    with beginClosedShape():
        a = 0
        while a < TWO_PI:
            sx = x + cos(a) * 25
            sy = y + sin(a) * 25
            vertex(sx, sy)
            sx = x + cos(a + halfAngle) * 5
            sy = y + sin(a + halfAngle) * 5
            vertex(sx, sy)
            a += angle
    with beginClosedShape():
        a = 0
        while a < TWO_PI:
            sx = x2 + cos(a) * 25
            sy = y2 + sin(a) * 25
            vertex(sx, sy)
            sx = x2 + cos(a + halfAngle) * 5
            sy = y2 + sin(a + halfAngle) * 5
            vertex(sx, sy)
            a += angle
    with beginClosedShape():
        a = 0
        while a < TWO_PI:
            sx = x3 + cos(a) * 25
            sy = y3 + sin(a) * 25
            vertex(sx, sy)
            sx = x3 + cos(a + halfAngle) * 5
            sy = y3 + sin(a + halfAngle) * 5
            vertex(sx, sy)
            a += angle
    with beginClosedShape():
        a = 0
        while a < TWO_PI:
            sx = x4 + cos(a) * 25
            sy = y4 + sin(a) * 25
            vertex(sx, sy)
            sx = x4 + cos(a + halfAngle) * 5
            sy = y4 + sin(a + halfAngle) * 5
            vertex(sx, sy)
            a += angle
    fill(c)
    
#g and h are the green and blue. l controls the alpha of the stars and aurora.
#Loads the mouse coordinates in an array, then creates a closing circle (elipse)
#that stays at those old mouse coordinates.
def aurora():
    global l
    l=l-2
    global k
    background(0)
    k=k+0.01
    g=abs(cos(k))*255+155
    h=abs(sin(k))*255+155
    fill(0,g,h,l)
    history.append((mouseX, mouseY))
    for i, (x, y) in enumerate(history):
        ellipse(x, y, i/4, i/4)

#this is the repeating loop that repeats the aurora and star function until stopped
def draw():
    aurora()
    star()
    
#when the mouse is pressed, the alpha values are reset, the stars are 
#randomized again and the program resumes its loop.
#when the alpha value reaches zero and the programs stops, this makes a 
#mouse press reset the program
def mousePressed():
    global x
    global y
    global x2
    global y2
    global x3
    global y3
    global x4
    global y4
    x=random(0,1000)
    y=random(0,600)
    x2=random(0,1000)
    y2=random(0,600)
    x3=random(0,1000)
    y3=random(0,600)
    x4=random(0,1000)
    y4=random(0,600)
    global b
    b=255.0
    global l
    l=255.0
    loop()
