  class Particle {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float lifespan;
    float mass = 1;
    Particle(PVector l) {
      acceleration = new PVector(0,0.05);
      //velocity = new PVector(random(-1,1),random(-2,0));
      location = l.get();
      lifespan = 255.0;
    }
   
    void run() {
      update();
      display();
    }
   
    void update() {
        velocity.add(acceleration);
      location.add(velocity);
      lifespan -= 2.0;
    }
   
    void display() {
      stroke(0,lifespan);
      fill(0,lifespan);
      ellipse(location.x,location.y,8,8);
    }
     void applyForce(PVector force) {
      PVector f = force.get();
      f.div(mass);
      acceleration.add(f);
    }
    boolean isDead() {
      if (lifespan < 0.0) {
        return true;
      } else {
        return false;
      }
    }
  }
