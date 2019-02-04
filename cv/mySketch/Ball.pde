class Ball {
  float m;
  float d;
  PVector pos;
  PVector vel;
  PVector acc;

  PVector previousPos;
  color c;
  //추가: 동시 충돌일 때 extraTime 위치 조정시 한번만 위치 조정되도록 하기 위해
  boolean forSameCount;

  //180807 파도효과
  boolean whiteWave;

  Ball(float m_, PVector pos_, PVector vel_, color c_) {

    
    m = m_;
    d = m * 3;
    pos = pos_.get();
    vel = vel_.get();
    acc = new PVector();

    previousPos = PVector.sub(pos, vel);
    c = c_;
    //추가: 
    forSameCount = false;

    whiteWave = false;
  }

  void applyForce(PVector f) {
    acc.add(PVector.div(f, m));
  }

  void update() {
    previousPos = pos.get();
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }
  //180807
  void setWhiteColor() {
    c = color(227, 235, 245);
    whiteWave = true;
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    fill(c, 150);
    ellipse(pos.x, pos.y, d, d);
  }

  boolean judgeCollision(Ball b) {
    float distance = PVector.dist(pos, b.pos);
    if (distance <= d/2 + b.d/2) {
      return true;
    } else {
      return false;
    }
  }
}