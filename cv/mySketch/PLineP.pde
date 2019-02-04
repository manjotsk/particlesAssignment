class PLineP {
  Point pS;
  Point pE;
  Line l;

  int lineindex;
  PVector start;
  PVector end;

  PLineP(PVector s, PVector e, int lineindex_) {
    start = s.get();
    end = e.get();

    l = new Line(start, end);
    pS = new Point(start);
    pE = new Point(end);
    lineindex = lineindex_;
  }

  void display() {
    l.display();
    pS.display();
    pE.display();
  }

  boolean judgeCollision(Ball ball) {
    if (preCollision(ball)) {
      
      boolean JudgeCollisionLinePoint = false;

      //선과 충돌했는가?
      float a = l.se.magSq();
      PVector cs = PVector.sub(start, ball.pos);
      float b = l.se.x * cs.x + l.se.y * cs.y;
      float c = cs.magSq() - (ball.d/2 * ball.d/2);
      float t1 = (-b + sqrt(b*b - a*c))/a;
      float t2 = (-b - sqrt(b*b - a*c))/a;

      //t가 0과 1 사이값이면 선분과 만난 것이 되므로 충돌, 아니면 충돌 아님
      if ((t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1)) {
        JudgeCollisionLinePoint = true;
        return JudgeCollisionLinePoint;
      } else {
        JudgeCollisionLinePoint = false;
      }

      //점과 충돌했는가
      float distanceS = PVector.dist(pS.pos, ball.pos);
      float distanceE = PVector.dist(pE.pos, ball.pos);

      //S점과 충돌하면
      if (distanceS <= ball.d/2) {
        JudgeCollisionLinePoint = true;
        return JudgeCollisionLinePoint;
      } 
      //E점과 충돌하면
      else if (distanceE <= ball.d/2) {
        JudgeCollisionLinePoint = true;
        return JudgeCollisionLinePoint;
      } 
      //점과 충돌하지 않았으면 0
      else {
        JudgeCollisionLinePoint = false;
      }
      return JudgeCollisionLinePoint;
    } else {
      return false;
    }
  }

  //확실한 충돌판단 이전에 충돌가능성 여부 판단 - 미리 체로 걸러내는 것과 비슷합니다.
  boolean preCollision(Ball ball) {
    PVector sc = PVector.sub(ball.pos, start);
    float distBallCenterAndLine = abs(sc.dot(l.normalUnit));
    if (distBallCenterAndLine <= ball.d/2) {
      return true;
    } else {
      return false;
    }
  }
}