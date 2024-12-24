class Building {
    constructor(x, y, w, h, c) {
      this.x = x
      this.y = y
      this.width = w
      this.height = h
      this.buildingColor = c
      this.isHovered = false
      this.isRebuilding = false
      this.rebuildProgress = 1.0
    }
  
    display() {
      if (this.isRebuilding) {
        this.rebuildProgress += 0.005
        if (this.rebuildProgress === 0.0) {
          this.buildingColor = color(random(50, 200), random(50, 200), random(50, 200))
          while (this.buildingColor === color(34, 139, 34)) {
            this.buildingColor = color(random(50, 200), random(50, 200), random(50, 200))
          }
        }
        if (this.rebuildProgress >= 1.0) {
          this.rebuildProgress = 1.0
          this.isRebuilding = false
        }
      }
      let currentHeight = this.height * this.rebuildProgress
      fill(this.isHovered ? color(255, 150, 150) : this.buildingColor)
      rect(this.x, this.y + this.height - currentHeight, this.width, currentHeight)
      fill(255, 255, 200)
      let windowSize = 15
      let gap = 10
      let floorHeight = 2 * (windowSize + gap)
      for (let wx = this.x + gap; wx < this.x + this.width - gap; wx += windowSize + gap) {
        for (let wy = this.y + this.height - currentHeight + floorHeight; wy < this.y + this.height - gap - floorHeight; wy += windowSize + gap) {
          rect(wx, wy, windowSize, windowSize)
        }
      }
    }
  
    contains(px, py) {
      return px > this.x && px < this.x + this.width &&
             py > this.y + this.height - this.height * this.rebuildProgress &&
             py < this.y + this.height
    }
  
    breakDown() {
      this.isRebuilding = true
      this.rebuildProgress = 0.0
      this.buildingColor = color(random(50, 200), random(50, 200), random(50, 200))
      while (this.buildingColor === color(34, 139, 34)) {
        this.buildingColor = color(random(50, 200), random(50, 200), random(50, 200))
      }
    }
  }
  
  class Sky {
    constructor(dayColor, nightColor) {
      this.dayColor = dayColor
      this.nightColor = nightColor
      this.transitionFactor = 0.0
    }
  
    update(factor) {
      this.transitionFactor = constrain(factor, 0.0, 1.0)
    }
  
    display(isDay) {
      let currentColor = isDay ? this.dayColor : this.nightColor
      background(currentColor)
    }
  }
  
  class CelestialBody {
    constructor(x, y, r, c) {
      this.x = x
      this.y = y
      this.radius = r
      this.bodyColor = c
    }
  
    update(time, isDay) {
      this.x = map(time, 0, 1, -this.radius, width + this.radius)
      let peakHeight = height / 4
      let a = -4 * peakHeight / pow(width + 2 * this.radius, 2)
      this.y = -a * pow(this.x - width / 2, 2) + peakHeight
      this.bodyColor = isDay ? color(255, 204, 0) : color(200)
    }
  
    display() {
      fill(this.bodyColor)
      noStroke()
      ellipse(this.x, this.y, this.radius, this.radius)
    }
  }
  
  class River {
    constructor(x, y, w, h, c) {
      this.x = x
      this.y = y
      this.width = w
      this.height = h
      this.riverColor = c
      this.flowOffset = 0
    }
  
    display() {
      this.flowOffset += 0.5
      fill(this.riverColor)
      beginShape()
      for (let i = 0; i <= this.width; i += 20) {
        let yVariation = 10 * sin((i + this.flowOffset) * 0.1)
        vertex(this.x + i, this.y + yVariation)
      }
      vertex(this.width, this.y + this.height)
      vertex(this.x, this.y + this.height)
      endShape(CLOSE)
    }
  }
  
  let sky, sun, moon, buildings, river
  let dayNightCycle = 0.0
  let isDay = true
  let groundColor
  
  function setup() {
    createCanvas(800, 600)
    groundColor = color(34, 139, 34)
    sky = new Sky(color(135, 206, 235), color(25, 25, 112))
    sun = new CelestialBody(-50, height / 4, 50, color(255, 204, 0))
    moon = new CelestialBody(-50, height / 4, 50, color(200))
    buildings = []
    for (let i = 0; i < 5; i++) {
      let bWidth = random(50, 100)
      let bHeight = random(150, 300)
      let bColor = color(random(50, 200), random(50, 200), random(50, 200))
      while (bColor === groundColor) {
        bColor = color(random(50, 200), random(50, 200), random(50, 200))
      }
      buildings.push(new Building(i * 160 + 20, height - 150 - bHeight, bWidth, bHeight, bColor))
    }
    river = new River(0, height - 100, width, 50, color(0, 0, 255))
  }
  
  function draw() {
    sky.update(dayNightCycle)
    sky.display(isDay)
    fill(groundColor)
    rect(0, height - 150, width, 150)
    if (isDay) {
      sun.update(dayNightCycle, true)
      sun.display()
    } else {
      moon.update(dayNightCycle, false)
      moon.display()
    }
    for (let building of buildings) {
      building.isHovered = building.contains(mouseX, mouseY)
      building.display()
    }
    river.display()
    if (isDay) {
      dayNightCycle += 0.002
      if (dayNightCycle >= 1.0) {
        isDay = false
      }
    } else {
      dayNightCycle -= 0.002
      if (dayNightCycle <= 0.0) {
        isDay = true
      }
    }
  }
  
  function mousePressed() {
    for (let building of buildings) {
      if (building.contains(mouseX, mouseY)) {
        building.breakDown()
      }
    }
  }
  