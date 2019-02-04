class Point {

  PVector pos;

  Point(PVector pos_) {
    pos = pos_.get();
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    point(pos.x, pos.y);
  }
}