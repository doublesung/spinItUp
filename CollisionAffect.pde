class CollisionAffect {
    float x, y;
    float[] rectsX = new float[5];
    float[] rectsY = new float[5];
    float[] xSpeed = new float[5];
    float[] ySpeed = new float[5];
    int timer = 0;
    boolean isAlive;
    
    CollisionAffect(float x, float y) {
        for(int i = 0; i < rectsX.length; i++) {
            rectsX[i] = x;
            rectsY[i] = y;
            xSpeed[i] = random(-5, 5);
            ySpeed[i] = random(-5, 5);
        }
        isAlive = false;
    }
    
    void display() {
        if(isAlive && timer < 10) {
            pushStyle();
            noStroke();
            rectMode(CENTER);
            for(int i = 0; i < rectsX.length; i++) {
                rect(rectsX[i], rectsY[i], 5, 5);
            }
            popStyle();
        }
    }
    
    void update() {
        if(isAlive && timer < 10) {
            for(int i = 0; i < rectsX.length; i++) {
                rectsX[i] += xSpeed[i];
                rectsY[i] += ySpeed[i];
            }
            timer += 1;
        }
    }
    
    void isHit(float x, float y) {
        isAlive = true;
        for(int i = 0; i < rectsX.length; i++) {
            rectsX[i] = x;
            rectsY[i] = y;
            xSpeed[i] = random(-5, 5);
            ySpeed[i] = random(-5, 5);
        }
        timer = 0;
    }
    
}
