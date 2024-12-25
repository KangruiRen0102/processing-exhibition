"""
Use the scroll wheel to move the hands of the clock.
The background color will change according to the clock.

NOTE: The minute hand has a very fast velocity due to the clock being realistically
scaled and cannot be properly observed.
It is advised to lower the angular_velcoity value to have a better visualization
of the minute hand.
"""

# Angle variables
hour_angle = 0
minute_angle = 0
second_angle = 0
day_night_angle = 0
angle_velocity = 0.5 # changing this value will change the velocity of the hands

# Window setup
def setup():
    size(500, 500)
    smooth()
    noStroke()

# Draws the background and clock
def draw():
    global hour_angle, minute_angle, second_angle, day_night_angle
    
    day_night_int = ((cos(day_night_angle) + 1) / 2) # Based on the angle of the hour hand, a number is assigned to this variable
    background_color = lerpColor(color(0, 2, 61), color(220, 220, 255), day_night_int) # The background color will change depending on the angle of hour hand
    background(background_color)
    
    translate(width / 2, height / 2)  # Move the origin to the center
    
    # Clock
    fill(50) # Gray
    ellipse(0, 0, 300, 300)
    
    # Hour ticks
    fill(255) # White
    for i in range(12): # Creates 12 ticks for the 12 hours in a clock evenly spaced in a circle
        pushMatrix()
        rotate((PI*2) / 12 * i)
        rect(140, -2, 10, 4)
        popMatrix()
    
    # Draw Clock Hands
    # Second Hand
    stroke(255, 0, 0) # Red
    strokeWeight(1) # Line thickness
    line(0, 0, 100 * cos(second_angle - (PI/2)), 100 * sin(second_angle - (PI/2)))
    
    # Minute Hand
    stroke(255) # White
    strokeWeight(3) # Line thickness
    line(0, 0, 80 * cos(minute_angle - HALF_PI), 80 * sin(minute_angle - HALF_PI))
    
    # Hour Hand
    stroke(255) # White
    strokeWeight(5) # Line thickness
    line(0, 0, 60 * cos(hour_angle - HALF_PI), 60 * sin(hour_angle - HALF_PI))
    
    # Center Point
    noStroke()
    fill(255) # White
    ellipse(0, 0, 10, 10)
    
    
# Gets values based on scroll wheel where positive and negative scroll is stored as
# an integer
# This value is stored in a scroll variable and is then added to the angle variables
# day_night_angle is dependent on hour_angle / 2 to make sure background color is 
# consistent with regular day-night cycle
def mouseWheel(scrolled):
    global hour_angle, minute_angle, second_angle, day_night_angle, angle_velocity
    
    scroll = scrolled.getCount()  # Gets a value from scroll which can be negative or positive
    hour_angle += scroll * (angle_velocity / 12)  # Adds scroll value mulitplied by angle_velocity divided by 12 due to moving 1/12th of a single minute rotation
    minute_angle += scroll * angle_velocity  # Adds scroll value mulitplied by angle_velocity
    second_angle += scroll * (angle_velocity * 60)  # Adds scroll value mulitplied by angle_velocity multiplied by 60 due to moving 60 times of a single minute rotation
    day_night_angle = hour_angle / 2
