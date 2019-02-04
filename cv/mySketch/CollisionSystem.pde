class CollisionSystem { 
  ArrayList<Object> objects;

  ArrayList<ArrayList<Object>> listCollisionTwoObjects;
  ArrayList<ArrayList<Object>> groupCollisionObjects;
  ArrayList<ArrayList<ArrayList<Object>>> finalGroup;

  PVector g;

  boolean repeat;
  float repeatThreshold;

  ArrayList<PVector> ground;

  CollisionSystem() {
    g = new PVector(0, 0.1);

    ground = new ArrayList<PVector>();

    initiateObject();

    listCollisionTwoObjects = new ArrayList<ArrayList<Object>>();
    groupCollisionObjects = new ArrayList<ArrayList<Object>>();
    finalGroup = new ArrayList<ArrayList<ArrayList<Object>>>();

    repeat = true;
    repeatThreshold = 5;
  }

  void initiateObject() {
    objects = new ArrayList<Object>();
    generateBalls1();
    generateLines();
  }

  void generateBalls1() {
    for (int i = 0; i < 28; i++) {
      for (int j = 0; j < 10; j++) {
        float mass = random(3, 6);
        color waterColor = color(random(255), random(255), random(255));
        objects.add(new Object(mass, new PVector(-200 - (10*j) +(19*i), height-90 - (19*j)), new PVector(random(1, 5), random(-0.3, 0.3)), waterColor));
      }
    }
  }

  void generateBalls2() {
    for (int i = 0; i < 23; i++) {
      for (int j = 0; j < 10; j++) {
        float mass = random(3, 6);
        color waterColor = color(random(255), random(255), random(255));
        objects.add(new Object(mass, new PVector(-500 - (10*j) + (19*i), height-130 - (19*j)), new PVector(random(2, 5), random(-0.7, 0.7)), waterColor));
      }
    }
  }
  
  void generateLines() {
    objects.add(new Object(new PVector(-500, height-30), new PVector(150, height-60), 1));
    objects.add(new Object(new PVector(150, height-60), new PVector(270, height-50), 2));  
    objects.add(new Object(new PVector(270, height-50), new PVector(400, height-30), 3));
    objects.add(new Object(new PVector(400, height-30), new PVector(500, height-55), 4));
    objects.add(new Object(new PVector(500, height-55), new PVector(620, height-20), 5));
    objects.add(new Object(new PVector(620, height-20), new PVector(700, height-50), 6));
    objects.add(new Object(new PVector(700, height-50), new PVector(800, height/2+100), 7));
    objects.add(new Object(new PVector(800, height/2+100), new PVector(870, height/2+70), 8));
    objects.add(new Object(new PVector(870, height/2+70), new PVector(1000, height/2+60), 9));

    ground.add(new PVector(-500, height-30));
    ground.add(new PVector(150, height-60));
    ground.add(new PVector(270, height-50));
    ground.add(new PVector(400, height-30));
    ground.add(new PVector(500, height-55));
    ground.add(new PVector(620, height-20));
    ground.add(new PVector(700, height-50));
    ground.add(new PVector(800, height/2+100));
    ground.add(new PVector(870, height/2+70));
    ground.add(new PVector(1000, height/2+60));
    ground.add(new PVector(1000, height));
    ground.add(new PVector(-500, height));
  }

  void run() {

    for (Object object : objects) {
      object.update(g);
    }

    collisionAlgorithm();

    for (Object object : objects) {
      object.display();
    }

    groundDisplay();

    if (frameCount % 620 == 0) {
      CSystem.generateBalls2();
    }    
    CSystem.deleteOutBall();

  }

  void groundDisplay() {
    fill(232, 216, 187, 200);
    beginShape();
    for (int i = 0; i < ground.size(); i++) {
      PVector groundPoint = ground.get(i);
      vertex(groundPoint.x, groundPoint.y);
    }
    endShape(CLOSE);
  }

  void collisionAlgorithm() {
    repeat = true;
    while (repeat == true) {
      generateCollisionSetBalls();

      applyCollisionAlgorithm();

      clearArrayList();
    }
  }

  void generateCollisionSetBalls() {
    makeListCollisionTwoObjects();//ex) [1-4][2-5][3-8][4-7]
    makeGroupCollisionObjects();//ex) [1-4-7][2-5][3-8]
    makefinalGroup();//ex)GroupA:[1-4][4-7], GroupB:[2-5], GroupC:[3-8]
  }

  void makeListCollisionTwoObjects() {
    for (int i = 0; i < objects.size()-1; i++) {
      Object object1 = objects.get(i);

      for (int j = i+1; j < objects.size(); j++) {
        Object object2 = objects.get(j);

        if (object1.judgeCollision(object2)) {

          ArrayList<Object> collisionTwoObjects = new ArrayList<Object>();
          collisionTwoObjects.add(object1);
          collisionTwoObjects.add(object2);
          listCollisionTwoObjects.add(collisionTwoObjects);
        }
      }
    }

    if (listCollisionTwoObjects.size() < repeatThreshold) {
      repeat = false;
    } else {
      repeat = true;
    }
  }

  void makeGroupCollisionObjects() {
    groupCollisionObjects = (ArrayList<ArrayList<Object>>)listCollisionTwoObjects.clone();

    for (int i = groupCollisionObjects.size()-1; i > 0; i--) {
      ArrayList<Object> objects1 = (ArrayList<Object>)groupCollisionObjects.get(i).clone();
      for (int j = objects1.size()-1; j >= 0; j--) {
        Object o1 = objects1.get(j);

        for (int k = i - 1; k >= 0; k--) {
          ArrayList<Object> objects2 = groupCollisionObjects.get(k);
          for (int l = objects2.size()-1; l >= 0; l--) {
            Object o2 = objects2.get(l);
            if (o1 == o2) {
              objects1.remove(j);
              objects2.addAll(objects1);
              groupCollisionObjects.remove(i);
              l = 0;
              k = 0;
              j = 0;
            }
          }
        }
      }
    }
  }

  void makefinalGroup() {
    for (int i = 0; i < groupCollisionObjects.size(); i++) {

      ArrayList<ArrayList<Object>> groupCollisionTwoObjects = new ArrayList<ArrayList<Object>>();

      ArrayList<Object> objects1 = groupCollisionObjects.get(i);
      for (int j = 0; j < objects1.size(); j++) {
        Object o1 = objects1.get(j);

        for (int k = listCollisionTwoObjects.size()-1; k >= 0; k--) {
          ArrayList<Object> objects2 = listCollisionTwoObjects.get(k);
          if (objects2.contains(o1)) {
            groupCollisionTwoObjects.add(objects2);
            listCollisionTwoObjects.remove(k);
          }
        }
      }
      finalGroup.add(groupCollisionTwoObjects);
    }
  }

  void applyCollisionAlgorithm() {
    for (int i = 0; i < finalGroup.size(); i++) {
      ArrayList<ArrayList<Object>> groupCollisionTwoObjects = finalGroup.get(i);
      while (groupCollisionTwoObjects.size() > 0) {
        //FloatList timeForOnePointOfCollision = new FloatList();
        ArrayList<Time> timeForOnePointOfCollision = new ArrayList<Time>();

        for (int j = groupCollisionTwoObjects.size()-1; j >= 0; j--) {
          ArrayList<Object> collisionTwoObjects = groupCollisionTwoObjects.get(j);
          Object o1 = collisionTwoObjects.get(0);
          Object o2 = collisionTwoObjects.get(1);
          if (o1.judgeCollision(o2)) {

            Time time = calTimeForOnePointOfCollision(o1, o2);
            if (time.t >= -6 && time.t <= 6) {
              timeForOnePointOfCollision.add(time);
            } else {
              groupCollisionTwoObjects.remove(j);
            }
          } else {
            groupCollisionTwoObjects.remove(j);
          }
        }

        if (!timeForOnePointOfCollision.isEmpty()) {
          reverseArrayList(timeForOnePointOfCollision);          
          int indexOfTimeMin = getMinIndex(timeForOnePointOfCollision);

          Time tMin = timeForOnePointOfCollision.get(indexOfTimeMin);

          int sameCount = 0;
          sameCount = getSameCount(timeForOnePointOfCollision, tMin);

          if (sameCount > 0) {         
            setPosAndVelInSameTimeAlgorithm(timeForOnePointOfCollision, groupCollisionTwoObjects, tMin);
          } else {
            setPosAndVel(groupCollisionTwoObjects, indexOfTimeMin, tMin);
          }
        }
      }
    }
  }

  void setPosAndVelInSameTimeAlgorithm(ArrayList<Time> timeForOnePointOfCollision, ArrayList<ArrayList<Object>> groupCollisionTwoObjects, Time tMin) {
    for (int k = 0; k < timeForOnePointOfCollision.size(); k++) {
      Time tMin1 = timeForOnePointOfCollision.get(k);
      float difference = abs(tMin1.t - tMin.t);
      if (difference <= 0.0001) {
        Object o1 = groupCollisionTwoObjects.get(k).get(0);
        Object o2 = groupCollisionTwoObjects.get(k).get(1);
        setRePositionForOnePointOfCollision(o1, o2, tMin);
      }
    }
    for (int k = 0; k < timeForOnePointOfCollision.size(); k++) {
      Time tMin1 = timeForOnePointOfCollision.get(k);
      float difference = abs(tMin1.t - tMin.t);
      if (difference <= 0.0001) {
        Object o1 = groupCollisionTwoObjects.get(k).get(0);
        Object o2 = groupCollisionTwoObjects.get(k).get(1);
        setReVelocityAfterCollision(o1, o2, tMin);
      }
    }
    for (int k = 0; k < timeForOnePointOfCollision.size(); k++) {
      Time tMin1 = timeForOnePointOfCollision.get(k);
      float difference = abs(tMin1.t - tMin.t);
      if (difference <= 0.0001) {
        Object o1 = groupCollisionTwoObjects.get(k).get(0);
        Object o2 = groupCollisionTwoObjects.get(k).get(1);

        float extraTime = 1 - tMin.t;
        setRePositionForExtraTime(o1, o2, extraTime);

        //추가: extraTime에 의한 위치재조정이 한번씩만 일어나도록 하기 위해
        if (o1.character == 'b') o1.ball.forSameCount = true;
        if (o2.character == 'b') o2.ball.forSameCount = true;
      }
    }

    //추가: true로 설정했던 forSameCount를 모두 false로 초기화
    for (int k = 0; k < timeForOnePointOfCollision.size(); k++) {
      Time tMin1 = timeForOnePointOfCollision.get(k);
      float difference = abs(tMin1.t - tMin.t);
      if (difference <= 0.0001) {
        Object o1 = groupCollisionTwoObjects.get(k).get(0);
        Object o2 = groupCollisionTwoObjects.get(k).get(1);
        //180802
        if (o1.character == 'b') o1.ball.forSameCount = false;
        if (o2.character == 'b') o2.ball.forSameCount = false;
      }
    }

    for (int k = timeForOnePointOfCollision.size()-1; k >= 0; k--) {
      Time tMin1 = timeForOnePointOfCollision.get(k);
      float difference = abs(tMin1.t - tMin.t);
      if (difference <= 0.0001) {
        groupCollisionTwoObjects.remove(k);
        timeForOnePointOfCollision.remove(k);
      }
    }
  } 

  void setPosAndVel(ArrayList<ArrayList<Object>> groupCollisionTwoObjects, int indexOfTimeMin, Time tMin) {

    Object o1 = groupCollisionTwoObjects.get(indexOfTimeMin).get(0);
    Object o2 = groupCollisionTwoObjects.get(indexOfTimeMin).get(1);
    setRePositionForOnePointOfCollision(o1, o2, tMin);
    setReVelocityAfterCollision(o1, o2, tMin);
    float extraTime = 1 - tMin.t;

    setRePositionForExtraTime(o1, o2, extraTime);
    groupCollisionTwoObjects.remove(indexOfTimeMin);
  }

  void reverseArrayList(ArrayList<Time> times) {
    for (int i = times.size()-2; i >= 0; i--) {
      Time time = times.get(i);
      times.add(time);
      times.remove(i);
    }
  }

  int getMinIndex(ArrayList<Time> times) {
    float minTime = 100000.0;
    int minIndex = 0;

    for (int i = 0; i < times.size(); i++) {
      float t = times.get(i).t;

      if (t < minTime) {
        minTime = t;
        minIndex = i;
      }
    }   
    return minIndex;
  }

  int getSameCount(ArrayList<Time> times, Time tMin) {
    int sameCount = -1;
    for (int i = 0; i < times.size(); i++) {
      float t = times.get(i).t;
      float difference = abs(t - tMin.t);
      if (difference <= 0.0001) {
        sameCount++;
      }
    }
    return sameCount;
  }

  Time calTimeForOnePointOfCollision(Object o1, Object o2) {

    Time time = new Time();
    float t;
    if (o1.character == 'b' && o2.character == 'b') {
      float a = ((o1.ball.vel.x - o2.ball.vel.x) * (o1.ball.vel.x - o2.ball.vel.x)) + ((o1.ball.vel.y - o2.ball.vel.y) * (o1.ball.vel.y - o2.ball.vel.y));
      float b = ((o1.ball.previousPos.x - o2.ball.previousPos.x) * (o1.ball.vel.x - o2.ball.vel.x)) + ((o1.ball.previousPos.y - o2.ball.previousPos.y) * (o1.ball.vel.y - o2.ball.vel.y));
      float c = ((o1.ball.previousPos.x - o2.ball.previousPos.x) * (o1.ball.previousPos.x - o2.ball.previousPos.x)) + ((o1.ball.previousPos.y - o2.ball.previousPos.y) * (o1.ball.previousPos.y - o2.ball.previousPos.y)) - ((o1.ball.d/2 + o2.ball.d/2) * (o1.ball.d/2 + o2.ball.d/2));

      float t1 = (-1 * b + sqrt(b*b - a*c))/a;
      float t2 = (-1 * b - sqrt(b*b - a*c))/a;

      if ((t1 >= -0.001) && (t1 <= 1)) {
        if ((t2 >= -0.001) && (t2 <= 1)) {
          if (t1 > t2) t = t2;
          else if (t1 < t2) t = t1;
          else t = t1;
        } else {
          t = t1;
        }
      } else if ((t2 >= -0.001) && (t2 <= 1)) {
        t = t2;
      } else {
        float abst1 = abs(t1);
        float abst2 = abs(t2);
        if (abst1 < abst2) {
          t = t1;
        } else {
          t = t2;
        }
      }
    } else if (o1.character == 'b' && o2.character == 'l') {

      float[] ts = new float[3];
      ts[0] = calTimeLine(o1, o2);
      ts[1] = calTimePoint(o1, 1, o2);//시작점
      ts[2] = calTimePoint(o1, 2, o2);//끝점

      float[] absTs = new float[3];
      absTs[0] = abs(ts[0]);
      absTs[1] = abs(ts[1]);
      absTs[2] = abs(ts[2]);

      t = 1000;
      int index = 0;
      for (int i = 0; i < absTs.length; i++) {
        if (absTs[i] < t) {
          t = absTs[i];
          index = i;
        }
      }
      //추가: 180807
      // 1. 가장 절대값 작은 것이 0보다 크거나 같으면 선택완료
      // 2. 가장 절대값 작은 것이 0보다 작으면
      //   (1) 0<=t<=1인 Index 찾는다. 그것을 선택
      //   (2) 그런 값이 없으면 아까 구한 가장 절대값 작은 것 선택
      // 셋 중 하나는 t값이 1000이다)
      if (ts[index] >= 0) {
        //그대로
      } else {
        if (ts[(index+1)%3] >= 0 && ts[(index+1)%3] <= 1) {
          index = (index+1)%3;
        } else if (ts[(index+2)%3] >= 0 && ts[(index+2)%3] <= 1) {
          index = (index+2)%3;
        } else {
          //그대로
        }
      }
      t = ts[index];
      time.c = index;
    } else if (o1.character == 'l' && o2.character == 'b') {
      t = 1000;
      float[] ts = new float[3];
      ts[0] = calTimeLine(o2, o1);
      ts[1] = calTimePoint(o2, 1, o1);//시작점
      ts[2] = calTimePoint(o2, 2, o1);//끝점

      float[] absTs = new float[3];
      absTs[0] = abs(ts[0]);
      absTs[1] = abs(ts[1]);
      absTs[2] = abs(ts[2]);
      int index = 0;
      for (int i = 0; i < absTs.length; i++) {
        if (absTs[i] < t) {
          t = absTs[i];
          index = i;
        }
      }
      //추가: 
      if (ts[index] >= 0) {
        //그대로
      } else {
        if (ts[(index+1)%3] >= 0 && ts[(index+1)%3] <= 1) {
          index = (index+1)%3;
        } else if (ts[(index+2)%3] >= 0 && ts[(index+2)%3] <= 1) {
          index = (index+2)%3;
        } else {
          //그대로
        }
      }

      t = ts[index];
      time.c = index;
    } else { //if(o1.character == 'l' && o2.character == 'l')
      //추가: 
      t = 10000;
    }
    time.t = t;
    return time;
  }

  //충돌 직전 공에서 선위의 한점 충돌까지의 시간 계산(선)
  float calTimeLine(Object o1, Object o2) {
    PVector se = PVector.sub(o1.ball.pos, o1.ball.previousPos);
    float a = se.dot(o2.line.l.normalUnit);
    PVector fromLineStartToBallPrePos = PVector.sub(o1.ball.previousPos, o2.line.start);
    float b = 0;

    //한점 충돌 위치는 선의 양쪽에 존재한다. 그 중 이전 공의 위치가 있는 곳을 한점 충돌 위치로 선택한다.
    float r = 0;
    float h = fromLineStartToBallPrePos.dot(o2.line.l.normalUnit);
    if (h > 0) {
      r = o1.ball.d/2;
    } else if (h < 0) {
      r = -1 * o1.ball.d/2;
    } else {
      r = 0;
    }
    b = r - h;
    return b/a;
  }

  float calTimePoint(Object o1, int SOrE, Object o2) {
    float a = o1.ball.vel.magSq();
    float b = 0.0;
    float c = 0.0;
    if (SOrE == 1) {
      b = -1 * ((o2.line.pS.pos.x - o1.ball.previousPos.x) * (o1.ball.vel.x) + (o2.line.pS.pos.y - o1.ball.previousPos.y) * (o1.ball.vel.y));
      c = PVector.sub(o2.line.pS.pos, o1.ball.previousPos).magSq() - (o1.ball.d/2 * o1.ball.d/2);
    } else if (SOrE == 2) {
      b = -1 * ((o2.line.pE.pos.x - o1.ball.previousPos.x) * (o1.ball.vel.x) + (o2.line.pE.pos.y - o1.ball.previousPos.y) * (o1.ball.vel.y));
      c = PVector.sub(o2.line.pE.pos, o1.ball.previousPos).magSq() - (o1.ball.d/2 * o1.ball.d/2);
    } else {
    }

    float t1 = (-1 * b + sqrt(b*b - a*c))/a;
    float t2 = (-1 * b - sqrt(b*b - a*c))/a;

    float t = 0;
    if ((t1 >= -0.001) && (t1 <= 1)) {
      if ((t2 >= -0.001) && (t2 <= 1)) {
        if (t1 > t2) t = t2;
        else if (t1 < t2) t = t1;
        else t = t1;
      } else {
        t = t1;
      }
    } else if ((t2 >= -0.001) && (t2 <= 1)) {
      t = t2;
    } else {
      //추가: point와의 충돌이 아니면 t값에 큰 임의의 값을 주어 충돌이 아님을 알린다.
      t = 10000;
    }
    return t;
  }

  void setRePositionForOnePointOfCollision(Object o1, Object o2, Time tMin) {
    if (o1.character == 'b') {
      o1.ball.pos = PVector.add(o1.ball.previousPos, PVector.mult(o1.ball.vel, tMin.t));
    }
    if (o2.character == 'b') {
      o2.ball.pos = PVector.add(o2.ball.previousPos, PVector.mult(o2.ball.vel, tMin.t));
    }
  }

  void setReVelocityAfterCollision(Object o1, Object o2, Time tMin) {

    if (o1.character == 'b' && o2.character == 'b') {
      //180807 파도효과
      if (o1.ball.whiteWave == true && o2.ball.pos.x > 700) {
        o2.ball.setWhiteColor();
      }
      if (o2.ball.whiteWave == true && o1.ball.pos.x > 700) {
        o1.ball.setWhiteColor();
      }

      PVector dir = PVector.sub(o2.ball.pos, o1.ball.pos);
      dir.normalize();

      PVector normal1 = PVector.mult(dir, o1.ball.vel.dot(dir));
      PVector tangent1 = PVector.sub(o1.ball.vel, normal1);
      PVector normal2 = PVector.mult(dir, o2.ball.vel.dot(dir));
      PVector tangent2 = PVector.sub(o2.ball.vel, normal2);
      
      //180809 질량이 다른 두 공의 충돌 후 속도 계산
      float a = (o1.ball.m - o2.ball.m)/(o1.ball.m + o2.ball.m);
      float b = (2 * o2.ball.m)/(o1.ball.m + o2.ball.m);
      float c = (2 * o1.ball.m)/(o1.ball.m + o2.ball.m);
      float d = (o2.ball.m - o1.ball.m)/(o1.ball.m + o2.ball.m);

      PVector vi1 = PVector.mult(normal1, a); 
      PVector vi2 = PVector.mult(normal2, b);
      PVector vf1 = PVector.add(vi1, vi2);
      vi1 = PVector.mult(normal1, c); 
      vi2 = PVector.mult(normal2, d); 
      PVector vf2 = PVector.add(vi1, vi2);

      //processingjs
      vf1.add(tangent1);
      o1.ball.vel = vf1.get();
      vf2.add(tangent2);
      o2.ball.vel = vf2.get();
    } else if (o1.character == 'b' && o2.character == 'l') {

      //180807 파도효과
      if (o2.line.lineindex >= 6) {
        o1.ball.setWhiteColor();
      }

      //선과의 충돌이었으면
      if (tMin.c == 0) {

        float n = -1 * o1.ball.vel.dot(o2.line.l.normalUnit);
        PVector normalVel = PVector.mult(o2.line.l.normalUnit, n);
        PVector dampingNormalVel = PVector.mult(normalVel, 0.8);//추가: 선과 충돌하면 선의 normal 방향의 속도를 20% 감소시킨다
        normalVel.add(dampingNormalVel);//damping
        //processingjs
        normalVel.add(o1.ball.vel);
        o1.ball.vel = normalVel.get();
      } 
      //점과의 충돌이었으면
      else if (tMin.c == 1 || tMin.c == 2) {

        PVector dir;
        if (tMin.c == 1) {
          dir = PVector.sub(o2.line.pS.pos, o1.ball.pos);
        } else {
          dir = PVector.sub(o2.line.pE.pos, o1.ball.pos);
        }
        dir.normalize();

        PVector normal = PVector.mult(dir, o1.ball.vel.dot(dir));
        PVector tangent = PVector.sub(o1.ball.vel, normal);

        normal.mult(-1);
        normal.mult(0.8);
        
        normal.add(tangent);
        o1.ball.vel = normal.get();
      }
    } else if (o1.character == 'l' && o2.character == 'b') {
      //180807 파도효과
      if (o1.line.lineindex >= 6) {
        o2.ball.setWhiteColor();
      }

      //선과의 충돌이었으면
      if (tMin.c == 0) {

        float n = -1 * o2.ball.vel.dot(o1.line.l.normalUnit);
        PVector normalVel = PVector.mult(o1.line.l.normalUnit, n);
        PVector dampingNormalVel = PVector.mult(normalVel, 0.8);
        normalVel.add(dampingNormalVel);//damping
        //processingjs
        normalVel.add(o2.ball.vel);
        o2.ball.vel = normalVel.get();
      } 
      
      else if (tMin.c == 1 || tMin.c == 2) {

        PVector dir;
        if (tMin.c == 1) {
          dir = PVector.sub(o1.line.pS.pos, o2.ball.pos);
        } else {
          dir = PVector.sub(o1.line.pE.pos, o2.ball.pos);
        }
        dir.normalize();

        PVector normal = PVector.mult(dir, o2.ball.vel.dot(dir));
        PVector tangent = PVector.sub(o2.ball.vel, normal);

        normal.mult(-1);
        normal.mult(0.8);//추가: 점과 충돌하면 점의 normal 방향의의 직각 방향의 속도를 20% 감소시킨다
        //processingjs
        normal.add(tangent);
        o2.ball.vel = normal.get();
      }
    } else {
    }
  }

  void setRePositionForExtraTime(Object o1, Object o2, float extraTime) {

    if (o1.character == 'b') {
      if (o1.ball.forSameCount == false) {
        o1.ball.pos.add(PVector.mult(o1.ball.vel, extraTime));
        o1.ball.previousPos = PVector.sub(o1.ball.pos, o1.ball.vel);
      }
    }
    if (o2.character == 'b') {
      if (o2.ball.forSameCount == false) {
        o2.ball.pos.add(PVector.mult(o2.ball.vel, extraTime));
        o2.ball.previousPos = PVector.sub(o2.ball.pos, o2.ball.vel);
      }
    }
  }

  void clearArrayList() {
    listCollisionTwoObjects.clear();
    groupCollisionObjects.clear();
    finalGroup.clear();
  }

  void deleteOutBall() {
    for (int i = objects.size()-1; i >= 0; i--) {
      Object object = objects.get(i);
      if (object.character == 'b') {
        if ((object.ball.pos.x < -550) || (object.ball.pos.x > width + 100)) {
          objects.remove(i);
        }
      }
    }
  }
}
