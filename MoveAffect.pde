class MoveAffect {
    float x, y;
    float size;
    float alpha;
    float timer;
    boolean isAlive;
    
    MoveAffect(float x, float y) {
        this.x = x;
        this.y = y;
        timer = 0;
        alpha = 100;
        size = 50;
        isAlive = false;
    }
    
    void display() {
        if(isAlive){
            pushStyle();
            noFill();
            stroke(255, alpha);
            strokeWeight(10);
            ellipse(x, y, size, size);
            popStyle();
        }
    }
    
    void update(float x, float y) {
        this.x = x;
        this.y = y;
        
        if(isAlive) {
            timer += 1;
            size += 5;
            alpha -= 10;
          
            if(timer == 10){
                isAlive = false;
                size = 50;
                alpha = 100;
                timer = 0;
            }
        }
    }
}
