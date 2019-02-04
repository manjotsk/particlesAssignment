class Object {
  char character;
  Ball ball;
  PLineP line;

  Object(float d, PVector pos, PVector vel, color c) {
    character = 'b';
    ball = new Ball(d, pos, vel, c);
  }

  Object(PVector s, PVector e, int li) {
    character = 'l';
    line = new PLineP(s, e, li);
  }

  void display() {
    if (character == 'b') {
      ball.display();
    } else if (character == 'l') {
      line.display();
    }
  }

  void update(PVector g) {
    if (character == 'b') {
      ball.applyForce(PVector.mult(g, ball.m));
      ball.update();
    }
  }
  
  boolean judgeCollision(Object object2) {    
    if (character == 'b' && object2.character == 'b') {
      return ball.judgeCollision(object2.ball);
    } else if (character == 'b' && object2.character == 'l') {
      return object2.line.judgeCollision(ball);
    } else if (character == 'l' && object2.character == 'b') {
      return line.judgeCollision(object2.ball);
    } else { //if (character == 'l' && object2.character == 'l')
      return false;
    }
  }
}
