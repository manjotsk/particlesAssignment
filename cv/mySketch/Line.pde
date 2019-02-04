class Line {
  PVector start;
  PVector end;
  //선의 시작점에서 끝점으로 가는 벡터입니다.
  PVector se;
  //벡터 se를 단위벡터화한 후 반시계방향으로 90도 회전해 선에 직각인 단위벡터를 만듭니다.
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