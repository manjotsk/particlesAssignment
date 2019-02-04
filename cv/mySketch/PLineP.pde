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

      float a = l.se.magSq();
      PVector cs = PVector.sub(start, ball.pos);
      float b = l.se.x * cs.x + l.se.y * cs.y;
      float c = cs.magSq() - (ball.d/2 * ball.d/2);
      float t1 = (-b + sqrt(b*b - a*c))/a;
      float t2 = (-b - sqrt(b*b - a*c))/a;

      if ((t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1)) {
        JudgeCollisionLinePoint = true;
        return JudgeCollisionLinePoint;
      } else {
        JudgeCollisionLinePoint = false;
      }

      float distanceS = PVector.dist(pS.pos, ball.pos);
      float distanceE = PVector.dist(pE.pos, ball.pos);

      if (distanceS <= ball.d/2) {
        JudgeCollisionLinePoint = true;
        return JudgeCollisionLinePoint;
      } 
      else if (distanceE <= ball.d/2) {
        JudgeCollisionLinePoint = true;
        return JudgeCollisionLinePoint;
      } 
      else {
        JudgeCollisionLinePoint = false;
      }
      return JudgeCollisionLinePoint;
    } else {
      return false;
    }
  }

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
