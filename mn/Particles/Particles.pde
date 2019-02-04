ParticleSystem ps;

void setup() {
  size(640,480);
  surface.setResizable(true);
  ps = new ParticleSystem(new PVector(width/2,height/2));
  for (int i = 0; i < 500; i++)
    ps.addParticle();
}

void draw() {
  fill(0, 77);
  rect(0, 0, width, height);
  ps.run();
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle());
  }

  void run() {
    for (int i = 0; i < particles.size(); i++) 
      particles.get(i).run();
      
    if(mousePressed && (mouseButton == RIGHT)) {  //add 20 particles on right click
      for (int i = 0; i < 20; i++) 
        particles.add(new Particle());
    }
  }
}

class Particle {
  PVector location, velocity, acceleration;
  float angle, radius;
  float R, G, B;
  float lifespan = -0.2;  
  Particle() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(.05, .05);
    angle = 0;
    lifespan = 255;
    R = random(255);
    G = random(255);
    B = random(255);
  }

  void run() {
    update();
    display();
  }

  float findAngle(float x, float y) {
    float a = atan2(y - location.y, x - location.x);
    return a;
  }
  
  float findHypotenuse(float x, float y) {
    return dist(x, y, location.x, location.y);
  }

  void update() {
    if (mousePressed && (mouseButton == LEFT)) {  //force push away on left click
      acceleration = new PVector(-1, -1);
      velocity.limit(7);
    }
    else {  //pull in on default
      acceleration = new PVector(.1, .1);
      velocity.limit(4);
    }
    
    angle = findAngle(mouseX, mouseY);
    
    radius = findHypotenuse(mouseX, mouseY);
    
    velocity.x += acceleration.x * cos(angle);
    velocity.y += acceleration.y * sin(angle);
    
    location.add(velocity);
    lifespan -= 0.2;
  }

  void display() {
    stroke(0,lifespan);
    fill(R, G, B);
    ellipse(location.x, location.y, 2 + (1 * abs(velocity.x/2)) + (1 * abs(velocity.y/2)), 2 + (1 * abs(velocity.x/2)) + (1 * abs(velocity.y/2)));
  }
}
