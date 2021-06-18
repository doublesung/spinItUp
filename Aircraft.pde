class Aircraft {
    JetPoint jetpoint;
    MoveAffect moveAffect;
    CollisionAffect collisionAffect;
    final float AIRCRAFT_INIT_X = width / 2;
    final float AIRCRAFT_INIT_Y = height - 100;
    PImage img, theEyeImg;
    float x, y;
    float size = AIRCRAFT_SIZE; 
    float eyeW, eyeH;
    float eyeHMin = 5, eyeHMax = 20;
    float moveAngle;
    float xSpeed , ySpeed ;
    float timer;
    float testX;
    float testY;
    float jetSpeed = -0.05;
    boolean start = false;
    
    Aircraft() {
        x = AIRCRAFT_INIT_X;
        y = AIRCRAFT_INIT_Y;
        img = aircraftImg;
        theEyeImg = eyeImg;
        timer = 90;
        testX = 0;
        testY = 0;
        eyeW = 20;
        eyeH = eyeHMax;
        jetpoint = new JetPoint(x, y);
        moveAffect = new MoveAffect(x, y);
        collisionAffect = new CollisionAffect(x, y);
    }

    void display() {
          
        pushMatrix();
        translate(x, y);
        rotateZ(angle);
        image(img, 0 - size/2, 0 - size/2 , AIRCRAFT_SIZE, AIRCRAFT_SIZE);
        popMatrix();

        jetpoint.display();
        moveAffect.display();
        collisionAffect.display();
    }

    void update() {
        
        if(start){
            if(!onfire.isAlive) {
                x += xSpeed;
                y += ySpeed;
                ySpeed += 0.11;
                if(timer < 100) timer += 1;
            }else {
                if(onfire.alpha[0] <= 100) {
                    if(onfire.alpha[0] == 40) fly.trigger();
                    ySpeed = -3.5;
                    jetSpeed -= 0.15;
                    y += jetSpeed;
                }
            }
            if(ySpeed < 0) eyeH = eyeHMin;
        }
        if(y < 400){
            y = 400;
            fire.y -= ySpeed;
            for (int i = 0; i < barriers.length; i++) {
              
                if(!onfire.isAlive) {
                    barriers[i].y -= ySpeed;
                }else {
                    barriers[i].y -= jetSpeed;
                }
               
                if(y < barriers[i].y) barriers[i].overtaken();
                
                if(barriers[i].y > height) {
                    barriers[i].isAlive = true;
                    barriers[i].y = 0 - barriers[i].h;
                    barriers[i].left = random(2) < 1;
                    barriers[i].x = (barriers[i].left) ? -75 : width / 2;
                    if(score >= 20) {
                        barriers[i].move = random(3) < 1;
                        if(barriers[i].move) {
                            barriers[i].speed = 0.75;
                            barriers[i].timer = 0;
                        }
                    } 
                }
            }
        }
        
        if(y < aircraftMaxY) aircraftMaxY = y;
        jetpoint.update(x, y);
        moveAffect.update(x, y);
        collisionAffect.update();
    }

    void eye() {
        pushStyle();
        eyeH = lerp(eyeH, eyeHMax, 0.1);
        image(theEyeImg, x - eyeW/2, y - eyeW/2, eyeW, eyeH);
        popStyle();
    }
    
    void move() {
        start = true;
        bounce.trigger();
        moveAngle = atan2(jetpoint.sy - y, jetpoint.sx - x);
        xSpeed = 6 * cos(moveAngle);
        ySpeed = 7.5 * sin(moveAngle);
        timer = 0;
        if(!onfire.isAlive) moveAffect.isAlive = true;
    }  

    void keepInScreen() {
        if(y - size / 2 < 0) makeBounceTop(0);
        if(y + size / 2 > height) {
            isTransition.isAlive = true;
            if(isTransition.over) { 
                gameState = GAME_START;
                score = 0;
                isTransition.over = false;
                initGame();
            }
        }
        if(x - size/2 < 0) makeBounceLeft(0);
        if(x + size/2 > width) makeBounceRight(width);
    }
    void barrierCollision(){
        for (int i = 0; i < barriers.length; i++){
            if(hit(x, y, size / 2, barriers[i].x, barriers[i].y, barriers[i].w, barriers[i].h) 
            && (testY == barriers[i].y || testY == barriers[i].y + barriers[i].h)) {
              
                if( (y - ySpeed < barriers[i].y || y - ySpeed > barriers[i].y + barriers[i].h)
                &&  (x - xSpeed < barriers[i].x || x - xSpeed > barriers[i].x + barriers[i].w)) {
                    hit.trigger();
                    collisionAffect.isHit(x, y);
                    x -= xSpeed * 1.2;
                    y -= ySpeed * 1.2;
                    xSpeed *= -1;
                    ySpeed *= -1;
                }else if(testX != barriers[i].x && testX != barriers[i].x + barriers[i].w 
                && (x - xSpeed > barriers[i].x || x - xSpeed < barriers[i].x + barriers[i].w)) {
                    if(y > barriers[i].y) makeBounceTop(barriers[i].y + barriers[i].h);
                    if(y < barriers[i].y) makeBounceBottom(barriers[i].y);
                }
              
            }else if(hit(x, y, size / 2, barriers[i].x, barriers[i].y, barriers[i].w, barriers[i].h)){
                if(x > barriers[i].x) makeBounceLeft(barriers[i].x + barriers[i].w);
                if(x < barriers[i].x) makeBounceRight(barriers[i].x);
            }
         
        }
    }
    
    void makeBounceTop(float surface) {
        hit.trigger();
        collisionAffect.isHit(x, surface);
        y = surface + size/2;
        ySpeed *= -1;
    }
    void makeBounceBottom(float surface) {
        hit.trigger();
        collisionAffect.isHit(x, surface);
        y = surface - size/2;
        ySpeed *= -1;
    }
    void makeBounceLeft(float surface) {
        hit.trigger();
        collisionAffect.isHit(surface, y);
        x = surface + size/2;
        xSpeed *= -1;
    }
    void makeBounceRight(float surface) {
        hit.trigger();
        collisionAffect.isHit(surface, y);
        x = surface - size/2;
        xSpeed *= -1;
    }
   
   boolean hit(float x, float y, float radius, float bx, float by, float bw, float bh) {

      // temporary variables to set edges for testing
      testX = x;
      testY = y;
    
      // which edge is closest?
      if (x < bx)         testX = bx;      // test left edge
      else if (x > bx+bw) testX = bx+bw;   // right edge
      if (y < by)         testY = by;      // top edge
      else if (y > by+bh) testY = by+bh;   // bottom edge
    
      // get distance from closest edges
      float distX = x - testX;
      float distY = y - testY;
      float distance = sqrt( (distX * distX) + (distY * distY) );
    
      // if the distance is less than the radius, collision!
      return distance <= radius;
  
  }
   
  boolean barrierDist() {
      float dist = 0;
      float checkDist;
      for(int i = 0; i < 3; i++) {
          checkDist = abs(y - barriers[i].y);
          if(dist == 0 || checkDist < dist) dist = checkDist;
      }
      return dist > size;
  }   
  
  void initGame() {
    x = AIRCRAFT_INIT_X;
    y = AIRCRAFT_INIT_Y;
    start = false;
    timer = 90;
    for (int i = 0; i < barriers.length; i++) {
        boolean left = random(2) < 1;
        float x = (left) ? -75 : width / 2;
        float y = i * height / 3  - 36;
        barriers[i].x = x;
        barriers[i].y = y;
        barriers[i].left = left;
        barriers[i].isAlive = true;
        barriers[i].move =false;
    }
    fire.x = -1000;
  }
}
