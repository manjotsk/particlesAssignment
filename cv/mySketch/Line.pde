class Line {
  PVector start;
  PVector end;
  PVector se;
  PVector normalUnit;
  
  Line(PVector s, PVector e) {
    start = s;
    end = e;
    se = PVector.sub(end, start);
    normalUnit = makeNormalUnit(se);   
  }
  
  PVector makeNormalUnit(PVector se) {
    PVector nu = se.get();
    nu.normalize();
    nu.rotate(-PI/2);
    return nu;
  }
  
  void display() {
    stroke(0);
    strokeWeight(2);
    line(start.x, start.y, end.x, end.y);
  }
}
