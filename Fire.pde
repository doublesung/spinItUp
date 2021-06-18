class Fire {
    PImage img;
    float x, y;
    float size;
    float timer = 0;
    float[] affectSize = new float[2];
    float[] alpha = new float[2];
    boolean isAlive;
    boolean secondCircle;
    
    Fire(float x, float y) {
        this.x = x;
        this.y = y;
        img = fireImg;
        size = 50;
        for(int i = 0; i < affectSize.length; i++) {
            affectSize[i] = 0;
            alpha[i] = 200;
        }
        isAlive = true;
        secondCircle = false;
    }
    
    void display() {
        if(y > height) {
            isAlive = false;
            x = -1000;
        }
        if(isAlive) {
            image(fireImg, x, y, size, size);
            pushStyle();
            noStroke();
            for(int i = 0; i < affectSize.length; i++) {
                fill(220, 135, 68, alpha[i]);
                ellipse(x + size/2, y + size/2, affectSize[i], affectSize[i]);
            }
            popStyle();
        }
        onfire.display(x, y);
    }
    
    void update() {
        if(alpha[0] >= 0) {
            affectSize[0] += 1.5;
            alpha[0] -= 2;
        }else {
            affectSize[0] = 0;
            alpha[0] = 200;
        }
        if(alpha[0] <= 100) secondCircle = true;
        if(secondCircle) {
            if(alpha[1] >= 0) {
                affectSize[1] += 1.5;
                alpha[1] -= 2;
            }else {
                affectSize[1] = 0;
                alpha[1] = 200;
            }
        }
        onfire.update();
    }
    
    void hit() {  
        if(isHit(x, y, size, size, aircraft.x - aircraft.size/2, aircraft.y - aircraft.size/2, aircraft.size, aircraft.size)) {
            isAlive = false;
            if(!onfire.isAlive) onfire.targetScore = score;
            if(!isAlive) onfire.isAlive = true;
            if(onfire.alpha[0] == 200) fireHit.trigger();
        }
    }
    
    boolean hadHit() {
        return isHit(x, y, size, size, aircraft.x - aircraft.size/2, aircraft.y - aircraft.size/2, aircraft.size, aircraft.size);
    }
}
