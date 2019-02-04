ParticleSystem ps;
Repeller repeller;
 
void setup() {
  size(640,360);
  ps = new ParticleSystem(new PVector(width/2,50));
  repeller = new Repeller(width/2-20,height/2);
}
 
void draw() {
  background(100);
  ps.addParticle();
  PVector gravity = new PVector(0,0.3);
  ps.applyForce(gravity);
  ps.applyRepeller(repeller);
 
  ps.run();
  repeller.display();
}
 
 
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
 
  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
 
  void addParticle() {
    particles.add(new Particle(origin));
  }
 
  void applyForce(PVector f) {
    for (Particle p: particles) {
      p.applyForce(f);
    }
  }
 
  void applyRepeller(Repeller r) {
    for (Particle p: particles) {
      PVector force = r.repel(p);
      p.applyForce(force);
    }
  }
 
  void run() {
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = (Particle) it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
}
 
class Repeller {
 
  float strength = 500;
  PVector location;
  float r = 10;
 
  Repeller(float x, float y)  {
    location = new PVector(x,y);
  }
 
  void display() {
    stroke(255);
    fill(255);
    ellipse(location.x,location.y,r*2,r*2);
  }
 
  PVector repel(Particle p) {
    PVector dir = PVector.sub(location,p.location);
    float d = dir.mag();
    dir.normalize();
    d = constrain(d,100,100);
    float force = -1 * strength / (d * d);
    dir.mult(force);
    return dir;
  }
}
