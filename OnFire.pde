class OnFire {
    float x, y;
    float size;
    float targetScore;
    float[] affectSize = new float[3];
    float[] alpha = new float[3];
    boolean secondCircle, thirdCircle;
    boolean isAlive;
    boolean soundFirst;
    
    OnFire(float x, float y) {
        this.x = x;
        this.y = y;
        size = 50;
        for(int i = 0; i < affectSize.length; i++) {
            affectSize[i] = 0;
            alpha[i] = 200;
        }
        secondCircle = false;
        thirdCircle = false;
        isAlive = false;
        soundFirst = true;
    }
    
    void display(float x, float y) {
        if(isAlive) {
            pushStyle();
            noStroke();
            for(int i = 0; i < affectSize.length; i++) {
                fill(220, 135, 68, alpha[i]);
                ellipse(x + size/2, y + size/2, affectSize[i], affectSize[i]);
            }
            popStyle();
        }
    }
    
    void update() {
        if(isAlive) {
            if(alpha[0] >= 0) {
                affectSize[0] += 25;
                alpha[0] -= 4;
            }
            if(alpha[0] <= 150) secondCircle = true;
            if(secondCircle) {
                if(alpha[1] >= 0) {
                    affectSize[1] += 25;
                    alpha[1] -= 4;
                }
            }
            if(alpha[1] <= 150) thirdCircle = true;
            if(thirdCircle) {
                if(alpha[2] >= 0) {
                    affectSize[2] += 25;
                    alpha[2] -= 4;
                }
            }
            
            if(targetScore + 10 <= score && aircraft.barrierDist()) {
                aircraft.jetSpeed = -0.05;
                isAlive = false;
                for(int i = 0; i < affectSize.length; i++) {
                    affectSize[i] = 0;
                    alpha[i] = 200;
                }
                secondCircle = false;
                thirdCircle = false;
                
                onFireMove.go = false;
            }
            if(targetScore + 5 <= score) fire.x = -1000;
        }
    }
}
